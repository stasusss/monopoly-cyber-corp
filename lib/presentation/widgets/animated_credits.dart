import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/game_rules.dart';
import '../../core/theme/cyber_theme.dart';

/// Monospace credit counter. On change the old value leaves upward and the
/// new one arrives from below, flashing green or magenta for 200 ms.
class AnimatedCredits extends StatefulWidget {
  const AnimatedCredits({
    super.key,
    required this.amount,
    this.style,
    this.textAlign = TextAlign.right,
  });

  final int amount;
  final TextStyle? style;
  final TextAlign textAlign;

  @override
  State<AnimatedCredits> createState() => _AnimatedCreditsState();
}

class _AnimatedCreditsState extends State<AnimatedCredits>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late int _from;
  int _delta = 0;

  @override
  void initState() {
    super.initState();
    _from = widget.amount;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedCredits oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount == widget.amount) return;
    _from = oldWidget.amount;
    _delta = widget.amount - oldWidget.amount;
    _ctrl.forward(from: 0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  TextStyle _base() {
    return widget.style ??
        GoogleFonts.shareTechMono(
          color: CyberColors.cyberYellow,
          fontWeight: FontWeight.w800,
          fontSize: 16,
          fontFeatures: const [FontFeature.tabularFigures()],
        );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.isAnimating ? _ctrl.value : 1.0;
        final flash = _delta >= 0
            ? CyberColors.terminalGreen
            : CyberColors.neonMagenta;
        final color = _ctrl.isAnimating
            ? Color.lerp(flash, CyberColors.cyberYellow, t)!
            : (widget.style?.color ?? CyberColors.cyberYellow);
        final style = _base().copyWith(color: color);
        final align = switch (widget.textAlign) {
          TextAlign.center => Alignment.center,
          TextAlign.right || TextAlign.end => Alignment.centerRight,
          _ => Alignment.centerLeft,
        };

        return ClipRect(
          child: Stack(
            alignment: align,
            children: [
              Opacity(
                opacity: 0,
                child: Text(
                  GameRules.credits(widget.amount),
                  style: style,
                  textAlign: widget.textAlign,
                ),
              ),
              Opacity(
                opacity: 0,
                child: Text(
                  GameRules.credits(_from),
                  style: style,
                  textAlign: widget.textAlign,
                ),
              ),
              if (_ctrl.isAnimating) ...[
                Transform.translate(
                  offset: Offset(0, -12 * t),
                  child: Opacity(
                    opacity: 1 - t,
                    child: Text(
                      GameRules.credits(_from),
                      style: style,
                      textAlign: widget.textAlign,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, 12 * (1 - t)),
                  child: Opacity(
                    opacity: t,
                    child: Text(
                      GameRules.credits(widget.amount),
                      style: style,
                      textAlign: widget.textAlign,
                    ),
                  ),
                ),
              ] else
                Text(
                  GameRules.credits(widget.amount),
                  style: style,
                  textAlign: widget.textAlign,
                ),
            ],
          ),
        );
      },
    );
  }
}
