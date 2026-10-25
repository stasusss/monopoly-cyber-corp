import 'package:uuid/uuid.dart';

import '../../models/game_state.dart';
import '../../models/player.dart';
import 'board_data.dart';
import 'game_rules.dart';

typedef PlayerRosterEntry = ({
  String name,
  TokenColor color,
  bool isAi,
  AiProfile? aiProfile,
});

/// Builds a fresh [GameState] for Pass & Play / AI opponents.
abstract final class GameFactory {
  static const _uuid = Uuid();

  static GameState newGame({
    required List<PlayerRosterEntry> roster,
  }) {
    assert(
      roster.length >= GameRules.minPlayers &&
          roster.length <= GameRules.maxPlayers,
      'Need ${GameRules.minPlayers}–${GameRules.maxPlayers} players',
    );

    final players = [
      for (final entry in roster)
        Player(
          id: _uuid.v4(),
          name: entry.name,
          tokenColor: entry.color,
          balance: GameRules.startingMoney,
          isAi: entry.isAi,
          aiProfile: entry.isAi
              ? (entry.aiProfile ?? AiProfile.strategist)
              : null,
        ),
    ];

    return GameState(
      board: BoardData.createBoard(),
      players: players,
      log: [
        'SESSION BOOT · operatives: ${players.map((p) => p.name).join(', ')}. '
        'Starting credits: ${GameRules.credits(GameRules.startingMoney)}.',
      ],
    );
  }

  /// Online match: keep lobby presence IDs so Realtime actions map 1:1.
  static GameState fromPlayers(List<Player> players) {
    assert(
      players.length >= GameRules.minPlayers &&
          players.length <= GameRules.maxPlayers,
      'Need ${GameRules.minPlayers}–${GameRules.maxPlayers} players',
    );
    return GameState(
      board: BoardData.createBoard(),
      players: [
        for (final p in players)
          p.copyWith(
            balance: GameRules.startingMoney,
            position: 0,
            inJail: false,
            jailTurns: 0,
            propertyIndexes: const [],
            isBankrupt: false,
            getOutOfJailCards: 0,
          ),
      ],
      log: [
        'UPLINK BOOT · operatives: ${players.map((p) => p.name).join(', ')}. '
        'Starting credits: ${GameRules.credits(GameRules.startingMoney)}.',
      ],
    );
  }

  static List<PlayerRosterEntry> get defaultRoster => const [
        (
          name: 'NETRUNNER',
          color: TokenColor.red,
          isAi: false,
          aiProfile: null,
        ),
        (
          name: 'Vektor',
          color: TokenColor.blue,
          isAi: true,
          aiProfile: AiProfile.aggressive,
        ),
        (
          name: 'Nexus-9',
          color: TokenColor.green,
          isAi: true,
          aiProfile: AiProfile.banker,
        ),
      ];
}
