import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/game_rules.dart';
import '../../core/constants/street_colors.dart';
import '../../core/theme/cyber_theme.dart';
import '../../models/cell.dart';
import 'cell_art.dart';

class BoardCellWidget extends StatelessWidget {
  const BoardCellWidget({
    super.key,
    required this.cell,
    required this.ownerColor,
    this.onTap,
    this.selected = false,
    this.virusHops = 0,
  });

  final BoardCell cell;
  final Color? ownerColor;
  final VoidCallback? onTap;
  final bool selected;
  final int virusHops;

  static Color accentOf(BoardCell cell) {
    return switch (cell) {
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
  }

  @override
  Widget build(BuildContext context) {
    final accent = accentOf(cell);
    final property = cell is PropertyCell ? cell as PropertyCell : null;
    final mortgaged = cell.isMortgagedOrFalse;

    final price = cell.priceOrNull;
    return Semantics(
      button: true,
      container: true,
      excludeSemantics: true,
      label: price == null
          ? cell.name
          : '${cell.name} ${GameRules.credits(price)}',
      child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: accent.withValues(alpha: 0.16),
        splashColor: accent.withValues(alpha: 0.28),
        highlightColor: accent.withValues(alpha: 0.1),
        child: Ink(
          decoration: BoxDecoration(
            color: CyberColors.panel.withValues(alpha: 0.92),
            border: Border.all(
              color: selected ? CyberColors.neonCyan : CyberColors.gridLine,
              width: selected ? 1.6 : 0.7,
            ),
            boxShadow: selected
                ? CyberTheme.glow(CyberColors.neonCyan, blur: 8)
                : null,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final side = math.min(constraints.maxWidth, constraints.maxHeight);
              final labelSize = (side / 6.4).clamp(7.0, 14.0);
              final priceSize = (labelSize * 0.85).clamp(7.0, 12.0);
              final band = (side * 0.12).clamp(4.0, 10.0);
              final bandOnTop = _bandOnTop(cell.index);

              return Stack(
                fit: StackFit.expand,
                children: [
                  CellArtwork(cell: cell, virusHops: virusHops),
                  if (mortgaged) const CustomPaint(painter: _MortgageHatch()),
                  if (property != null)
                    _ColorBand(
                      color: property.colorGroup.swatch,
                      onTop: bandOnTop,
                      thickness: band,
                    ),
                  if (price != null && !mortgaged)
                    Align(
                      alignment: bandOnTop
                          ? Alignment.bottomCenter
                          : Alignment.topCenter,
                      child: ColoredBox(
                        color: CyberColors.voidBlack.withValues(alpha: 0.62),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            GameRules.credits(price),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.shareTechMono(
                              fontSize: priceSize,
                              fontWeight: FontWeight.w700,
                              height: 1.05,
                              color: CyberColors.cyberYellow,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (property != null && property.houses > 0)
                    _DevMarks(
                      houses: property.houses,
                      onTop: !bandOnTop,
                    ),
                  if (ownerColor != null)
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: math.max(6, side * 0.16),
                        height: math.max(6, side * 0.16),
                        decoration: BoxDecoration(
                          color: ownerColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 0.6),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
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

}

class _ColorBand extends StatelessWidget {
  const _ColorBand({
    required this.color,
    required this.onTop,
    required this.thickness,
  });

  final Color color;
  final bool onTop;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: onTop ? Alignment.topCenter : Alignment.bottomCenter,
      child: Container(
        height: thickness,
        width: double.infinity,
        color: color,
      ),
    );
  }
}

class _DevMarks extends StatelessWidget {
  const _DevMarks({required this.houses, required this.onTop});

  final int houses;
  final bool onTop;

  @override
  Widget build(BuildContext context) {
    final hq = houses >= 5;
    return Align(
      alignment: onTop ? Alignment.topCenter : Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: hq
            ? Container(
                width: 16,
                height: 5,
                decoration: BoxDecoration(
                  color: CyberColors.neonMagenta,
                  borderRadius: BorderRadius.circular(1),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < houses; i++)
                    Container(
                      width: 3,
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 0.6),
                      color: CyberColors.terminalGreen,
                    ),
                ],
              ),
      ),
    );
  }
}

class _MortgageHatch extends CustomPainter {
  const _MortgageHatch();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CyberColors.neonMagenta.withValues(alpha: 0.28)
      ..strokeWidth = 1;
    for (double x = -size.height; x < size.width; x += 6) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
