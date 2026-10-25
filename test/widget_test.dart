import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:monopoly/core/theme/cyber_theme.dart';
import 'package:monopoly/main.dart';

void main() {
  testWidgets('Cyber-Corp shell renders', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MonopolyApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining(CyberLore.appTitle), findsWidgets);
    expect(find.textContaining('ROLL'), findsWidgets);
  });
}
