import 'package:flutter/material.dart';

import '../../core/theme/cyber_theme.dart';

/// Modal body that scrolls, with action buttons pinned under the scroll.
class CyberDialogFrame extends StatelessWidget {
  const CyberDialogFrame({
    super.key,
    required this.glowColor,
    required this.body,
    required this.actions,
    this.maxWidth = 400,
  });

  final Color glowColor;
  final Widget body;
  final Widget actions;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.8;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: CyberTheme.glass(
        glowColor: glowColor,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: SingleChildScrollView(child: body),
              ),
              const SizedBox(height: 14),
              actions,
            ],
          ),
        ),
      ),
    );
  }
}
