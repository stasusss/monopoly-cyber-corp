import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/constants/street_colors.dart';

part 'cell.freezed.dart';
part 'cell.g.dart';

/// Kind of non-ownable special / action cell.
enum SpecialKind {
  go,
  jail,
  freeParking,
  goToJail,
  chance,
  communityChest,
}

/// Ownable or interactive board cell (classic 40-cell layout).
@freezed
sealed class BoardCell with _$BoardCell {
  const BoardCell._();

  /// Street property belonging to a [ColorGroup].
  ///
  /// [rents] length is 6: base, 1–4 houses, hotel.
  const factory BoardCell.property({
    required int index,
    required String name,
    required ColorGroup colorGroup,
    required int price,
    required List<int> rents,
    required int mortgage,
    String? ownerId,
    @Default(0) int houses,
    @Default(false) bool isMortgaged,
  }) = PropertyCell;

  const factory BoardCell.railroad({
    required int index,
    required String name,
    required int price,
    required int mortgage,
    String? ownerId,
    @Default(false) bool isMortgaged,
  }) = RailroadCell;

  const factory BoardCell.utility({
    required int index,
    required String name,
    required int price,
    required int mortgage,
    String? ownerId,
    @Default(false) bool isMortgaged,
  }) = UtilityCell;

  const factory BoardCell.tax({
    required int index,
    required String name,
    required int amount,
  }) = TaxCell;

  const factory BoardCell.special({
    required int index,
    required String name,
    required SpecialKind kind,
  }) = SpecialCell;

  factory BoardCell.fromJson(Map<String, dynamic> json) =>
      _$BoardCellFromJson(json);

  bool get isOwnable => switch (this) {
        PropertyCell() || RailroadCell() || UtilityCell() => true,
        _ => false,
      };

  String? get ownerIdOrNull => switch (this) {
        PropertyCell(:final ownerId) => ownerId,
        RailroadCell(:final ownerId) => ownerId,
        UtilityCell(:final ownerId) => ownerId,
        _ => null,
      };

  int? get priceOrNull => switch (this) {
        PropertyCell(:final price) => price,
        RailroadCell(:final price) => price,
        UtilityCell(:final price) => price,
        _ => null,
      };

  bool get isMortgagedOrFalse => switch (this) {
        PropertyCell(:final isMortgaged) => isMortgaged,
        RailroadCell(:final isMortgaged) => isMortgaged,
        UtilityCell(:final isMortgaged) => isMortgaged,
        _ => false,
      };
}
