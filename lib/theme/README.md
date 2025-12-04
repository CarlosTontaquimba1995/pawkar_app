App Theme Guide
----------------

This directory contains the application's central theming primitives.

- `app_theme.dart` — primary entrypoint exposing `AppTheme.light()` and `AppTheme.dark()`.
  - Provides a single `ColorScheme` for all components.
  - Exposes a typographic scale and component defaults (buttons, inputs, cards).

Usage
-----

Wrap your app with the theme returned by `AppTheme.light()` or `AppTheme.dark()` depending
on the platform brightness, for example in `main.dart`:

```dart
final brightness = WidgetsBinding.instance.window.platformBrightness;
runApp(MaterialApp(theme: AppTheme.light(), darkTheme: AppTheme.dark(), themeMode: ThemeMode.system));
```

Guidelines
----------
- Always use `Theme.of(context).colorScheme` for colors in widgets.
- Use the provided `CustomButton` and `CustomCard` components for consistent spacing, touch size and micro-interactions.
- The theme is intentionally minimalistic: prefer whitespace, larger touch targets and subtle depth.
