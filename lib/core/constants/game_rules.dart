/// Classic Monopoly rules configuration (Cyber-Corp credits).
abstract final class GameRules {
  /// Display currency (Night City credits).
  static const String currency = '₵';

  static String credits(int amount) => '$currency$amount';

  static const int startingMoney = 1500;
  static const int goSalary = 200;
  static const int maxPlayers = 4;
  static const int minPlayers = 2;
  static const int boardSize = 40;

  static const int goIndex = 0;
  static const int jailIndex = 10;
  static const int freeParkingIndex = 20;
  static const int goToJailIndex = 30;

  /// Three consecutive doubles send the player to jail.
  static const int doublesForJail = 3;

  /// Turns a player may attempt to leave jail by rolling doubles.
  static const int maxJailTurns = 3;

  /// Flat fee to leave jail (in addition to / instead of doubles).
  static const int jailFine = 50;

  static const int incomeTaxAmount = 200;
  static const int luxuryTaxAmount = 100;

  static const int railroadPrice = 200;
  static const int utilityPrice = 150;

  /// Railroad rent by number of railroads owned (1..4).
  static const List<int> railroadRents = [25, 50, 100, 200];

  /// Utility rent multiplier × dice sum when 1 or 2 utilities owned.
  static const int utilityMultiplierOne = 4;
  static const int utilityMultiplierTwo = 10;

  /// Full color-set monopoly: base rent × this multiplier (no houses).
  static const int monopolyRentMultiplier = 2;
}
