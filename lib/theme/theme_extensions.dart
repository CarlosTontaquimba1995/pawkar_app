// lib/theme/theme_extensions.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

@immutable
class ThemeExtensions extends ThemeExtension<ThemeExtensions> {
  final Color success;
  final Color warning;
  final Color info;
  final Color shadow;
  final Color divider;
  final Color disabled;
  final Color disabledContainer;
  final Color onDisabled;

  const ThemeExtensions({
    required this.success,
    required this.warning,
    required this.info,
    required this.shadow,
    required this.divider,
    required this.disabled,
    required this.disabledContainer,
    required this.onDisabled,
  });

  static final light = ThemeExtensions(
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
    shadow: Colors.black.withOpacity(0.1),
    divider: Colors.black12,
    disabled: Colors.black26,
    disabledContainer: Colors.grey[200]!,
    onDisabled: AppColors.lightOnSurfaceVariant,
  );

  static final dark = ThemeExtensions(
    success: const Color(0xFF81C784),
    warning: const Color(0xFFFFB74D),
    info: const Color(0xFF4FC3F7),
    shadow: Colors.black.withOpacity(0.5),
    divider: Colors.white24,
    disabled: Colors.white38,
    disabledContainer: const Color(0xFF1E1E1E),
    onDisabled: Colors.white70,
  );

  @override
  ThemeExtension<ThemeExtensions> copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? shadow,
    Color? divider,
    Color? disabled,
    Color? disabledContainer,
    Color? onDisabled,
  }) {
    return ThemeExtensions(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      shadow: shadow ?? this.shadow,
      divider: divider ?? this.divider,
      disabled: disabled ?? this.disabled,
      disabledContainer: disabledContainer ?? this.disabledContainer,
      onDisabled: onDisabled ?? this.onDisabled,
    );
  }

  @override
  ThemeExtension<ThemeExtensions> lerp(
    ThemeExtension<ThemeExtensions>? other,
    double t,
  ) {
    if (other is! ThemeExtensions) {
      return this;
    }
    return ThemeExtensions(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      disabledContainer: Color.lerp(
        disabledContainer,
        other.disabledContainer,
        t,
      )!,
      onDisabled: Color.lerp(onDisabled, other.onDisabled, t)!,
    );
  }
}
