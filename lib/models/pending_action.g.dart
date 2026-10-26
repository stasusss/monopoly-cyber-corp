// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PendingNoneImpl _$$PendingNoneImplFromJson(Map<String, dynamic> json) =>
    _$PendingNoneImpl($type: json['runtimeType'] as String?);

Map<String, dynamic> _$$PendingNoneImplToJson(_$PendingNoneImpl instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

_$PendingBuyOfferImpl _$$PendingBuyOfferImplFromJson(
  Map<String, dynamic> json,
) => _$PendingBuyOfferImpl(
  cellIndex: (json['cellIndex'] as num).toInt(),
  propertyName: json['propertyName'] as String,
  price: (json['price'] as num).toInt(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$PendingBuyOfferImplToJson(
  _$PendingBuyOfferImpl instance,
) => <String, dynamic>{
  'cellIndex': instance.cellIndex,
  'propertyName': instance.propertyName,
  'price': instance.price,
  'runtimeType': instance.$type,
};

_$PendingRentNoticeImpl _$$PendingRentNoticeImplFromJson(
  Map<String, dynamic> json,
) => _$PendingRentNoticeImpl(
  payerName: json['payerName'] as String,
  ownerName: json['ownerName'] as String,
  propertyName: json['propertyName'] as String,
  amount: (json['amount'] as num).toInt(),
  canDodge: json['canDodge'] as bool? ?? false,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$PendingRentNoticeImplToJson(
  _$PendingRentNoticeImpl instance,
) => <String, dynamic>{
  'payerName': instance.payerName,
  'ownerName': instance.ownerName,
  'propertyName': instance.propertyName,
  'amount': instance.amount,
  'canDodge': instance.canDodge,
  'runtimeType': instance.$type,
};

_$PendingTaxNoticeImpl _$$PendingTaxNoticeImplFromJson(
  Map<String, dynamic> json,
) => _$PendingTaxNoticeImpl(
  playerName: json['playerName'] as String,
  taxName: json['taxName'] as String,
  amount: (json['amount'] as num).toInt(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$PendingTaxNoticeImplToJson(
  _$PendingTaxNoticeImpl instance,
) => <String, dynamic>{
  'playerName': instance.playerName,
  'taxName': instance.taxName,
  'amount': instance.amount,
  'runtimeType': instance.$type,
};

_$PendingCardNoticeImpl _$$PendingCardNoticeImplFromJson(
  Map<String, dynamic> json,
) => _$PendingCardNoticeImpl(
  title: json['title'] as String,
  description: json['description'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$PendingCardNoticeImplToJson(
  _$PendingCardNoticeImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'runtimeType': instance.$type,
};

_$PendingAuctionImpl _$$PendingAuctionImplFromJson(Map<String, dynamic> json) =>
    _$PendingAuctionImpl(
      cellIndex: (json['cellIndex'] as num).toInt(),
      propertyName: json['propertyName'] as String,
      highestBid: (json['highestBid'] as num).toInt(),
      highestBidderId: json['highestBidderId'] as String?,
      currentBidderId: json['currentBidderId'] as String,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      passedIds: (json['passedIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PendingAuctionImplToJson(
  _$PendingAuctionImpl instance,
) => <String, dynamic>{
  'cellIndex': instance.cellIndex,
  'propertyName': instance.propertyName,
  'highestBid': instance.highestBid,
  'highestBidderId': instance.highestBidderId,
  'currentBidderId': instance.currentBidderId,
  'participantIds': instance.participantIds,
  'passedIds': instance.passedIds,
  'runtimeType': instance.$type,
};

_$PendingTradeOfferImpl _$$PendingTradeOfferImplFromJson(
  Map<String, dynamic> json,
) => _$PendingTradeOfferImpl(
  fromPlayerId: json['fromPlayerId'] as String,
  toPlayerId: json['toPlayerId'] as String,
  offerCash: (json['offerCash'] as num).toInt(),
  requestCash: (json['requestCash'] as num).toInt(),
  offerProperties: (json['offerProperties'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  requestProperties: (json['requestProperties'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$PendingTradeOfferImplToJson(
  _$PendingTradeOfferImpl instance,
) => <String, dynamic>{
  'fromPlayerId': instance.fromPlayerId,
  'toPlayerId': instance.toPlayerId,
  'offerCash': instance.offerCash,
  'requestCash': instance.requestCash,
  'offerProperties': instance.offerProperties,
  'requestProperties': instance.requestProperties,
  'runtimeType': instance.$type,
};

_$PendingWinnerImpl _$$PendingWinnerImplFromJson(Map<String, dynamic> json) =>
    _$PendingWinnerImpl(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      netWorth: (json['netWorth'] as num?)?.toInt() ?? 0,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PendingWinnerImplToJson(_$PendingWinnerImpl instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'netWorth': instance.netWorth,
      'runtimeType': instance.$type,
    };

_$PendingClaimOfferImpl _$$PendingClaimOfferImplFromJson(
  Map<String, dynamic> json,
) => _$PendingClaimOfferImpl(
  cellIndexes: (json['cellIndexes'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  consumesBuyout: json['consumesBuyout'] as bool,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$PendingClaimOfferImplToJson(
  _$PendingClaimOfferImpl instance,
) => <String, dynamic>{
  'cellIndexes': instance.cellIndexes,
  'consumesBuyout': instance.consumesBuyout,
  'runtimeType': instance.$type,
};

_$PendingShortfallImpl _$$PendingShortfallImplFromJson(
  Map<String, dynamic> json,
) => _$PendingShortfallImpl(
  amount: (json['amount'] as num).toInt(),
  kind: json['kind'] as String,
  creditorId: json['creditorId'] as String?,
  cellIndex: (json['cellIndex'] as num?)?.toInt(),
  label: json['label'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$PendingShortfallImplToJson(
  _$PendingShortfallImpl instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'kind': instance.kind,
  'creditorId': instance.creditorId,
  'cellIndex': instance.cellIndex,
  'label': instance.label,
  'runtimeType': instance.$type,
};

_$PendingCityVoteImpl _$$PendingCityVoteImplFromJson(
  Map<String, dynamic> json,
) => _$PendingCityVoteImpl(
  round: (json['round'] as num).toInt(),
  leaderId: json['leaderId'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$PendingCityVoteImplToJson(
  _$PendingCityVoteImpl instance,
) => <String, dynamic>{
  'round': instance.round,
  'leaderId': instance.leaderId,
  'runtimeType': instance.$type,
};

_$PendingHeatCheckImpl _$$PendingHeatCheckImplFromJson(
  Map<String, dynamic> json,
) => _$PendingHeatCheckImpl(
  fine: (json['fine'] as num).toInt(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$PendingHeatCheckImplToJson(
  _$PendingHeatCheckImpl instance,
) => <String, dynamic>{'fine': instance.fine, 'runtimeType': instance.$type};
