import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly/core/constants/board_data.dart';
import 'package:monopoly/core/constants/game_rules.dart';
import 'package:monopoly/logic/ai/ai_decision_matrix.dart';
import 'package:monopoly/models/cell.dart';
import 'package:monopoly/models/game_state.dart';
import 'package:monopoly/models/player.dart';

void main() {
  GameState baseState(Player ai) {
    return GameState(
      board: BoardData.createBoard(),
      players: [
        ai,
        const Player(
          id: 'human',
          name: 'Human',
          tokenColor: TokenColor.red,
        ),
      ],
    );
  }

  Player aiPlayer({
    AiProfile profile = AiProfile.strategist,
    int balance = 1500,
    List<int> props = const [],
  }) {
    return Player(
      id: 'ai',
      name: 'AI',
      tokenColor: TokenColor.blue,
      balance: balance,
      isAi: true,
      aiProfile: profile,
      propertyIndexes: props,
    );
  }

  test('closes monopoly when buying the last street in a set', () {
    final ai = aiPlayer(props: [1]);
    var board = BoardData.createBoard();
    board = [
      for (final c in board)
        if (c.index == 1) (c as PropertyCell).copyWith(ownerId: ai.id) else c,
    ];
    final state = GameState(board: board, players: [ai]);
    final baltic = board[3];
    expect(
      AiDecisionMatrix.closesMonopoly(state: state, ai: ai, cell: baltic),
      isTrue,
    );
  });

  test('aggressive buys more readily than banker', () {
    final cell = BoardData.createBoard()[39]; // Boardwalk 400
    final rich = aiPlayer(profile: AiProfile.aggressive, balance: 900);
    final careful = aiPlayer(profile: AiProfile.banker, balance: 900);
    final stateA = baseState(rich);
    final stateB = baseState(careful);

    expect(
      AiDecisionMatrix.shouldBuyProperty(
        state: stateA,
        ai: rich,
        cell: cell,
        price: 400,
      ),
      isTrue,
    );
    expect(
      AiDecisionMatrix.shouldBuyProperty(
        state: stateB,
        ai: careful,
        cell: cell,
        price: 400,
      ),
      isFalse,
    );
  });

  test('late game prefers sitting in jail', () {
    final ai = aiPlayer(profile: AiProfile.banker).copyWith(
      inJail: true,
      jailTurns: 0,
      balance: 1000,
    );
    // Seed many houses to mark late game.
    var board = BoardData.createBoard();
    board = [
      for (final c in board)
        if (c is PropertyCell && c.index == 19)
          c.copyWith(ownerId: 'human', houses: 5)
        else if (c is PropertyCell && c.index == 16)
          c.copyWith(ownerId: 'human', houses: 5)
        else
          c,
    ];
    final state = GameState(
      board: board,
      players: [
        ai,
        const Player(id: 'human', name: 'H', tokenColor: TokenColor.red),
      ],
    );
    expect(AiDecisionMatrix.isLateGame(state), isTrue);
    expect(
      AiDecisionMatrix.shouldPayJailFine(state: state, ai: ai),
      isFalse,
    );
  });

  test('liquidation mortgages railroads before colour streets', () {
    final ai = aiPlayer(balance: 10, props: [5, 1]);
    var board = BoardData.createBoard();
    board = [
      for (final c in board)
        if (c.index == 5)
          (c as RailroadCell).copyWith(ownerId: ai.id)
        else if (c.index == 1)
          (c as PropertyCell).copyWith(ownerId: ai.id)
        else
          c,
    ];
    final state = GameState(board: board, players: [ai]);
    final steps = AiDecisionMatrix.liquidationQueue(
      state: state,
      ai: ai,
      amountNeeded: 80,
    );
    expect(steps.first, isA<MortgageStep>());
    expect((steps.first as MortgageStep).cellIndex, 5);
  });

  test('preferred build targets favour orange when opponent is 7 away', () {
    // Give AI orange monopoly; opponent at position that lands on 16–19 with 7.
    final ai = aiPlayer(balance: 800, props: [16, 18, 19]);
    var board = BoardData.createBoard();
    board = [
      for (final c in board)
        if (c.index == 16 || c.index == 18 || c.index == 19)
          (c as PropertyCell).copyWith(ownerId: ai.id)
        else
          c,
    ];
    final human = const Player(
      id: 'human',
      name: 'H',
      tokenColor: TokenColor.red,
      position: 12, // +7 → 19
    );
    final state = GameState(board: board, players: [ai, human]);
    final targets = AiDecisionMatrix.preferredBuildTargets(
      state: state,
      ai: ai.copyWith(aiProfile: AiProfile.strategist),
    );
    expect(targets, isNotEmpty);
    expect(targets.contains(19) || targets.first == 19 || targets.contains(16),
        isTrue);
  });

  test('cash buffer scales with profile', () {
    final state = baseState(aiPlayer());
    final agr = aiPlayer(profile: AiProfile.aggressive);
    final bank = aiPlayer(profile: AiProfile.banker);
    expect(
      AiDecisionMatrix.cashBuffer(state, agr),
      lessThan(AiDecisionMatrix.cashBuffer(state, bank)),
    );
    expect(GameRules.jailFine, 50);
  });
}
