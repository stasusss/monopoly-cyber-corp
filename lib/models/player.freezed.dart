// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return _Player.fromJson(json);
}

/// @nodoc
mixin _$Player {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  TokenColor get tokenColor => throw _privateConstructorUsedError;
  int get balance => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  bool get inJail => throw _privateConstructorUsedError;
  int get jailTurns => throw _privateConstructorUsedError;
  List<int> get propertyIndexes => throw _privateConstructorUsedError;
  bool get isBankrupt => throw _privateConstructorUsedError;
  bool get isAi => throw _privateConstructorUsedError;
  AiProfile? get aiProfile => throw _privateConstructorUsedError;
  int get getOutOfJailCards => throw _privateConstructorUsedError;

  /// Serializes this Player to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerCopyWith<Player> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCopyWith<$Res> {
  factory $PlayerCopyWith(Player value, $Res Function(Player) then) =
      _$PlayerCopyWithImpl<$Res, Player>;
  @useResult
  $Res call({
    String id,
    String name,
    TokenColor tokenColor,
    int balance,
    int position,
    bool inJail,
    int jailTurns,
    List<int> propertyIndexes,
    bool isBankrupt,
    bool isAi,
    AiProfile? aiProfile,
    int getOutOfJailCards,
  });
}

/// @nodoc
class _$PlayerCopyWithImpl<$Res, $Val extends Player>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? tokenColor = null,
    Object? balance = null,
    Object? position = null,
    Object? inJail = null,
    Object? jailTurns = null,
    Object? propertyIndexes = null,
    Object? isBankrupt = null,
    Object? isAi = null,
    Object? aiProfile = freezed,
    Object? getOutOfJailCards = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            tokenColor: null == tokenColor
                ? _value.tokenColor
                : tokenColor // ignore: cast_nullable_to_non_nullable
                      as TokenColor,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as int,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            inJail: null == inJail
                ? _value.inJail
                : inJail // ignore: cast_nullable_to_non_nullable
                      as bool,
            jailTurns: null == jailTurns
                ? _value.jailTurns
                : jailTurns // ignore: cast_nullable_to_non_nullable
                      as int,
            propertyIndexes: null == propertyIndexes
                ? _value.propertyIndexes
                : propertyIndexes // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            isBankrupt: null == isBankrupt
                ? _value.isBankrupt
                : isBankrupt // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAi: null == isAi
                ? _value.isAi
                : isAi // ignore: cast_nullable_to_non_nullable
                      as bool,
            aiProfile: freezed == aiProfile
                ? _value.aiProfile
                : aiProfile // ignore: cast_nullable_to_non_nullable
                      as AiProfile?,
            getOutOfJailCards: null == getOutOfJailCards
                ? _value.getOutOfJailCards
                : getOutOfJailCards // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerImplCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$$PlayerImplCopyWith(
    _$PlayerImpl value,
    $Res Function(_$PlayerImpl) then,
  ) = __$$PlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    TokenColor tokenColor,
    int balance,
    int position,
    bool inJail,
    int jailTurns,
    List<int> propertyIndexes,
    bool isBankrupt,
    bool isAi,
    AiProfile? aiProfile,
    int getOutOfJailCards,
  });
}

/// @nodoc
class __$$PlayerImplCopyWithImpl<$Res>
    extends _$PlayerCopyWithImpl<$Res, _$PlayerImpl>
    implements _$$PlayerImplCopyWith<$Res> {
  __$$PlayerImplCopyWithImpl(
    _$PlayerImpl _value,
    $Res Function(_$PlayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? tokenColor = null,
    Object? balance = null,
    Object? position = null,
    Object? inJail = null,
    Object? jailTurns = null,
    Object? propertyIndexes = null,
    Object? isBankrupt = null,
    Object? isAi = null,
    Object? aiProfile = freezed,
    Object? getOutOfJailCards = null,
  }) {
    return _then(
      _$PlayerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        tokenColor: null == tokenColor
            ? _value.tokenColor
            : tokenColor // ignore: cast_nullable_to_non_nullable
                  as TokenColor,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as int,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        inJail: null == inJail
            ? _value.inJail
            : inJail // ignore: cast_nullable_to_non_nullable
                  as bool,
        jailTurns: null == jailTurns
            ? _value.jailTurns
            : jailTurns // ignore: cast_nullable_to_non_nullable
                  as int,
        propertyIndexes: null == propertyIndexes
            ? _value._propertyIndexes
            : propertyIndexes // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        isBankrupt: null == isBankrupt
            ? _value.isBankrupt
            : isBankrupt // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAi: null == isAi
            ? _value.isAi
            : isAi // ignore: cast_nullable_to_non_nullable
                  as bool,
        aiProfile: freezed == aiProfile
            ? _value.aiProfile
            : aiProfile // ignore: cast_nullable_to_non_nullable
                  as AiProfile?,
        getOutOfJailCards: null == getOutOfJailCards
            ? _value.getOutOfJailCards
            : getOutOfJailCards // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerImpl extends _Player {
  const _$PlayerImpl({
    required this.id,
    required this.name,
    required this.tokenColor,
    this.balance = 1500,
    this.position = 0,
    this.inJail = false,
    this.jailTurns = 0,
    final List<int> propertyIndexes = const [],
    this.isBankrupt = false,
    this.isAi = false,
    this.aiProfile,
    this.getOutOfJailCards = 0,
  }) : _propertyIndexes = propertyIndexes,
       super._();

  factory _$PlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final TokenColor tokenColor;
  @override
  @JsonKey()
  final int balance;
  @override
  @JsonKey()
  final int position;
  @override
  @JsonKey()
  final bool inJail;
  @override
  @JsonKey()
  final int jailTurns;
  final List<int> _propertyIndexes;
  @override
  @JsonKey()
  List<int> get propertyIndexes {
    if (_propertyIndexes is EqualUnmodifiableListView) return _propertyIndexes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_propertyIndexes);
  }

  @override
  @JsonKey()
  final bool isBankrupt;
  @override
  @JsonKey()
  final bool isAi;
  @override
  final AiProfile? aiProfile;
  @override
  @JsonKey()
  final int getOutOfJailCards;

  @override
  String toString() {
    return 'Player(id: $id, name: $name, tokenColor: $tokenColor, balance: $balance, position: $position, inJail: $inJail, jailTurns: $jailTurns, propertyIndexes: $propertyIndexes, isBankrupt: $isBankrupt, isAi: $isAi, aiProfile: $aiProfile, getOutOfJailCards: $getOutOfJailCards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.tokenColor, tokenColor) ||
                other.tokenColor == tokenColor) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.inJail, inJail) || other.inJail == inJail) &&
            (identical(other.jailTurns, jailTurns) ||
                other.jailTurns == jailTurns) &&
            const DeepCollectionEquality().equals(
              other._propertyIndexes,
              _propertyIndexes,
            ) &&
            (identical(other.isBankrupt, isBankrupt) ||
                other.isBankrupt == isBankrupt) &&
            (identical(other.isAi, isAi) || other.isAi == isAi) &&
            (identical(other.aiProfile, aiProfile) ||
                other.aiProfile == aiProfile) &&
            (identical(other.getOutOfJailCards, getOutOfJailCards) ||
                other.getOutOfJailCards == getOutOfJailCards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    tokenColor,
    balance,
    position,
    inJail,
    jailTurns,
    const DeepCollectionEquality().hash(_propertyIndexes),
    isBankrupt,
    isAi,
    aiProfile,
    getOutOfJailCards,
  );

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      __$$PlayerImplCopyWithImpl<_$PlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerImplToJson(this);
  }
}

abstract class _Player extends Player {
  const factory _Player({
    required final String id,
    required final String name,
    required final TokenColor tokenColor,
    final int balance,
    final int position,
    final bool inJail,
    final int jailTurns,
    final List<int> propertyIndexes,
    final bool isBankrupt,
    final bool isAi,
    final AiProfile? aiProfile,
    final int getOutOfJailCards,
  }) = _$PlayerImpl;
  const _Player._() : super._();

  factory _Player.fromJson(Map<String, dynamic> json) = _$PlayerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  TokenColor get tokenColor;
  @override
  int get balance;
  @override
  int get position;
  @override
  bool get inJail;
  @override
  int get jailTurns;
  @override
  List<int> get propertyIndexes;
  @override
  bool get isBankrupt;
  @override
  bool get isAi;
  @override
  AiProfile? get aiProfile;
  @override
  int get getOutOfJailCards;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
