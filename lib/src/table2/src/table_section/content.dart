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
    super.key,
  });

  final bool enableMultiSelect;
  final double selectWdith;
  final List items;
  final double itemHeight;
  final List itemsSelected;
  final Function({required bool add, T? item})? itemMultiSelectOnChange;
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
        final contentWidth = availableHeight - widget.selectWdith - widget.actionsWidth;
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
                              onChanged: (value) => widget.itemMultiSelectOnChange?.call(
                                item: item,
                                add: value,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Content <T>
              Expanded(
                child: SizedBox(
                  height: availableHeight,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: ListView.builder(
                      itemExtent: widget.itemHeight,
                      itemCount: widget.items.length,
                      controller: contentController,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final isHovered = _hoveredRows.contains(index);

                        return MouseRegion(
                          onEnter: (_) {
                            _hoveredRows.add(index);
                            setState(() {});
                          },
                          onExit: (_) {
                            _hoveredRows.remove(index);
                            setState(() {});
                          },
                          child: SizedBox(
                            height: widget.itemHeight,
                            width: contentWidth,
                            child: Row(
                              children: [
                                ...widget.columns.map((ThemedColumn2<T> col) {
                                  final Widget cellContent = col.widgetBuilder != null
                                      ? col.widgetBuilder!(context, item)
                                      : Text(
                                          col.valueBuilder(context, item),
                                          style: widget.textStyle,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                  Widget cell = Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: col.onTap != null ? () => col.onTap!(item) : null,
                                      child: Container(
                                        alignment: col.alignment,
                                        padding: widget.padding,
                                        decoration: widget.decoration.copyWith(
                                          color: isHovered ? hoverColor : null,
                                        ),
                                        width: col.width,
                                        constraints: BoxConstraints(
                                          minWidth: col.minWidth ?? 200,
                                        ),
                                        child: cellContent,
                                      ),
                                    ),
                                  );

                                  if (col.width != null) {
                                    return cell;
                                  } else {
                                    return Expanded(child: cell);
                                  }
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Actions
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
                    return Container(
                      padding: widget.padding,
                      height: widget.itemHeight,

                      decoration: widget.decoration.copyWith(
                        color: isHovered ? hoverColor : null,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ThemedActionsButtons(
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
}
