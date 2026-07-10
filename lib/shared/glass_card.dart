import 'dart:ui';
import 'package:doctro/core/theme/glass_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final bool animate;

  const GlassCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 20.0,
    this.animate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.72),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.65),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: GlassTheme.textPrimaryLight),
              child: IconTheme.merge(
                data: const IconThemeData(color: GlassTheme.textPrimaryLight),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );

    if (!animate) return card;

    return card
        .animate()
        .fadeIn(duration: 240.ms, curve: Curves.easeOut)
        .slideY(
            begin: 0.025, end: 0, duration: 240.ms, curve: Curves.easeOutCubic);
  }
}
