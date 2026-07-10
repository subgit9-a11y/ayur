import 'package:flutter/material.dart';
import 'package:doctro/theme/ayureze_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OslerCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool showBorder;

  const OslerCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      child: Material(
        color: backgroundColor ?? AyurezeTheme.surface.withOpacity(0.82),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: showBorder
                  ? Border.all(color: Colors.white.withOpacity(0.55))
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AyurezeTheme.shadow.withOpacity(0.28),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );

    return card
        .animate()
        .fadeIn(duration: 220.ms, curve: Curves.easeOut)
        .slideY(
            begin: 0.018, end: 0, duration: 220.ms, curve: Curves.easeOutCubic);
  }
}
