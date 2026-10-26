import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monopoly/core/constants/board_data.dart';
import 'package:monopoly/core/theme/cyber_theme.dart';
import 'package:monopoly/logic/game_controller.dart';
import 'package:monopoly/presentation/board/board_cell_widget.dart';
import 'package:monopoly/presentation/player_hud/player_hud.dart';
import 'package:monopoly/presentation/player_hud/player_strip.dart';
import 'package:monopoly/presentation/shell/game_shell_page.dart';

void main() {
  testWidgets('Cyber-Corp shell renders', (tester) async {
    final cell = BoardData.createBoard().first;

    await tester.pumpWidget(
      MaterialApp(
        theme: CyberTheme.dark,
        home: Scaffold(
          body: Column(
            children: [
              Text(CyberLore.appTitle),
              SizedBox(
                width: 72,
                height: 96,
                child: BoardCellWidget(cell: cell, ownerColor: null),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining(CyberLore.appTitle), findsOneWidget);
    expect(find.byType(BoardCellWidget), findsOneWidget);
  });

  testWidgets('shell fits phone, desktop, and short landscape', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;

    Future<void> pumpAt(Size size) async {
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameControllerProvider.overrideWith(
              (ref) => GameController(enableAi: false, autosave: false),
            ),
          ],
          child: MaterialApp(
            theme: CyberTheme.dark,
            home: const GameShellPage(),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    }

    await pumpAt(const Size(390, 844));
    expect(find.byType(PlayerStrip), findsOneWidget);
    expect(find.text('ROLL'), findsOneWidget);

    await tester.tap(find.byType(BoardCellWidget).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
    expect(find.text('SWIPE · NEIGHBOR NODES'), findsOneWidget);

    await pumpAt(const Size(1440, 900));
    expect(find.byType(PlayerHud), findsOneWidget);
    expect(find.text('END TURN'), findsOneWidget);

    await pumpAt(const Size(844, 390));
    expect(find.text('ROTATE TO PORTRAIT'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
