import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly/core/constants/board_data.dart';
import 'package:monopoly/core/constants/game_rules.dart';
import 'package:monopoly/logic/rules_engine.dart';
import 'package:monopoly/models/cell.dart';

void main() {
  late List<BoardCell> board;

  setUp(() => board = BoardData.createBoard());

  BoardCell own(BoardCell cell, String ownerId) => switch (cell) {
        PropertyCell c => c.copyWith(ownerId: ownerId),
        RailroadCell c => c.copyWith(ownerId: ownerId),
        UtilityCell c => c.copyWith(ownerId: ownerId),
        _ => cell,
      };

  test('base street rent doubles with monopoly and no houses', () {
    board = [
      for (final c in board)
        if (c is PropertyCell &&
            (c.index == 1 || c.index == 3))
          own(c, 'p1')
        else
          c,
    ];
    final mediterranean = board[1];
    expect(
      RulesEngine.calculateRent(cell: mediterranean, board: board, diceTotal: 7),
      2 * GameRules.monopolyRentMultiplier,
    );
  });

  test('railroad rent scales with count', () {
    board = [
      for (final c in board)
        if (c is RailroadCell && (c.index == 5 || c.index == 15))
          own(c, 'p1')
        else
          c,
    ];
    expect(
      RulesEngine.calculateRent(cell: board[5], board: board, diceTotal: 0),
      GameRules.railroadRents[1],
    );
  });

  test('utility rent uses dice multiplier', () {
    board = [
      for (final c in board)
        if (c is UtilityCell) own(c, 'p1') else c,
    ];
    expect(
      RulesEngine.calculateRent(cell: board[12], board: board, diceTotal: 8),
      8 * GameRules.utilityMultiplierTwo,
    );
  });

  test('mortgaged property yields zero rent', () {
    final cell = (board[1] as PropertyCell).copyWith(
      ownerId: 'p1',
      isMortgaged: true,
    );
    board = [...board]..[1] = cell;
    expect(
      RulesEngine.calculateRent(cell: cell, board: board, diceTotal: 5),
      0,
    );
  });
}
