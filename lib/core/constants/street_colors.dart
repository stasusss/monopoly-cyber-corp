import 'package:flutter/material.dart';

import '../theme/cyber_theme.dart';

/// District colour groups (cyberpunk megacorp zones).
enum ColorGroup {
  brown,
  lightBlue,
  pink,
  orange,
  red,
  yellow,
  green,
  darkBlue,
}

extension ColorGroupX on ColorGroup {
  String get labelUk => districtName;

  /// Night City district / corp zone label.
  String get districtName => switch (this) {
        ColorGroup.brown => 'Kabuki Slums',
        ColorGroup.lightBlue => 'Watson Hub',
        ColorGroup.pink => 'Japantown Neon',
        ColorGroup.orange => 'Heywood Barrens',
        ColorGroup.red => 'Pacifica Ruins',
        ColorGroup.yellow => 'Westbrook Luxury',
        ColorGroup.green => 'City Center Grid',
        ColorGroup.darkBlue => 'Arasaka Corporate Plaza',
      };

  int get propertyCount => switch (this) {
        ColorGroup.brown || ColorGroup.darkBlue => 2,
        _ => 3,
      };

  Color get swatch => switch (this) {
        ColorGroup.brown => const Color(0xFFB85C38),
        ColorGroup.lightBlue => CyberColors.neonCyan,
        ColorGroup.pink => CyberColors.neonMagenta,
        ColorGroup.orange => const Color(0xFFFF6A00),
        ColorGroup.red => const Color(0xFFFF2A2A),
        ColorGroup.yellow => CyberColors.cyberYellow,
        ColorGroup.green => CyberColors.terminalGreen,
        ColorGroup.darkBlue => const Color(0xFF4B6CFF),
      };

  int get houseCost => switch (this) {
        ColorGroup.brown || ColorGroup.lightBlue => 50,
        ColorGroup.pink || ColorGroup.orange => 100,
        ColorGroup.red || ColorGroup.yellow => 150,
        ColorGroup.green || ColorGroup.darkBlue => 200,
      };
}
