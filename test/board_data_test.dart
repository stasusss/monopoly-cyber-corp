import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly/core/constants/board_data.dart';
import 'package:monopoly/core/constants/game_factory.dart';
import 'package:monopoly/core/constants/game_rules.dart';
import 'package:monopoly/core/constants/street_colors.dart';
import 'package:monopoly/models/cell.dart';
import 'package:monopoly/models/dice.dart';
import 'package:monopoly/models/player.dart';

void main() {
  group('BoardData', () {
    late List<BoardCell> board;

    setUp(() => board = BoardData.createBoard());

    test('has exactly 40 cells indexed 0..39', () {
      expect(board, hasLength(GameRules.boardSize));
      for (var i = 0; i < board.length; i++) {
        expect(board[i].index, i);
      }
    });

    test('corner and tax specials are correct', () {
      expect(
        board[0],
        isA<SpecialCell>().having((c) => c.kind, 'kind', SpecialKind.go),
      );
      expect(
        board[10],
        isA<SpecialCell>().having((c) => c.kind, 'kind', SpecialKind.jail),
      );
      expect(
        board[20],
        isA<SpecialCell>()
            .having((c) => c.kind, 'kind', SpecialKind.freeParking),
      );
      expect(
        board[30],
        isA<SpecialCell>().having((c) => c.kind, 'kind', SpecialKind.goToJail),
      );
      expect(
        board[4],
        isA<TaxCell>()
            .having((c) => c.amount, 'amount', GameRules.incomeTaxAmount),
      );
      expect(
        board[38],
        isA<TaxCell>()
            .having((c) => c.amount, 'amount', GameRules.luxuryTaxAmount),
      );
    });

    test('has 22 streets, 4 railroads, 2 utilities', () {
      expect(board.whereType<PropertyCell>(), hasLength(22));
      expect(board.whereType<RailroadCell>(), hasLength(4));
      expect(board.whereType<UtilityCell>(), hasLength(2));
    });

    test('color groups match classic sizes', () {
      for (final group in ColorGroup.values) {
        final count =
            board.whereType<PropertyCell>().where((p) => p.colorGroup == group);
        expect(count, hasLength(group.propertyCount), reason: group.name);
      }
    });

    test('street rents have 6 tiers and Boardwalk costs 400', () {
      for (final p in board.whereType<PropertyCell>()) {
        expect(p.rents, hasLength(6), reason: p.name);
      }
      final boardwalk = board[39] as PropertyCell;
      expect(boardwalk.price, 400);
      expect(boardwalk.rents.first, 50);
      expect(boardwalk.rents.last, 2000);
    });

    test('createBoard returns independent mutable ownership copies', () {
      final a = BoardData.createBoard();
      final b = BoardData.createBoard();
      final updated = (a[1] as PropertyCell).copyWith(ownerId: 'p1');
      expect((b[1] as PropertyCell).ownerId, isNull);
      expect(updated.ownerId, 'p1');
    });
  });

  group('DiceRoll', () {
    test('totals and doubles', () {
      const roll = DiceRoll(die1: 4, die2: 4);
      expect(roll.total, 8);
      expect(roll.isDoubles, isTrue);
      expect(const DiceRoll(die1: 1, die2: 2).isDoubles, isFalse);
    });

    test('roll stays in 1..6', () {
      for (var i = 0; i < 50; i++) {
        final r = DiceRoll.roll();
        expect(r.die1, inInclusiveRange(1, 6));
        expect(r.die2, inInclusiveRange(1, 6));
      }
    });
  });

  group('GameFactory', () {
    test('starts players with classic capital on GO', () {
      final state = GameFactory.newGame(
        roster: [
          (
            name: 'Аня',
            color: TokenColor.red,
            isAi: false,
            aiProfile: null,
          ),
          (
            name: 'Бот',
            color: TokenColor.blue,
            isAi: true,
            aiProfile: null,
          ),
        ],
      );
      expect(state.board, hasLength(40));
      expect(state.players, hasLength(2));
      expect(state.activePlayerIndex, 0);
      expect(state.phase.name, 'waitingForRoll');
      for (final p in state.players) {
        expect(p.balance, GameRules.startingMoney);
        expect(p.position, GameRules.goIndex);
      }
    });
  });
}
