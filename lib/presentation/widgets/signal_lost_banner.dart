import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/cyber_theme.dart';
import '../../logic/game_controller.dart';
import '../../logic/network/online_session.dart';

/// Cyberpunk overlay while an operative's presence grace timer is running.
class SignalLostBanner extends ConsumerStatefulWidget {
  const SignalLostBanner({super.key});

  @override
  ConsumerState<SignalLostBanner> createState() => _SignalLostBannerState();
}

class _SignalLostBannerState extends ConsumerState<SignalLostBanner> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  int _secondsLeft(int? deadlineMs) {
    if (deadlineMs == null) return disconnectAiGrace.inSeconds;
    final left =
        ((deadlineMs - DateTime.now().millisecondsSinceEpoch) / 1000).ceil();
    return left.clamp(0, disconnectAiGrace.inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    if (!state.isWaitingForReconnection) return const SizedBox.shrink();

    final name = (state.disconnectedPlayerName ?? 'OPERATIVE').toUpperCase();
    final secs = _secondsLeft(state.reconnectDeadlineMs);

    return Positioned(
      left: 12,
      right: 12,
      top: 12,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CyberColors.voidBlack.withValues(alpha: 0.92),
            border: Border.all(color: CyberColors.neonMagenta, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: CyberColors.neonMagenta.withValues(alpha: 0.45),
                blurRadius: 16,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              '[SIGNAL LOST: RECONNECTING $name... ($secs сек)]',
              textAlign: TextAlign.center,
              style: GoogleFonts.shareTechMono(
                color: CyberColors.neonMagenta,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                height: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
