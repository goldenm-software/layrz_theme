part of '../new_table.dart';

class ThemedColumn2<T> {
  final String labelText;
  final ValueBuilder<T> valueBuilder;
  final WidgetBuilder<T>? widgetBuilder;
  final Alignment alignment;
  final bool isSortable;
  double? width;
  double? minWidth;

  final CellTap<T>? onTap;

  ThemedColumn2({
    required this.labelText,
    required this.valueBuilder,
    this.widgetBuilder,
    this.alignment = Alignment.centerLeft,
    this.isSortable = true,
    this.width,
    this.minWidth,
    this.onTap,
  });
}
