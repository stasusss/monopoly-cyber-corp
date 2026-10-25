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

extension TokenColorX on TokenColor {
  Color get color => switch (this) {
        TokenColor.red => const Color(0xFFE53935),
        TokenColor.blue => const Color(0xFF1E88E5),
        TokenColor.green => const Color(0xFF43A047),
        TokenColor.yellow => const Color(0xFFFDD835),
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
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  bool get isSolvent => !isBankrupt && balance >= 0;

  /// Alias kept for readability in older call sites.
  bool get isBot => isAi;
}
