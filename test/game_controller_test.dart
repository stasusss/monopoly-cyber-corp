import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly/core/constants/game_factory.dart';
import 'package:monopoly/core/constants/game_rules.dart';
import 'package:monopoly/logic/game_controller.dart';
import 'package:monopoly/models/cell.dart';
import 'package:monopoly/models/game_state.dart';
import 'package:monopoly/models/pending_action.dart';
import 'package:monopoly/models/player.dart';

/// Deterministic dice: yields pairs from [pairs] in order, then repeats last.
class _ScriptedRandom implements Random {
  _ScriptedRandom(this.pairs);

  final List<(int, int)> pairs;
  int _i = 0;
  bool _firstOfPair = true;

  @override
  int nextInt(int max) {
    if (max == 6) {
      final pair = pairs[_i.clamp(0, pairs.length - 1)];
      if (_firstOfPair) {
        _firstOfPair = false;
        return pair.$1 - 1;
      }
      _firstOfPair = true;
      if (_i < pairs.length - 1) _i++;
      return pair.$2 - 1;
    }
    return 0;
  }

  @override
  double nextDouble() => 0;

  @override
  bool nextBool() => false;
}

void main() {
  GameController controllerWith({
    required List<(int, int)> rolls,
    List<PlayerRosterEntry>? roster,
  }) {
    final initial = GameFactory.newGame(
      roster: roster ??
          [
            (
              name: 'Аня',
              color: TokenColor.red,
              isAi: false,
              aiProfile: null,
            ),
            (
              name: 'Богдан',
              color: TokenColor.blue,
              isAi: false,
              aiProfile: null,
            ),
          ],
    );
    return GameController(
      random: _ScriptedRandom(rolls),
      initial: initial,
      enableAi: false,
    );
  }

  test('move grants GO salary when passing index 0', () {
    final c = controllerWith(rolls: [(1, 1)]);
    final p = c.state.activePlayer.copyWith(position: 39);
    c.state = c.state.copyWith(
      players: [p, ...c.state.players.skip(1)],
    );

    final before = p.balance;
    c.rollDice();
    c.finishMove();

    expect(c.state.activePlayer.position, 1);
    expect(c.state.activePlayer.balance, before + GameRules.goSalary);
  });

  test('landing on free property opens buy offer', () {
    final c = controllerWith(rolls: [(1, 2)]);
    c.rollDice();
    c.finishMove();
    expect(c.state.phase, TurnPhase.cellAction);
    expect(c.state.pendingAction, isA<PendingBuyOffer>());
    final offer = c.state.pendingAction as PendingBuyOffer;
    expect(offer.cellIndex, 3);
  });

  test('acceptBuy assigns owner and deducts price', () {
    final c = controllerWith(rolls: [(1, 2)]);
    c.rollDice();
    c.finishMove();
    final price = (c.state.pendingAction as PendingBuyOffer).price;
    final before = c.state.activePlayer.balance;
    c.acceptBuy();
    expect(c.state.cellAt(3).ownerIdOrNull, c.state.players.first.id);
    expect(c.state.players.first.balance, before - price);
    expect(c.state.phase, TurnPhase.canEndTurn);
  });

  test('rent is paid to owner automatically', () {
    final c = controllerWith(rolls: [(1, 2)]);
    final owner = c.state.players[1];
    final cell = (c.state.board[3] as PropertyCell).copyWith(ownerId: owner.id);
    final board = [...c.state.board]..[3] = cell;
    final ownerUpdated =
        owner.copyWith(propertyIndexes: [...owner.propertyIndexes, 3]);
    c.state = c.state.copyWith(
      board: board,
      players: [c.state.players[0], ownerUpdated],
    );

    final payerBefore = c.state.players[0].balance;
    final ownerBefore = c.state.players[1].balance;
    c.rollDice();
    c.finishMove();

    expect(c.state.pendingAction, isA<PendingRentNotice>());
    expect(c.state.players[0].balance, payerBefore - 4);
    expect(c.state.players[1].balance, ownerBefore + 4);
  });

  test('go-to-jail cell sends player to jail without GO salary', () {
    final c = controllerWith(rolls: [(2, 3)]);
    final p = c.state.activePlayer.copyWith(position: 25);
    c.state = c.state.copyWith(players: [p, c.state.players[1]]);
    final before = p.balance;
    c.rollDice();
    c.finishMove();
    expect(c.state.activePlayer.position, GameRules.jailIndex);
    expect(c.state.activePlayer.inJail, isTrue);
    expect(c.state.activePlayer.balance, before);
    expect(c.state.consecutiveDoubles, 0);
  });

  void clearPending(GameController c) {
    for (var i = 0; i < 12; i++) {
      final p = c.state.pendingAction;
      if (p is PendingNone) return;
      if (p is PendingBuyOffer) {
        c.declineBuy();
        continue;
      }
      if (p is PendingAuction) {
        c.auctionPass();
        continue;
      }
      if (p is PendingWinner) return;
      c.dismissNotice();
    }
  }

  test('three doubles send to jail', () {
    final c = controllerWith(rolls: [(1, 1), (2, 2), (3, 3)]);
    c.rollDice();
    c.finishMove();
    clearPending(c);
    c.endTurn();

    expect(c.state.activePlayerIndex, 0);

    c.rollDice();
    c.finishMove();
    clearPending(c);
    c.endTurn();

    c.rollDice();
    expect(c.state.activePlayer.inJail, isTrue);
    expect(c.state.activePlayer.position, GameRules.jailIndex);
  });

  test('income tax deducts 200', () {
    final c = controllerWith(rolls: [(2, 2)]);
    final before = c.state.activePlayer.balance;
    c.rollDice();
    c.finishMove();
    expect(c.state.pendingAction, isA<PendingTaxNotice>());
    expect(c.state.activePlayer.balance, before - GameRules.incomeTaxAmount);
  });

  test('mortgage raises cash for AI liquidation path', () {
    final c = controllerWith(rolls: [(1, 1)]);
    final p = c.state.activePlayer.copyWith(
      balance: 10,
      propertyIndexes: [5],
      isAi: true,
      aiProfile: AiProfile.banker,
    );
    final board = [...c.state.board];
    board[5] = (board[5] as RailroadCell).copyWith(ownerId: p.id);
    c.state = c.state.copyWith(
      board: board,
      players: [p, c.state.players[1]],
    );

    expect(c.raiseFunds(p.id, 100), isTrue);
    expect(c.state.players.first.balance, greaterThanOrEqualTo(100));
    expect((c.state.board[5] as RailroadCell).isMortgaged, isTrue);
  });
}
