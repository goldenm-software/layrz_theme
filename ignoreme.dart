// This file is for store unused code temporarily.
// Should be empty before a deployment

/*
Expanded(
  child: Scrollbar(
    controller: _horizontalScroll,
    trackVisibility: !isMobile,
    thumbVisibility: !isMobile,
    child: Scrollbar(
      controller: _verticalScroll,
      notificationPredicate: (notif) => notif.depth == 1,
      thumbVisibility: false,
      trackVisibility: false,
      child: SingleChildScrollView(
        controller: _horizontalScroll,
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (multiSelectionEnabled) ...[
                  _drawColumn(
                    index: -3,
                    column: ThemedColumn(
                      labelText: '',
                      valueBuilder: (context, item) => '',
                      isSortable: false,
                    ),
                    content: ThemedAnimatedCheckbox(
                      value: _isAllSelected,
                      onChanged: (value) {
                        if (value) {
                          _selectedItems = List.from(_items);
                        } else {
                          _selectedItems = [];
                        }

                        _validateSelection();
                      },
                    ),
                    sizes: sizes,
                  ),
                ],
                if (widget.idEnabled) ...[
                  _drawColumn(
                    index: _idIndex,
                    column: ThemedColumn(
                      labelText: widget.idLabel,
                      valueBuilder: (context, item) => '',
                    ),
                    sizes: sizes,
                  ),
                ],
                ...widget.columns.asMap().entries.map((entry) {
                  int index = entry.key;
                  ThemedColumn<T> column = entry.value;
                  return _drawColumn(
                    index: index,
                    column: column,
                    sizes: sizes,
                  );
                }),
                if (actionsEnabled) ...[
                  _drawColumn(
                    index: -1,
                    content: Icon(MdiIcons.toolbox, size: 20),
                    column: ThemedColumn(
                      labelText: 'Actions',
                      alignment: Alignment.centerRight,
                      valueBuilder: (context, item) => '',
                      isSortable: false,
                    ),
                    sizes: sizes,
                  ),
                ],
              ],
            ),
            Expanded(
              child: Container(
                key: _tableKey,
                child: SingleChildScrollView(
                  controller: _verticalScroll,
                  child: Column(
                    children: [
                      ...items.map((item) {
                        bool isSelected = _selectedItems.contains(item);

                        return SizedBox(
                          height: widget.rowHeight,
                          child: Row(
                            children: [
                              if (multiSelectionEnabled) ...[
                                _drawCell(
                                  index: -3,
                                  child: ThemedAnimatedCheckbox(
                                    value: isSelected,
                                    onChanged: (value) {
                                      if (value) {
                                        _selectedItems.add(item);
                                      } else {
                                        _selectedItems.remove(item);
                                      }

                                      _validateSelection();
                                    },
                                  ),
                                  sizes: sizes,
                                ),
                              ],
                              if (widget.idEnabled) ...[
                                _drawCell(
                                  index: _idIndex,
                                  value: "#${widget.idBuilder(context, item)}",
                                  sizes: sizes,
                                  onTap: widget.onIdTap == null ? null : () => widget.onIdTap?.call(item),
                                ),
                              ],
                              ...widget.columns.asMap().entries.map((entry) {
                                int index = entry.key;
                                ThemedColumn<T> column = entry.value;
                                return _drawCell(
                                  index: index,
                                  child: column.widgetBuilder?.call(context, item),
                                  value: column.valueBuilder(context, item),
                                  sizes: sizes,
                                  onTap: column.onTap == null ? null : () => column.onTap?.call(item),
                                  cellColor: column.cellColor?.call(item),
                                  cellTextColor: column.cellTextColor?.call(item),
                                );
                              }),
                              if (actionsEnabled) ...[
                                _drawCell(
                                  index: -1,
                                  alignment: Alignment.centerRight,
                                  child: ThemedActionsButtons(
                                    actionsLabel: t('helpers.actions'),
                                    actionPadding: _actionsPadding,
                                    actions: [
                                      ...widget.additionalActions?.call(context, item) ?? [],
                                      if (widget.onShow != null)
                                        ThemedActionButton.show(
                                          isMobile: true,
                                          tooltipPosition: ThemedTooltipPosition.left,
                                          labelText: t('helpers.buttons.show'),
                                          isLoading: widget.isLoading,
                                          isCooldown: widget.isCooldown,
                                          onCooldownFinish: widget.onCooldown,
                                          onTap: () => widget.onShow?.call(context, item),
                                        ),
                                      if (widget.onEdit != null && widget.canEdit.call(context, item))
                                        ThemedActionButton.edit(
                                          isMobile: true,
                                          tooltipPosition: ThemedTooltipPosition.left,
                                          labelText: t('helpers.buttons.edit'),
                                          isLoading: widget.isLoading,
                                          isCooldown: widget.isCooldown,
                                          onCooldownFinish: widget.onCooldown,
                                          onTap: () => widget.onEdit?.call(context, item),
                                        ),
                                      if (widget.onDelete != null && widget.canDelete.call(context, item))
                                        ThemedActionButton.delete(
                                          isMobile: true,
                                          tooltipPosition: ThemedTooltipPosition.left,
                                          labelText: t('helpers.buttons.delete'),
                                          isLoading: widget.isLoading,
                                          isCooldown: widget.isCooldown,
                                          onCooldownFinish: widget.onCooldown,
                                          onTap: () async {
                                            bool confirmation = await deleteConfirmationDialog(
                                              context: context,
                                              isCooldown: widget.isCooldown,
                                              isLoading: widget.isLoading,
                                              onCooldown: widget.onCooldown,
                                            );
                                            if (confirmation) {
                                              if (context.mounted) widget.onDelete?.call(context, item);
                                            }
                                          },
                                        ),
                                    ],
                                  ),
                                  sizes: sizes,
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),

/// [_drawCell] draws a cell of the table.
Widget _drawCell({
  required int index,
  Widget? child,
  required Map<int, double> sizes,
  String? value,
  Alignment alignment = Alignment.centerLeft,
  VoidCallback? onTap,
  Color? cellColor,
  Color? cellTextColor,
}) {
  double width = sizes[index] ?? 50;

  BorderSide borderLeft = border;

  if (index == -3) {
    borderLeft = BorderSide.none;
  }

  if (sizes[-3] == 0 && index == _idIndex) {
    borderLeft = BorderSide.none;
  } else if (sizes[-3] == 0 && index == 0 && !widget.idEnabled) {
    borderLeft = BorderSide.none;
  }

  cellColor = cellColor ?? Theme.of(context).scaffoldBackgroundColor;

  return Container(
    decoration: BoxDecoration(
      color: cellColor,
      border: Border(bottom: border, left: borderLeft),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: widget.rowHeight,
          padding: ThemedColumn.padding,
          alignment: alignment,
          child: child ??
              Text(
                value ?? '',
                style: _rowStyle?.copyWith(
                  color: cellTextColor ?? validateColor(color: cellColor),
                ),
              ),
        ),
      ),
    ),
  );
}

/// [_drawColumn] draws a column of the table.
  /// If the index is -3, will not draw the border left
  Widget _drawColumn({
    required int index,
    required ThemedColumn<T> column,
    required Map<int, double> sizes,
    Widget? content,
    String? label,
  }) {
    Widget header = content ??
        Text(
          label ?? column.labelText ?? '',
          style: _headerStyle,
        );

    double width = sizes[index] ?? 50;

    BorderSide borderLeft = border;

    if (index == -3) {
      borderLeft = BorderSide.none;
    }

    if (sizes[-3] == 0 && index == _idIndex) {
      borderLeft = BorderSide.none;
    } else if (sizes[-3] == 0 && index == 0 && !widget.idEnabled) {
      borderLeft = BorderSide.none;
    }

    Widget itm = Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: border.color,
            width: 3,
          ),
          left: borderLeft,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: column.isSortable
              ? () {
                  if (_sortBy == index) {
                    _sortAsc = !_sortAsc;
                  } else {
                    _sortBy = index;
                    _sortAsc = true;
                  }
                  _sort();
                }
              : null,
          child: Container(
            width: width,
            height: widget.rowHeight,
            alignment: column.alignment,
            padding: ThemedColumn.padding,
            child: Row(
              mainAxisAlignment: index == -1 ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (_sortBy == index) ...[
                  Icon(
                    _sortAsc ? MdiIcons.sortAscending : MdiIcons.sortDescending,
                    size: ThemedColumn.sortIconSize,
                  ),
                  const SizedBox(width: 5),
                ],
                header,
              ],
            ),
          ),
        ),
      ),
    );

    return itm;
  }
*/