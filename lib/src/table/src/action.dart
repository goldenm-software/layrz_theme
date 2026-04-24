part of '../table.dart';

@Deprecated('Use ThemedTable2 instead. ThemedTable will be removed in version 8.0.0.')
class ThemedTableAction<T> {
  /// The label of the action.
  final Widget? label;

  /// The label text of the action.
  /// Works similar as [label] but it is used when you want to display a [Text] widget.
  final String? labelText;

  /// Represents the function to call when the action is triggered.
  final bool Function(List<T>) onTap;

  /// Represents the color of the displayed button
  final Color? color;

  /// An action in a table.
  ThemedTableAction({
    this.label,
    this.labelText,
    required this.onTap,
    this.color,
  }) : assert(label != null || labelText != null);
}
