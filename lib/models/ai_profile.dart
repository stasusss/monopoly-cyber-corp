/// Heuristic personality for AI opponents.
enum AiProfile {
  /// Buys aggressively, exits jail early, builds fast.
  aggressive,

  /// Protects cash buffer, avoids risky buys, stays in jail late-game.
  banker,

  /// Prioritises monopoly completion and high-traffic colour groups.
  strategist,
}

extension AiProfileX on AiProfile {
  String get labelUk => switch (this) {
        AiProfile.aggressive => 'Агресор',
        AiProfile.banker => 'Банкір',
        AiProfile.strategist => 'Стратег',
      };

  /// Cash reserve multiplier × estimated average rent exposure.
  double get safetyCoefficient => switch (this) {
        AiProfile.aggressive => 1.25,
        AiProfile.banker => 3.0,
        AiProfile.strategist => 2.0,
      };

  /// Max share of balance willing to spend on a single buy (0–1).
  double get maxBuyFraction => switch (this) {
        AiProfile.aggressive => 0.75,
        AiProfile.banker => 0.40,
        AiProfile.strategist => 0.55,
      };

  /// Willingness to pay jail fine in early game (0–1).
  double get earlyJailExitBias => switch (this) {
        AiProfile.aggressive => 0.95,
        AiProfile.banker => 0.55,
        AiProfile.strategist => 0.75,
      };

  /// How strongly orange/red (high traffic) groups are preferred when building.
  double get trafficBias => switch (this) {
        AiProfile.aggressive => 1.1,
        AiProfile.banker => 0.9,
        AiProfile.strategist => 1.35,
      };

  /// Thinking delay range in milliseconds.
  (int minMs, int maxMs) get thinkDelayMs => switch (this) {
        AiProfile.aggressive => (400, 600),
        AiProfile.banker => (550, 800),
        AiProfile.strategist => (500, 750),
      };
}
