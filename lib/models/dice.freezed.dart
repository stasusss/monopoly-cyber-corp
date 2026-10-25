// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiceRoll _$DiceRollFromJson(Map<String, dynamic> json) {
  return _DiceRoll.fromJson(json);
}

/// @nodoc
mixin _$DiceRoll {
  int get die1 => throw _privateConstructorUsedError;
  int get die2 => throw _privateConstructorUsedError;

  /// Serializes this DiceRoll to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiceRoll
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiceRollCopyWith<DiceRoll> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiceRollCopyWith<$Res> {
  factory $DiceRollCopyWith(DiceRoll value, $Res Function(DiceRoll) then) =
      _$DiceRollCopyWithImpl<$Res, DiceRoll>;
  @useResult
  $Res call({int die1, int die2});
}

/// @nodoc
class _$DiceRollCopyWithImpl<$Res, $Val extends DiceRoll>
    implements $DiceRollCopyWith<$Res> {
  _$DiceRollCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiceRoll
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? die1 = null, Object? die2 = null}) {
    return _then(
      _value.copyWith(
            die1: null == die1
                ? _value.die1
                : die1 // ignore: cast_nullable_to_non_nullable
                      as int,
            die2: null == die2
                ? _value.die2
                : die2 // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiceRollImplCopyWith<$Res>
    implements $DiceRollCopyWith<$Res> {
  factory _$$DiceRollImplCopyWith(
    _$DiceRollImpl value,
    $Res Function(_$DiceRollImpl) then,
  ) = __$$DiceRollImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int die1, int die2});
}

/// @nodoc
class __$$DiceRollImplCopyWithImpl<$Res>
    extends _$DiceRollCopyWithImpl<$Res, _$DiceRollImpl>
    implements _$$DiceRollImplCopyWith<$Res> {
  __$$DiceRollImplCopyWithImpl(
    _$DiceRollImpl _value,
    $Res Function(_$DiceRollImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiceRoll
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? die1 = null, Object? die2 = null}) {
    return _then(
      _$DiceRollImpl(
        die1: null == die1
            ? _value.die1
            : die1 // ignore: cast_nullable_to_non_nullable
                  as int,
        die2: null == die2
            ? _value.die2
            : die2 // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiceRollImpl extends _DiceRoll {
  const _$DiceRollImpl({required this.die1, required this.die2}) : super._();

  factory _$DiceRollImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiceRollImplFromJson(json);

  @override
  final int die1;
  @override
  final int die2;

  @override
  String toString() {
    return 'DiceRoll(die1: $die1, die2: $die2)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiceRollImpl &&
            (identical(other.die1, die1) || other.die1 == die1) &&
            (identical(other.die2, die2) || other.die2 == die2));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, die1, die2);

  /// Create a copy of DiceRoll
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiceRollImplCopyWith<_$DiceRollImpl> get copyWith =>
      __$$DiceRollImplCopyWithImpl<_$DiceRollImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiceRollImplToJson(this);
  }
}

abstract class _DiceRoll extends DiceRoll {
  const factory _DiceRoll({required final int die1, required final int die2}) =
      _$DiceRollImpl;
  const _DiceRoll._() : super._();

  factory _DiceRoll.fromJson(Map<String, dynamic> json) =
      _$DiceRollImpl.fromJson;

  @override
  int get die1;
  @override
  int get die2;

  /// Create a copy of DiceRoll
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiceRollImplCopyWith<_$DiceRollImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
