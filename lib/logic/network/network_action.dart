import 'package:flutter/foundation.dart';

/// Broadcast event names on the Realtime channel.
abstract final class NetworkEvents {
  static const action = 'ACTION';
  static const stateSync = 'STATE_SYNC';
  static const lobby = 'LOBBY';
}

/// Concrete multiplayer command kinds (payload of [NetworkEvents.action]).
enum NetworkActionType {
  roll('ACTION_ROLL'),
  buy('ACTION_BUY'),
  declineBuy('ACTION_DECLINE_BUY'),
  endTurn('ACTION_END_TURN'),
  trade('ACTION_TRADE'),
  tradeAccept('ACTION_TRADE_ACCEPT'),
  tradeDecline('ACTION_TRADE_DECLINE'),
  auctionBid('ACTION_AUCTION_BID'),
  auctionPass('ACTION_AUCTION_PASS'),
  dismissNotice('ACTION_DISMISS'),
  payJailFine('ACTION_PAY_JAIL'),
  buildHouse('ACTION_BUILD'),
  sellHouse('ACTION_SELL'),
  mortgage('ACTION_MORTGAGE'),
  unmortgage('ACTION_UNMORTGAGE'),
  useJailCard('ACTION_JAIL_CARD'),
  overdraft('ACTION_OVERDRAFT'),
  buyout('ACTION_BUYOUT'),
  blackout('ACTION_BLACKOUT'),
  requestClaim('ACTION_REQUEST_CLAIM'),
  acceptClaim('ACTION_ACCEPT_CLAIM'),
  declineClaim('ACTION_DECLINE_CLAIM'),
  ready('ACTION_READY'),
  startGame('ACTION_START_GAME'),
  kickToAi('ACTION_KICK_TO_AI'),
  armChrome('ACTION_ARM_CHROME'),
  peekDeck('ACTION_PEEK_DECK'),
  dodgeRent('ACTION_DODGE_RENT'),
  fixer('ACTION_FIXER'),
  plantVirus('ACTION_PLANT_VIRUS'),
  clearVirus('ACTION_CLEAR_VIRUS'),
  settleShortfall('ACTION_SETTLE_SHORTFALL'),
  abandonShortfall('ACTION_ABANDON_SHORTFALL'),
  heatPay('ACTION_HEAT_PAY'),
  heatJail('ACTION_HEAT_JAIL'),
  cityDecree('ACTION_CITY_DECREE');

  const NetworkActionType(this.wireName);
  final String wireName;

  static NetworkActionType? tryParse(String? raw) {
    if (raw == null) return null;
    for (final v in values) {
      if (v.wireName == raw || v.name == raw) return v;
    }
    return null;
  }
}

/// Envelope sent over Supabase Broadcast.
@immutable
class NetworkAction {
  NetworkAction({
    required this.type,
    required this.senderId,
    this.payload = const {},
    DateTime? sentAt,
  }) : sentAt = sentAt ?? DateTime.now();

  final NetworkActionType type;
  final String senderId;
  final Map<String, dynamic> payload;
  final DateTime sentAt;

  Map<String, dynamic> toJson() => {
        'type': type.wireName,
        'senderId': senderId,
        // Avoid key name `payload` — Realtime may unwrap it and drop the envelope.
        'data': payload,
        'sentAt': sentAt.toIso8601String(),
      };

  /// Returns null for non-game payloads (acks / presence noise).
  static NetworkAction? tryFromJson(Map<String, dynamic> json) {
    final direct = NetworkActionType.tryParse(json['type'] as String?);
    if (direct != null) {
      final payloadRaw = json['data'] ?? json['payload'];
      return NetworkAction(
        type: direct,
        senderId: json['senderId'] as String? ?? '',
        payload: payloadRaw is Map
            ? Map<String, dynamic>.from(payloadRaw)
            : const {},
        sentAt: DateTime.tryParse(json['sentAt'] as String? ?? '') ??
            DateTime.now(),
      );
    }

    // Dig through Realtime wrappers without treating action `data` as envelope.
    for (final key in ['payload', 'data']) {
      final nested = json[key];
      if (nested is Map) {
        final map = Map<String, dynamic>.from(nested);
        if (NetworkActionType.tryParse(map['type'] as String?) != null) {
          return tryFromJson(map);
        }
      }
    }
    return null;
  }

  factory NetworkAction.fromJson(Map<String, dynamic> json) {
    final parsed = tryFromJson(json);
    if (parsed == null) {
      throw FormatException('Unknown NetworkAction type: ${json['type']}');
    }
    return parsed;
  }
}

/// Presence payload tracked per connected operative.
@immutable
class PresenceMember {
  const PresenceMember({
    required this.playerId,
    required this.name,
    required this.tokenColor,
    required this.joinedAtMs,
    required this.presenceKey,
    this.chrome = 'sandevistan',
    this.ready = false,
    this.isHost = false,
  });

  final String playerId;
  final String name;
  final String tokenColor;
  final String chrome;
  final int joinedAtMs;
  final String presenceKey;
  final bool ready;
  final bool isHost;

  Map<String, dynamic> toPresencePayload() => {
        'playerId': playerId,
        'name': name,
        'tokenColor': tokenColor,
        'chrome': chrome,
        'joinedAtMs': joinedAtMs,
        'ready': ready,
      };

  factory PresenceMember.fromPresence({
    required String presenceKey,
    required Map<String, dynamic> payload,
    bool isHost = false,
  }) {
    return PresenceMember(
      playerId: payload['playerId'] as String? ?? presenceKey,
      name: payload['name'] as String? ?? 'UNKNOWN',
      tokenColor: payload['tokenColor'] as String? ?? 'cyan',
      chrome: payload['chrome'] as String? ?? 'sandevistan',
      joinedAtMs: (payload['joinedAtMs'] as num?)?.toInt() ?? 0,
      presenceKey: presenceKey,
      ready: payload['ready'] as bool? ?? false,
      isHost: isHost,
    );
  }

  PresenceMember copyWith({
    bool? ready,
    bool? isHost,
    String? name,
    String? tokenColor,
  }) {
    return PresenceMember(
      playerId: playerId,
      name: name ?? this.name,
      tokenColor: tokenColor ?? this.tokenColor,
      chrome: chrome,
      joinedAtMs: joinedAtMs,
      presenceKey: presenceKey,
      ready: ready ?? this.ready,
      isHost: isHost ?? this.isHost,
    );
  }
}
