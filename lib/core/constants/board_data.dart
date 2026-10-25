import '../../models/cell.dart';
import 'game_rules.dart';
import 'street_colors.dart';

/// Night City board: indices 0..39, classic prices, Cyber-Corp lore names.
/// Currency displayed as credits (₵) in UI.
abstract final class BoardData {
  static List<BoardCell> createBoard() => List<BoardCell>.unmodifiable(_cells);

  static const List<BoardCell> _cells = [
    // 0
    BoardCell.special(
      index: 0,
      name: 'CYCLE RESET',
      kind: SpecialKind.go,
    ),
    // 1 — Kabuki Slums
    BoardCell.property(
      index: 1,
      name: 'Kabuki Back-Alley',
      colorGroup: ColorGroup.brown,
      price: 60,
      rents: [2, 10, 30, 90, 160, 250],
      mortgage: 30,
    ),
    // 2
    BoardCell.special(
      index: 2,
      name: 'CORPO BOUNTY',
      kind: SpecialKind.communityChest,
    ),
    // 3
    BoardCell.property(
      index: 3,
      name: 'Cherry Blossom Market',
      colorGroup: ColorGroup.brown,
      price: 60,
      rents: [4, 20, 60, 180, 320, 450],
      mortgage: 30,
    ),
    // 4
    BoardCell.tax(
      index: 4,
      name: 'NETWATCH TAX LEVY',
      amount: GameRules.incomeTaxAmount,
    ),
    // 5
    BoardCell.railroad(
      index: 5,
      name: 'MAGLEV STATION ALPHA',
      price: GameRules.railroadPrice,
      mortgage: 100,
    ),
    // 6 — Watson Hub
    BoardCell.property(
      index: 6,
      name: 'Little China Node',
      colorGroup: ColorGroup.lightBlue,
      price: 100,
      rents: [6, 30, 90, 270, 400, 550],
      mortgage: 50,
    ),
    // 7
    BoardCell.special(
      index: 7,
      name: 'DATA BREACH',
      kind: SpecialKind.chance,
    ),
    // 8
    BoardCell.property(
      index: 8,
      name: 'Northside Industrial',
      colorGroup: ColorGroup.lightBlue,
      price: 100,
      rents: [6, 30, 90, 270, 400, 550],
      mortgage: 50,
    ),
    // 9
    BoardCell.property(
      index: 9,
      name: 'Watson Transit Hub',
      colorGroup: ColorGroup.lightBlue,
      price: 120,
      rents: [8, 40, 100, 300, 450, 600],
      mortgage: 60,
    ),
    // 10
    BoardCell.special(
      index: 10,
      name: 'NETWATCH ICE LOCKDOWN',
      kind: SpecialKind.jail,
    ),
    // 11 — Japantown Neon
    BoardCell.property(
      index: 11,
      name: 'Jig-Jig Street',
      colorGroup: ColorGroup.pink,
      price: 140,
      rents: [10, 50, 150, 450, 625, 750],
      mortgage: 70,
    ),
    // 12
    BoardCell.utility(
      index: 12,
      name: 'POWER GRID RELAY',
      price: GameRules.utilityPrice,
      mortgage: 75,
    ),
    // 13
    BoardCell.property(
      index: 13,
      name: 'Glow Street Arcade',
      colorGroup: ColorGroup.pink,
      price: 140,
      rents: [10, 50, 150, 450, 625, 750],
      mortgage: 70,
    ),
    // 14
    BoardCell.property(
      index: 14,
      name: 'Sakura Dome Mall',
      colorGroup: ColorGroup.pink,
      price: 160,
      rents: [12, 60, 180, 500, 700, 900],
      mortgage: 80,
    ),
    // 15
    BoardCell.railroad(
      index: 15,
      name: 'MAGLEV STATION BETA',
      price: GameRules.railroadPrice,
      mortgage: 100,
    ),
    // 16 — Heywood Barrens
    BoardCell.property(
      index: 16,
      name: 'Valentino Block',
      colorGroup: ColorGroup.orange,
      price: 180,
      rents: [14, 70, 200, 550, 750, 950],
      mortgage: 90,
    ),
    // 17
    BoardCell.special(
      index: 17,
      name: 'CORPO BOUNTY',
      kind: SpecialKind.communityChest,
    ),
    // 18
    BoardCell.property(
      index: 18,
      name: 'Vista Del Rey Flats',
      colorGroup: ColorGroup.orange,
      price: 180,
      rents: [14, 70, 200, 550, 750, 950],
      mortgage: 90,
    ),
    // 19
    BoardCell.property(
      index: 19,
      name: 'Glen Market Stack',
      colorGroup: ColorGroup.orange,
      price: 200,
      rents: [16, 80, 220, 600, 800, 1000],
      mortgage: 100,
    ),
    // 20
    BoardCell.special(
      index: 20,
      name: 'NEUTRAL SAFE-ZONE',
      kind: SpecialKind.freeParking,
    ),
    // 21 — Pacifica Ruins
    BoardCell.property(
      index: 21,
      name: 'Coastview Wrecks',
      colorGroup: ColorGroup.red,
      price: 220,
      rents: [18, 90, 250, 700, 875, 1050],
      mortgage: 110,
    ),
    // 22
    BoardCell.special(
      index: 22,
      name: 'DATA BREACH',
      kind: SpecialKind.chance,
    ),
    // 23
    BoardCell.property(
      index: 23,
      name: 'Grand Imperial Mall',
      colorGroup: ColorGroup.red,
      price: 220,
      rents: [18, 90, 250, 700, 875, 1050],
      mortgage: 110,
    ),
    // 24
    BoardCell.property(
      index: 24,
      name: 'Pacifica Combat Zone',
      colorGroup: ColorGroup.red,
      price: 240,
      rents: [20, 100, 300, 750, 925, 1100],
      mortgage: 120,
    ),
    // 25
    BoardCell.railroad(
      index: 25,
      name: 'MAGLEV STATION GAMMA',
      price: GameRules.railroadPrice,
      mortgage: 100,
    ),
    // 26 — Westbrook Luxury
    BoardCell.property(
      index: 26,
      name: 'Charter Hill Villas',
      colorGroup: ColorGroup.yellow,
      price: 260,
      rents: [22, 110, 330, 800, 975, 1150],
      mortgage: 130,
    ),
    // 27
    BoardCell.property(
      index: 27,
      name: 'North Oak Estates',
      colorGroup: ColorGroup.yellow,
      price: 260,
      rents: [22, 110, 330, 800, 975, 1150],
      mortgage: 130,
    ),
    // 28
    BoardCell.utility(
      index: 28,
      name: 'WATERNET PURIFIER',
      price: GameRules.utilityPrice,
      mortgage: 75,
    ),
    // 29
    BoardCell.property(
      index: 29,
      name: 'Corpo Plaza West',
      colorGroup: ColorGroup.yellow,
      price: 280,
      rents: [24, 120, 360, 850, 1025, 1200],
      mortgage: 140,
    ),
    // 30
    BoardCell.special(
      index: 30,
      name: 'CYBERPSYCHO DETENTION',
      kind: SpecialKind.goToJail,
    ),
    // 31 — City Center Grid
    BoardCell.property(
      index: 31,
      name: 'Corpo Plaza East',
      colorGroup: ColorGroup.green,
      price: 300,
      rents: [26, 130, 390, 900, 1100, 1275],
      mortgage: 150,
    ),
    // 32
    BoardCell.property(
      index: 32,
      name: 'Memorial Park Spire',
      colorGroup: ColorGroup.green,
      price: 300,
      rents: [26, 130, 390, 900, 1100, 1275],
      mortgage: 150,
    ),
    // 33
    BoardCell.special(
      index: 33,
      name: 'CORPO BOUNTY',
      kind: SpecialKind.communityChest,
    ),
    // 34
    BoardCell.property(
      index: 34,
      name: 'Downtown Data Sprawl',
      colorGroup: ColorGroup.green,
      price: 320,
      rents: [28, 150, 450, 1000, 1200, 1400],
      mortgage: 160,
    ),
    // 35
    BoardCell.railroad(
      index: 35,
      name: 'MAGLEV STATION DELTA',
      price: GameRules.railroadPrice,
      mortgage: 100,
    ),
    // 36
    BoardCell.special(
      index: 36,
      name: 'DATA BREACH',
      kind: SpecialKind.chance,
    ),
    // 37 — Arasaka Corporate Plaza
    BoardCell.property(
      index: 37,
      name: 'Arasaka Tower Lobby',
      colorGroup: ColorGroup.darkBlue,
      price: 350,
      rents: [35, 175, 500, 1100, 1300, 1500],
      mortgage: 175,
    ),
    // 38
    BoardCell.tax(
      index: 38,
      name: 'LUXURY CHROME TARIFF',
      amount: GameRules.luxuryTaxAmount,
    ),
    // 39
    BoardCell.property(
      index: 39,
      name: 'Arasaka Penthouse',
      colorGroup: ColorGroup.darkBlue,
      price: 400,
      rents: [50, 200, 600, 1400, 1700, 2000],
      mortgage: 200,
    ),
  ];
}
