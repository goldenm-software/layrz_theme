part of '../new_table.dart';

class ThemedColumn2<T> {
  final String headerText;
  @Deprecated("")
  final String Function(T item) valueBuilder;
  @Deprecated("")
  final Widget Function(T item)? widgetBuilder;
  final InlineSpan Function(T item)? richTextBuilder;
  final Alignment alignment;
  final bool isSortable;
  final double? fixWidth;
  double minWidth;
  final bool wantMinWidth;
  final CellTap<T>? onTap;

  ThemedColumn2({
    required this.headerText,
    required this.valueBuilder,
    this.richTextBuilder,
    this.widgetBuilder,
    this.alignment = Alignment.centerLeft,
    this.isSortable = true,
    this.fixWidth,
    this.minWidth = 100,
    this.wantMinWidth = false,
    this.onTap,
  });
}
