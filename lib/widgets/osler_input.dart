import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doctro/theme/ayureze_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OslerInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;

  const OslerInput({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AyurezeTheme.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            hintStyle: TextStyle(color: AyurezeTheme.textSecondary),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.65)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: AyurezeTheme.healingGreen100, width: 1.6),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 180.ms, curve: Curves.easeOut);
  }
}
