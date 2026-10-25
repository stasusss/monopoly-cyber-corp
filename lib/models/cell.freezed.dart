// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cell.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BoardCell _$BoardCellFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'property':
      return PropertyCell.fromJson(json);
    case 'railroad':
      return RailroadCell.fromJson(json);
    case 'utility':
      return UtilityCell.fromJson(json);
    case 'tax':
      return TaxCell.fromJson(json);
    case 'special':
      return SpecialCell.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'BoardCell',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$BoardCell {
  int get index => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )
    property,
    required TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )
    railroad,
    required TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )
    utility,
    required TResult Function(int index, String name, int amount) tax,
    required TResult Function(int index, String name, SpecialKind kind) special,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )?
    property,
    TResult? Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    railroad,
    TResult? Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    utility,
    TResult? Function(int index, String name, int amount)? tax,
    TResult? Function(int index, String name, SpecialKind kind)? special,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )?
    property,
    TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    railroad,
    TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    utility,
    TResult Function(int index, String name, int amount)? tax,
    TResult Function(int index, String name, SpecialKind kind)? special,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PropertyCell value) property,
    required TResult Function(RailroadCell value) railroad,
    required TResult Function(UtilityCell value) utility,
    required TResult Function(TaxCell value) tax,
    required TResult Function(SpecialCell value) special,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PropertyCell value)? property,
    TResult? Function(RailroadCell value)? railroad,
    TResult? Function(UtilityCell value)? utility,
    TResult? Function(TaxCell value)? tax,
    TResult? Function(SpecialCell value)? special,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PropertyCell value)? property,
    TResult Function(RailroadCell value)? railroad,
    TResult Function(UtilityCell value)? utility,
    TResult Function(TaxCell value)? tax,
    TResult Function(SpecialCell value)? special,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this BoardCell to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoardCellCopyWith<BoardCell> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardCellCopyWith<$Res> {
  factory $BoardCellCopyWith(BoardCell value, $Res Function(BoardCell) then) =
      _$BoardCellCopyWithImpl<$Res, BoardCell>;
  @useResult
  $Res call({int index, String name});
}

/// @nodoc
class _$BoardCellCopyWithImpl<$Res, $Val extends BoardCell>
    implements $BoardCellCopyWith<$Res> {
  _$BoardCellCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? index = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            index: null == index
                ? _value.index
                : index // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PropertyCellImplCopyWith<$Res>
    implements $BoardCellCopyWith<$Res> {
  factory _$$PropertyCellImplCopyWith(
    _$PropertyCellImpl value,
    $Res Function(_$PropertyCellImpl) then,
  ) = __$$PropertyCellImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int index,
    String name,
    ColorGroup colorGroup,
    int price,
    List<int> rents,
    int mortgage,
    String? ownerId,
    int houses,
    bool isMortgaged,
  });
}

/// @nodoc
class __$$PropertyCellImplCopyWithImpl<$Res>
    extends _$BoardCellCopyWithImpl<$Res, _$PropertyCellImpl>
    implements _$$PropertyCellImplCopyWith<$Res> {
  __$$PropertyCellImplCopyWithImpl(
    _$PropertyCellImpl _value,
    $Res Function(_$PropertyCellImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? name = null,
    Object? colorGroup = null,
    Object? price = null,
    Object? rents = null,
    Object? mortgage = null,
    Object? ownerId = freezed,
    Object? houses = null,
    Object? isMortgaged = null,
  }) {
    return _then(
      _$PropertyCellImpl(
        index: null == index
            ? _value.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        colorGroup: null == colorGroup
            ? _value.colorGroup
            : colorGroup // ignore: cast_nullable_to_non_nullable
                  as ColorGroup,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        rents: null == rents
            ? _value._rents
            : rents // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        mortgage: null == mortgage
            ? _value.mortgage
            : mortgage // ignore: cast_nullable_to_non_nullable
                  as int,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        houses: null == houses
            ? _value.houses
            : houses // ignore: cast_nullable_to_non_nullable
                  as int,
        isMortgaged: null == isMortgaged
            ? _value.isMortgaged
            : isMortgaged // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyCellImpl extends PropertyCell {
  const _$PropertyCellImpl({
    required this.index,
    required this.name,
    required this.colorGroup,
    required this.price,
    required final List<int> rents,
    required this.mortgage,
    this.ownerId,
    this.houses = 0,
    this.isMortgaged = false,
    final String? $type,
  }) : _rents = rents,
       $type = $type ?? 'property',
       super._();

  factory _$PropertyCellImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyCellImplFromJson(json);

  @override
  final int index;
  @override
  final String name;
  @override
  final ColorGroup colorGroup;
  @override
  final int price;
  final List<int> _rents;
  @override
  List<int> get rents {
    if (_rents is EqualUnmodifiableListView) return _rents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rents);
  }

  @override
  final int mortgage;
  @override
  final String? ownerId;
  @override
  @JsonKey()
  final int houses;
  @override
  @JsonKey()
  final bool isMortgaged;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BoardCell.property(index: $index, name: $name, colorGroup: $colorGroup, price: $price, rents: $rents, mortgage: $mortgage, ownerId: $ownerId, houses: $houses, isMortgaged: $isMortgaged)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyCellImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.colorGroup, colorGroup) ||
                other.colorGroup == colorGroup) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(other._rents, _rents) &&
            (identical(other.mortgage, mortgage) ||
                other.mortgage == mortgage) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.houses, houses) || other.houses == houses) &&
            (identical(other.isMortgaged, isMortgaged) ||
                other.isMortgaged == isMortgaged));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    index,
    name,
    colorGroup,
    price,
    const DeepCollectionEquality().hash(_rents),
    mortgage,
    ownerId,
    houses,
    isMortgaged,
  );

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyCellImplCopyWith<_$PropertyCellImpl> get copyWith =>
      __$$PropertyCellImplCopyWithImpl<_$PropertyCellImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )
    property,
    required TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )
    railroad,
    required TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )
    utility,
    required TResult Function(int index, String name, int amount) tax,
    required TResult Function(int index, String name, SpecialKind kind) special,
  }) {
    return property(
      index,
      name,
      colorGroup,
      price,
      rents,
      mortgage,
      ownerId,
      houses,
      isMortgaged,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )?
    property,
    TResult? Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    railroad,
    TResult? Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    utility,
    TResult? Function(int index, String name, int amount)? tax,
    TResult? Function(int index, String name, SpecialKind kind)? special,
  }) {
    return property?.call(
      index,
      name,
      colorGroup,
      price,
      rents,
      mortgage,
      ownerId,
      houses,
      isMortgaged,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )?
    property,
    TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    railroad,
    TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    utility,
    TResult Function(int index, String name, int amount)? tax,
    TResult Function(int index, String name, SpecialKind kind)? special,
    required TResult orElse(),
  }) {
    if (property != null) {
      return property(
        index,
        name,
        colorGroup,
        price,
        rents,
        mortgage,
        ownerId,
        houses,
        isMortgaged,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PropertyCell value) property,
    required TResult Function(RailroadCell value) railroad,
    required TResult Function(UtilityCell value) utility,
    required TResult Function(TaxCell value) tax,
    required TResult Function(SpecialCell value) special,
  }) {
    return property(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PropertyCell value)? property,
    TResult? Function(RailroadCell value)? railroad,
    TResult? Function(UtilityCell value)? utility,
    TResult? Function(TaxCell value)? tax,
    TResult? Function(SpecialCell value)? special,
  }) {
    return property?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PropertyCell value)? property,
    TResult Function(RailroadCell value)? railroad,
    TResult Function(UtilityCell value)? utility,
    TResult Function(TaxCell value)? tax,
    TResult Function(SpecialCell value)? special,
    required TResult orElse(),
  }) {
    if (property != null) {
      return property(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyCellImplToJson(this);
  }
}

abstract class PropertyCell extends BoardCell {
  const factory PropertyCell({
    required final int index,
    required final String name,
    required final ColorGroup colorGroup,
    required final int price,
    required final List<int> rents,
    required final int mortgage,
    final String? ownerId,
    final int houses,
    final bool isMortgaged,
  }) = _$PropertyCellImpl;
  const PropertyCell._() : super._();

  factory PropertyCell.fromJson(Map<String, dynamic> json) =
      _$PropertyCellImpl.fromJson;

  @override
  int get index;
  @override
  String get name;
  ColorGroup get colorGroup;
  int get price;
  List<int> get rents;
  int get mortgage;
  String? get ownerId;
  int get houses;
  bool get isMortgaged;

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyCellImplCopyWith<_$PropertyCellImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RailroadCellImplCopyWith<$Res>
    implements $BoardCellCopyWith<$Res> {
  factory _$$RailroadCellImplCopyWith(
    _$RailroadCellImpl value,
    $Res Function(_$RailroadCellImpl) then,
  ) = __$$RailroadCellImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int index,
    String name,
    int price,
    int mortgage,
    String? ownerId,
    bool isMortgaged,
  });
}

/// @nodoc
class __$$RailroadCellImplCopyWithImpl<$Res>
    extends _$BoardCellCopyWithImpl<$Res, _$RailroadCellImpl>
    implements _$$RailroadCellImplCopyWith<$Res> {
  __$$RailroadCellImplCopyWithImpl(
    _$RailroadCellImpl _value,
    $Res Function(_$RailroadCellImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? name = null,
    Object? price = null,
    Object? mortgage = null,
    Object? ownerId = freezed,
    Object? isMortgaged = null,
  }) {
    return _then(
      _$RailroadCellImpl(
        index: null == index
            ? _value.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        mortgage: null == mortgage
            ? _value.mortgage
            : mortgage // ignore: cast_nullable_to_non_nullable
                  as int,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isMortgaged: null == isMortgaged
            ? _value.isMortgaged
            : isMortgaged // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RailroadCellImpl extends RailroadCell {
  const _$RailroadCellImpl({
    required this.index,
    required this.name,
    required this.price,
    required this.mortgage,
    this.ownerId,
    this.isMortgaged = false,
    final String? $type,
  }) : $type = $type ?? 'railroad',
       super._();

  factory _$RailroadCellImpl.fromJson(Map<String, dynamic> json) =>
      _$$RailroadCellImplFromJson(json);

  @override
  final int index;
  @override
  final String name;
  @override
  final int price;
  @override
  final int mortgage;
  @override
  final String? ownerId;
  @override
  @JsonKey()
  final bool isMortgaged;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BoardCell.railroad(index: $index, name: $name, price: $price, mortgage: $mortgage, ownerId: $ownerId, isMortgaged: $isMortgaged)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RailroadCellImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.mortgage, mortgage) ||
                other.mortgage == mortgage) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.isMortgaged, isMortgaged) ||
                other.isMortgaged == isMortgaged));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    index,
    name,
    price,
    mortgage,
    ownerId,
    isMortgaged,
  );

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RailroadCellImplCopyWith<_$RailroadCellImpl> get copyWith =>
      __$$RailroadCellImplCopyWithImpl<_$RailroadCellImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )
    property,
    required TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )
    railroad,
    required TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )
    utility,
    required TResult Function(int index, String name, int amount) tax,
    required TResult Function(int index, String name, SpecialKind kind) special,
  }) {
    return railroad(index, name, price, mortgage, ownerId, isMortgaged);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )?
    property,
    TResult? Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    railroad,
    TResult? Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    utility,
    TResult? Function(int index, String name, int amount)? tax,
    TResult? Function(int index, String name, SpecialKind kind)? special,
  }) {
    return railroad?.call(index, name, price, mortgage, ownerId, isMortgaged);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )?
    property,
    TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    railroad,
    TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    utility,
    TResult Function(int index, String name, int amount)? tax,
    TResult Function(int index, String name, SpecialKind kind)? special,
    required TResult orElse(),
  }) {
    if (railroad != null) {
      return railroad(index, name, price, mortgage, ownerId, isMortgaged);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PropertyCell value) property,
    required TResult Function(RailroadCell value) railroad,
    required TResult Function(UtilityCell value) utility,
    required TResult Function(TaxCell value) tax,
    required TResult Function(SpecialCell value) special,
  }) {
    return railroad(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PropertyCell value)? property,
    TResult? Function(RailroadCell value)? railroad,
    TResult? Function(UtilityCell value)? utility,
    TResult? Function(TaxCell value)? tax,
    TResult? Function(SpecialCell value)? special,
  }) {
    return railroad?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PropertyCell value)? property,
    TResult Function(RailroadCell value)? railroad,
    TResult Function(UtilityCell value)? utility,
    TResult Function(TaxCell value)? tax,
    TResult Function(SpecialCell value)? special,
    required TResult orElse(),
  }) {
    if (railroad != null) {
      return railroad(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RailroadCellImplToJson(this);
  }
}

abstract class RailroadCell extends BoardCell {
  const factory RailroadCell({
    required final int index,
    required final String name,
    required final int price,
    required final int mortgage,
    final String? ownerId,
    final bool isMortgaged,
  }) = _$RailroadCellImpl;
  const RailroadCell._() : super._();

  factory RailroadCell.fromJson(Map<String, dynamic> json) =
      _$RailroadCellImpl.fromJson;

  @override
  int get index;
  @override
  String get name;
  int get price;
  int get mortgage;
  String? get ownerId;
  bool get isMortgaged;

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RailroadCellImplCopyWith<_$RailroadCellImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UtilityCellImplCopyWith<$Res>
    implements $BoardCellCopyWith<$Res> {
  factory _$$UtilityCellImplCopyWith(
    _$UtilityCellImpl value,
    $Res Function(_$UtilityCellImpl) then,
  ) = __$$UtilityCellImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int index,
    String name,
    int price,
    int mortgage,
    String? ownerId,
    bool isMortgaged,
  });
}

/// @nodoc
class __$$UtilityCellImplCopyWithImpl<$Res>
    extends _$BoardCellCopyWithImpl<$Res, _$UtilityCellImpl>
    implements _$$UtilityCellImplCopyWith<$Res> {
  __$$UtilityCellImplCopyWithImpl(
    _$UtilityCellImpl _value,
    $Res Function(_$UtilityCellImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? name = null,
    Object? price = null,
    Object? mortgage = null,
    Object? ownerId = freezed,
    Object? isMortgaged = null,
  }) {
    return _then(
      _$UtilityCellImpl(
        index: null == index
            ? _value.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        mortgage: null == mortgage
            ? _value.mortgage
            : mortgage // ignore: cast_nullable_to_non_nullable
                  as int,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isMortgaged: null == isMortgaged
            ? _value.isMortgaged
            : isMortgaged // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UtilityCellImpl extends UtilityCell {
  const _$UtilityCellImpl({
    required this.index,
    required this.name,
    required this.price,
    required this.mortgage,
    this.ownerId,
    this.isMortgaged = false,
    final String? $type,
  }) : $type = $type ?? 'utility',
       super._();

  factory _$UtilityCellImpl.fromJson(Map<String, dynamic> json) =>
      _$$UtilityCellImplFromJson(json);

  @override
  final int index;
  @override
  final String name;
  @override
  final int price;
  @override
  final int mortgage;
  @override
  final String? ownerId;
  @override
  @JsonKey()
  final bool isMortgaged;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BoardCell.utility(index: $index, name: $name, price: $price, mortgage: $mortgage, ownerId: $ownerId, isMortgaged: $isMortgaged)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UtilityCellImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.mortgage, mortgage) ||
                other.mortgage == mortgage) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.isMortgaged, isMortgaged) ||
                other.isMortgaged == isMortgaged));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    index,
    name,
    price,
    mortgage,
    ownerId,
    isMortgaged,
  );

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UtilityCellImplCopyWith<_$UtilityCellImpl> get copyWith =>
      __$$UtilityCellImplCopyWithImpl<_$UtilityCellImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )
    property,
    required TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )
    railroad,
    required TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )
    utility,
    required TResult Function(int index, String name, int amount) tax,
    required TResult Function(int index, String name, SpecialKind kind) special,
  }) {
    return utility(index, name, price, mortgage, ownerId, isMortgaged);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )?
    property,
    TResult? Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    railroad,
    TResult? Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    utility,
    TResult? Function(int index, String name, int amount)? tax,
    TResult? Function(int index, String name, SpecialKind kind)? special,
  }) {
    return utility?.call(index, name, price, mortgage, ownerId, isMortgaged);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )?
    property,
    TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    railroad,
    TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    utility,
    TResult Function(int index, String name, int amount)? tax,
    TResult Function(int index, String name, SpecialKind kind)? special,
    required TResult orElse(),
  }) {
    if (utility != null) {
      return utility(index, name, price, mortgage, ownerId, isMortgaged);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PropertyCell value) property,
    required TResult Function(RailroadCell value) railroad,
    required TResult Function(UtilityCell value) utility,
    required TResult Function(TaxCell value) tax,
    required TResult Function(SpecialCell value) special,
  }) {
    return utility(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PropertyCell value)? property,
    TResult? Function(RailroadCell value)? railroad,
    TResult? Function(UtilityCell value)? utility,
    TResult? Function(TaxCell value)? tax,
    TResult? Function(SpecialCell value)? special,
  }) {
    return utility?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PropertyCell value)? property,
    TResult Function(RailroadCell value)? railroad,
    TResult Function(UtilityCell value)? utility,
    TResult Function(TaxCell value)? tax,
    TResult Function(SpecialCell value)? special,
    required TResult orElse(),
  }) {
    if (utility != null) {
      return utility(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UtilityCellImplToJson(this);
  }
}

abstract class UtilityCell extends BoardCell {
  const factory UtilityCell({
    required final int index,
    required final String name,
    required final int price,
    required final int mortgage,
    final String? ownerId,
    final bool isMortgaged,
  }) = _$UtilityCellImpl;
  const UtilityCell._() : super._();

  factory UtilityCell.fromJson(Map<String, dynamic> json) =
      _$UtilityCellImpl.fromJson;

  @override
  int get index;
  @override
  String get name;
  int get price;
  int get mortgage;
  String? get ownerId;
  bool get isMortgaged;

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UtilityCellImplCopyWith<_$UtilityCellImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TaxCellImplCopyWith<$Res>
    implements $BoardCellCopyWith<$Res> {
  factory _$$TaxCellImplCopyWith(
    _$TaxCellImpl value,
    $Res Function(_$TaxCellImpl) then,
  ) = __$$TaxCellImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int index, String name, int amount});
}

/// @nodoc
class __$$TaxCellImplCopyWithImpl<$Res>
    extends _$BoardCellCopyWithImpl<$Res, _$TaxCellImpl>
    implements _$$TaxCellImplCopyWith<$Res> {
  __$$TaxCellImplCopyWithImpl(
    _$TaxCellImpl _value,
    $Res Function(_$TaxCellImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? name = null,
    Object? amount = null,
  }) {
    return _then(
      _$TaxCellImpl(
        index: null == index
            ? _value.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
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
class _$TaxCellImpl extends TaxCell {
  const _$TaxCellImpl({
    required this.index,
    required this.name,
    required this.amount,
    final String? $type,
  }) : $type = $type ?? 'tax',
       super._();

  factory _$TaxCellImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaxCellImplFromJson(json);

  @override
  final int index;
  @override
  final String name;
  @override
  final int amount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BoardCell.tax(index: $index, name: $name, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxCellImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, index, name, amount);

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxCellImplCopyWith<_$TaxCellImpl> get copyWith =>
      __$$TaxCellImplCopyWithImpl<_$TaxCellImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )
    property,
    required TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )
    railroad,
    required TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )
    utility,
    required TResult Function(int index, String name, int amount) tax,
    required TResult Function(int index, String name, SpecialKind kind) special,
  }) {
    return tax(index, name, amount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )?
    property,
    TResult? Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    railroad,
    TResult? Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    utility,
    TResult? Function(int index, String name, int amount)? tax,
    TResult? Function(int index, String name, SpecialKind kind)? special,
  }) {
    return tax?.call(index, name, amount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )?
    property,
    TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    railroad,
    TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    utility,
    TResult Function(int index, String name, int amount)? tax,
    TResult Function(int index, String name, SpecialKind kind)? special,
    required TResult orElse(),
  }) {
    if (tax != null) {
      return tax(index, name, amount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PropertyCell value) property,
    required TResult Function(RailroadCell value) railroad,
    required TResult Function(UtilityCell value) utility,
    required TResult Function(TaxCell value) tax,
    required TResult Function(SpecialCell value) special,
  }) {
    return tax(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PropertyCell value)? property,
    TResult? Function(RailroadCell value)? railroad,
    TResult? Function(UtilityCell value)? utility,
    TResult? Function(TaxCell value)? tax,
    TResult? Function(SpecialCell value)? special,
  }) {
    return tax?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PropertyCell value)? property,
    TResult Function(RailroadCell value)? railroad,
    TResult Function(UtilityCell value)? utility,
    TResult Function(TaxCell value)? tax,
    TResult Function(SpecialCell value)? special,
    required TResult orElse(),
  }) {
    if (tax != null) {
      return tax(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TaxCellImplToJson(this);
  }
}

abstract class TaxCell extends BoardCell {
  const factory TaxCell({
    required final int index,
    required final String name,
    required final int amount,
  }) = _$TaxCellImpl;
  const TaxCell._() : super._();

  factory TaxCell.fromJson(Map<String, dynamic> json) = _$TaxCellImpl.fromJson;

  @override
  int get index;
  @override
  String get name;
  int get amount;

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaxCellImplCopyWith<_$TaxCellImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SpecialCellImplCopyWith<$Res>
    implements $BoardCellCopyWith<$Res> {
  factory _$$SpecialCellImplCopyWith(
    _$SpecialCellImpl value,
    $Res Function(_$SpecialCellImpl) then,
  ) = __$$SpecialCellImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int index, String name, SpecialKind kind});
}

/// @nodoc
class __$$SpecialCellImplCopyWithImpl<$Res>
    extends _$BoardCellCopyWithImpl<$Res, _$SpecialCellImpl>
    implements _$$SpecialCellImplCopyWith<$Res> {
  __$$SpecialCellImplCopyWithImpl(
    _$SpecialCellImpl _value,
    $Res Function(_$SpecialCellImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? index = null, Object? name = null, Object? kind = null}) {
    return _then(
      _$SpecialCellImpl(
        index: null == index
            ? _value.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        kind: null == kind
            ? _value.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as SpecialKind,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpecialCellImpl extends SpecialCell {
  const _$SpecialCellImpl({
    required this.index,
    required this.name,
    required this.kind,
    final String? $type,
  }) : $type = $type ?? 'special',
       super._();

  factory _$SpecialCellImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpecialCellImplFromJson(json);

  @override
  final int index;
  @override
  final String name;
  @override
  final SpecialKind kind;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BoardCell.special(index: $index, name: $name, kind: $kind)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecialCellImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.kind, kind) || other.kind == kind));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, index, name, kind);

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecialCellImplCopyWith<_$SpecialCellImpl> get copyWith =>
      __$$SpecialCellImplCopyWithImpl<_$SpecialCellImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )
    property,
    required TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )
    railroad,
    required TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )
    utility,
    required TResult Function(int index, String name, int amount) tax,
    required TResult Function(int index, String name, SpecialKind kind) special,
  }) {
    return special(index, name, kind);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )?
    property,
    TResult? Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    railroad,
    TResult? Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    utility,
    TResult? Function(int index, String name, int amount)? tax,
    TResult? Function(int index, String name, SpecialKind kind)? special,
  }) {
    return special?.call(index, name, kind);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      int index,
      String name,
      ColorGroup colorGroup,
      int price,
      List<int> rents,
      int mortgage,
      String? ownerId,
      int houses,
      bool isMortgaged,
    )?
    property,
    TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    railroad,
    TResult Function(
      int index,
      String name,
      int price,
      int mortgage,
      String? ownerId,
      bool isMortgaged,
    )?
    utility,
    TResult Function(int index, String name, int amount)? tax,
    TResult Function(int index, String name, SpecialKind kind)? special,
    required TResult orElse(),
  }) {
    if (special != null) {
      return special(index, name, kind);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PropertyCell value) property,
    required TResult Function(RailroadCell value) railroad,
    required TResult Function(UtilityCell value) utility,
    required TResult Function(TaxCell value) tax,
    required TResult Function(SpecialCell value) special,
  }) {
    return special(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PropertyCell value)? property,
    TResult? Function(RailroadCell value)? railroad,
    TResult? Function(UtilityCell value)? utility,
    TResult? Function(TaxCell value)? tax,
    TResult? Function(SpecialCell value)? special,
  }) {
    return special?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PropertyCell value)? property,
    TResult Function(RailroadCell value)? railroad,
    TResult Function(UtilityCell value)? utility,
    TResult Function(TaxCell value)? tax,
    TResult Function(SpecialCell value)? special,
    required TResult orElse(),
  }) {
    if (special != null) {
      return special(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecialCellImplToJson(this);
  }
}

abstract class SpecialCell extends BoardCell {
  const factory SpecialCell({
    required final int index,
    required final String name,
    required final SpecialKind kind,
  }) = _$SpecialCellImpl;
  const SpecialCell._() : super._();

  factory SpecialCell.fromJson(Map<String, dynamic> json) =
      _$SpecialCellImpl.fromJson;

  @override
  int get index;
  @override
  String get name;
  SpecialKind get kind;

  /// Create a copy of BoardCell
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecialCellImplCopyWith<_$SpecialCellImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
