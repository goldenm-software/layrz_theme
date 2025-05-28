part of '../alerts.dart';

/// [ThemedAlertStyle] defines the style of the alert.
enum ThemedAlertStyle {
  /// [layrz] is the default style of the alert, uses the Layrz standard alert styling.
  layrz,

  /// [filledTonal] is a filled tonal style of the alert, uses the background color
  /// with transparency and the text will be the same color as the background.
  filledTonal,

  /// [filled] is a filled style of the alert, uses a solid fill color and no border.
  filled,

  /// [outlined] is an outlined style of the alert, with a border and no fill color.
  outlined,

  /// [filledIcon] is a outlined filled style of the alert, with a border and a solid fill color only on the icon side.
  filledIcon,
}
