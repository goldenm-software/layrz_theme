// This file is for store unused code temporarily.
// Should be empty before a deployment

/* return _TableSection<T>(
  items: itemsFiltered,
  itemsSelected: itemsSelected,
  columns: widget.columns,
  textStyle: textStyleDefault,
  onShow: widget.onShow,
  onEdit: widget.onEdit,
  onDelete: widget.onDelete,
  addtionalActions: widget.addtionalActions,
  enableMultiSelect: true,
  actionsMobileBreakpoint: widget.actionsMobileBreakpoint,
  minActionsWidth: minActionsWidth,
  headerHeight: widget.headerHeight,
  headerBackgroundColor: widget.headerBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
  actionsLabelText: widget.actionsLabelText,
  actionsIcon: widget.actionsIcon ?? LayrzIcons.mdiDotsVertical,
  actionWidth: widget.actionWidth,
  selectedColumn: selectedColumn,
  isReverse: isReversed,
  multiSelectOnChange: (bool isAdd) {
    if (isAdd) {
      itemsSelected = List.from(itemsFiltered);
    } else {
      itemsSelected.clear();
    }
    setState(() {});
  },
  itemMultiSelectOnChange: (item, isAdd) {
    if (isAdd) {
      itemsSelected.add(item);
    } else {
      itemsSelected.remove(item);
    }
  },
  headerOntap: (col) async {
    if (selectedColumn == col) {
      isReversed = !isReversed;
    } else {
      isReversed = false;
      selectedColumn = col;
    }
    await _sortListAsync(isReversed);
  },
); */
