// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PendingAction _$PendingActionFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'none':
      return PendingNone.fromJson(json);
    case 'buyOffer':
      return PendingBuyOffer.fromJson(json);
    case 'rentNotice':
      return PendingRentNotice.fromJson(json);
    case 'taxNotice':
      return PendingTaxNotice.fromJson(json);
    case 'cardNotice':
      return PendingCardNotice.fromJson(json);
    case 'auction':
      return PendingAuction.fromJson(json);
    case 'tradeOffer':
      return PendingTradeOffer.fromJson(json);
    case 'winner':
      return PendingWinner.fromJson(json);
    case 'claimOffer':
      return PendingClaimOffer.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'PendingAction',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$PendingAction {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int cellIndex, String propertyName, int price)
    buyOffer,
    required TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )
    rentNotice,
    required TResult Function(String playerName, String taxName, int amount)
    taxNotice,
    required TResult Function(String title, String description) cardNotice,
    required TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )
    auction,
    required TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )
    tradeOffer,
    required TResult Function(String playerId, String playerName, int netWorth)
    winner,
    required TResult Function(List<int> cellIndexes, bool consumesBuyout)
    claimOffer,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult? Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult? Function(String playerName, String taxName, int amount)? taxNotice,
    TResult? Function(String title, String description)? cardNotice,
    TResult? Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult? Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult? Function(String playerId, String playerName, int netWorth)? winner,
    TResult? Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult Function(String playerName, String taxName, int amount)? taxNotice,
    TResult Function(String title, String description)? cardNotice,
    TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult Function(String playerId, String playerName, int netWorth)? winner,
    TResult Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PendingNone value) none,
    required TResult Function(PendingBuyOffer value) buyOffer,
    required TResult Function(PendingRentNotice value) rentNotice,
    required TResult Function(PendingTaxNotice value) taxNotice,
    required TResult Function(PendingCardNotice value) cardNotice,
    required TResult Function(PendingAuction value) auction,
    required TResult Function(PendingTradeOffer value) tradeOffer,
    required TResult Function(PendingWinner value) winner,
    required TResult Function(PendingClaimOffer value) claimOffer,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PendingNone value)? none,
    TResult? Function(PendingBuyOffer value)? buyOffer,
    TResult? Function(PendingRentNotice value)? rentNotice,
    TResult? Function(PendingTaxNotice value)? taxNotice,
    TResult? Function(PendingCardNotice value)? cardNotice,
    TResult? Function(PendingAuction value)? auction,
    TResult? Function(PendingTradeOffer value)? tradeOffer,
    TResult? Function(PendingWinner value)? winner,
    TResult? Function(PendingClaimOffer value)? claimOffer,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PendingNone value)? none,
    TResult Function(PendingBuyOffer value)? buyOffer,
    TResult Function(PendingRentNotice value)? rentNotice,
    TResult Function(PendingTaxNotice value)? taxNotice,
    TResult Function(PendingCardNotice value)? cardNotice,
    TResult Function(PendingAuction value)? auction,
    TResult Function(PendingTradeOffer value)? tradeOffer,
    TResult Function(PendingWinner value)? winner,
    TResult Function(PendingClaimOffer value)? claimOffer,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this PendingAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PendingActionCopyWith<$Res> {
  factory $PendingActionCopyWith(
    PendingAction value,
    $Res Function(PendingAction) then,
  ) = _$PendingActionCopyWithImpl<$Res, PendingAction>;
}

/// @nodoc
class _$PendingActionCopyWithImpl<$Res, $Val extends PendingAction>
    implements $PendingActionCopyWith<$Res> {
  _$PendingActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PendingNoneImplCopyWith<$Res> {
  factory _$$PendingNoneImplCopyWith(
    _$PendingNoneImpl value,
    $Res Function(_$PendingNoneImpl) then,
  ) = __$$PendingNoneImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PendingNoneImplCopyWithImpl<$Res>
    extends _$PendingActionCopyWithImpl<$Res, _$PendingNoneImpl>
    implements _$$PendingNoneImplCopyWith<$Res> {
  __$$PendingNoneImplCopyWithImpl(
    _$PendingNoneImpl _value,
    $Res Function(_$PendingNoneImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$PendingNoneImpl implements PendingNone {
  const _$PendingNoneImpl({final String? $type}) : $type = $type ?? 'none';

  factory _$PendingNoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingNoneImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PendingAction.none()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PendingNoneImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int cellIndex, String propertyName, int price)
    buyOffer,
    required TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )
    rentNotice,
    required TResult Function(String playerName, String taxName, int amount)
    taxNotice,
    required TResult Function(String title, String description) cardNotice,
    required TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )
    auction,
    required TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )
    tradeOffer,
    required TResult Function(String playerId, String playerName, int netWorth)
    winner,
    required TResult Function(List<int> cellIndexes, bool consumesBuyout)
    claimOffer,
  }) {
    return none();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult? Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult? Function(String playerName, String taxName, int amount)? taxNotice,
    TResult? Function(String title, String description)? cardNotice,
    TResult? Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult? Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult? Function(String playerId, String playerName, int netWorth)? winner,
    TResult? Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
  }) {
    return none?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult Function(String playerName, String taxName, int amount)? taxNotice,
    TResult Function(String title, String description)? cardNotice,
    TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult Function(String playerId, String playerName, int netWorth)? winner,
    TResult Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PendingNone value) none,
    required TResult Function(PendingBuyOffer value) buyOffer,
    required TResult Function(PendingRentNotice value) rentNotice,
    required TResult Function(PendingTaxNotice value) taxNotice,
    required TResult Function(PendingCardNotice value) cardNotice,
    required TResult Function(PendingAuction value) auction,
    required TResult Function(PendingTradeOffer value) tradeOffer,
    required TResult Function(PendingWinner value) winner,
    required TResult Function(PendingClaimOffer value) claimOffer,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PendingNone value)? none,
    TResult? Function(PendingBuyOffer value)? buyOffer,
    TResult? Function(PendingRentNotice value)? rentNotice,
    TResult? Function(PendingTaxNotice value)? taxNotice,
    TResult? Function(PendingCardNotice value)? cardNotice,
    TResult? Function(PendingAuction value)? auction,
    TResult? Function(PendingTradeOffer value)? tradeOffer,
    TResult? Function(PendingWinner value)? winner,
    TResult? Function(PendingClaimOffer value)? claimOffer,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PendingNone value)? none,
    TResult Function(PendingBuyOffer value)? buyOffer,
    TResult Function(PendingRentNotice value)? rentNotice,
    TResult Function(PendingTaxNotice value)? taxNotice,
    TResult Function(PendingCardNotice value)? cardNotice,
    TResult Function(PendingAuction value)? auction,
    TResult Function(PendingTradeOffer value)? tradeOffer,
    TResult Function(PendingWinner value)? winner,
    TResult Function(PendingClaimOffer value)? claimOffer,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingNoneImplToJson(this);
  }
}

abstract class PendingNone implements PendingAction {
  const factory PendingNone() = _$PendingNoneImpl;

  factory PendingNone.fromJson(Map<String, dynamic> json) =
      _$PendingNoneImpl.fromJson;
}

/// @nodoc
abstract class _$$PendingBuyOfferImplCopyWith<$Res> {
  factory _$$PendingBuyOfferImplCopyWith(
    _$PendingBuyOfferImpl value,
    $Res Function(_$PendingBuyOfferImpl) then,
  ) = __$$PendingBuyOfferImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int cellIndex, String propertyName, int price});
}

/// @nodoc
class __$$PendingBuyOfferImplCopyWithImpl<$Res>
    extends _$PendingActionCopyWithImpl<$Res, _$PendingBuyOfferImpl>
    implements _$$PendingBuyOfferImplCopyWith<$Res> {
  __$$PendingBuyOfferImplCopyWithImpl(
    _$PendingBuyOfferImpl _value,
    $Res Function(_$PendingBuyOfferImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cellIndex = null,
    Object? propertyName = null,
    Object? price = null,
  }) {
    return _then(
      _$PendingBuyOfferImpl(
        cellIndex: null == cellIndex
            ? _value.cellIndex
            : cellIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        propertyName: null == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingBuyOfferImpl implements PendingBuyOffer {
  const _$PendingBuyOfferImpl({
    required this.cellIndex,
    required this.propertyName,
    required this.price,
    final String? $type,
  }) : $type = $type ?? 'buyOffer';

  factory _$PendingBuyOfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingBuyOfferImplFromJson(json);

  @override
  final int cellIndex;
  @override
  final String propertyName;
  @override
  final int price;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PendingAction.buyOffer(cellIndex: $cellIndex, propertyName: $propertyName, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingBuyOfferImpl &&
            (identical(other.cellIndex, cellIndex) ||
                other.cellIndex == cellIndex) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cellIndex, propertyName, price);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingBuyOfferImplCopyWith<_$PendingBuyOfferImpl> get copyWith =>
      __$$PendingBuyOfferImplCopyWithImpl<_$PendingBuyOfferImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int cellIndex, String propertyName, int price)
    buyOffer,
    required TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )
    rentNotice,
    required TResult Function(String playerName, String taxName, int amount)
    taxNotice,
    required TResult Function(String title, String description) cardNotice,
    required TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )
    auction,
    required TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )
    tradeOffer,
    required TResult Function(String playerId, String playerName, int netWorth)
    winner,
    required TResult Function(List<int> cellIndexes, bool consumesBuyout)
    claimOffer,
  }) {
    return buyOffer(cellIndex, propertyName, price);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult? Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult? Function(String playerName, String taxName, int amount)? taxNotice,
    TResult? Function(String title, String description)? cardNotice,
    TResult? Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult? Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult? Function(String playerId, String playerName, int netWorth)? winner,
    TResult? Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
  }) {
    return buyOffer?.call(cellIndex, propertyName, price);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult Function(String playerName, String taxName, int amount)? taxNotice,
    TResult Function(String title, String description)? cardNotice,
    TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult Function(String playerId, String playerName, int netWorth)? winner,
    TResult Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
    required TResult orElse(),
  }) {
    if (buyOffer != null) {
      return buyOffer(cellIndex, propertyName, price);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PendingNone value) none,
    required TResult Function(PendingBuyOffer value) buyOffer,
    required TResult Function(PendingRentNotice value) rentNotice,
    required TResult Function(PendingTaxNotice value) taxNotice,
    required TResult Function(PendingCardNotice value) cardNotice,
    required TResult Function(PendingAuction value) auction,
    required TResult Function(PendingTradeOffer value) tradeOffer,
    required TResult Function(PendingWinner value) winner,
    required TResult Function(PendingClaimOffer value) claimOffer,
  }) {
    return buyOffer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PendingNone value)? none,
    TResult? Function(PendingBuyOffer value)? buyOffer,
    TResult? Function(PendingRentNotice value)? rentNotice,
    TResult? Function(PendingTaxNotice value)? taxNotice,
    TResult? Function(PendingCardNotice value)? cardNotice,
    TResult? Function(PendingAuction value)? auction,
    TResult? Function(PendingTradeOffer value)? tradeOffer,
    TResult? Function(PendingWinner value)? winner,
    TResult? Function(PendingClaimOffer value)? claimOffer,
  }) {
    return buyOffer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PendingNone value)? none,
    TResult Function(PendingBuyOffer value)? buyOffer,
    TResult Function(PendingRentNotice value)? rentNotice,
    TResult Function(PendingTaxNotice value)? taxNotice,
    TResult Function(PendingCardNotice value)? cardNotice,
    TResult Function(PendingAuction value)? auction,
    TResult Function(PendingTradeOffer value)? tradeOffer,
    TResult Function(PendingWinner value)? winner,
    TResult Function(PendingClaimOffer value)? claimOffer,
    required TResult orElse(),
  }) {
    if (buyOffer != null) {
      return buyOffer(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingBuyOfferImplToJson(this);
  }
}

abstract class PendingBuyOffer implements PendingAction {
  const factory PendingBuyOffer({
    required final int cellIndex,
    required final String propertyName,
    required final int price,
  }) = _$PendingBuyOfferImpl;

  factory PendingBuyOffer.fromJson(Map<String, dynamic> json) =
      _$PendingBuyOfferImpl.fromJson;

  int get cellIndex;
  String get propertyName;
  int get price;

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingBuyOfferImplCopyWith<_$PendingBuyOfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PendingRentNoticeImplCopyWith<$Res> {
  factory _$$PendingRentNoticeImplCopyWith(
    _$PendingRentNoticeImpl value,
    $Res Function(_$PendingRentNoticeImpl) then,
  ) = __$$PendingRentNoticeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String payerName,
    String ownerName,
    String propertyName,
    int amount,
  });
}

/// @nodoc
class __$$PendingRentNoticeImplCopyWithImpl<$Res>
    extends _$PendingActionCopyWithImpl<$Res, _$PendingRentNoticeImpl>
    implements _$$PendingRentNoticeImplCopyWith<$Res> {
  __$$PendingRentNoticeImplCopyWithImpl(
    _$PendingRentNoticeImpl _value,
    $Res Function(_$PendingRentNoticeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? payerName = null,
    Object? ownerName = null,
    Object? propertyName = null,
    Object? amount = null,
  }) {
    return _then(
      _$PendingRentNoticeImpl(
        payerName: null == payerName
            ? _value.payerName
            : payerName // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerName: null == ownerName
            ? _value.ownerName
            : ownerName // ignore: cast_nullable_to_non_nullable
                  as String,
        propertyName: null == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingRentNoticeImpl implements PendingRentNotice {
  const _$PendingRentNoticeImpl({
    required this.payerName,
    required this.ownerName,
    required this.propertyName,
    required this.amount,
    final String? $type,
  }) : $type = $type ?? 'rentNotice';

  factory _$PendingRentNoticeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingRentNoticeImplFromJson(json);

  @override
  final String payerName;
  @override
  final String ownerName;
  @override
  final String propertyName;
  @override
  final int amount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PendingAction.rentNotice(payerName: $payerName, ownerName: $ownerName, propertyName: $propertyName, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingRentNoticeImpl &&
            (identical(other.payerName, payerName) ||
                other.payerName == payerName) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, payerName, ownerName, propertyName, amount);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingRentNoticeImplCopyWith<_$PendingRentNoticeImpl> get copyWith =>
      __$$PendingRentNoticeImplCopyWithImpl<_$PendingRentNoticeImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int cellIndex, String propertyName, int price)
    buyOffer,
    required TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )
    rentNotice,
    required TResult Function(String playerName, String taxName, int amount)
    taxNotice,
    required TResult Function(String title, String description) cardNotice,
    required TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )
    auction,
    required TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )
    tradeOffer,
    required TResult Function(String playerId, String playerName, int netWorth)
    winner,
    required TResult Function(List<int> cellIndexes, bool consumesBuyout)
    claimOffer,
  }) {
    return rentNotice(payerName, ownerName, propertyName, amount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult? Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult? Function(String playerName, String taxName, int amount)? taxNotice,
    TResult? Function(String title, String description)? cardNotice,
    TResult? Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult? Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult? Function(String playerId, String playerName, int netWorth)? winner,
    TResult? Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
  }) {
    return rentNotice?.call(payerName, ownerName, propertyName, amount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult Function(String playerName, String taxName, int amount)? taxNotice,
    TResult Function(String title, String description)? cardNotice,
    TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult Function(String playerId, String playerName, int netWorth)? winner,
    TResult Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
    required TResult orElse(),
  }) {
    if (rentNotice != null) {
      return rentNotice(payerName, ownerName, propertyName, amount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PendingNone value) none,
    required TResult Function(PendingBuyOffer value) buyOffer,
    required TResult Function(PendingRentNotice value) rentNotice,
    required TResult Function(PendingTaxNotice value) taxNotice,
    required TResult Function(PendingCardNotice value) cardNotice,
    required TResult Function(PendingAuction value) auction,
    required TResult Function(PendingTradeOffer value) tradeOffer,
    required TResult Function(PendingWinner value) winner,
    required TResult Function(PendingClaimOffer value) claimOffer,
  }) {
    return rentNotice(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PendingNone value)? none,
    TResult? Function(PendingBuyOffer value)? buyOffer,
    TResult? Function(PendingRentNotice value)? rentNotice,
    TResult? Function(PendingTaxNotice value)? taxNotice,
    TResult? Function(PendingCardNotice value)? cardNotice,
    TResult? Function(PendingAuction value)? auction,
    TResult? Function(PendingTradeOffer value)? tradeOffer,
    TResult? Function(PendingWinner value)? winner,
    TResult? Function(PendingClaimOffer value)? claimOffer,
  }) {
    return rentNotice?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PendingNone value)? none,
    TResult Function(PendingBuyOffer value)? buyOffer,
    TResult Function(PendingRentNotice value)? rentNotice,
    TResult Function(PendingTaxNotice value)? taxNotice,
    TResult Function(PendingCardNotice value)? cardNotice,
    TResult Function(PendingAuction value)? auction,
    TResult Function(PendingTradeOffer value)? tradeOffer,
    TResult Function(PendingWinner value)? winner,
    TResult Function(PendingClaimOffer value)? claimOffer,
    required TResult orElse(),
  }) {
    if (rentNotice != null) {
      return rentNotice(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingRentNoticeImplToJson(this);
  }
}

abstract class PendingRentNotice implements PendingAction {
  const factory PendingRentNotice({
    required final String payerName,
    required final String ownerName,
    required final String propertyName,
    required final int amount,
  }) = _$PendingRentNoticeImpl;

  factory PendingRentNotice.fromJson(Map<String, dynamic> json) =
      _$PendingRentNoticeImpl.fromJson;

  String get payerName;
  String get ownerName;
  String get propertyName;
  int get amount;

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingRentNoticeImplCopyWith<_$PendingRentNoticeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PendingTaxNoticeImplCopyWith<$Res> {
  factory _$$PendingTaxNoticeImplCopyWith(
    _$PendingTaxNoticeImpl value,
    $Res Function(_$PendingTaxNoticeImpl) then,
  ) = __$$PendingTaxNoticeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String playerName, String taxName, int amount});
}

/// @nodoc
class __$$PendingTaxNoticeImplCopyWithImpl<$Res>
    extends _$PendingActionCopyWithImpl<$Res, _$PendingTaxNoticeImpl>
    implements _$$PendingTaxNoticeImplCopyWith<$Res> {
  __$$PendingTaxNoticeImplCopyWithImpl(
    _$PendingTaxNoticeImpl _value,
    $Res Function(_$PendingTaxNoticeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerName = null,
    Object? taxName = null,
    Object? amount = null,
  }) {
    return _then(
      _$PendingTaxNoticeImpl(
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        taxName: null == taxName
            ? _value.taxName
            : taxName // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingTaxNoticeImpl implements PendingTaxNotice {
  const _$PendingTaxNoticeImpl({
    required this.playerName,
    required this.taxName,
    required this.amount,
    final String? $type,
  }) : $type = $type ?? 'taxNotice';

  factory _$PendingTaxNoticeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingTaxNoticeImplFromJson(json);

  @override
  final String playerName;
  @override
  final String taxName;
  @override
  final int amount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PendingAction.taxNotice(playerName: $playerName, taxName: $taxName, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingTaxNoticeImpl &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.taxName, taxName) || other.taxName == taxName) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, playerName, taxName, amount);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingTaxNoticeImplCopyWith<_$PendingTaxNoticeImpl> get copyWith =>
      __$$PendingTaxNoticeImplCopyWithImpl<_$PendingTaxNoticeImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int cellIndex, String propertyName, int price)
    buyOffer,
    required TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )
    rentNotice,
    required TResult Function(String playerName, String taxName, int amount)
    taxNotice,
    required TResult Function(String title, String description) cardNotice,
    required TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )
    auction,
    required TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )
    tradeOffer,
    required TResult Function(String playerId, String playerName, int netWorth)
    winner,
    required TResult Function(List<int> cellIndexes, bool consumesBuyout)
    claimOffer,
  }) {
    return taxNotice(playerName, taxName, amount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult? Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult? Function(String playerName, String taxName, int amount)? taxNotice,
    TResult? Function(String title, String description)? cardNotice,
    TResult? Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult? Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult? Function(String playerId, String playerName, int netWorth)? winner,
    TResult? Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
  }) {
    return taxNotice?.call(playerName, taxName, amount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult Function(String playerName, String taxName, int amount)? taxNotice,
    TResult Function(String title, String description)? cardNotice,
    TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult Function(String playerId, String playerName, int netWorth)? winner,
    TResult Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
    required TResult orElse(),
  }) {
    if (taxNotice != null) {
      return taxNotice(playerName, taxName, amount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PendingNone value) none,
    required TResult Function(PendingBuyOffer value) buyOffer,
    required TResult Function(PendingRentNotice value) rentNotice,
    required TResult Function(PendingTaxNotice value) taxNotice,
    required TResult Function(PendingCardNotice value) cardNotice,
    required TResult Function(PendingAuction value) auction,
    required TResult Function(PendingTradeOffer value) tradeOffer,
    required TResult Function(PendingWinner value) winner,
    required TResult Function(PendingClaimOffer value) claimOffer,
  }) {
    return taxNotice(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PendingNone value)? none,
    TResult? Function(PendingBuyOffer value)? buyOffer,
    TResult? Function(PendingRentNotice value)? rentNotice,
    TResult? Function(PendingTaxNotice value)? taxNotice,
    TResult? Function(PendingCardNotice value)? cardNotice,
    TResult? Function(PendingAuction value)? auction,
    TResult? Function(PendingTradeOffer value)? tradeOffer,
    TResult? Function(PendingWinner value)? winner,
    TResult? Function(PendingClaimOffer value)? claimOffer,
  }) {
    return taxNotice?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PendingNone value)? none,
    TResult Function(PendingBuyOffer value)? buyOffer,
    TResult Function(PendingRentNotice value)? rentNotice,
    TResult Function(PendingTaxNotice value)? taxNotice,
    TResult Function(PendingCardNotice value)? cardNotice,
    TResult Function(PendingAuction value)? auction,
    TResult Function(PendingTradeOffer value)? tradeOffer,
    TResult Function(PendingWinner value)? winner,
    TResult Function(PendingClaimOffer value)? claimOffer,
    required TResult orElse(),
  }) {
    if (taxNotice != null) {
      return taxNotice(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingTaxNoticeImplToJson(this);
  }
}

abstract class PendingTaxNotice implements PendingAction {
  const factory PendingTaxNotice({
    required final String playerName,
    required final String taxName,
    required final int amount,
  }) = _$PendingTaxNoticeImpl;

  factory PendingTaxNotice.fromJson(Map<String, dynamic> json) =
      _$PendingTaxNoticeImpl.fromJson;

  String get playerName;
  String get taxName;
  int get amount;

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingTaxNoticeImplCopyWith<_$PendingTaxNoticeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PendingCardNoticeImplCopyWith<$Res> {
  factory _$$PendingCardNoticeImplCopyWith(
    _$PendingCardNoticeImpl value,
    $Res Function(_$PendingCardNoticeImpl) then,
  ) = __$$PendingCardNoticeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String title, String description});
}

/// @nodoc
class __$$PendingCardNoticeImplCopyWithImpl<$Res>
    extends _$PendingActionCopyWithImpl<$Res, _$PendingCardNoticeImpl>
    implements _$$PendingCardNoticeImplCopyWith<$Res> {
  __$$PendingCardNoticeImplCopyWithImpl(
    _$PendingCardNoticeImpl _value,
    $Res Function(_$PendingCardNoticeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = null, Object? description = null}) {
    return _then(
      _$PendingCardNoticeImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingCardNoticeImpl implements PendingCardNotice {
  const _$PendingCardNoticeImpl({
    required this.title,
    required this.description,
    final String? $type,
  }) : $type = $type ?? 'cardNotice';

  factory _$PendingCardNoticeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingCardNoticeImplFromJson(json);

  @override
  final String title;
  @override
  final String description;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PendingAction.cardNotice(title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingCardNoticeImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingCardNoticeImplCopyWith<_$PendingCardNoticeImpl> get copyWith =>
      __$$PendingCardNoticeImplCopyWithImpl<_$PendingCardNoticeImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int cellIndex, String propertyName, int price)
    buyOffer,
    required TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )
    rentNotice,
    required TResult Function(String playerName, String taxName, int amount)
    taxNotice,
    required TResult Function(String title, String description) cardNotice,
    required TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )
    auction,
    required TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )
    tradeOffer,
    required TResult Function(String playerId, String playerName, int netWorth)
    winner,
    required TResult Function(List<int> cellIndexes, bool consumesBuyout)
    claimOffer,
  }) {
    return cardNotice(title, description);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult? Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult? Function(String playerName, String taxName, int amount)? taxNotice,
    TResult? Function(String title, String description)? cardNotice,
    TResult? Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult? Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult? Function(String playerId, String playerName, int netWorth)? winner,
    TResult? Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
  }) {
    return cardNotice?.call(title, description);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult Function(String playerName, String taxName, int amount)? taxNotice,
    TResult Function(String title, String description)? cardNotice,
    TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult Function(String playerId, String playerName, int netWorth)? winner,
    TResult Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
    required TResult orElse(),
  }) {
    if (cardNotice != null) {
      return cardNotice(title, description);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PendingNone value) none,
    required TResult Function(PendingBuyOffer value) buyOffer,
    required TResult Function(PendingRentNotice value) rentNotice,
    required TResult Function(PendingTaxNotice value) taxNotice,
    required TResult Function(PendingCardNotice value) cardNotice,
    required TResult Function(PendingAuction value) auction,
    required TResult Function(PendingTradeOffer value) tradeOffer,
    required TResult Function(PendingWinner value) winner,
    required TResult Function(PendingClaimOffer value) claimOffer,
  }) {
    return cardNotice(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PendingNone value)? none,
    TResult? Function(PendingBuyOffer value)? buyOffer,
    TResult? Function(PendingRentNotice value)? rentNotice,
    TResult? Function(PendingTaxNotice value)? taxNotice,
    TResult? Function(PendingCardNotice value)? cardNotice,
    TResult? Function(PendingAuction value)? auction,
    TResult? Function(PendingTradeOffer value)? tradeOffer,
    TResult? Function(PendingWinner value)? winner,
    TResult? Function(PendingClaimOffer value)? claimOffer,
  }) {
    return cardNotice?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PendingNone value)? none,
    TResult Function(PendingBuyOffer value)? buyOffer,
    TResult Function(PendingRentNotice value)? rentNotice,
    TResult Function(PendingTaxNotice value)? taxNotice,
    TResult Function(PendingCardNotice value)? cardNotice,
    TResult Function(PendingAuction value)? auction,
    TResult Function(PendingTradeOffer value)? tradeOffer,
    TResult Function(PendingWinner value)? winner,
    TResult Function(PendingClaimOffer value)? claimOffer,
    required TResult orElse(),
  }) {
    if (cardNotice != null) {
      return cardNotice(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingCardNoticeImplToJson(this);
  }
}

abstract class PendingCardNotice implements PendingAction {
  const factory PendingCardNotice({
    required final String title,
    required final String description,
  }) = _$PendingCardNoticeImpl;

  factory PendingCardNotice.fromJson(Map<String, dynamic> json) =
      _$PendingCardNoticeImpl.fromJson;

  String get title;
  String get description;

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingCardNoticeImplCopyWith<_$PendingCardNoticeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PendingAuctionImplCopyWith<$Res> {
  factory _$$PendingAuctionImplCopyWith(
    _$PendingAuctionImpl value,
    $Res Function(_$PendingAuctionImpl) then,
  ) = __$$PendingAuctionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    int cellIndex,
    String propertyName,
    int highestBid,
    String? highestBidderId,
    String currentBidderId,
    List<String> participantIds,
    List<String> passedIds,
  });
}

/// @nodoc
class __$$PendingAuctionImplCopyWithImpl<$Res>
    extends _$PendingActionCopyWithImpl<$Res, _$PendingAuctionImpl>
    implements _$$PendingAuctionImplCopyWith<$Res> {
  __$$PendingAuctionImplCopyWithImpl(
    _$PendingAuctionImpl _value,
    $Res Function(_$PendingAuctionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cellIndex = null,
    Object? propertyName = null,
    Object? highestBid = null,
    Object? highestBidderId = freezed,
    Object? currentBidderId = null,
    Object? participantIds = null,
    Object? passedIds = null,
  }) {
    return _then(
      _$PendingAuctionImpl(
        cellIndex: null == cellIndex
            ? _value.cellIndex
            : cellIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        propertyName: null == propertyName
            ? _value.propertyName
            : propertyName // ignore: cast_nullable_to_non_nullable
                  as String,
        highestBid: null == highestBid
            ? _value.highestBid
            : highestBid // ignore: cast_nullable_to_non_nullable
                  as int,
        highestBidderId: freezed == highestBidderId
            ? _value.highestBidderId
            : highestBidderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentBidderId: null == currentBidderId
            ? _value.currentBidderId
            : currentBidderId // ignore: cast_nullable_to_non_nullable
                  as String,
        participantIds: null == participantIds
            ? _value._participantIds
            : participantIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        passedIds: null == passedIds
            ? _value._passedIds
            : passedIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingAuctionImpl implements PendingAuction {
  const _$PendingAuctionImpl({
    required this.cellIndex,
    required this.propertyName,
    required this.highestBid,
    this.highestBidderId,
    required this.currentBidderId,
    required final List<String> participantIds,
    required final List<String> passedIds,
    final String? $type,
  }) : _participantIds = participantIds,
       _passedIds = passedIds,
       $type = $type ?? 'auction';

  factory _$PendingAuctionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingAuctionImplFromJson(json);

  @override
  final int cellIndex;
  @override
  final String propertyName;
  @override
  final int highestBid;
  @override
  final String? highestBidderId;
  @override
  final String currentBidderId;
  final List<String> _participantIds;
  @override
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  final List<String> _passedIds;
  @override
  List<String> get passedIds {
    if (_passedIds is EqualUnmodifiableListView) return _passedIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_passedIds);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PendingAction.auction(cellIndex: $cellIndex, propertyName: $propertyName, highestBid: $highestBid, highestBidderId: $highestBidderId, currentBidderId: $currentBidderId, participantIds: $participantIds, passedIds: $passedIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingAuctionImpl &&
            (identical(other.cellIndex, cellIndex) ||
                other.cellIndex == cellIndex) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.highestBid, highestBid) ||
                other.highestBid == highestBid) &&
            (identical(other.highestBidderId, highestBidderId) ||
                other.highestBidderId == highestBidderId) &&
            (identical(other.currentBidderId, currentBidderId) ||
                other.currentBidderId == currentBidderId) &&
            const DeepCollectionEquality().equals(
              other._participantIds,
              _participantIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._passedIds,
              _passedIds,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cellIndex,
    propertyName,
    highestBid,
    highestBidderId,
    currentBidderId,
    const DeepCollectionEquality().hash(_participantIds),
    const DeepCollectionEquality().hash(_passedIds),
  );

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingAuctionImplCopyWith<_$PendingAuctionImpl> get copyWith =>
      __$$PendingAuctionImplCopyWithImpl<_$PendingAuctionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int cellIndex, String propertyName, int price)
    buyOffer,
    required TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )
    rentNotice,
    required TResult Function(String playerName, String taxName, int amount)
    taxNotice,
    required TResult Function(String title, String description) cardNotice,
    required TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )
    auction,
    required TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )
    tradeOffer,
    required TResult Function(String playerId, String playerName, int netWorth)
    winner,
    required TResult Function(List<int> cellIndexes, bool consumesBuyout)
    claimOffer,
  }) {
    return auction(
      cellIndex,
      propertyName,
      highestBid,
      highestBidderId,
      currentBidderId,
      participantIds,
      passedIds,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult? Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult? Function(String playerName, String taxName, int amount)? taxNotice,
    TResult? Function(String title, String description)? cardNotice,
    TResult? Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult? Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult? Function(String playerId, String playerName, int netWorth)? winner,
    TResult? Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
  }) {
    return auction?.call(
      cellIndex,
      propertyName,
      highestBid,
      highestBidderId,
      currentBidderId,
      participantIds,
      passedIds,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult Function(String playerName, String taxName, int amount)? taxNotice,
    TResult Function(String title, String description)? cardNotice,
    TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult Function(String playerId, String playerName, int netWorth)? winner,
    TResult Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
    required TResult orElse(),
  }) {
    if (auction != null) {
      return auction(
        cellIndex,
        propertyName,
        highestBid,
        highestBidderId,
        currentBidderId,
        participantIds,
        passedIds,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PendingNone value) none,
    required TResult Function(PendingBuyOffer value) buyOffer,
    required TResult Function(PendingRentNotice value) rentNotice,
    required TResult Function(PendingTaxNotice value) taxNotice,
    required TResult Function(PendingCardNotice value) cardNotice,
    required TResult Function(PendingAuction value) auction,
    required TResult Function(PendingTradeOffer value) tradeOffer,
    required TResult Function(PendingWinner value) winner,
    required TResult Function(PendingClaimOffer value) claimOffer,
  }) {
    return auction(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PendingNone value)? none,
    TResult? Function(PendingBuyOffer value)? buyOffer,
    TResult? Function(PendingRentNotice value)? rentNotice,
    TResult? Function(PendingTaxNotice value)? taxNotice,
    TResult? Function(PendingCardNotice value)? cardNotice,
    TResult? Function(PendingAuction value)? auction,
    TResult? Function(PendingTradeOffer value)? tradeOffer,
    TResult? Function(PendingWinner value)? winner,
    TResult? Function(PendingClaimOffer value)? claimOffer,
  }) {
    return auction?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PendingNone value)? none,
    TResult Function(PendingBuyOffer value)? buyOffer,
    TResult Function(PendingRentNotice value)? rentNotice,
    TResult Function(PendingTaxNotice value)? taxNotice,
    TResult Function(PendingCardNotice value)? cardNotice,
    TResult Function(PendingAuction value)? auction,
    TResult Function(PendingTradeOffer value)? tradeOffer,
    TResult Function(PendingWinner value)? winner,
    TResult Function(PendingClaimOffer value)? claimOffer,
    required TResult orElse(),
  }) {
    if (auction != null) {
      return auction(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingAuctionImplToJson(this);
  }
}

abstract class PendingAuction implements PendingAction {
  const factory PendingAuction({
    required final int cellIndex,
    required final String propertyName,
    required final int highestBid,
    final String? highestBidderId,
    required final String currentBidderId,
    required final List<String> participantIds,
    required final List<String> passedIds,
  }) = _$PendingAuctionImpl;

  factory PendingAuction.fromJson(Map<String, dynamic> json) =
      _$PendingAuctionImpl.fromJson;

  int get cellIndex;
  String get propertyName;
  int get highestBid;
  String? get highestBidderId;
  String get currentBidderId;
  List<String> get participantIds;
  List<String> get passedIds;

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingAuctionImplCopyWith<_$PendingAuctionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PendingTradeOfferImplCopyWith<$Res> {
  factory _$$PendingTradeOfferImplCopyWith(
    _$PendingTradeOfferImpl value,
    $Res Function(_$PendingTradeOfferImpl) then,
  ) = __$$PendingTradeOfferImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String fromPlayerId,
    String toPlayerId,
    int offerCash,
    int requestCash,
    List<int> offerProperties,
    List<int> requestProperties,
  });
}

/// @nodoc
class __$$PendingTradeOfferImplCopyWithImpl<$Res>
    extends _$PendingActionCopyWithImpl<$Res, _$PendingTradeOfferImpl>
    implements _$$PendingTradeOfferImplCopyWith<$Res> {
  __$$PendingTradeOfferImplCopyWithImpl(
    _$PendingTradeOfferImpl _value,
    $Res Function(_$PendingTradeOfferImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromPlayerId = null,
    Object? toPlayerId = null,
    Object? offerCash = null,
    Object? requestCash = null,
    Object? offerProperties = null,
    Object? requestProperties = null,
  }) {
    return _then(
      _$PendingTradeOfferImpl(
        fromPlayerId: null == fromPlayerId
            ? _value.fromPlayerId
            : fromPlayerId // ignore: cast_nullable_to_non_nullable
                  as String,
        toPlayerId: null == toPlayerId
            ? _value.toPlayerId
            : toPlayerId // ignore: cast_nullable_to_non_nullable
                  as String,
        offerCash: null == offerCash
            ? _value.offerCash
            : offerCash // ignore: cast_nullable_to_non_nullable
                  as int,
        requestCash: null == requestCash
            ? _value.requestCash
            : requestCash // ignore: cast_nullable_to_non_nullable
                  as int,
        offerProperties: null == offerProperties
            ? _value._offerProperties
            : offerProperties // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        requestProperties: null == requestProperties
            ? _value._requestProperties
            : requestProperties // ignore: cast_nullable_to_non_nullable
                  as List<int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingTradeOfferImpl implements PendingTradeOffer {
  const _$PendingTradeOfferImpl({
    required this.fromPlayerId,
    required this.toPlayerId,
    required this.offerCash,
    required this.requestCash,
    required final List<int> offerProperties,
    required final List<int> requestProperties,
    final String? $type,
  }) : _offerProperties = offerProperties,
       _requestProperties = requestProperties,
       $type = $type ?? 'tradeOffer';

  factory _$PendingTradeOfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingTradeOfferImplFromJson(json);

  @override
  final String fromPlayerId;
  @override
  final String toPlayerId;
  @override
  final int offerCash;
  @override
  final int requestCash;
  final List<int> _offerProperties;
  @override
  List<int> get offerProperties {
    if (_offerProperties is EqualUnmodifiableListView) return _offerProperties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_offerProperties);
  }

  final List<int> _requestProperties;
  @override
  List<int> get requestProperties {
    if (_requestProperties is EqualUnmodifiableListView)
      return _requestProperties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requestProperties);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PendingAction.tradeOffer(fromPlayerId: $fromPlayerId, toPlayerId: $toPlayerId, offerCash: $offerCash, requestCash: $requestCash, offerProperties: $offerProperties, requestProperties: $requestProperties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingTradeOfferImpl &&
            (identical(other.fromPlayerId, fromPlayerId) ||
                other.fromPlayerId == fromPlayerId) &&
            (identical(other.toPlayerId, toPlayerId) ||
                other.toPlayerId == toPlayerId) &&
            (identical(other.offerCash, offerCash) ||
                other.offerCash == offerCash) &&
            (identical(other.requestCash, requestCash) ||
                other.requestCash == requestCash) &&
            const DeepCollectionEquality().equals(
              other._offerProperties,
              _offerProperties,
            ) &&
            const DeepCollectionEquality().equals(
              other._requestProperties,
              _requestProperties,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fromPlayerId,
    toPlayerId,
    offerCash,
    requestCash,
    const DeepCollectionEquality().hash(_offerProperties),
    const DeepCollectionEquality().hash(_requestProperties),
  );

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingTradeOfferImplCopyWith<_$PendingTradeOfferImpl> get copyWith =>
      __$$PendingTradeOfferImplCopyWithImpl<_$PendingTradeOfferImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int cellIndex, String propertyName, int price)
    buyOffer,
    required TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )
    rentNotice,
    required TResult Function(String playerName, String taxName, int amount)
    taxNotice,
    required TResult Function(String title, String description) cardNotice,
    required TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )
    auction,
    required TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )
    tradeOffer,
    required TResult Function(String playerId, String playerName, int netWorth)
    winner,
    required TResult Function(List<int> cellIndexes, bool consumesBuyout)
    claimOffer,
  }) {
    return tradeOffer(
      fromPlayerId,
      toPlayerId,
      offerCash,
      requestCash,
      offerProperties,
      requestProperties,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult? Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult? Function(String playerName, String taxName, int amount)? taxNotice,
    TResult? Function(String title, String description)? cardNotice,
    TResult? Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult? Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult? Function(String playerId, String playerName, int netWorth)? winner,
    TResult? Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
  }) {
    return tradeOffer?.call(
      fromPlayerId,
      toPlayerId,
      offerCash,
      requestCash,
      offerProperties,
      requestProperties,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult Function(String playerName, String taxName, int amount)? taxNotice,
    TResult Function(String title, String description)? cardNotice,
    TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult Function(String playerId, String playerName, int netWorth)? winner,
    TResult Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
    required TResult orElse(),
  }) {
    if (tradeOffer != null) {
      return tradeOffer(
        fromPlayerId,
        toPlayerId,
        offerCash,
        requestCash,
        offerProperties,
        requestProperties,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PendingNone value) none,
    required TResult Function(PendingBuyOffer value) buyOffer,
    required TResult Function(PendingRentNotice value) rentNotice,
    required TResult Function(PendingTaxNotice value) taxNotice,
    required TResult Function(PendingCardNotice value) cardNotice,
    required TResult Function(PendingAuction value) auction,
    required TResult Function(PendingTradeOffer value) tradeOffer,
    required TResult Function(PendingWinner value) winner,
    required TResult Function(PendingClaimOffer value) claimOffer,
  }) {
    return tradeOffer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PendingNone value)? none,
    TResult? Function(PendingBuyOffer value)? buyOffer,
    TResult? Function(PendingRentNotice value)? rentNotice,
    TResult? Function(PendingTaxNotice value)? taxNotice,
    TResult? Function(PendingCardNotice value)? cardNotice,
    TResult? Function(PendingAuction value)? auction,
    TResult? Function(PendingTradeOffer value)? tradeOffer,
    TResult? Function(PendingWinner value)? winner,
    TResult? Function(PendingClaimOffer value)? claimOffer,
  }) {
    return tradeOffer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PendingNone value)? none,
    TResult Function(PendingBuyOffer value)? buyOffer,
    TResult Function(PendingRentNotice value)? rentNotice,
    TResult Function(PendingTaxNotice value)? taxNotice,
    TResult Function(PendingCardNotice value)? cardNotice,
    TResult Function(PendingAuction value)? auction,
    TResult Function(PendingTradeOffer value)? tradeOffer,
    TResult Function(PendingWinner value)? winner,
    TResult Function(PendingClaimOffer value)? claimOffer,
    required TResult orElse(),
  }) {
    if (tradeOffer != null) {
      return tradeOffer(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingTradeOfferImplToJson(this);
  }
}

abstract class PendingTradeOffer implements PendingAction {
  const factory PendingTradeOffer({
    required final String fromPlayerId,
    required final String toPlayerId,
    required final int offerCash,
    required final int requestCash,
    required final List<int> offerProperties,
    required final List<int> requestProperties,
  }) = _$PendingTradeOfferImpl;

  factory PendingTradeOffer.fromJson(Map<String, dynamic> json) =
      _$PendingTradeOfferImpl.fromJson;

  String get fromPlayerId;
  String get toPlayerId;
  int get offerCash;
  int get requestCash;
  List<int> get offerProperties;
  List<int> get requestProperties;

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingTradeOfferImplCopyWith<_$PendingTradeOfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PendingWinnerImplCopyWith<$Res> {
  factory _$$PendingWinnerImplCopyWith(
    _$PendingWinnerImpl value,
    $Res Function(_$PendingWinnerImpl) then,
  ) = __$$PendingWinnerImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String playerId, String playerName, int netWorth});
}

/// @nodoc
class __$$PendingWinnerImplCopyWithImpl<$Res>
    extends _$PendingActionCopyWithImpl<$Res, _$PendingWinnerImpl>
    implements _$$PendingWinnerImplCopyWith<$Res> {
  __$$PendingWinnerImplCopyWithImpl(
    _$PendingWinnerImpl _value,
    $Res Function(_$PendingWinnerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? netWorth = null,
  }) {
    return _then(
      _$PendingWinnerImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        netWorth: null == netWorth
            ? _value.netWorth
            : netWorth // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingWinnerImpl implements PendingWinner {
  const _$PendingWinnerImpl({
    required this.playerId,
    required this.playerName,
    this.netWorth = 0,
    final String? $type,
  }) : $type = $type ?? 'winner';

  factory _$PendingWinnerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingWinnerImplFromJson(json);

  @override
  final String playerId;
  @override
  final String playerName;
  @override
  @JsonKey()
  final int netWorth;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PendingAction.winner(playerId: $playerId, playerName: $playerName, netWorth: $netWorth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingWinnerImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.netWorth, netWorth) ||
                other.netWorth == netWorth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, playerId, playerName, netWorth);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingWinnerImplCopyWith<_$PendingWinnerImpl> get copyWith =>
      __$$PendingWinnerImplCopyWithImpl<_$PendingWinnerImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int cellIndex, String propertyName, int price)
    buyOffer,
    required TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )
    rentNotice,
    required TResult Function(String playerName, String taxName, int amount)
    taxNotice,
    required TResult Function(String title, String description) cardNotice,
    required TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )
    auction,
    required TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )
    tradeOffer,
    required TResult Function(String playerId, String playerName, int netWorth)
    winner,
    required TResult Function(List<int> cellIndexes, bool consumesBuyout)
    claimOffer,
  }) {
    return winner(playerId, playerName, netWorth);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult? Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult? Function(String playerName, String taxName, int amount)? taxNotice,
    TResult? Function(String title, String description)? cardNotice,
    TResult? Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult? Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult? Function(String playerId, String playerName, int netWorth)? winner,
    TResult? Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
  }) {
    return winner?.call(playerId, playerName, netWorth);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult Function(String playerName, String taxName, int amount)? taxNotice,
    TResult Function(String title, String description)? cardNotice,
    TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult Function(String playerId, String playerName, int netWorth)? winner,
    TResult Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
    required TResult orElse(),
  }) {
    if (winner != null) {
      return winner(playerId, playerName, netWorth);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PendingNone value) none,
    required TResult Function(PendingBuyOffer value) buyOffer,
    required TResult Function(PendingRentNotice value) rentNotice,
    required TResult Function(PendingTaxNotice value) taxNotice,
    required TResult Function(PendingCardNotice value) cardNotice,
    required TResult Function(PendingAuction value) auction,
    required TResult Function(PendingTradeOffer value) tradeOffer,
    required TResult Function(PendingWinner value) winner,
    required TResult Function(PendingClaimOffer value) claimOffer,
  }) {
    return winner(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PendingNone value)? none,
    TResult? Function(PendingBuyOffer value)? buyOffer,
    TResult? Function(PendingRentNotice value)? rentNotice,
    TResult? Function(PendingTaxNotice value)? taxNotice,
    TResult? Function(PendingCardNotice value)? cardNotice,
    TResult? Function(PendingAuction value)? auction,
    TResult? Function(PendingTradeOffer value)? tradeOffer,
    TResult? Function(PendingWinner value)? winner,
    TResult? Function(PendingClaimOffer value)? claimOffer,
  }) {
    return winner?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PendingNone value)? none,
    TResult Function(PendingBuyOffer value)? buyOffer,
    TResult Function(PendingRentNotice value)? rentNotice,
    TResult Function(PendingTaxNotice value)? taxNotice,
    TResult Function(PendingCardNotice value)? cardNotice,
    TResult Function(PendingAuction value)? auction,
    TResult Function(PendingTradeOffer value)? tradeOffer,
    TResult Function(PendingWinner value)? winner,
    TResult Function(PendingClaimOffer value)? claimOffer,
    required TResult orElse(),
  }) {
    if (winner != null) {
      return winner(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingWinnerImplToJson(this);
  }
}

abstract class PendingWinner implements PendingAction {
  const factory PendingWinner({
    required final String playerId,
    required final String playerName,
    final int netWorth,
  }) = _$PendingWinnerImpl;

  factory PendingWinner.fromJson(Map<String, dynamic> json) =
      _$PendingWinnerImpl.fromJson;

  String get playerId;
  String get playerName;
  int get netWorth;

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingWinnerImplCopyWith<_$PendingWinnerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PendingClaimOfferImplCopyWith<$Res> {
  factory _$$PendingClaimOfferImplCopyWith(
    _$PendingClaimOfferImpl value,
    $Res Function(_$PendingClaimOfferImpl) then,
  ) = __$$PendingClaimOfferImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<int> cellIndexes, bool consumesBuyout});
}

/// @nodoc
class __$$PendingClaimOfferImplCopyWithImpl<$Res>
    extends _$PendingActionCopyWithImpl<$Res, _$PendingClaimOfferImpl>
    implements _$$PendingClaimOfferImplCopyWith<$Res> {
  __$$PendingClaimOfferImplCopyWithImpl(
    _$PendingClaimOfferImpl _value,
    $Res Function(_$PendingClaimOfferImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cellIndexes = null, Object? consumesBuyout = null}) {
    return _then(
      _$PendingClaimOfferImpl(
        cellIndexes: null == cellIndexes
            ? _value._cellIndexes
            : cellIndexes // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        consumesBuyout: null == consumesBuyout
            ? _value.consumesBuyout
            : consumesBuyout // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingClaimOfferImpl implements PendingClaimOffer {
  const _$PendingClaimOfferImpl({
    required final List<int> cellIndexes,
    required this.consumesBuyout,
    final String? $type,
  }) : _cellIndexes = cellIndexes,
       $type = $type ?? 'claimOffer';

  factory _$PendingClaimOfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingClaimOfferImplFromJson(json);

  final List<int> _cellIndexes;
  @override
  List<int> get cellIndexes {
    if (_cellIndexes is EqualUnmodifiableListView) return _cellIndexes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cellIndexes);
  }

  @override
  final bool consumesBuyout;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PendingAction.claimOffer(cellIndexes: $cellIndexes, consumesBuyout: $consumesBuyout)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingClaimOfferImpl &&
            const DeepCollectionEquality().equals(
              other._cellIndexes,
              _cellIndexes,
            ) &&
            (identical(other.consumesBuyout, consumesBuyout) ||
                other.consumesBuyout == consumesBuyout));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_cellIndexes),
    consumesBuyout,
  );

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingClaimOfferImplCopyWith<_$PendingClaimOfferImpl> get copyWith =>
      __$$PendingClaimOfferImplCopyWithImpl<_$PendingClaimOfferImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(int cellIndex, String propertyName, int price)
    buyOffer,
    required TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )
    rentNotice,
    required TResult Function(String playerName, String taxName, int amount)
    taxNotice,
    required TResult Function(String title, String description) cardNotice,
    required TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )
    auction,
    required TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )
    tradeOffer,
    required TResult Function(String playerId, String playerName, int netWorth)
    winner,
    required TResult Function(List<int> cellIndexes, bool consumesBuyout)
    claimOffer,
  }) {
    return claimOffer(cellIndexes, consumesBuyout);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult? Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult? Function(String playerName, String taxName, int amount)? taxNotice,
    TResult? Function(String title, String description)? cardNotice,
    TResult? Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult? Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult? Function(String playerId, String playerName, int netWorth)? winner,
    TResult? Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
  }) {
    return claimOffer?.call(cellIndexes, consumesBuyout);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(int cellIndex, String propertyName, int price)? buyOffer,
    TResult Function(
      String payerName,
      String ownerName,
      String propertyName,
      int amount,
    )?
    rentNotice,
    TResult Function(String playerName, String taxName, int amount)? taxNotice,
    TResult Function(String title, String description)? cardNotice,
    TResult Function(
      int cellIndex,
      String propertyName,
      int highestBid,
      String? highestBidderId,
      String currentBidderId,
      List<String> participantIds,
      List<String> passedIds,
    )?
    auction,
    TResult Function(
      String fromPlayerId,
      String toPlayerId,
      int offerCash,
      int requestCash,
      List<int> offerProperties,
      List<int> requestProperties,
    )?
    tradeOffer,
    TResult Function(String playerId, String playerName, int netWorth)? winner,
    TResult Function(List<int> cellIndexes, bool consumesBuyout)? claimOffer,
    required TResult orElse(),
  }) {
    if (claimOffer != null) {
      return claimOffer(cellIndexes, consumesBuyout);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PendingNone value) none,
    required TResult Function(PendingBuyOffer value) buyOffer,
    required TResult Function(PendingRentNotice value) rentNotice,
    required TResult Function(PendingTaxNotice value) taxNotice,
    required TResult Function(PendingCardNotice value) cardNotice,
    required TResult Function(PendingAuction value) auction,
    required TResult Function(PendingTradeOffer value) tradeOffer,
    required TResult Function(PendingWinner value) winner,
    required TResult Function(PendingClaimOffer value) claimOffer,
  }) {
    return claimOffer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PendingNone value)? none,
    TResult? Function(PendingBuyOffer value)? buyOffer,
    TResult? Function(PendingRentNotice value)? rentNotice,
    TResult? Function(PendingTaxNotice value)? taxNotice,
    TResult? Function(PendingCardNotice value)? cardNotice,
    TResult? Function(PendingAuction value)? auction,
    TResult? Function(PendingTradeOffer value)? tradeOffer,
    TResult? Function(PendingWinner value)? winner,
    TResult? Function(PendingClaimOffer value)? claimOffer,
  }) {
    return claimOffer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PendingNone value)? none,
    TResult Function(PendingBuyOffer value)? buyOffer,
    TResult Function(PendingRentNotice value)? rentNotice,
    TResult Function(PendingTaxNotice value)? taxNotice,
    TResult Function(PendingCardNotice value)? cardNotice,
    TResult Function(PendingAuction value)? auction,
    TResult Function(PendingTradeOffer value)? tradeOffer,
    TResult Function(PendingWinner value)? winner,
    TResult Function(PendingClaimOffer value)? claimOffer,
    required TResult orElse(),
  }) {
    if (claimOffer != null) {
      return claimOffer(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingClaimOfferImplToJson(this);
  }
}

abstract class PendingClaimOffer implements PendingAction {
  const factory PendingClaimOffer({
    required final List<int> cellIndexes,
    required final bool consumesBuyout,
  }) = _$PendingClaimOfferImpl;

  factory PendingClaimOffer.fromJson(Map<String, dynamic> json) =
      _$PendingClaimOfferImpl.fromJson;

  List<int> get cellIndexes;
  bool get consumesBuyout;

  /// Create a copy of PendingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingClaimOfferImplCopyWith<_$PendingClaimOfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
