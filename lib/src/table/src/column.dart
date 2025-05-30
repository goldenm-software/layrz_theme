part of '../table.dart';

/// [ValueBuilder<T>] defines the value to display in a column.
typedef ValueBuilder<T> = String Function(BuildContext context, T item);

/// [WidgetBuilder<T>] defines the widget to display in a column.
typedef WidgetBuilder<T> = Widget Function(BuildContext context, T item);

/// [CellTap<T>] defines the action when the cell is tapped.
typedef CellTap<T> = void Function(T item);

/// [CellColor<T>] defines the color of the cell.
typedef CellColor<T> = Color? Function(T item);

class ThemedColumn<T> {
  /// The label of the column.
  final Widget? label;

  /// The label text of the column.
  /// Works similar as [label] but it is used when you want to display a [Text] widget.
  final String? labelText;

  /// Whether the column is sortable or not. By default it is [true].
  final bool isSortable;

  /// The alignment of the column. By default it is [Alignment.centerLeft].
  final Alignment alignment;

  /// The widget builder of the column. This is used to display a custom widget in the column.
  /// When this property is null, will be displayed the value of the column as [Text] widget.
  final WidgetBuilder<T>? widgetBuilder;

  /// The value builder of the column. This is used to display the value of the column.
  /// Also, this property is used to search the value of the column.
  final ValueBuilder<T> valueBuilder;

  /// Compare function for custom sorting of the column.
  /// If this function is not null it will be used to sort the column.
  /// If this function is null, the column will be sorted with the default method.
  /// acceptable return values:
  /// -1: a < b
  /// 0: a == b
  /// 1: a > b
  final int Function(T a, T b)? customSortingFunction;

  /// [onTap] function of the column. This is used to define the action when the cell is tapped.
  /// This only will work in desktop mode.
  final CellTap<T>? onTap;

  /// [width] is the width of the column. Only will be used if [widgetBuilder] is not null and/or [label] is not null.
  /// This property is used to calculate the width of the column.
  final double width;

  /// [color] overrides the color of the column header.
  final Color? color;

  /// [textColor] overrides the text color of the column header.
  final Color? textColor;

  /// [cellColor] overrides the color of the cell.
  final CellColor<T>? cellColor;

  /// [cellTextColor] overrides the text color of the cell.
  final CellColor<T>? cellTextColor;

  /// [richTextBuilder] is the builder of the rich text of the column.
  /// Avoid using this property when you use [widgetBuilder] property.
  final List<InlineSpan> Function(BuildContext context, T item)? richTextBuilder;

  /// A column in a table. This is used to define the columns in a table and search properties.
  ThemedColumn({
    this.label,
    this.labelText,
    this.isSortable = true,
    this.alignment = Alignment.centerLeft,
    this.widgetBuilder,
    this.customSortingFunction,
    required this.valueBuilder,
    this.width = 100,
    this.onTap,
    this.color,
    this.textColor,
    this.cellColor,
    this.cellTextColor,
    this.richTextBuilder,
  }) : assert(label != null || labelText != null);

  /// [padding] is the padding of the column.
  static EdgeInsets get padding => const EdgeInsets.symmetric(horizontal: 10);

  /// [sortIconSize] is the size of the sort icon.
  static double get sortIconSize => 15;

  /// [predictedContentSize] returns the predicted size of the content of the column.
  /// This is used to calculate the width of the column.
  Size predictedContentSize(BuildContext context, T item, TextStyle? style) {
    if (widgetBuilder != null) {
      return Size(
        width + ThemedColumn.padding.horizontal + (isSortable ? ThemedColumn.sortIconSize : 0),
        0,
      );
    }

    List<InlineSpan> children = richTextBuilder?.call(context, item) ?? [];
    children = children.whereType<TextSpan>().toList();

    TextPainter painter = TextPainter(
      text: TextSpan(
        children: children.isEmpty ? null : children,
        text: children.isEmpty ? valueBuilder.call(context, item) : null,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return Size(
      painter.size.width + ThemedColumn.padding.horizontal + (isSortable ? ThemedColumn.sortIconSize : 0),
      painter.size.height,
    );
  }

  /// [predictedHeaderSize] returns the predicted size of the header of the column.
  /// This is used to calculate the width of the column.
  Size predictedHeaderSize(BuildContext context, TextStyle? style) {
    if (label != null) {
      return Size(
        width + ThemedColumn.padding.horizontal + (isSortable ? ThemedColumn.sortIconSize : 0),
        0,
      );
    }

    TextPainter painter = TextPainter(
      text: TextSpan(
        text: labelText,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return Size(
      painter.size.width + ThemedColumn.padding.horizontal + (isSortable ? ThemedColumn.sortIconSize : 0),
      painter.size.height,
    );
  }
}
