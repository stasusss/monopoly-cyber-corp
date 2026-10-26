import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/l10n/app_lang.dart';
import '../../core/theme/cyber_theme.dart';

/// UA / EN toggle. The active side is the language of the whole interface.
class LangSwitch extends ConsumerWidget {
  const LangSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(appLangProvider);
    final controller = ref.read(appLangProvider.notifier);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: CyberColors.neonCyan.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _side(
            label: 'UA',
            selected: lang == AppLang.uk,
            onTap: () => controller.setLang(AppLang.uk),
          ),
          _side(
            label: 'EN',
            selected: lang == AppLang.en,
            onTap: () => controller.setLang(AppLang.en),
          ),
        ],
      ),
    );
  }

  Widget _side({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: ColoredBox(
        color: selected ? CyberColors.neonCyan : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            label,
            style: GoogleFonts.shareTechMono(
              color: selected ? CyberColors.voidBlack : CyberColors.neonCyan,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
