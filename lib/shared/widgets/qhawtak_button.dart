import 'package:flutter/material.dart';
import 'package:qhawtak/core/theme/app_colors.dart';

enum QhawtakButtonVariant { primary, secondary, accent, danger }

class QhawtakButton extends StatelessWidget {
  const QhawtakButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = QhawtakButtonVariant.primary,
    this.icon,
    this.isExpanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final QhawtakButtonVariant variant;
  final IconData? icon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final Widget button = icon == null
        ? FilledButton(
            onPressed: onPressed,
            style: _style(),
            child: Text(label),
          )
        : FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 18),
            label: Text(label),
            style: _style(),
          );

    if (!isExpanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  ButtonStyle _style() {
    final ({Color background, Color foreground, BorderSide? border}) palette = switch (variant) {
      QhawtakButtonVariant.primary => (
          background: AppColors.primary,
          foreground: Colors.white,
          border: null,
        ),
      QhawtakButtonVariant.secondary => (
          background: Colors.white,
          foreground: AppColors.secondary,
          border: const BorderSide(color: AppColors.secondary),
        ),
      QhawtakButtonVariant.accent => (
          background: AppColors.accent,
          foreground: AppColors.textPrimary,
          border: null,
        ),
      QhawtakButtonVariant.danger => (
          background: AppColors.error,
          foreground: Colors.white,
          border: null,
        ),
    };

    return FilledButton.styleFrom(
      backgroundColor: palette.background,
      foregroundColor: palette.foreground,
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: palette.border ?? BorderSide.none,
      ),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }
}
