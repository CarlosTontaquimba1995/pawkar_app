import 'package:flutter/material.dart';

// Custom theme extensions
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color success;
  final Color warning;
  final Color info;
  final Color error;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color textDisabled;
  final Color backgroundLight;
  final Color backgroundDark;
  final Color surfaceVariant;
  final Color surfaceContainer;
  final double borderRadiusSmall;
  final double borderRadiusMedium;
  final double borderRadiusLarge;

  const AppThemeExtension({
    required this.success,
    required this.warning,
    required this.info,
    required this.error,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textDisabled,
    required this.backgroundLight,
    required this.backgroundDark,
    required this.surfaceVariant,
    required this.surfaceContainer,
    required this.borderRadiusSmall,
    required this.borderRadiusMedium,
    required this.borderRadiusLarge,
  });

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? error,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? textDisabled,
    Color? backgroundLight,
    Color? backgroundDark,
    Color? surfaceVariant,
    Color? surfaceContainer,
    double? borderRadiusSmall,
    double? borderRadiusMedium,
    double? borderRadiusLarge,
  }) {
    return AppThemeExtension(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      error: error ?? this.error,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      textDisabled: textDisabled ?? this.textDisabled,
      backgroundLight: backgroundLight ?? this.backgroundLight,
      backgroundDark: backgroundDark ?? this.backgroundDark,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      borderRadiusSmall: borderRadiusSmall ?? this.borderRadiusSmall,
      borderRadiusMedium: borderRadiusMedium ?? this.borderRadiusMedium,
      borderRadiusLarge: borderRadiusLarge ?? this.borderRadiusLarge,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }

    double _lerpDouble(num a, num b, double t) => a + (b - a) * t;

    return AppThemeExtension(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      info: Color.lerp(info, other.info, t) ?? info,
      error: Color.lerp(error, other.error, t) ?? error,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textHint: Color.lerp(textHint, other.textHint, t) ?? textHint,
      textDisabled:
          Color.lerp(textDisabled, other.textDisabled, t) ?? textDisabled,
      backgroundLight:
          Color.lerp(backgroundLight, other.backgroundLight, t) ??
          backgroundLight,
      backgroundDark:
          Color.lerp(backgroundDark, other.backgroundDark, t) ?? backgroundDark,
      surfaceVariant:
          Color.lerp(surfaceVariant, other.surfaceVariant, t) ?? surfaceVariant,
      surfaceContainer:
          Color.lerp(surfaceContainer, other.surfaceContainer, t) ??
          surfaceContainer,
      borderRadiusSmall: _lerpDouble(
        borderRadiusSmall,
        other.borderRadiusSmall,
        t,
      ),
      borderRadiusMedium: _lerpDouble(
        borderRadiusMedium,
        other.borderRadiusMedium,
        t,
      ),
      borderRadiusLarge: _lerpDouble(
        borderRadiusLarge,
        other.borderRadiusLarge,
        t,
      ),
    );
  }

  // Light theme extension
  static final light = AppThemeExtension(
    success: const Color(0xFF4CAF50),
    warning: const Color(0xFFFFC107),
    info: const Color(0xFF2196F3),
    error: const Color(0xFFF44336),
    textPrimary: const Color(0xFF1A1A1A),
    textSecondary: const Color(0xFF666666),
    textHint: const Color(0x99000000),
    textDisabled: const Color(0xFFBDBDBD),
    backgroundLight: Colors.white,
    backgroundDark: const Color(0xFFF5F5F5),
    surfaceVariant: const Color(0xFFEEEEEE),
    surfaceContainer: Colors.white,
    borderRadiusSmall: 8.0,
    borderRadiusMedium: 12.0,
    borderRadiusLarge: 16.0,
  );

  // Dark theme extension
  static final dark = AppThemeExtension(
    success: const Color(0xFF66BB6A),
    warning: const Color(0xFFFFD54F),
    info: const Color(0xFF64B5F6),
    error: const Color(0xFFE57373),
    textPrimary: Colors.white,
    textSecondary: const Color(0xFFB0BEC5),
    textHint: const Color(0x99FFFFFF),
    textDisabled: const Color(0xFF616161),
    backgroundLight: const Color(0xFF1E1E1E),
    backgroundDark: const Color(0xFF121212),
    surfaceVariant: const Color(0xFF2D2D2D),
    surfaceContainer: const Color(0xFF252525),
    borderRadiusSmall: 8.0,
    borderRadiusMedium: 12.0,
    borderRadiusLarge: 16.0,
  );
}

// Extension method to easily access the theme extensions
extension ThemeDataExtension on ThemeData {
  AppThemeExtension get appThemeExtension =>
      extension<AppThemeExtension>() ?? AppThemeExtension.light;
}

// Extension method to easily access the theme extensions from BuildContext
extension AppThemeExtensionX on BuildContext {
  AppThemeExtension get appTheme => Theme.of(this).appThemeExtension;

  // Convenience getters for colors
  Color get successColor => appTheme.success;
  Color get warningColor => appTheme.warning;
  Color get infoColor => appTheme.info;
  Color get errorColor => appTheme.error;
  Color get textPrimaryColor => appTheme.textPrimary;
  Color get textSecondaryColor => appTheme.textSecondary;
  Color get textHintColor => appTheme.textHint;
  Color get textDisabledColor => appTheme.textDisabled;

  // Convenience getters for border radius
  double get smallRadius => appTheme.borderRadiusSmall;
  double get mediumRadius => appTheme.borderRadiusMedium;
  double get largeRadius => appTheme.borderRadiusLarge;

  // Convenience getters for spacing
  double get smallSpacing => 8.0;
  double get mediumSpacing => 16.0;
  double get largeSpacing => 24.0;

  // Convenience getters for elevation
  double get lowElevation => 1.0;
  double get mediumElevation => 4.0;
  double get highElevation => 8.0;

  // Convenience getter for animations
  Duration get shortAnimationDuration => const Duration(milliseconds: 200);
  Duration get mediumAnimationDuration => const Duration(milliseconds: 350);
  Duration get longAnimationDuration => const Duration(milliseconds: 500);
}
