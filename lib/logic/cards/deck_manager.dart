import 'dart:math';

import 'game_card.dart';

/// Shuffleable FIFO decks for DATA BREACH / CORPO BOUNTY.
class DeckManager {
  DeckManager({
    List<GameCard>? dataBreach,
    List<GameCard>? corpoBounty,
    Random? random,
  })  : _random = random ?? Random(),
        _dataBreach = List<GameCard>.from(
          dataBreach ?? CyberCardCatalog.dataBreachDeck(),
        ),
        _corpoBounty = List<GameCard>.from(
          corpoBounty ?? CyberCardCatalog.corpoBountyDeck(),
        ) {
    if (dataBreach == null) shuffleAll();
    if (corpoBounty == null && dataBreach != null) {
      // only shuffle missing — handled above
    }
  }

  factory DeckManager.shuffled([Random? random]) =>
      DeckManager(random: random)..shuffleAll();

  final Random _random;
  final List<GameCard> _dataBreach;
  final List<GameCard> _corpoBounty;

  void shuffleAll() {
    _dataBreach.shuffle(_random);
    _corpoBounty.shuffle(_random);
  }

  GameCard peek(CardDeckKind kind) {
    final deck = kind == CardDeckKind.dataBreach ? _dataBreach : _corpoBounty;
    if (deck.isEmpty) {
      return kind == CardDeckKind.dataBreach
          ? CyberCardCatalog.dataBreachDeck().first
          : CyberCardCatalog.corpoBountyDeck().first;
    }
    return deck.first;
  }

  GameCard draw(CardDeckKind kind) {
    final deck = kind == CardDeckKind.dataBreach ? _dataBreach : _corpoBounty;
    if (deck.isEmpty) {
      final refill = kind == CardDeckKind.dataBreach
          ? CyberCardCatalog.dataBreachDeck()
          : CyberCardCatalog.corpoBountyDeck();
      deck
        ..clear()
        ..addAll(refill)
        ..shuffle(_random);
    }
    final card = deck.removeAt(0);
    // Return to bottom unless Get Out of Jail (held by player).
    if (card.effect != CardEffectType.getOutOfJail) {
      deck.add(card);
    }
    return card;
  }

  void returnGetOutCard(CardDeckKind kind) {
    final catalog = kind == CardDeckKind.dataBreach
        ? CyberCardCatalog.dataBreachDeck()
        : CyberCardCatalog.corpoBountyDeck();
    final card = catalog.firstWhere((c) => c.effect == CardEffectType.getOutOfJail);
    final deck = kind == CardDeckKind.dataBreach ? _dataBreach : _corpoBounty;
    if (!deck.any((c) => c.id == card.id)) {
      deck.add(card);
    }
  }

  Map<String, dynamic> toJson() => {
        'dataBreach': _dataBreach.map((c) => c.id).toList(),
        'corpoBounty': _corpoBounty.map((c) => c.id).toList(),
      };

  factory DeckManager.fromJson(Map<String, dynamic> json, [Random? random]) {
    GameCard byId(String id) {
      final all = [
        ...CyberCardCatalog.dataBreachDeck(),
        ...CyberCardCatalog.corpoBountyDeck(),
      ];
      return all.firstWhere((c) => c.id == id);
    }

    return DeckManager(
      dataBreach: [
        for (final id in (json['dataBreach'] as List<dynamic>? ?? const []))
          byId(id as String),
      ],
      corpoBounty: [
        for (final id in (json['corpoBounty'] as List<dynamic>? ?? const []))
          byId(id as String),
      ],
      random: random,
    );
  }
}
