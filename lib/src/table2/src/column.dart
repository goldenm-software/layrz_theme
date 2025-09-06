part of '../new_table.dart';

class ThemedColumn2<T> {
  final String headerText;
  final String Function(T item) value;
  final Widget Function(T item)? widgetBuilder;
  final Alignment alignment;
  final bool isSortable;
  double? width;
  double? minWidth;

  final CellTap<T>? onTap;

  ThemedColumn2({
    required this.headerText,
    required this.value,
    this.widgetBuilder,
    this.alignment = Alignment.centerLeft,
    this.isSortable = true,
    this.width,
    this.minWidth,
    this.onTap,
  });
}
