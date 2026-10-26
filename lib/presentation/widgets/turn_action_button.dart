import 'package:flutter/material.dart';

import '../../core/theme/cyber_theme.dart';

/// Primary or outline action. While [pulse] is set and the button is enabled,
/// the neon border breathes between 45% and full opacity over 1.6 s.
class TurnActionButton extends StatefulWidget {
  const TurnActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.primary = true,
    this.pulse = false,
    this.pulseColor = CyberColors.neonCyan,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final bool primary;
  final bool pulse;
  final Color pulseColor;

  @override
  State<TurnActionButton> createState() => _TurnActionButtonState();
}

class _TurnActionButtonState extends State<TurnActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _sync();
  }

  @override
  void didUpdateWidget(covariant TurnActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final live = widget.pulse && widget.onPressed != null;
    if (live) {
      if (!_ctrl.isAnimating) _ctrl.repeat(reverse: true);
    } else {
      _ctrl.stop();
      _ctrl.value = 1;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = Icon(widget.icon, size: 18);
    final label = Text(
      widget.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final alpha = 0.45 + 0.55 * _ctrl.value;
        final style = widget.pulse && widget.onPressed != null
            ? ButtonStyle(
                side: WidgetStateProperty.all(
                  BorderSide(
                    color: widget.pulseColor.withValues(alpha: alpha),
                    width: 1.6,
                  ),
                ),
              )
            : null;

        if (widget.primary) {
          return FilledButton.icon(
            onPressed: widget.onPressed,
            style: style,
            icon: icon,
            label: label,
          );
        }
        return OutlinedButton.icon(
          onPressed: widget.onPressed,
          style: style,
          icon: icon,
          label: label,
        );
      },
    );
  }
}
