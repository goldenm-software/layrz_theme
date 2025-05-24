part of '../extensions.dart';

extension StylingExtension on BuildContext {
  /// [isDark] returns true if the current theme is dark.
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// [primaryColor] returns the primary color of the current theme.
  Color get primaryColor => Theme.of(this).primaryColor;

  /// [titleStyle] returns the title style for the scaffold.
  TextStyle? get titleStyle => Theme.of(this).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);

  /// [subtitleStyle] returns the subtitle style for the scaffold.
  TextStyle? get subtitleStyle => Theme.of(this).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);

  /// [bodyStyle] returns the body style for the scaffold.
  TextStyle? get bodyStyle => Theme.of(this).textTheme.bodyMedium;
}
