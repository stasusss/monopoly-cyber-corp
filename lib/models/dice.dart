import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dice.freezed.dart';
part 'dice.g.dart';

@freezed
abstract class DiceRoll with _$DiceRoll {
  const DiceRoll._();

  const factory DiceRoll({
    required int die1,
    required int die2,
  }) = _DiceRoll;

  factory DiceRoll.fromJson(Map<String, dynamic> json) =>
      _$DiceRollFromJson(json);

  /// Random fair roll of two six-sided dice.
  factory DiceRoll.roll([Random? random]) {
    final rng = random ?? Random();
    return DiceRoll(
      die1: rng.nextInt(6) + 1,
      die2: rng.nextInt(6) + 1,
    );
  }

  int get total => die1 + die2;

  bool get isDoubles => die1 == die2;
}
