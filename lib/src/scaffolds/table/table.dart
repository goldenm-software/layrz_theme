part of layrz_theme;

bool kThemedTableCanTrue(BuildContext context, item) => true;

class ThemedTable<T> extends StatefulWidget {
  /// Represents the columns or headers of the table.
  final List<ThemedColumn<T>> columns;

  /// Is the list of items to display
  final List<T> items;

  /// [onShow] will be called when the user clicks on the show button.
  /// On mobile size, the row click also will call this function.
  /// The `show` button only will show ehen this function is not null.
  final Future<void> Function(BuildContext, T)? onShow;

  /// [onEdit] will be called when the user clicks on the edit button.
  /// The `edit` button only will show ehen this function is not null.
  final Future<void> Function(BuildContext, T)? onEdit;

  /// [onDelete] will be called when the user clicks on the delete button.
  /// The `delete` button only will show ehen this function is not null.
  final Future<void> Function(BuildContext, T)? onDelete;

  /// [onMultiDelete] will be called when the user selects multiple items and perform the option `multiDelete`.
  /// The `multiDelete` button only will show ehen this function is not null.
  ///
  final Future<bool> Function(BuildContext ctx, List<T> items)? onMultiDelete;

  /// Represents the callback when the user clicks on the add button.
  final VoidCallback? onAdd;

  /// Represents the additional buttons of the table. This buttons will be append before the [onAdd] button.
  final List<Widget> additionalButtons;

  /// Represents the additional actions generator for each row.
  /// This actions will be append before the [onShow] button inside the [ThemedActionsButtons] widget.
  final List<ThemedActionButton> Function(BuildContext, T)? additionalActions;

  /// Represents the default search value of the table.
  final String searchText;

  /// Represents the module name of the table. This is used to generate the titleText and the add button label.
  /// The format of each translation key should be:
  /// - for `titleText` => `module.title.list` and the value should be `My items ({count})`
  /// - for `addButtonLabel` => `module.title.new` and the value should be `Add new item`
  final String module;

  /// [title] represents the custom title of the table. If this property is null, the title will be generated
  /// using the [module] property.
  final Widget? title;

  /// Represents the builders of row avatar when the table is in mobile size.
  final ThemedTableAvatar Function(BuildContext, List<ThemedColumn<T>>, T) rowAvatarBuilder;

  /// Represents the builders of row title when the table is in mobile size.
  final Widget Function(BuildContext, List<ThemedColumn<T>>, T) rowTitleBuilder;

  /// Represents the builders of row subtitle when the table is in mobile size.
  final Widget Function(BuildContext, List<ThemedColumn<T>>, T) rowSubtitleBuilder;

  /// Represents the builder of the id of the item.
  final String Function(BuildContext, T) idBuilder;

  /// Represents the multiple selection is enabled
  final bool multiSelectionEnabled;

  /// Represents the additional actions to display when the multiple selection is enabled
  final List<ThemedTableAction<T>> multiSelectionActions;

  /// Represents the minimum selected items before show the dialog
  final int minSelectionsBeforeDialog;

  /// Represents the breakpoint to switch to mobile size. By default is [kSmallGrid]
  final double mobileBreakpoint;

  /// Represents the indicator of the buttons
  /// Indicates (through buttons) that the table is loading
  final bool isLoading;

  /// Indicates (through buttons) that the table is in cooldown
  final bool isCooldown;

  /// This will be called when the [ThemedButton] completes the cooldown
  final VoidCallback? onCooldown;

  /// This will be called when the user clicks on the refresh button
  final VoidCallback? onRefresh;

  /// Represents the custom translations of the table.
  /// If you cannot use Layrz Translation Engine, you can add your custom translations here.
  /// If the Layrz Translation Engine is null, the table will use this property to generate the translations,
  /// but you may see this error: `Missing translation for key: translation.key : {itemCount} : {arguments}`
  /// `{itemCount}` is the number of items in the table. Only will appear when the translation has pluralization.
  /// `{arguments}` is the representation of a `Map<String, dynamic>` arguments object.
  final Map<String, dynamic> customTranslations;

  /// Represents the callback when the user selects multiple items.
  /// This callback will be called when the user selects or deselects an item.
  final void Function(BuildContext, List<T>)? onSelectedItemsChanged;

  /// Represents the automatic dialog display of the multiple selection.
  /// If this property is true, the dialog will be displayed when the user selects more
  /// than [minSelectionsBeforeDialog] items.
  final bool enableMultiSelectDialog;

  /// [canEdit] represents the callback to check if the item can be edited.
  /// If this function returns false, the edit button will be disabled.
  /// By default, this function returns true.
  final bool Function(BuildContext, T) canEdit;

  /// [canDelete] represents the callback to check if the item can be deleted.
  /// If this function returns false, the delete button will be disabled.
  /// By default, this function returns true.
  final bool Function(BuildContext, T) canDelete;

  /// [mobileRowHeight] represents the height of the row when the table is in mobile size.
  /// By default, this value is 72.0
  final double mobileRowHeight;

  /// A standard table with a list of items, designed to be used in the scaffold.
  /// Helps to display a list of items in desktop and mobile mode without a lot of code. (I hope so)
  /// Please read the documentation of each property to understand how to use it.
  const ThemedTable({
    super.key,
    required this.columns,
    required this.items,
    this.onShow,
    this.onEdit,
    this.onDelete,
    this.onMultiDelete,
    this.additionalActions,
    this.searchText = '',
    required this.module,
    this.title,
    this.onAdd,
    this.additionalButtons = const [],
    required this.rowAvatarBuilder,
    required this.rowTitleBuilder,
    required this.rowSubtitleBuilder,
    required this.idBuilder,
    this.multiSelectionEnabled = true,
    this.multiSelectionActions = const [],
    this.minSelectionsBeforeDialog = 2,
    this.mobileBreakpoint = kSmallGrid,
    this.isLoading = false,
    this.isCooldown = false,
    this.onCooldown,
    this.onRefresh,
    this.customTranslations = const {},
    this.onSelectedItemsChanged,
    this.enableMultiSelectDialog = true,
    this.canEdit = kThemedTableCanTrue,
    this.canDelete = kThemedTableCanTrue,
    this.mobileRowHeight = 72.0,
  }) : assert(columns.length > 0);

  @override
  State<ThemedTable<T>> createState() => _ThemedTableState<T>();
}

class _ThemedTableState<T> extends State<ThemedTable<T>> with TickerProviderStateMixin {
  late AnimationController animationController;
  OverlayEntry? overlayEntry;

  String get module => widget.module;
  List<T> items = [];

  void _resyncItems() {
    items = List<T>.from(widget.items);

    if (searchText.isNotEmpty) {
      items = items.where((T item) {
        bool c1 = "#${widget.idBuilder(context, item)}".contains(searchText);
        bool c2 = false;

        for (ThemedColumn<T> column in columns) {
          String value = column.valueBuilder(context, item);
          c2 = c2 || value.toLowerCase().contains(searchText.toLowerCase());
        }
        return c1 || c2;
      }).toList();
    }

    items.sort((a, b) {
      dynamic aValue;
      dynamic bValue;

      if (sortBy == -1) {
        aValue = int.tryParse(widget.idBuilder(context, a)) ?? 0;
        bValue = int.tryParse(widget.idBuilder(context, b)) ?? 0;
      } else {
        ThemedColumn<T> column = columns[sortBy];
        aValue = column.valueBuilder(context, a);
        bValue = column.valueBuilder(context, b);
      }

      if (sortAsc) {
        return Comparable.compare(aValue, bValue);
      } else {
        return Comparable.compare(bValue, aValue);
      }
    });

    setState(() {});
  }

  List<ThemedColumn<T>> get columns => widget.columns;
  int get columnsLength => columns.length;
  double get actionsWidth {
    double length = 10;

    if (widget.onShow != null) {
      length += 50;
    }

    if (widget.onEdit != null) {
      length += 50;
    }

    if (widget.onDelete != null) {
      length += 50;
    }

    // Perform the additional actions
    if (widget.additionalActions != null) {
      int maxActions = 0;

      for (T item in items) {
        int actions = widget.additionalActions!(context, item).length;
        if (actions > maxActions) {
          maxActions = actions;
        }
      }

      length += maxActions * 50;
    }

    return length;
  }

  int get minSelectionsBeforeDialog => widget.minSelectionsBeforeDialog;
  bool get multiSelectionEnabled => widget.multiSelectionEnabled;
  double get rowSelectionWidth => multiSelectionEnabled ? 60 : 0;
  double get rowHeight => 40;

  List<T> selectedItems = [];

  BoxDecoration get decoration => BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      );

  TextStyle? get headerStyle => Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

  double get idSize => 80;

  Color get checkboxColor {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color color = Theme.of(context).primaryColor;

    if (isDark && !useBlack(color: color)) {
      color = Colors.white;
    }

    return color;
  }

  int sortBy = -1;
  bool sortAsc = true;
  String searchText = '';

  final ScrollController _scrollController = ScrollController();
  // final List<T> _visibleItems = [];

  @override
  void initState() {
    super.initState();
    searchText = widget.searchText;
    animationController = AnimationController(vsync: this, duration: kHoverDuration);
    _resyncItems();
  }

  @override
  dispose() {
    animationController.dispose();
    overlayEntry?.remove();
    overlayEntry = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(ThemedTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resyncItems();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        double tableWidth = width - 20;
        double columnWidth = (tableWidth - actionsWidth - idSize - rowSelectionWidth) / columnsLength;

        bool isMobile = width < widget.mobileBreakpoint;

        bool isDark = Theme.of(context).brightness == Brightness.dark;
        Color primaryColor = Theme.of(context).primaryColor;

        if (isDark && !useBlack(color: primaryColor)) {
          primaryColor = Colors.white;
        }

        double itemHeight = isMobile ? widget.mobileRowHeight : rowHeight;

        return Container(
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(maxWidth: width),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: widget.title ??
                        Text(
                          t('$module.title.list', {'count': items.length}),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                        ),
                  ),
                  ThemedSearchInput(
                    value: searchText,
                    labelText: t('helpers.search'),
                    onSearch: (value) {
                      setState(() => searchText = value);
                      _resyncItems();
                    },
                  ),
                  ...widget.additionalButtons,
                  if (widget.onAdd != null) ...[
                    const SizedBox(width: 5),
                    ThemedButton(
                      labelText: t('$module.title.new'),
                      icon: MdiIcons.plus,
                      style: isMobile ? ThemedButtonStyle.fab : ThemedButtonStyle.filledTonal,
                      color: primaryColor,
                      onTap: widget.onAdd,
                      isLoading: widget.isLoading,
                      isCooldown: widget.isCooldown,
                      onCooldownFinish: widget.onCooldown,
                    ),
                  ],
                  if (widget.onRefresh != null) ...[
                    const SizedBox(width: 5),
                    ThemedButton(
                      labelText: t('helpers.refersh'),
                      icon: MdiIcons.refresh,
                      style: ThemedButtonStyle.fab,
                      color: primaryColor,
                      onTap: widget.onRefresh,
                      isLoading: widget.isLoading,
                      isCooldown: widget.isCooldown,
                      onCooldownFinish: widget.onCooldown,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              if (!isMobile) ...[
                Row(
                  children: [
                    if (multiSelectionEnabled) ...[
                      drawHeader(
                        width: rowSelectionWidth,
                        canSort: false,
                        alignment: Alignment.center,
                        child: ThemedAnimatedCheckbox(
                          activeColor: checkboxColor,
                          value: selectedItems.length == items.length,
                          onChanged: (value) {
                            if (value == true) {
                              setState(() => selectedItems = items);
                            } else {
                              setState(() => selectedItems = []);
                            }

                            validateSelection();
                          },
                        ),
                      ),
                    ],
                    drawHeader(
                      width: idSize,
                      index: -1,
                      child: Text("ID", style: headerStyle),
                    ),
                    ...columns.asMap().entries.map((entry) {
                      final column = entry.value;
                      final index = entry.key;
                      return drawHeader(
                        width: columnWidth,
                        index: index,
                        child: column.label ?? Text(column.labelText ?? '', style: headerStyle),
                      );
                    }).toList(),
                    drawHeader(
                      width: actionsWidth,
                      alignment: Alignment.centerRight,
                      canSort: false,
                      isLast: true,
                      child: Text(t('helpers.actions'), style: headerStyle),
                    ),
                  ],
                ),
                const Divider(),
              ],
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => builder(
                          context,
                          index,
                          isMobile: isMobile,
                          itemHeight: itemHeight,
                          columnWidth: columnWidth,
                        ),
                        childCount: items.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? builder(
    BuildContext context,
    int index, {
    bool isMobile = false,
    required double itemHeight,
    required double columnWidth,
  }) {
    if (index >= items.length) {
      debugPrint('index >= items.length');
      return null;
    }

    final item = items[index];

    Widget actions = ThemedActionsButtons(
      actionsLabel: t('helpers.actions'),
      actions: [
        ...widget.additionalActions?.call(context, item) ?? [],
        if (widget.onShow != null)
          ThemedActionButton(
            onlyIcon: true,
            labelText: t('helpers.buttons.show'),
            icon: MdiIcons.magnifyScan,
            color: Colors.blue,
            isLoading: widget.isLoading,
            isCooldown: widget.isCooldown,
            onCooldownFinish: widget.onCooldown,
            onPressed: () => widget.onShow?.call(context, item),
          ),
        if (widget.onEdit != null && widget.canEdit.call(context, item))
          ThemedActionButton(
            onlyIcon: true,
            labelText: t('helpers.buttons.edit'),
            icon: MdiIcons.squareEditOutline,
            color: Colors.orange,
            isLoading: widget.isLoading,
            isCooldown: widget.isCooldown,
            onCooldownFinish: widget.onCooldown,
            onPressed: () => widget.onEdit?.call(context, item),
          ),
        if (widget.onDelete != null && widget.canDelete.call(context, item))
          ThemedActionButton(
            onlyIcon: true,
            labelText: t('helpers.buttons.delete'),
            icon: MdiIcons.trashCan,
            color: Colors.red,
            isLoading: widget.isLoading,
            isCooldown: widget.isCooldown,
            onCooldownFinish: widget.onCooldown,
            onPressed: () async {
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
    );

    if (isMobile) {
      final avatarInfo = widget.rowAvatarBuilder(context, columns, item);
      return SizedBox(
        height: itemHeight,
        child: InkWell(
          onTap: widget.onShow != null
              ? () {
                  widget.onShow?.call(context, item);
                }
              : null,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(35),
                  onTap: () {
                    if (multiSelectionEnabled) {
                      setState(() {
                        if (selectedItems.contains(item)) {
                          selectedItems.remove(item);
                        } else {
                          selectedItems.add(item);
                        }
                      });

                      validateSelection();
                    }
                  },
                  child: drawAvatar(
                    context: context,
                    size: 35,
                    radius: 35,
                    dynamicAvatar: selectedItems.contains(item) ? null : avatarInfo.dynamicAvatar,
                    avatar: selectedItems.contains(item) ? null : avatarInfo.avatar,
                    icon: selectedItems.contains(item) ? MdiIcons.checkboxMarkedCircleOutline : avatarInfo.icon,
                    name: selectedItems.contains(item) ? null : avatarInfo.label,
                    color: selectedItems.contains(item) ? checkboxColor : avatarInfo.color,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.rowTitleBuilder(context, columns, item),
                      widget.rowSubtitleBuilder(context, columns, item),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                actions,
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: rowHeight,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          if (multiSelectionEnabled) ...[
            drawCell(
              width: rowSelectionWidth,
              alignment: Alignment.center,
              child: ThemedAnimatedCheckbox(
                activeColor: checkboxColor,
                value: selectedItems.contains(item),
                onChanged: (value) {
                  if (value == true) {
                    setState(() => selectedItems.add(item));
                  } else {
                    setState(() => selectedItems.remove(item));
                  }
                  validateSelection();
                },
              ),
            ),
          ],
          drawCell(
            width: idSize,
            child: Text("#${widget.idBuilder(context, item)}"),
          ),
          for (ThemedColumn<T> column in columns) ...[
            drawCell(
              width: columnWidth,
              child: column.widgetBuilder?.call(context, item) ?? Text(column.valueBuilder(context, item)),
            ),
          ],
          drawCell(
            width: actionsWidth,
            alignment: Alignment.centerRight,
            child: actions,
          ),
        ],
      ),
    );
  }

  /// Validates the multi selection dialog, depends of the number of selected items and
  /// the property [minSelectionsBeforeDialog]
  /// If the number of selected items is greater than [minSelectionsBeforeDialog] the dialog will be shown
  /// otherwise the dialog will be destroyed
  void validateSelection() {
    widget.onSelectedItemsChanged?.call(context, selectedItems);
    if (!widget.enableMultiSelectDialog) {
      return;
    }

    if (selectedItems.length >= minSelectionsBeforeDialog) {
      buildOverlay();
    } else {
      destroyOverlay();
    }
  }

  /// Builds the overlay using the [overlayEntry] property
  /// If the [overlayEntry] is not null, the method will return without doing anything
  /// Otherwise, the overlay will be built
  void buildOverlay() {
    if (overlayEntry != null) {
      return;
    }

    double width = MediaQuery.of(context).size.width * 0.8;
    if (width > 500) {
      width = 500;
    }

    ScrollController actionsController = ScrollController();

    overlayEntry = OverlayEntry(
      builder: (context1) {
        return Stack(
          children: [
            Positioned(
              top: 10,
              left: (MediaQuery.of(context).size.width - width) / 2,
              width: width,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.5, end: 1).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: width,
                        decoration: generateContainerElevation(context: context),
                        child: StatefulBuilder(
                          builder: (BuildContext context2, setLocalState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t('helpers.multipleSelection.title'),
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  t('helpers.multipleSelection.caption'),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: width,
                                  child: SingleChildScrollView(
                                    controller: actionsController,
                                    reverse: true,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ThemedButton(
                                          color: checkboxColor,
                                          labelText: t('helpers.multipleSelection.actions.cancel'),
                                          isLoading: widget.isLoading,
                                          isCooldown: widget.isCooldown,
                                          onCooldownFinish: widget.onCooldown,
                                          onTap: () {
                                            destroyOverlay(callback: () {
                                              setState(() => selectedItems = []);
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 5),
                                        for (final action in widget.multiSelectionActions) ...[
                                          ThemedButton(
                                            color: action.color,
                                            label: action.label,
                                            labelText: action.labelText,
                                            isLoading: widget.isLoading,
                                            isCooldown: widget.isCooldown,
                                            onCooldownFinish: widget.onCooldown,
                                            onTap: () {
                                              destroyOverlay(callback: () {
                                                bool result = action.onTap.call(selectedItems);
                                                if (result) {
                                                  setState(() => selectedItems = []);
                                                }
                                              });
                                            },
                                          ),
                                          const SizedBox(width: 5),
                                        ],
                                        if (widget.onMultiDelete != null)
                                          ThemedButton(
                                            color: Colors.red,
                                            labelText: t('helpers.multipleSelection.actions.delete'),
                                            isLoading: widget.isLoading,
                                            isCooldown: widget.isCooldown,
                                            onCooldownFinish: widget.onCooldown,
                                            onTap: () {
                                              destroyOverlay(
                                                callback: () async {
                                                  bool confirmation = await deleteConfirmationDialog(
                                                    context: context,
                                                    isMultiple: true,
                                                    isCooldown: widget.isCooldown,
                                                    isLoading: widget.isLoading,
                                                    onCooldown: widget.onCooldown,
                                                  );

                                                  if (confirmation && context.mounted) {
                                                    // debugPrint('context.mounted ${context.mounted}');
                                                    // debugPrint('context1.mounted ${context1.mounted}');
                                                    // debugPrint('context2.mounted ${context2.mounted}');
                                                    bool result = await widget.onMultiDelete?.call(
                                                          context,
                                                          selectedItems,
                                                        ) ??
                                                        false;
                                                    if (result) {
                                                      setState(() => selectedItems = []);
                                                    }
                                                  } else {
                                                    setState(() => selectedItems = []);
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(overlayEntry!);
    animationController.forward();
  }

  /// Destroys the overlay using the [overlayEntry] property
  void destroyOverlay({VoidCallback? callback}) async {
    await animationController.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
    callback?.call();
  }

  /// Helper to draw the header cell, with the sorting logic
  Widget drawHeader({
    required double width,
    required Widget child,
    Alignment alignment = Alignment.centerLeft,
    bool canSort = true,
    bool isLast = false,
    int? index,
  }) {
    return InkWell(
      onTap: canSort
          ? () {
              if (sortBy == index) {
                sortAsc = !sortAsc;
              } else {
                sortBy = index!;
                sortAsc = true;
              }

              _resyncItems();
            }
          : null,
      child: Container(
        width: width,
        height: rowHeight,
        alignment: alignment,
        decoration: isLast ? null : decoration,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: canSort
            ? Row(
                children: [
                  Expanded(child: child),
                  if (sortBy == index) ...[
                    Icon(
                      sortAsc ? MdiIcons.sortAscending : MdiIcons.sortDescending,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                  ],
                ],
              )
            : child,
      ),
    );
  }

  /// Helper to draw a cell
  Widget drawCell({
    required double width,
    required Widget child,
    Alignment alignment = Alignment.centerLeft,
    bool isLast = false,
  }) {
    return Container(
      width: width,
      height: rowHeight,
      alignment: alignment,
      decoration: isLast ? null : decoration,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    );
  }

  /// Translation helper
  String t(String key, [Map<String, dynamic> args = const {}]) {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);

    if (i18n != null) {
      return i18n.t(key, args);
    }

    if (widget.customTranslations.containsKey(key)) {
      String result = widget.customTranslations[key]!;
      args.forEach((key, value) => result = result.replaceAll('{$key}', value.toString()));
      return result;
    }

    return 'Missing translation for key $key : $args';
  }

  /// Translation helper for singular / plural detection
  /// Note: To a correct use of this method, your translation should be
  /// in the following format: `singular | plural`
  /// Is important to have the ` | ` character with the spaces before and after to work correctly
  String tc(String key, int count, {Map<String, dynamic> args = const {}}) {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);

    if (i18n != null) {
      return i18n.tc(key, count, args);
    }

    if (widget.customTranslations.containsKey(key)) {
      String result = widget.customTranslations[key]!;
      args.forEach((key, value) => result = result.replaceAll('{$key}', value.toString()));

      List<String> parts = result.split(' | ');
      if (parts.length == 2) {
        return count == 1 ? parts[0] : parts[1];
      }

      return result;
    }

    return 'Missing translation for key $key : $count : $args';
  }
}

/// Shows a dialog to confirm the deletion of items (Can be single or multiple)
/// Requires the following translations:
/// - actions.confirmation.title
/// - actions.confirmation.content
/// - actions.confirmation.dismiss
/// - actions.confirmation.confirm
/// - actions.confirmationMultiple.title
/// - actions.confirmationMultiple.content
Future<bool> deleteConfirmationDialog({
  required BuildContext context,
  bool isMultiple = false,
  bool isLoading = false,
  bool isCooldown = false,
  VoidCallback? onCooldown,
}) async {
  LayrzAppLocalizations i18n = LayrzAppLocalizations.of(context)!;
  bool? result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(i18n.t('actions.${isMultiple ? 'confirmationMultiple' : 'confirmation'}.title')),
        content: Text(i18n.t('actions.${isMultiple ? 'confirmationMultiple' : 'confirmation'}.content')),
        actions: [
          ThemedButton(
            style: ThemedButtonStyle.filledTonal,
            color: Colors.red.shade700,
            labelText: i18n.t('actions.confirmation.dismiss'),
            isLoading: isLoading,
            isCooldown: isCooldown,
            onCooldownFinish: onCooldown,
            onTap: () => Navigator.pop(context, false),
          ),
          ThemedButton(
            style: ThemedButtonStyle.filledTonal,
            color: Colors.green.shade700,
            labelText: i18n.t('actions.confirmation.confirm'),
            isLoading: isLoading,
            isCooldown: isCooldown,
            onCooldownFinish: onCooldown,
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
