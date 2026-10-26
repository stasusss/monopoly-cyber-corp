import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly/core/constants/game_factory.dart';
import 'package:monopoly/core/constants/game_rules.dart';
import 'package:monopoly/logic/game_controller.dart';
import 'package:monopoly/logic/nightfall.dart';
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
      autosave: false,
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

  test('safe zone hands the turn over without an END click', () {
    final c = controllerWith(rolls: [(1, 3)]);
    final p = c.state.activePlayer.copyWith(position: 16);
    c.state = c.state.copyWith(players: [p, c.state.players[1]]);
    c.rollDice();
    c.finishMove();
    expect(c.state.players.first.position, GameRules.freeParkingIndex);
    expect(c.state.activePlayerIndex, 1);
    expect(c.state.phase, TurnPhase.waitingForRoll);
  });

  test('first two nodes cost half and the third costs full', () {
    final c = controllerWith(rolls: [(1, 1)]);
    final me = c.state.players.first;
    final board = [...c.state.board];
    board[1] = (board[1] as PropertyCell).copyWith(ownerId: me.id);
    board[3] = (board[3] as PropertyCell).copyWith(ownerId: me.id);
    c.state = c.state.copyWith(
      board: board,
      players: [
        me.copyWith(propertyIndexes: [1, 3], balance: 500),
        c.state.players[1],
      ],
    );

    expect(c.buildHouse(1), isTrue);
    expect(c.buildHouse(1), isFalse);
    expect((c.state.board[1] as PropertyCell).houses, 1);
    expect(c.state.players.first.balance, 500 - 25);
    expect((c.state.board[1] as PropertyCell).houses, 1);
    expect(c.state.housesInBank, GameRules.housesInSupply - 1);

    expect(c.buildHouse(3), isTrue);
    expect(c.buildHouse(1), isTrue);
    expect(c.buildHouse(3), isTrue);
    // Two streets × two half-price levels = 100, then the third level is full.
    expect(c.buildHouse(1), isTrue);
    expect((c.state.board[1] as PropertyCell).houses, 3);
    expect(c.state.players.first.balance, 500 - 100 - 50);
  });

  test('lifting ICE costs mortgage plus 10 percent', () {
    final c = controllerWith(rolls: [(1, 1)]);
    final me = c.state.players.first;
    final board = [...c.state.board];
    board[5] = (board[5] as RailroadCell).copyWith(
      ownerId: me.id,
      isMortgaged: true,
    );
    c.state = c.state.copyWith(
      board: board,
      players: [
        me.copyWith(propertyIndexes: [5], balance: 200),
        c.state.players[1],
      ],
    );

    expect(c.unmortgageProperty(5), isTrue);
    expect((c.state.board[5] as RailroadCell).isMortgaged, isFalse);
    expect(c.state.players.first.balance, 200 - 110);
  });

  test('auction bid under 50 is refused and a pass sticks', () {
    final c = controllerWith(rolls: [(1, 2)]);
    c.rollDice();
    c.finishMove();
    c.declineBuy();
    expect(c.state.pendingAction, isA<PendingAuction>());
    c.auctionBid(10);
    expect((c.state.pendingAction as PendingAuction).highestBid, 0);
    c.auctionBid(80);
    expect((c.state.pendingAction as PendingAuction).highestBid, 80);
    final bidder = (c.state.pendingAction as PendingAuction).currentBidderId;
    c.auctionPass();
    final again = c.state.pendingAction;
    if (again is PendingAuction) {
      expect(again.passedIds, contains(bidder));
    }
  });

  test('a lone street cannot take a rack even with cash on the cell', () {
    final c = controllerWith(rolls: [(1, 1)]);
    final me = c.state.players.first;
    final board = [...c.state.board];
    board[8] = (board[8] as PropertyCell).copyWith(ownerId: me.id);
    c.state = c.state.copyWith(
      board: board,
      players: [
        me.copyWith(propertyIndexes: [8], balance: 1400, position: 8),
        c.state.players[1],
      ],
    );

    expect(c.buildHouse(8), isFalse);
    expect((c.state.board[8] as PropertyCell).houses, 0);
    final reason = Nightfall.rackBuildBlock(
      state: c.state,
      cell: c.state.board[8] as PropertyCell,
      player: c.state.players.first,
    );
    expect(reason, contains('does not matter'));
    expect(reason, contains('Watson Hub'));
    expect(reason, contains('Little China Node'));
    expect(reason, contains('Watson Transit Hub'));
  });
}
