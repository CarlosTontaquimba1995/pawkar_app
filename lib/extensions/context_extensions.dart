// lib/extensions/context_extensions.dart
import 'package:flutter/material.dart';

/// A collection of useful extensions on [BuildContext] to simplify
/// accessing theme, media query, and navigation properties.
extension ContextExtensions on BuildContext {
  // MARK: - Text Styles

  /// Returns the displayLarge text style from the current theme
  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge;

  /// Returns the displayMedium text style from the current theme
  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;

  /// Returns the displaySmall text style from the current theme
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;

  /// Returns the headlineMedium text style from the current theme
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;

  /// Returns the headlineSmall text style from the current theme
  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;

  /// Returns the titleLarge text style from the current theme
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;

  /// Returns the titleMedium text style from the current theme
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;

  /// Returns the titleSmall text style from the current theme
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;

  /// Returns the bodyLarge text style from the current theme
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;

  /// Returns the bodyMedium text style from the current theme
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;

  /// Returns the bodySmall text style from the current theme
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;

  /// Returns the labelLarge text style from the current theme
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;

  /// Returns the labelMedium text style from the current theme
  TextStyle? get labelMedium => Theme.of(this).textTheme.labelMedium;

  /// Returns the labelSmall text style from the current theme
  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;

  // MARK: - Colors

  /// Returns the primary color from the current theme
  Color get primaryColor => Theme.of(this).colorScheme.primary;

  /// Returns the primary container color from the current theme
  Color get primaryVariant => Theme.of(this).colorScheme.primaryContainer;

  /// Returns the secondary color from the current theme
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;

  /// Returns the secondary container color from the current theme
  Color get secondaryVariant => Theme.of(this).colorScheme.secondaryContainer;

  /// Returns the surface color from the current theme
  Color get surface => Theme.of(this).colorScheme.surface;

  /// Returns the background color from the current theme
  Color get background => Theme.of(this).colorScheme.surface;

  /// Returns the error color from the current theme
  Color get errorColor => Theme.of(this).colorScheme.error;

  /// Returns the onPrimary color from the current theme
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  /// Returns the onSecondary color from the current theme
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;

  /// Returns the onSurface color from the current theme
  Color get onSurface => Theme.of(this).colorScheme.onSurface;

  /// Returns the onBackground color from the current theme
  Color get onBackground => Theme.of(this).colorScheme.onSurface;

  /// Returns the onError color from the current theme
  Color get onError => Theme.of(this).colorScheme.onError;

  // MARK: - Sizes

  /// Returns the width of the screen
  double get width => MediaQuery.of(this).size.width;

  /// Returns the height of the screen
  double get height => MediaQuery.of(this).size.height;

  /// Returns the top padding (status bar height)
  double get paddingTop => MediaQuery.of(this).padding.top;

  /// Returns the bottom padding (usually the system UI or keyboard)
  double get paddingBottom => MediaQuery.of(this).padding.bottom;

  /// Returns the safe area height (height - top padding - bottom padding)
  double get safeAreaHeight => height - paddingTop - paddingBottom;

  // MARK: - Navigation

  /// Pops the current route off the navigator
  void pop<T>([T? result]) => Navigator.of(this).pop<T>(result);

  /// Navigates to a new page
  Future<T?> push<T>(Widget page) =>
      Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));

  /// Replaces the current route with a new route
  Future<T?> pushReplacement<T>(Widget page) => Navigator.of(
    this,
  ).pushReplacement<T, dynamic>(MaterialPageRoute(builder: (_) => page));

  /// Pushes a route and removes all previous routes
  Future<T?> pushAndRemoveUntil<T>(Widget page) =>
      Navigator.of(this).pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
        (route) => false,
      );

  // MARK: - Dialogs

  /// Shows a styled dialog
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: child,
      ),
    );
  }

  // MARK: - Bottom Sheets

  /// Shows a styled bottom sheet
  Future<T?> showAppBottomSheet<T>(Widget child) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: child,
      ),
    );
  }
}
