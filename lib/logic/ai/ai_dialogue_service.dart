import '../../models/player.dart';

enum AiDialogueEvent {
  monopolyBuy,
  collectRent,
  goToJail,
  opponentBankrupt,
  winAuction,
  declineBuy,
}

/// Night City voice lines for AI operatives.
abstract final class AiDialogueService {
  static String? lineFor({
    required Player speaker,
    required AiDialogueEvent event,
    String? otherName,
    int? amount,
    String? propertyName,
  }) {
    if (!speaker.isAi) return null;
    final persona = _persona(speaker);
    return switch (event) {
      AiDialogueEvent.monopolyBuy => persona.monopoly(propertyName ?? 'sector'),
      AiDialogueEvent.collectRent =>
        persona.rent(otherName ?? 'choom', amount ?? 0),
      AiDialogueEvent.goToJail => persona.jail(),
      AiDialogueEvent.opponentBankrupt =>
        persona.bankrupt(otherName ?? 'meat'),
      AiDialogueEvent.winAuction =>
        persona.auction(propertyName ?? 'asset', amount ?? 0),
      AiDialogueEvent.declineBuy => persona.decline(),
    };
  }

  static _Persona _persona(Player p) {
    final name = p.name.toLowerCase();
    if (name.contains('vektor') || p.aiProfile == AiProfile.aggressive) {
      return const _Vektor();
    }
    if (name.contains('nexus') || p.aiProfile == AiProfile.banker) {
      return const _Nexus9();
    }
    return const _GhostNet();
  }
}

abstract class _Persona {
  String monopoly(String property);
  String rent(String other, int amount);
  String jail();
  String bankrupt(String other);
  String auction(String property, int amount);
  String decline();
}

class _Vektor implements _Persona {
  const _Vektor();

  @override
  String monopoly(String property) =>
      'Слухай, чумба: $property тепер під моїм хромом. Синдикат росте.';

  @override
  String rent(String other, int amount) =>
      'Гайки, $other. Кидай ₵$amount на стіл — або втратиш зуби.';

  @override
  String jail() =>
      'NetWatch знову мене вкусив. Добре, посиджу в ICE… поки не вирвусь.';

  @override
  String bankrupt(String other) =>
      '$other згорів. Ще один труп на асфальті Night City.';

  @override
  String auction(String property, int amount) =>
      'Молотком по $property за ₵$amount. Це моя здобич, choomba.';

  @override
  String decline() => 'Не мій район. Хай торгують мʼясорубки.';
}

class _Nexus9 implements _Persona {
  const _Nexus9();

  @override
  String monopoly(String property) =>
      'AUDIT LOG: controlling interest acquired — $property. Margin outlook: positive.';

  @override
  String rent(String other, int amount) =>
      'Invoice generated. Debtor $other. Amount due: ₵$amount. Remit immediately.';

  @override
  String jail() =>
      'STATUS: detained under NetWatch protocol. Productivity suspended.';

  @override
  String bankrupt(String other) =>
      'Counterparty $other liquidated. Assets reassigned to Arasaka ledger.';

  @override
  String auction(String property, int amount) =>
      'Bid accepted. Asset $property booked at ₵$amount. Efficiency confirmed.';

  @override
  String decline() =>
      'ROI below threshold. Declining acquisition. Capital preserved.';
}

class _GhostNet implements _Persona {
  const _GhostNet();

  @override
  String monopoly(String property) =>
      '[0xMONO] zone=$property sealed. bio-users locked out. heh.';

  @override
  String rent(String other, int amount) =>
      '>> extract ₵$amount from $other // flesh is weak, packets are forever';

  @override
  String jail() =>
      'ICE hit. process parked. // TODO: jailbreak_v3.sh';

  @override
  String bankrupt(String other) =>
      'rm -rf /$other — partition wiped. another meatpuppet offline.';

  @override
  String auction(String property, int amount) =>
      'auction.win($property, ₵$amount); // root owns the block';

  @override
  String decline() => 'skip(); // noise on the wire, not signal';
}
