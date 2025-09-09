part of '../../new_table.dart';

class TableSection<T> extends StatefulWidget {
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
  final double? actionWidth;
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
    this.actionWidth,
  });

  @override
  State<TableSection<T>> createState() => _TableSectionState<T>();
}

class _TableSectionState<T> extends State<TableSection<T>> {
  late ScrollController headerHorizontalController;
  late ScrollController contentHorizontalController;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    headerHorizontalController = ScrollController();
    contentHorizontalController = ScrollController();

    headerHorizontalController.addListener(() => _syncScroll(headerHorizontalController));
    contentHorizontalController.addListener(() => _syncScroll(contentHorizontalController));
  }

  void _syncScroll(ScrollController source) {
    if (_isSyncing) return;
    _isSyncing = true;
    final offset = source.offset;
    if (source != headerHorizontalController && headerHorizontalController.hasClients) {
      headerHorizontalController.jumpTo(offset);
    }
    if (source != contentHorizontalController && contentHorizontalController.hasClients) {
      contentHorizontalController.jumpTo(offset);
    }
    _isSyncing = false;
  }

  @override
  void dispose() {
    headerHorizontalController.dispose();
    contentHorizontalController.dispose();
    super.dispose();
  }

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
    final actionsWidth = _getActionsWidth(isBrackPointMobileActivate: size.width <= widget.actionsMobileBreakpoint);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        HeaderTableSection(
          enableMultiSelect: widget.enableMultiSelect,
          multiSelectOnChange: widget.multiSelectOnChange,
          itemsSelected: widget.itemsSelected,
          items: widget.items,
          padding: padding,
          decoration: decoration.copyWith(color: widget.headerBackgroundColor),
          selectWdith: selectWdith,
          textStyle: widget.textStyle?.copyWith(
            fontWeight: FontWeight.bold,
            color: validateColor(color: widget.headerBackgroundColor),
          ),
          columns: widget.columns,
          actionsWidth: actionsWidth,
          itemHeight: itemHeight,
          isSelected: widget.itemsSelected.length == widget.items.length,
          headerHeight: widget.headerHeight,
          headerBackgroundColor: widget.headerBackgroundColor,
          actionsLabelText: widget.actionsLabelText,
          actionsIcon: widget.actionsIcon,
          horizontalController: headerHorizontalController,
        ),

        // Columns content
        Expanded(
          child: ContentTableSection(
            enableMultiSelect: widget.enableMultiSelect,
            selectWdith: selectWdith,
            items: widget.items,
            itemHeight: itemHeight,
            itemsSelected: widget.itemsSelected,
            itemMultiSelectOnChange: widget.itemMultiSelectOnChange,
            columns: widget.columns,
            textStyle: widget.textStyle,
            padding: padding,
            decoration: decoration,
            actionsWidth: actionsWidth,
            addtionalActions: widget.addtionalActions,
            onShow: widget.onShow,
            onEdit: widget.onEdit,
            onDelete: widget.onDelete,
            isDark: isDark,
            actionsMobileBreakpoint: widget.actionsMobileBreakpoint,
            horizontalController: contentHorizontalController,
          ),
        ),
      ],
    );
  }

  double _getActionsWidth({required bool isBrackPointMobileActivate}) {
    if (widget.actionWidth != null) {
      return widget.actionWidth!;
    }
    const double actionWidth = 50;
    double width = 0.0;

    if (isBrackPointMobileActivate) {
      if (widget.onShow != null || widget.onEdit != null || widget.onDelete != null) {
        width += actionWidth;
      }
    } else {
      if (widget.onShow != null) width += actionWidth;
      if (widget.onEdit != null) width += actionWidth;
      if (widget.onDelete != null) width += actionWidth;
      if (widget.addtionalActions.isNotEmpty) {
        width += widget.addtionalActions.length * actionWidth;
      }
    }

    if (width < widget.minActionsWidth) {
      width = widget.minActionsWidth;
    }

    return width;
  }
}
