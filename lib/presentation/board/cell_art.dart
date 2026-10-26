import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/game_rules.dart';
import '../../core/constants/street_colors.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/theme/cyber_theme.dart';
import '../../models/cell.dart';

/// One Night City frame per location. Tiles crop the center; cards show more of it.
abstract final class CellArt {
  static String assetFor(BoardCell cell) {
    return switch (cell) {
      SpecialCell(:final kind) => switch (kind) {
          SpecialKind.go => 'assets/board/go.jpg',
          SpecialKind.jail => 'assets/board/jail.jpg',
          SpecialKind.freeParking => 'assets/board/safe.jpg',
          SpecialKind.goToJail => 'assets/board/detention.jpg',
          SpecialKind.chance => 'assets/board/breach.jpg',
          SpecialKind.communityChest => 'assets/board/bounty.jpg',
        },
      TaxCell(:final name) => name.contains('LUXURY')
          ? 'assets/board/tax_luxury.jpg'
          : 'assets/board/tax_net.jpg',
      RailroadCell() => 'assets/board/maglev.jpg',
      UtilityCell(:final name) => name.contains('WATER')
          ? 'assets/board/water.jpg'
          : 'assets/board/power.jpg',
      PropertyCell(:final name) => switch (name) {
          'Kabuki Back-Alley' => 'assets/board/kabuki.jpg',
          'Cherry Blossom Market' => 'assets/board/cherry.jpg',
          'Little China Node' => 'assets/board/little_china.jpg',
          'Northside Industrial' => 'assets/board/northside.jpg',
          'Watson Transit Hub' => 'assets/board/watson_transit.jpg',
          'Jig-Jig Street' => 'assets/board/jigjig.jpg',
          'Glow Street Arcade' => 'assets/board/glow_arcade.jpg',
          'Sakura Dome Mall' => 'assets/board/sakura_mall.jpg',
          'Valentino Block' => 'assets/board/valentino.jpg',
          'Vista Del Rey Flats' => 'assets/board/vista.jpg',
          'Glen Market Stack' => 'assets/board/glen.jpg',
          'Coastview Wrecks' => 'assets/board/coastview.jpg',
          'Grand Imperial Mall' => 'assets/board/grand_imperial.jpg',
          'Pacifica Combat Zone' => 'assets/board/pacifica_combat.jpg',
          'Charter Hill Villas' => 'assets/board/charter_hill.jpg',
          'North Oak Estates' => 'assets/board/north_oak.jpg',
          'Corpo Plaza West' => 'assets/board/corpo_west.jpg',
          'Corpo Plaza East' => 'assets/board/corpo_east.jpg',
          'Memorial Park Spire' => 'assets/board/memorial_spire.jpg',
          'Downtown Data Sprawl' => 'assets/board/downtown.jpg',
          'Arasaka Tower Lobby' => 'assets/board/arasaka_lobby.jpg',
          'Arasaka Penthouse' => 'assets/board/arasaka_penthouse.jpg',
          _ => 'assets/board/go.jpg',
        },
    };
  }

  /// Stations share one picture. The letter tells them apart.
  static String? stationMark(BoardCell cell) {
    if (cell is! RailroadCell) return null;
    final name = cell.name;
    if (name.contains('ALPHA')) return 'A';
    if (name.contains('BETA')) return 'B';
    if (name.contains('GAMMA')) return 'G';
    if (name.contains('DELTA')) return 'D';
    return null;
  }
}

class CellArtwork extends StatelessWidget {
  const CellArtwork({super.key, required this.cell, this.virusHops = 0});

  final BoardCell cell;
  final int virusHops;

  static const List<double> _muted = <double>[
    0.45, 0.35, 0.2, 0, 0,
    0.25, 0.45, 0.3, 0, 0,
    0.25, 0.35, 0.45, 0, 0,
    0, 0, 0, 1, 0,
  ];

  @override
  Widget build(BuildContext context) {
    final mark = CellArt.stationMark(cell);
    final racks = cell is PropertyCell ? (cell as PropertyCell).houses : 0;
    Widget image = Image.asset(
      CellArt.assetFor(cell),
      fit: BoxFit.cover,
      alignment: Alignment.center,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) =>
          const ColoredBox(color: CyberColors.deepIndigo),
    );
    if (cell.isMortgagedOrFalse) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.matrix(_muted),
        child: image,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        image,
        if (virusHops > 0)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0x55FF2BD6), Color(0x00000000), Color(0x66FF2BD6)],
              ),
            ),
            child: SizedBox.expand(),
          ),
        if (racks > 0)
          Positioned(
            left: 3,
            bottom: 3,
            child: Row(
              children: [
                for (var i = 0; i < (racks >= 5 ? 4 : racks); i++)
                  Container(
                    width: racks >= 5 ? 5 : 4,
                    height: racks >= 5 ? 5 : 4,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: racks >= 5
                          ? CyberColors.neonMagenta
                          : CyberColors.neonCyan,
                      boxShadow: CyberTheme.glow(
                        racks >= 5
                            ? CyberColors.neonMagenta
                            : CyberColors.neonCyan,
                        blur: 4,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (mark != null)
          Positioned(
            left: 2,
            top: 2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: CyberColors.voidBlack.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: CyberColors.neonCyan.withValues(alpha: 0.8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                child: Text(
                  mark,
                  style: GoogleFonts.shareTechMono(
                    color: CyberColors.neonCyan,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Large frame for the center of the board and for deed / buy dialogs.
class CellPortrait extends StatelessWidget {
  const CellPortrait({
    super.key,
    required this.cell,
    this.height = 120,
    this.onTap,
    this.showCaption = true,
    this.status,
    this.virusHops = 0,
  });

  final BoardCell cell;
  final double height;
  final VoidCallback? onTap;
  final bool showCaption;
  final String? status;
  final int virusHops;

  @override
  Widget build(BuildContext context) {
    final s = stringsOf(context);
    final price = cell.priceOrNull;
    final district = cell is PropertyCell
        ? s.districtName((cell as PropertyCell).colorGroup)
        : null;

    final frame = ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CellArtwork(cell: cell, virusHops: virusHops),
      ),
    );

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        frame,
        if (showCaption) ...[
          const SizedBox(height: 4),
          Text(
            cell.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.rajdhani(
              color: CyberColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          if (status != null && status!.isNotEmpty)
            Text(
              status!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.shareTechMono(
                color: CyberColors.terminalGreen,
                fontSize: 10,
                height: 1.2,
              ),
            )
          else if (district != null || price != null)
            Text(
              [
                ?district,
                if (price != null) GameRules.credits(price),
              ].join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.shareTechMono(
                color: district != null
                    ? BoardCellAccent.of(cell)
                    : CyberColors.cyberYellow,
                fontSize: 10,
                height: 1.2,
              ),
            ),
        ],
      ],
    );

    if (onTap == null) return body;
    return InkWell(
      onTap: onTap,
      child: body,
    );
  }
}

/// Accent used by captions. Kept here so dialogs do not import the tile widget.
abstract final class BoardCellAccent {
  static Color of(BoardCell cell) {
    return switch (cell) {
      PropertyCell(:final colorGroup) => colorGroup.swatch,
      SpecialCell(:final kind) => switch (kind) {
          SpecialKind.go => CyberColors.terminalGreen,
          SpecialKind.goToJail || SpecialKind.jail => CyberColors.neonMagenta,
          SpecialKind.chance ||
          SpecialKind.communityChest =>
            CyberColors.cyberYellow,
          SpecialKind.freeParking => CyberColors.neonCyan,
        },
      TaxCell() => CyberColors.neonMagenta,
      RailroadCell() || UtilityCell() => CyberColors.neonCyan,
    };
  }
}
