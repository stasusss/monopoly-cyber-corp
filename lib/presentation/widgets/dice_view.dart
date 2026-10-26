import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/cyber_theme.dart';
import '../../models/dice.dart';

/// Neon dice with shake / glitch before settling on [roll].
class DiceView extends StatefulWidget {
  const DiceView({
    super.key,
    required this.roll,
    this.rolling = false,
  });

  final DiceRoll? roll;
  final bool rolling;

  @override
  State<DiceView> createState() => _DiceViewState();
}

class _DiceViewState extends State<DiceView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final _rng = math.Random();
  bool _burst = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..addStatusListener(_onStatus);
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || widget.roll == null) return;
    setState(() => _burst = true);
    Future<void>.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _burst = false);
    });
  }

  @override
  void didUpdateWidget(covariant DiceView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rolling && !oldWidget.rolling) {
      _ctrl.forward(from: 0);
    }
    if (widget.roll != oldWidget.roll && widget.roll != null) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.isAnimating ? _ctrl.value : 1.0;
        final glitch = t < 1;
        final d1 = glitch ? _rng.nextInt(6) + 1 : (widget.roll?.die1 ?? 0);
        final d2 = glitch ? _rng.nextInt(6) + 1 : (widget.roll?.die2 ?? 0);
        final shake = math.sin(t * math.pi * 8) * (1 - t) * 6;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(shake, -shake),
              child: _NeonDie(value: d1 == 0 ? null : d1, burst: _burst),
            ),
            const SizedBox(width: 12),
            Transform.translate(
              offset: Offset(-shake, shake),
              child: _NeonDie(value: d2 == 0 ? null : d2, burst: _burst),
            ),
            if (widget.roll != null && !glitch) ...[
              const SizedBox(width: 12),
              Text(
                '= ${widget.roll!.total}${widget.roll!.isDoubles ? ' ★' : ''}',
                style: GoogleFonts.shareTechMono(
                  color: CyberColors.cyberYellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _NeonDie extends StatelessWidget {
  const _NeonDie({required this.value, required this.burst});

  final int? value;
  final bool burst;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: burst
            ? CyberColors.cyberYellow.withValues(alpha: 0.35)
            : CyberColors.panel,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: CyberColors.cyberYellow,
          width: burst ? 2.4 : 1.6,
        ),
        boxShadow: burst
            ? CyberTheme.glow(CyberColors.cyberYellow, blur: 16)
            : null,
      ),
      child: Text(
        value?.toString() ?? '·',
        style: GoogleFonts.shareTechMono(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: CyberColors.cyberYellow,
        ),
      ),
    );
  }
}
