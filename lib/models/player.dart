import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

import 'ai_profile.dart';

export 'ai_profile.dart';

part 'player.freezed.dart';
part 'player.g.dart';

/// Token color for a player piece on the board.
enum TokenColor {
  red,
  blue,
  green,
  yellow,
}

/// One piece of chrome chosen in the lobby. Most charges spend once.
enum Chrome {
  none,
  sandevistan,
  kerenzikov,
  cyberdeck,
  mantis,
}

extension ChromeX on Chrome {
  static Chrome parse(String? raw) {
    for (final chrome in Chrome.values) {
      if (chrome.name == raw) return chrome;
    }
    return Chrome.none;
  }

  static Chrome forProfile(AiProfile? profile) => switch (profile) {
        AiProfile.aggressive => Chrome.mantis,
        AiProfile.banker => Chrome.kerenzikov,
        _ => Chrome.cyberdeck,
      };
}

extension TokenColorX on TokenColor {
  Color get color => switch (this) {
        TokenColor.red => const Color(0xFFE53935),
        TokenColor.blue => const Color(0xFF1E88E5),
        TokenColor.green => const Color(0xFF43A047),
        TokenColor.yellow => const Color(0xFFFDD835),
      };

  /// Glyph color that stays readable on the token fill.
  Color get ink => switch (this) {
        TokenColor.yellow || TokenColor.green => const Color(0xFF0A0C10),
        _ => const Color(0xFFFFFFFF),
      };

  String get labelUk => switch (this) {
        TokenColor.red => 'Червоний',
        TokenColor.blue => 'Синій',
        TokenColor.green => 'Зелений',
        TokenColor.yellow => 'Жовтий',
      };
}

@freezed
abstract class Player with _$Player {
  const Player._();

  const factory Player({
    required String id,
    required String name,
    required TokenColor tokenColor,
    @Default(1500) int balance,
    @Default(0) int position,
    @Default(false) bool inJail,
    @Default(0) int jailTurns,
    @Default([]) List<int> propertyIndexes,
    @Default(false) bool isBankrupt,
    @Default(false) bool isAi,
    AiProfile? aiProfile,
    @Default(0) int getOutOfJailCards,

    /// Deck ids (`dataBreach` / `corpoBounty`) for held ICE nullifiers, oldest first.
    @Default([]) List<String> jailCardSources,

    @Default(false) bool overdraftUsed,
    @Default(0) int overdraftRemaining,
    @Default(0) int overdraftInstallmentsLeft,
    @Default(false) bool buyoutUsed,
    @Default(false) bool blackoutUsedThisTurn,
    @Default(Chrome.none) Chrome chrome,
    @Default(false) bool chromeSpent,
    @Default(false) bool chromeArmed,
    @Default(false) bool fixerSpent,
    @Default(0) int heat,
    @Default(0) int virusRound,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  bool get isSolvent => !isBankrupt && balance >= 0;

  /// Alias kept for readability in older call sites.
  bool get isBot => isAi;
}
