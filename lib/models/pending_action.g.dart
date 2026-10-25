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
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$PendingRentNoticeImplToJson(
  _$PendingRentNoticeImpl instance,
) => <String, dynamic>{
  'payerName': instance.payerName,
  'ownerName': instance.ownerName,
  'propertyName': instance.propertyName,
  'amount': instance.amount,
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
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PendingWinnerImplToJson(_$PendingWinnerImpl instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'runtimeType': instance.$type,
    };
