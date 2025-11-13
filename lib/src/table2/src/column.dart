part of '../table2.dart';

class ThemedColumn2<T> {
  /// [headerText] is the text displayed in the header of the column
  final String headerText;

  /// [valueBuilder] is a function that takes an item and returns the value to be displayed in the cell
  final String Function(T item) valueBuilder;

  /// [richTextBuilder] is a function that takes an item and returns a list of InlineSpan to be displayed in the cell
  final List<InlineSpan> Function(T item)? richTextBuilder;

  /// [alignment] is the alignment of the cell
  final Alignment alignment;

  /// [isSortable] determines if the column is sortable
  final bool isSortable;

  /// [width] is the fixed width of the column. If is null, the size for this column will be calculated based on the available space and
  /// number of columns, otherwise, it will be fixed to this value.
  final double? width;

  /// [onTap] is a function that takes the item and its index when the cell is tapped
  final CellTap<T>? onTap;

  /// [customSort] is a function that takes two items and returns an integer for custom sorting
  int Function(T a, T b)? customSort;

  /// [ThemedColumn2] is the new implementation of ThemedColumn with enhanced features
  ///
  /// Allows to fix a width for the column, making it non-flexible.
  ThemedColumn2({
    required this.headerText,
    required this.valueBuilder,
    this.richTextBuilder,
    this.alignment = .centerLeft,
    this.isSortable = true,
    this.width,
    this.onTap,
    this.customSort,
  });

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is ThemedColumn2 &&
          runtimeType == other.runtimeType &&
          headerText == other.headerText &&
          alignment == other.alignment &&
          isSortable == other.isSortable &&
          width == other.width;

  @override
  int get hashCode => headerText.hashCode;
}
