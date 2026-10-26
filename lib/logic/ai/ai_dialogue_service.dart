import '../../core/l10n/app_lang.dart';
import '../../core/l10n/app_strings.dart';
import '../../models/player.dart';

enum AiDialogueEvent {
  monopolyBuy,
  collectRent,
  goToJail,
  opponentBankrupt,
  winAuction,
  declineBuy,
}

/// Night City voice lines for AI operatives, in the active interface language.
abstract final class AiDialogueService {
  static String? lineFor({
    required Player speaker,
    required AiDialogueEvent event,
    String? otherName,
    int? amount,
    String? propertyName,
    AppStrings strings = const AppStrings(AppLang.en),
  }) {
    if (!speaker.isAi) return null;
    final persona = _persona(speaker);
    final key = switch (event) {
      AiDialogueEvent.monopolyBuy => 'mono',
      AiDialogueEvent.collectRent => 'rent',
      AiDialogueEvent.goToJail => 'jail',
      AiDialogueEvent.opponentBankrupt => 'broke',
      AiDialogueEvent.winAuction => 'auction',
      AiDialogueEvent.declineBuy => 'decline',
    };
    return strings.aiLine(
      persona: persona,
      event: key,
      other: otherName,
      amount: amount,
      property: propertyName,
    );
  }

  static String _persona(Player p) {
    final name = p.name.toLowerCase();
    if (name.contains('vektor') || p.aiProfile == AiProfile.aggressive) {
      return 'vektor';
    }
    if (name.contains('nexus') || p.aiProfile == AiProfile.banker) {
      return 'nexus';
    }
    return 'ghost';
  }
}
