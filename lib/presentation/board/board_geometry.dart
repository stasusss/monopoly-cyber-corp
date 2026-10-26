import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/game_rules.dart';

/// Maps board index 0..39 to a cell rectangle inside an 11×11 slot grid.
///
/// Layout (clockwise from bottom-right GO):
/// - Bottom row right→left: 0..10
/// - Left column bottom→top: 10..20
/// - Top row left→right: 20..30
/// - Right column top→bottom: 30..0
abstract final class BoardGeometry {
  static const int gridSize = 11;

  /// Slot (col, row) for [index] in an 11×11 grid (0,0 = top-left).
  static (int col, int row) slotForIndex(int index) {
    final i = index % GameRules.boardSize;
    if (i <= 10) {
      return (10 - i, 10);
    }
    if (i <= 20) {
      return (0, 10 - (i - 10));
    }
    if (i <= 30) {
      return (i - 20, 0);
    }
    return (10, i - 30);
  }

  static bool isCorner(int index) =>
      index == 0 || index == 10 || index == 20 || index == 30;

  /// Pixel rect for a board cell given the board's outer [size].
  static Rect cellRect(Size size, int index) {
    final cellW = size.width / gridSize;
    final cellH = size.height / gridSize;
    final (col, row) = slotForIndex(index);
    return Rect.fromLTWH(col * cellW, row * cellH, cellW, cellH);
  }

  /// Center of a cell, optionally nudged for multiple tokens.
  static Offset tokenOffset({
    required Size boardSize,
    required int index,
    required int tokenSlot,
    required int tokensOnCell,
  }) {
    final rect = cellRect(boardSize, index);
    final center = rect.center;
    if (tokensOnCell <= 1) return center;

    final radius = math.min(rect.width, rect.height) * 0.22;
    final angle = (tokenSlot / tokensOnCell) * math.pi * 2;
    return center + Offset(radius * math.cos(angle), radius * math.sin(angle));
  }
}
