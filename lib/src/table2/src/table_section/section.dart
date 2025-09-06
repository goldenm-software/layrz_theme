part of '../../new_table.dart';

class TableSection<T> extends StatelessWidget {
  final List<T> items;
  final List<ThemedColumn2<T>> columns;
  final TextStyle? textStyle;

  final Future<void> Function(BuildContext, T)? onShow;
  final Future<void> Function(BuildContext, T)? onEdit;
  final Future<void> Function(BuildContext, T)? onDelete;
  final List<ThemedActionButton> addtionalActions;
  final bool enableMultiSelect;
  final List<T> itemsSelected;
  final Function({T? item, required bool add})? itemMultiSelectOnChange;
  final Function(bool add)? multiSelectOnChange;

  const TableSection({
    required this.items,
    required this.columns,
    super.key,
    this.textStyle,
    this.onShow,
    this.onEdit,
    this.onDelete,
    this.addtionalActions = const [],
    this.enableMultiSelect = false,
    this.itemsSelected = const [],
    this.itemMultiSelectOnChange,
    this.multiSelectOnChange,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final decoration = BoxDecoration(
      border: Border.all(
        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.7),
        width: 0.1,
      ),
    );
    final padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 12);
    final itemHeight = 60.0;

    final selectWdith = 60.0;
    final actionsWidth = 160.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        HeaderTableSection(
          enableMultiSelect: enableMultiSelect,
          multiSelectOnChange: multiSelectOnChange,
          itemsSelected: itemsSelected,
          items: items,
          padding: padding,
          decoration: decoration,
          selectWdith: selectWdith,
          textStyle: textStyle,
          columns: columns,
          actionsWidth: actionsWidth,
        ),

        // Columns content
        Expanded(
          child: ContentTableSection(
            enableMultiSelect: enableMultiSelect,
            selectWdith: selectWdith,
            items: items,
            itemHeight: itemHeight,
            itemsSelected: itemsSelected,
            itemMultiSelectOnChange: itemMultiSelectOnChange,
            columns: columns,
            textStyle: textStyle,
            padding: padding,
            decoration: decoration,
            actionsWidth: actionsWidth,
            addtionalActions: addtionalActions,
            onShow: onShow,
            onEdit: onEdit,
            onDelete: onDelete,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}
