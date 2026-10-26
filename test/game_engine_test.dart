import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly/core/constants/game_factory.dart';
import 'package:monopoly/core/constants/game_rules.dart';
import 'package:monopoly/logic/ai/ai_decision_matrix.dart';
import 'package:monopoly/logic/game_controller.dart';
import 'package:monopoly/models/cell.dart';
import 'package:monopoly/models/game_state.dart';
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
  GameController humanOnly({
    List<(int, int)> rolls = const [(1, 1)],
    GameState? initial,
  }) {
    final base = initial ??
        GameFactory.newGame(
          roster: const [
            (
              name: 'NETRUNNER',
              color: TokenColor.red,
              isAi: false,
              aiProfile: null,
            ),
            (
              name: 'Rival',
              color: TokenColor.blue,
              isAi: false,
              aiProfile: null,
            ),
          ],
        );
    return GameController(
      random: _ScriptedRandom(rolls),
      initial: base,
      enableAi: false,
      autosave: false,
    );
  }

  group('movement & CYCLE RESET', () {
    test('from 38 with [2,1] lands on 1 and gains +200₵', () {
      final c = humanOnly(rolls: [(2, 1)]);
      final p = c.state.activePlayer.copyWith(position: 38);
      c.state = c.state.copyWith(players: [p, c.state.players[1]]);

      final before = p.balance;
      c.debugRollExact(2, 1);

      // 38 → 39 → 0 (salary) → 1
      expect(c.state.activePlayer.position, 1);
      expect(
        c.state.activePlayer.balance,
        before + GameRules.goSalary,
      );
    });
  });

  group('rent transfer', () {
    test('exact rent is deducted from payer and credited to owner', () {
      final c = humanOnly(rolls: [(1, 2)]); // → index 3
      final owner = c.state.players[1];
      final cell = (c.state.board[3] as PropertyCell).copyWith(ownerId: owner.id);
      final board = [...c.state.board]..[3] = cell;
      c.state = c.state.copyWith(
        board: board,
        players: [
          c.state.players[0],
          owner.copyWith(propertyIndexes: [3]),
        ],
      );

      final rent = 4; // Cherry Blossom Market base rent
      final payerBefore = c.state.players[0].balance;
      final ownerBefore = c.state.players[1].balance;

      c.debugRollExact(1, 2);

      expect(c.state.players[0].balance, payerBefore - rent);
      expect(c.state.players[1].balance, ownerBefore + rent);
    });
  });

  group('bankruptcy', () {
    test('player with no assets goes bankrupt when unable to pay', () {
      final c = humanOnly(rolls: [(1, 2)]);
      final owner = c.state.players[1];
      final cell = (c.state.board[3] as PropertyCell).copyWith(ownerId: owner.id);
      final board = [...c.state.board]..[3] = cell;

      // Broke human, no properties to liquidate.
      final broke = c.state.players[0].copyWith(
        balance: 0,
        propertyIndexes: const [],
      );
      c.state = c.state.copyWith(
        board: board,
        players: [
          broke,
          owner.copyWith(propertyIndexes: [3], balance: 1500),
        ],
      );

      c.debugRollExact(1, 2);

      expect(c.state.players[0].isBankrupt, isTrue);
      expect(c.state.players[0].balance, 0);
      expect(c.state.players[0].propertyIndexes, isEmpty);
    });
  });

  group('AiDecisionMatrix buy/decline', () {
    test('declines expensive buy when cash buffer would break', () {
      final ai = Player(
        id: 'ai',
        name: 'Nexus-9',
        tokenColor: TokenColor.green,
        balance: 420,
        isAi: true,
        aiProfile: AiProfile.banker,
      );
      final state = GameState(
        board: cBoard(),
        players: [
          ai,
          const Player(
            id: 'h',
            name: 'H',
            tokenColor: TokenColor.red,
          ),
        ],
      );
      final arasaka = state.board[39]; // 400₵
      expect(
        AiDecisionMatrix.shouldBuyProperty(
          state: state,
          ai: ai,
          cell: arasaka,
          price: 400,
        ),
        isFalse,
      );
    });

    test('aggressive buys Arasaka when remaining cash stays solvent', () {
      final ai = Player(
        id: 'ai',
        name: 'Vektor',
        tokenColor: TokenColor.blue,
        balance: 900,
        isAi: true,
        aiProfile: AiProfile.aggressive,
      );
      final state = GameState(
        board: cBoard(),
        players: [ai],
      );
      expect(
        AiDecisionMatrix.shouldBuyProperty(
          state: state,
          ai: ai,
          cell: state.board[39],
          price: 400,
        ),
        isTrue,
      );
    });

    test('always buys when purchase closes a colour monopoly', () {
      final ai = Player(
        id: 'ai',
        name: 'Ghost_Net',
        tokenColor: TokenColor.yellow,
        balance: 120,
        isAi: true,
        aiProfile: AiProfile.strategist,
        propertyIndexes: const [1],
      );
      var board = cBoard();
      board = [
        for (final cell in board)
          if (cell.index == 1)
            (cell as PropertyCell).copyWith(ownerId: ai.id)
          else
            cell,
      ];
      final state = GameState(board: board, players: [ai]);
      expect(
        AiDecisionMatrix.shouldBuyProperty(
          state: state,
          ai: ai,
          cell: board[3],
          price: 60,
        ),
        isTrue,
      );
    });
  });
}

List<BoardCell> cBoard() =>
    GameFactory.newGame(
      roster: const [
        (
          name: 'A',
          color: TokenColor.red,
          isAi: false,
          aiProfile: null,
        ),
        (
          name: 'B',
          color: TokenColor.blue,
          isAi: false,
          aiProfile: null,
        ),
      ],
    ).board;
