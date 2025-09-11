part of '../new_table.dart';

class ThemedColumn2<T> {
  final String headerText;
  final String Function(T item) valueBuilder;
  final List<InlineSpan> Function(T item)? richTextBuilder;
  // final Widget Function(T item)? widgetBuilder;
  final Alignment alignment;
  final bool isSortable;

  final double? fixedWidth;

  final bool wantMinWidth;
  final CellTap<T>? onTap;

  ThemedColumn2({
    required this.headerText,
    required this.valueBuilder,
    this.richTextBuilder,
    // this.widgetBuilder,
    this.alignment = Alignment.centerLeft,
    this.isSortable = true,
    this.fixedWidth,
    this.wantMinWidth = false,
    this.onTap,
  });

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is ThemedColumn2 &&
          runtimeType == other.runtimeType &&
          headerText == other.headerText &&
          alignment == other.alignment &&
          isSortable == other.isSortable &&
          fixedWidth == other.fixedWidth;

  @override
  int get hashCode => headerText.hashCode ^ alignment.hashCode ^ isSortable.hashCode ^ fixedWidth.hashCode;
}
