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
  final Function(T item, bool add)? itemMultiSelectOnChange;
  final Function(bool add)? multiSelectOnChange;
  final double actionsMobileBreakpoint;
  final double minActionsWidth;
  final double headerHeight;
  final Color headerBackgroundColor;
  final String actionsLabelText;
  final IconData actionsIcon;

  const TableSection({
    required this.items,
    required this.columns,
    required this.actionsMobileBreakpoint,
    required this.minActionsWidth,
    required this.headerHeight,
    required this.headerBackgroundColor,
    required this.actionsLabelText,
    required this.actionsIcon,
    required this.itemsSelected,
    super.key,
    this.textStyle,
    this.onShow,
    this.onEdit,
    this.onDelete,
    this.addtionalActions = const [],
    this.enableMultiSelect = false,
    this.itemMultiSelectOnChange,
    this.multiSelectOnChange,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    final decoration = BoxDecoration(
      border: Border.all(
        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.7),
        width: 0.1,
      ),
    );
    final padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 12);
    final itemHeight = 60.0;

    final selectWdith = 60.0;
    final actionsWidth = _getActionsWidth(isActionsMobileActive: size.width <= actionsMobileBreakpoint);
    debugPrint("Items Selected: ${itemsSelected.length} - if all selected (${itemsSelected.length == items.length})");

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
          decoration: decoration.copyWith(color: headerBackgroundColor),
          selectWdith: selectWdith,
          textStyle: textStyle?.copyWith(
            fontWeight: FontWeight.bold,
            color: validateColor(color: headerBackgroundColor),
          ),
          columns: columns,
          actionsWidth: actionsWidth,
          itemHeight: itemHeight,
          isSelected: itemsSelected.length == items.length,
          headerHeight: headerHeight,
          headerBackgroundColor: headerBackgroundColor,
          actionsLabelText: actionsLabelText,
          actionsIcon: actionsIcon,
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
            actionsMobileBreakpoint: actionsMobileBreakpoint,
          ),
        ),
      ],
    );
  }

  double _getActionsWidth({required bool isActionsMobileActive}) {
    const double actionWidth = 50;
    double width = 0.0;

    if (isActionsMobileActive) {
      if (onShow != null || onEdit != null || onDelete != null) {
        width += actionWidth;
      }
      if (addtionalActions.isNotEmpty) {
        width += addtionalActions.length * actionWidth;
      }
    } else {
      if (onShow != null) width += actionWidth;
      if (onEdit != null) width += actionWidth;
      if (onDelete != null) width += actionWidth;
      if (addtionalActions.isNotEmpty) {
        width += addtionalActions.length * actionWidth;
      }
    }

    if (width < minActionsWidth) {
      width = minActionsWidth;
    }

    return width;
  }
}
