import 'package:flutter/material.dart';
import 'animated_pressable.dart';

enum CustomButtonVariant { primary, secondary, ghost }

class CustomButton extends StatelessWidget {
  final String label;
  final Widget? leading;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;

  const CustomButton({
    super.key,
    required this.label,
    this.leading,
    this.onPressed,
    this.variant = CustomButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    switch (variant) {
      case CustomButtonVariant.secondary:
        return AnimatedPressable(
          onTap: onPressed,
          child: OutlinedButton.icon(
            onPressed: onPressed,
            icon: leading ?? const SizedBox.shrink(),
            label: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.secondary,
              side: BorderSide(color: cs.secondary.withAlpha(79)),
              minimumSize: const Size(48, 48),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );

      case CustomButtonVariant.ghost:
        return AnimatedPressable(
          onTap: onPressed,
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

      case CustomButtonVariant.primary:
        return AnimatedPressable(
          onTap: onPressed,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: leading ?? const SizedBox.shrink(),
            label: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.secondary,
              foregroundColor: cs.onSecondary,
              minimumSize: const Size(48, 48),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        );
    }
  }
}
