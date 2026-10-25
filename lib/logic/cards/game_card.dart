/// Cyber-Corp deck card (DATA BREACH / CORPO BOUNTY).
enum CardDeckKind { dataBreach, corpoBounty }

enum CardEffectType {
  gainMoney,
  loseMoney,
  moveTo,
  moveRelative,
  goToJail,
  getOutOfJail,
  repairs,
  collectFromEach,
  payEach,
  nearestRailroad,
  nearestUtility,
}

class GameCard {
  const GameCard({
    required this.id,
    required this.deck,
    required this.title,
    required this.description,
    required this.effect,
    this.amount = 0,
    this.targetIndex,
  });

  final String id;
  final CardDeckKind deck;
  final String title;
  final String description;
  final CardEffectType effect;
  final int amount;
  final int? targetIndex;

  Map<String, dynamic> toJson() => {
        'id': id,
        'deck': deck.name,
        'title': title,
        'description': description,
        'effect': effect.name,
        'amount': amount,
        'targetIndex': targetIndex,
      };

  factory GameCard.fromJson(Map<String, dynamic> json) => GameCard(
        id: json['id'] as String,
        deck: CardDeckKind.values.byName(json['deck'] as String),
        title: json['title'] as String,
        description: json['description'] as String,
        effect: CardEffectType.values.byName(json['effect'] as String),
        amount: json['amount'] as int? ?? 0,
        targetIndex: json['targetIndex'] as int?,
      );
}

/// Classic-inspired Night City decks.
abstract final class CyberCardCatalog {
  static List<GameCard> dataBreachDeck() => const [
        GameCard(
          id: 'db_go',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Exploit found. Advance to CYCLE RESET — collect ₵200.',
          effect: CardEffectType.moveTo,
          targetIndex: 0,
        ),
        GameCard(
          id: 'db_illinois',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Trace routed to Pacifica Combat Zone.',
          effect: CardEffectType.moveTo,
          targetIndex: 24,
        ),
        GameCard(
          id: 'db_charles',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Neon ping — go to Jig-Jig Street.',
          effect: CardEffectType.moveTo,
          targetIndex: 11,
        ),
        GameCard(
          id: 'db_rail',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Hop the nearest Maglev. Pay owner 2× fare if owned.',
          effect: CardEffectType.nearestRailroad,
        ),
        GameCard(
          id: 'db_util',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Force-jack nearest utility. Pay 10× dice if owned.',
          effect: CardEffectType.nearestUtility,
        ),
        GameCard(
          id: 'db_back3',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Packet loss. Go back 3 nodes.',
          effect: CardEffectType.moveRelative,
          amount: -3,
        ),
        GameCard(
          id: 'db_jail',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'NetWatch snare. ICE lockdown — no salary.',
          effect: CardEffectType.goToJail,
        ),
        GameCard(
          id: 'db_repairs',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Rack maintenance: ₵25 / Data Rack, ₵100 / MegaCorp HQ.',
          effect: CardEffectType.repairs,
          amount: 25, // house; hotel uses 100 via engine
        ),
        GameCard(
          id: 'db_speeding',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Speeding fine — pay ₵15.',
          effect: CardEffectType.loseMoney,
          amount: 15,
        ),
        GameCard(
          id: 'db_loan',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Street loan matures — collect ₵150.',
          effect: CardEffectType.gainMoney,
          amount: 150,
        ),
        GameCard(
          id: 'db_chair',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Syndicate chair dividend — ₵50.',
          effect: CardEffectType.gainMoney,
          amount: 50,
        ),
        GameCard(
          id: 'db_out',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Black ICE nullifier acquired (Get Out of Jail).',
          effect: CardEffectType.getOutOfJail,
        ),
        GameCard(
          id: 'db_boardwalk',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Take the elevator to Arasaka Penthouse.',
          effect: CardEffectType.moveTo,
          targetIndex: 39,
        ),
        GameCard(
          id: 'db_pay_each',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'You have been elected Chairman — pay each player ₵50.',
          effect: CardEffectType.payEach,
          amount: 50,
        ),
        GameCard(
          id: 'db_reading',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Advance to Maglev Station Alpha. Collect ₵200 if pass RESET.',
          effect: CardEffectType.moveTo,
          targetIndex: 5,
        ),
        GameCard(
          id: 'db_poor',
          deck: CardDeckKind.dataBreach,
          title: 'DATA BREACH',
          description: 'Poor tax — pay ₵20.',
          effect: CardEffectType.loseMoney,
          amount: 20,
        ),
      ];

  static List<GameCard> corpoBountyDeck() => const [
        GameCard(
          id: 'cb_bank_error',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Bank error in your favor — collect ₵200.',
          effect: CardEffectType.gainMoney,
          amount: 200,
        ),
        GameCard(
          id: 'cb_doctor',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Chrome clinic bill — pay ₵50.',
          effect: CardEffectType.loseMoney,
          amount: 50,
        ),
        GameCard(
          id: 'cb_stock',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Stock sale — collect ₵50.',
          effect: CardEffectType.gainMoney,
          amount: 50,
        ),
        GameCard(
          id: 'cb_out',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Arasaka legal waiver (Get Out of Jail).',
          effect: CardEffectType.getOutOfJail,
        ),
        GameCard(
          id: 'cb_jail',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Audit failed. Go to ICE lockdown.',
          effect: CardEffectType.goToJail,
        ),
        GameCard(
          id: 'cb_opera',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Night City opera opening — collect ₵50 from every operative.',
          effect: CardEffectType.collectFromEach,
          amount: 50,
        ),
        GameCard(
          id: 'cb_xmas',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Holiday fund — collect ₵100.',
          effect: CardEffectType.gainMoney,
          amount: 100,
        ),
        GameCard(
          id: 'cb_tax_refund',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Tax refund — collect ₵20.',
          effect: CardEffectType.gainMoney,
          amount: 20,
        ),
        GameCard(
          id: 'cb_life',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Life insurance matures — collect ₵100.',
          effect: CardEffectType.gainMoney,
          amount: 100,
        ),
        GameCard(
          id: 'cb_hospital',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Hospital fees — pay ₵100.',
          effect: CardEffectType.loseMoney,
          amount: 100,
        ),
        GameCard(
          id: 'cb_school',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'School tuition — pay ₵50.',
          effect: CardEffectType.loseMoney,
          amount: 50,
        ),
        GameCard(
          id: 'cb_consultancy',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Consultancy fee — collect ₵25.',
          effect: CardEffectType.gainMoney,
          amount: 25,
        ),
        GameCard(
          id: 'cb_repairs',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Street repairs: ₵40 / Data Rack, ₵115 / MegaCorp HQ.',
          effect: CardEffectType.repairs,
          amount: 40,
        ),
        GameCard(
          id: 'cb_beauty',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'You won a street beauty contest — ₵10.',
          effect: CardEffectType.gainMoney,
          amount: 10,
        ),
        GameCard(
          id: 'cb_inherit',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'You inherit ₵100.',
          effect: CardEffectType.gainMoney,
          amount: 100,
        ),
        GameCard(
          id: 'cb_go',
          deck: CardDeckKind.corpoBounty,
          title: 'CORPO BOUNTY',
          description: 'Advance to CYCLE RESET — collect ₵200.',
          effect: CardEffectType.moveTo,
          targetIndex: 0,
        ),
      ];
}
