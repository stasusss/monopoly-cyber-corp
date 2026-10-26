import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly/core/constants/game_factory.dart';
import 'package:monopoly/logic/city_ops.dart';
import 'package:monopoly/logic/game_controller.dart';
import 'package:monopoly/models/cell.dart';
import 'package:monopoly/models/game_state.dart';
import 'package:monopoly/models/pending_action.dart';
import 'package:monopoly/models/player.dart';

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
  GameController open(List<(int, int)> rolls) {
    return GameController(
      random: _ScriptedRandom(rolls),
      initial: GameFactory.newGame(
        roster: const [
          (name: 'Аня', color: TokenColor.red, isAi: false, aiProfile: null),
          (name: 'Богдан', color: TokenColor.blue, isAi: false, aiProfile: null),
        ],
      ),
      enableAi: false,
      autosave: false,
    );
  }

  test('landing on your own street leaves the turn open', () {
    final c = open([(1, 1)]);
    final me = c.state.players[0].copyWith(position: 39, propertyIndexes: [1]);
    final cell = (c.state.board[1] as PropertyCell).copyWith(ownerId: me.id);
    final board = [...c.state.board]..[1] = cell;
    c.state = c.state.copyWith(board: board, players: [me, c.state.players[1]]);

    c.rollDice();
    c.finishMove();

    expect(c.state.activePlayerIndex, 0);
    expect(c.state.phase, TurnPhase.canEndTurn);
    expect(c.state.activePlayer.position, 1);
  });

  test('a broke human chooses what to sell', () {
    final c = open([(1, 2)]);
    final owner = c.state.players[1];
    final me = c.state.players[0].copyWith(balance: 0, propertyIndexes: [1]);
    final owned = (c.state.board[1] as PropertyCell).copyWith(ownerId: me.id);
    final rentCell =
        (c.state.board[3] as PropertyCell).copyWith(ownerId: owner.id);
    final board = [...c.state.board]
      ..[1] = owned
      ..[3] = rentCell;
    c.state = c.state.copyWith(
      board: board,
      players: [
        me,
        owner.copyWith(propertyIndexes: [3]),
      ],
    );

    c.rollDice();
    c.finishMove();

    expect(c.state.pendingAction, isA<PendingShortfall>());
    expect((c.state.board[1] as PropertyCell).isMortgaged, isFalse);
    expect(c.state.players[0].balance, 0);
  });

  test('a virus halves the rent for this landing', () {
    final c = open([(1, 2)]);
    final owner = c.state.players[1];
    final rentCell =
        (c.state.board[3] as PropertyCell).copyWith(ownerId: owner.id);
    final board = [...c.state.board]..[3] = rentCell;
    c.state = c.state.copyWith(
      board: board,
      players: [
        c.state.players[0],
        owner.copyWith(propertyIndexes: [3]),
      ],
      virusCells: [3],
      virusHops: [2],
    );
    final before = c.state.players[0].balance;

    c.rollDice();
    c.finishMove();

    expect(c.state.players[0].balance, before - 2);
    expect(c.state.virusHops, [1]);
  });

  test('mantis discounts a street in a district you already started', () {
    final c = open([(1, 1)]);
    final me = c.state.players[0].copyWith(
      chrome: Chrome.mantis,
      propertyIndexes: [1],
    );
    final owned = (c.state.board[1] as PropertyCell).copyWith(ownerId: me.id);
    final board = [...c.state.board]..[1] = owned;
    c.state = c.state.copyWith(board: board, players: [me, c.state.players[1]]);
    final list = (c.state.board[3] as PropertyCell).price;

    expect(
      CityOps.buyPrice(c.state, c.state.players[0], c.state.board[3]),
      (list * 4) ~/ 5,
    );
  });

  test('tax holiday skips the levy', () {
    final c = open([(2, 2)]);
    c.state = c.state.copyWith(decree: CityDecree.taxHoliday);
    final before = c.state.activePlayer.balance;

    c.rollDice();
    c.finishMove();

    expect(c.state.players[0].balance, before);
  });
}
