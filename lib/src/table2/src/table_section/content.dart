part of '../../new_table.dart';

class ContentTableSection<T> extends StatefulWidget {
  const ContentTableSection({
    required this.enableMultiSelect,
    required this.selectWdith,
    required this.items,
    required this.itemHeight,
    required this.itemsSelected,
    required this.itemMultiSelectOnChange,
    required this.columns,
    required this.textStyle,
    required this.padding,
    required this.decoration,
    required this.actionsWidth,
    required this.addtionalActions,
    required this.onShow,
    required this.onEdit,
    required this.onDelete,
    required this.isDark,
    required this.actionsMobileBreakpoint,
    required this.horizontalController,
    super.key,
  });

  final bool enableMultiSelect;
  final double selectWdith;
  final List<T> items;
  final double itemHeight;
  final List<T> itemsSelected;
  final Function(T item, bool add)? itemMultiSelectOnChange;
  final List<ThemedColumn2<T>> columns;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final BoxDecoration decoration;
  final double actionsWidth;
  final List<ThemedActionButton> addtionalActions;
  final Future<void> Function(BuildContext, T)? onShow;
  final Future<void> Function(BuildContext, T)? onEdit;
  final Future<void> Function(BuildContext, T)? onDelete;
  final bool isDark;
  final double actionsMobileBreakpoint;
  final ScrollController horizontalController;

  @override
  State<ContentTableSection<T>> createState() => _ContentTableSectionState<T>();
}

class _ContentTableSectionState<T> extends State<ContentTableSection<T>> {
  late ScrollController multiSelectController;
  late ScrollController contentController;
  late ScrollController actionsController;

  bool _isSyncing = false;
  Color get hoverColor => widget.isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1);
  final Set<int> _hoveredRows = {};

  @override
  void initState() {
    super.initState();
    multiSelectController = ScrollController();
    contentController = ScrollController();
    actionsController = ScrollController();

    multiSelectController.addListener(() => _syncScroll(multiSelectController));
    contentController.addListener(() => _syncScroll(contentController));
    actionsController.addListener(() => _syncScroll(actionsController));
  }

  void _syncScroll(ScrollController source) {
    if (_isSyncing) return;
    _isSyncing = true;
    final offset = source.offset;
    if (source != multiSelectController && multiSelectController.hasClients) {
      multiSelectController.jumpTo(offset);
    }
    if (source != contentController && contentController.hasClients) {
      contentController.jumpTo(offset);
    }
    if (source != actionsController && actionsController.hasClients) {
      actionsController.jumpTo(offset);
    }
    _isSyncing = false;
  }

  @override
  void dispose() {
    multiSelectController.dispose();
    contentController.dispose();
    actionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final double avaliableWidth = constraints.maxWidth;
        final double avaliableContentWidth = avaliableWidth - widget.selectWdith - widget.actionsWidth;

        final double totalColumnsWidth = _getTotal();
        final bool addExpanded = avaliableContentWidth > totalColumnsWidth;

        return SizedBox(
          height: availableHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Multiselect column
              if (widget.enableMultiSelect)
                SizedBox(
                  width: widget.selectWdith,
                  height: availableHeight,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: ListView.builder(
                      itemExtent: widget.itemHeight,
                      itemCount: widget.items.length,
                      controller: multiSelectController,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        bool isSelected = widget.itemsSelected.contains(item);
                        final isHovered = _hoveredRows.contains(index);
                        return Container(
                          height: widget.itemHeight,
                          padding: widget.padding,
                          decoration: widget.decoration.copyWith(
                            color: isHovered ? hoverColor : null,
                          ),
                          child: Center(
                            child: ThemedAnimatedCheckbox(
                              value: isSelected,
                              onChanged: (value) => widget.itemMultiSelectOnChange?.call(item, value),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Content <T>
              Expanded(
                child: ColumsContent<T>(
                  items: widget.items,
                  itemHeight: widget.itemHeight,
                  columns: widget.columns,
                  textStyle: widget.textStyle,
                  padding: widget.padding,
                  decoration: widget.decoration,
                  hoverColor: hoverColor,
                  hoveredRows: _hoveredRows,
                  addExpanded: addExpanded,
                  totalColumnsWidth: totalColumnsWidth,
                  contentController: contentController,
                  horizontalController: widget.horizontalController,
                  onEnter: (index) {
                    _hoveredRows.add(index);
                    setState(() {});
                  },
                  onExit: (index) {
                    _hoveredRows.remove(index);
                    setState(() {});
                  },
                ),
              ),

              // Actions
              if (widget.onShow != null ||
                  widget.onEdit != null ||
                  widget.onDelete != null ||
                  widget.addtionalActions.isNotEmpty)
                SizedBox(
                  width: widget.actionsWidth,
                  height: availableHeight,
                  child: ListView.builder(
                    itemExtent: widget.itemHeight,
                    itemCount: widget.items.length,
                    controller: actionsController,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isHovered = _hoveredRows.contains(index);
                      return SingleChildScrollView(
                        child: Container(
                          padding: widget.padding,
                          height: widget.itemHeight,

                          decoration: widget.decoration.copyWith(
                            color: isHovered ? hoverColor : null,
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ThemedActionsButtons(
                              mobileBreakpoint: widget.actionsMobileBreakpoint,
                              actions: [
                                ...widget.addtionalActions,
                                if (widget.onShow != null)
                                  ThemedActionButton.show(
                                    labelText: 'Show',
                                    isMobile: true,
                                    onTap: () => widget.onShow!(context, item),
                                  ),
                                if (widget.onEdit != null)
                                  ThemedActionButton.edit(
                                    labelText: 'Edit',
                                    isMobile: true,
                                    onTap: () => widget.onEdit!(context, item),
                                  ),
                                if (widget.onDelete != null)
                                  ThemedActionButton.delete(
                                    labelText: 'Delete',
                                    isMobile: true,
                                    onTap: () => widget.onDelete!(context, item),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  double _getTotal() {
    double number = 0;
    for (var column in widget.columns) {
      if (column.wantMinWidth) {
        number += column.minWidth;
        continue;
      }
      if (column.fixWidth != null) {
        number += column.fixWidth!;
        continue;
      }
      number += column.minWidth;
      continue;
    }
    return number;
  }
}

class ColumsContent<T> extends StatelessWidget {
  final Function(int) onEnter;
  final Function(int) onExit;
  final double itemHeight;
  final List<T> items;
  final Set<int> hoveredRows;
  final List<ThemedColumn2<T>> columns;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final BoxDecoration decoration;
  final Color hoverColor;
  final bool addExpanded;
  final double totalColumnsWidth;

  final ScrollController contentController;
  final ScrollController horizontalController;

  const ColumsContent({
    required this.onEnter,
    required this.onExit,
    required this.items,
    required this.hoveredRows,
    required this.itemHeight,
    required this.columns,
    required this.textStyle,
    required this.padding,
    required this.decoration,
    required this.hoverColor,
    required this.addExpanded,
    required this.totalColumnsWidth,
    required this.contentController,
    required this.horizontalController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget list = ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        itemExtent: itemHeight,
        itemCount: items.length,
        controller: contentController,
        itemBuilder: (context, index) {
          final item = items[index];
          final isHovered = hoveredRows.contains(index);

          return MouseRegion(
            onEnter: (_) => onEnter(index),
            onExit: (_) => onExit(index),
            child: SizedBox(
              height: itemHeight,

              child: Row(
                children: [
                  ...columns.map((ThemedColumn2<T> col) {
                    final Widget cellContent = col.widgetBuilder != null
                        ? col.widgetBuilder!(item)
                        : Text(
                            col.valueBuilder(item),
                            style: textStyle,
                            overflow: TextOverflow.ellipsis,
                          );

                    Widget cell = Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: col.onTap != null ? () => col.onTap!(item) : null,
                        child: Container(
                          alignment: col.alignment,
                          padding: padding,
                          decoration: decoration.copyWith(color: isHovered ? hoverColor : null),
                          width: col.fixWidth ?? col.minWidth,

                          child: cellContent,
                        ),
                      ),
                    );
                    if (col.fixWidth != null || col.wantMinWidth) {
                      return cell;
                    }
                    if (addExpanded) {
                      return Expanded(child: cell);
                    } else {
                      return cell;
                    }
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (!addExpanded) {
      return Scrollbar(
        thumbVisibility: true,
        interactive: true,
        controller: horizontalController,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: horizontalController,
          child: SizedBox(
            width: totalColumnsWidth,

            child: list,
          ),
        ),
      );
    }
    return list;
  }
}
