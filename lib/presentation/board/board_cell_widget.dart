import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/game_rules.dart';
import '../../core/constants/street_colors.dart';
import '../../core/theme/cyber_theme.dart';
import '../../models/cell.dart';
import 'board_geometry.dart';

class BoardCellWidget extends StatelessWidget {
  const BoardCellWidget({
    super.key,
    required this.cell,
    required this.ownerColor,
  });

  final BoardCell cell;
  final Color? ownerColor;

  @override
  Widget build(BuildContext context) {
    final isCorner = BoardGeometry.isCorner(cell.index);
    final rotation = _labelRotation(cell.index);
    final accent = switch (cell) {
      PropertyCell(:final colorGroup) => colorGroup.swatch,
      SpecialCell(:final kind) => switch (kind) {
          SpecialKind.go => CyberColors.terminalGreen,
          SpecialKind.goToJail || SpecialKind.jail => CyberColors.neonMagenta,
          SpecialKind.chance || SpecialKind.communityChest =>
            CyberColors.cyberYellow,
          SpecialKind.freeParking => CyberColors.neonCyan,
        },
      TaxCell() => CyberColors.neonMagenta,
      RailroadCell() || UtilityCell() => CyberColors.neonCyan,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: CyberColors.panel.withValues(alpha: 0.92),
        border: Border.all(
          color: accent.withValues(alpha: 0.55),
          width: 0.7,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (cell is PropertyCell)
            _ColorBand(
              group: (cell as PropertyCell).colorGroup,
              index: cell.index,
            ),
          Padding(
            padding: EdgeInsets.only(
              top: cell is PropertyCell && _bandOnTop(cell.index) ? 10 : 2,
              bottom: cell is PropertyCell && !_bandOnTop(cell.index) ? 10 : 2,
              left: 2,
              right: 2,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Transform.rotate(
                angle: rotation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _shortLabel(cell),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.shareTechMono(
                        fontSize: isCorner ? 8 : 6.5,
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                        color: CyberColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (cell.priceOrNull != null)
                      Text(
                        GameRules.credits(cell.priceOrNull!),
                        style: GoogleFonts.shareTechMono(
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                          color: CyberColors.cyberYellow,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (ownerColor != null)
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: ownerColor,
                  shape: BoxShape.circle,
                  boxShadow: CyberTheme.glow(ownerColor!, blur: 6),
                  border: Border.all(color: Colors.white24, width: 0.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static bool _bandOnTop(int index) {
    if (index >= 1 && index <= 9) return true;
    if (index >= 11 && index <= 19) return false;
    if (index >= 21 && index <= 29) return false;
    if (index >= 31 && index <= 39) return true;
    return true;
  }

  static double _labelRotation(int index) {
    if (index >= 11 && index <= 19) return 1.5708;
    if (index >= 21 && index <= 29) return 3.14159;
    if (index >= 31 && index <= 39) return -1.5708;
    return 0;
  }

  static String _shortLabel(BoardCell cell) {
    return switch (cell) {
      SpecialCell(:final kind) => switch (kind) {
          SpecialKind.go => 'CYCLE\nRESET',
          SpecialKind.jail => 'ICE\nLOCK',
          SpecialKind.freeParking => 'SAFE\nZONE',
          SpecialKind.goToJail => 'DETENTION',
          SpecialKind.chance => 'DATA\nBREACH',
          SpecialKind.communityChest => 'CORPO\nBOUNTY',
        },
      TaxCell(:final name) => name
          .replaceAll('NETWATCH ', '')
          .replaceAll('LUXURY ', '')
          .replaceAll(' TARIFF', '')
          .replaceAll(' LEVY', ''),
      RailroadCell(:final name) => name
          .replaceFirst('MAGLEV STATION ', 'MAGLEV\n'),
      UtilityCell(:final name) => name.split(' ').take(2).join('\n'),
      _ => cell.name,
    };
  }
}

class _ColorBand extends StatelessWidget {
  const _ColorBand({required this.group, required this.index});

  final ColorGroup group;
  final int index;

  @override
  Widget build(BuildContext context) {
    final top = BoardCellWidget._bandOnTop(index);
    return Align(
      alignment: top ? Alignment.topCenter : Alignment.bottomCenter,
      child: Container(
        height: 9,
        width: double.infinity,
        decoration: BoxDecoration(
          color: group.swatch,
          boxShadow: [
            BoxShadow(
              color: group.swatch.withValues(alpha: 0.7),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
