import 'package:doctro/core/theme/glass_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GlassBackground extends StatelessWidget {
  final Widget child;
  final bool animate;

  const GlassBackground({
    super.key,
    required this.child,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final background = Stack(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF6FAEF),
                Color(0xFFE9F5DE),
                Color(0xFFEAF7F2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SizedBox.expand(),
        ),
        _GlowOrb(
          alignment: const Alignment(-1.15, -0.92),
          size: 240,
          color: GlassTheme.lightGreen.withOpacity(0.38),
        ),
        _GlowOrb(
          alignment: const Alignment(1.18, -0.42),
          size: 210,
          color: GlassTheme.accentTeal.withOpacity(0.16),
        ),
        _GlowOrb(
          alignment: const Alignment(0.85, 1.05),
          size: 280,
          color: GlassTheme.primaryGreen.withOpacity(0.14),
        ),
        Positioned.fill(child: child),
      ],
    );

    if (!animate) return background;

    return background.animate().fadeIn(duration: 280.ms, curve: Curves.easeOut);
  }
}

class _GlowOrb extends StatelessWidget {
  final Alignment alignment;
  final double size;
  final Color color;

  const _GlowOrb({
    required this.alignment,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withOpacity(0)],
          ),
        ),
      ),
    );
  }
}
