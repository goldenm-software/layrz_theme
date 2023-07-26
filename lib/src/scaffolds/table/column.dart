part of layrz_theme;

/// [ValueBuilder<T>] defines the value to display in a column.
typedef ValueBuilder<T> = String Function(BuildContext context, T item);

/// [WidgetBuilder<T>] defines the widget to display in a column.
typedef WidgetBuilder<T> = Widget Function(BuildContext context, T item);

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

  /// A column in a table. This is used to define the columns in a table and search properties.
  ThemedColumn({
    this.label,
    this.labelText,
    this.isSortable = true,
    this.alignment = Alignment.centerLeft,
    this.widgetBuilder,
    this.customSortingFunction,
    required this.valueBuilder,
  }) : assert(label != null || labelText != null);
}
