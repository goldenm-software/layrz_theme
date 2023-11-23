part of scaffolds;

bool kThemedTableCanTrue(BuildContext context, item) => true;

class ThemedTable<T> extends StatefulWidget {
  /// Represents the columns or headers of the table. This columns only will be displayed in desktop size.
  /// For mobile mode, refer to the [rowTitleBuilder], [rowSubtitleBuilder] and [rowAvatarBuilder] properties.
  /// You can display up to 99 columns, but I don't recommend it.
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
  /// This will appear at the left of the row, before the title and subtitle.
  final ThemedTableAvatar Function(BuildContext, List<ThemedColumn<T>>, T) rowAvatarBuilder;

  /// Represents the builders of row title when the table is in mobile size.
  /// This will appear at the center of the row, after the avatar and above the subtitle.
  /// This widget returned will be inside in a [Expanded][Column] widget.
  final Widget Function(BuildContext, List<ThemedColumn<T>>, T) rowTitleBuilder;

  /// Represents the builders of row subtitle when the table is in mobile size.
  /// This will appear at the center of the row, after the title and below the avatar.
  /// This widget returned will be inside in a [Expanded][Column] widget.
  final Widget Function(BuildContext, List<ThemedColumn<T>>, T) rowSubtitleBuilder;

  /// Represents the builder of the id of the item.
  /// This will be used to sort the items by id, and will appear as the first column of the table.
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

  /// [idLabel] represents the label of the id column.
  /// By default, this value is `ID`
  final String idLabel;

  /// [customTitleText] represents the custom title text of the table.
  /// If this property is null, the title will be generated using the [module] property.
  final String? customTitleText;

  /// [rowHeight] represents the height of the row when the table is in desktop size.
  /// By default, this value is 40.0
  final double rowHeight;

  /// [initialPage] represents the initial page of the table.
  /// By default, this value is 0
  final int initialPage;

  /// [onPageChanged] represents the callback when the user changes the page.
  /// By default, this value is null
  final void Function(int)? onPageChanged;

  /// [enablePaginator] represents the indicator of the paginator.
  /// Will only apply in desktop mode.
  /// By default, this value is true
  /// We strongly recommend to use the paginator to prevent issues displaying a lot of items with many columns.
  final bool enablePaginator;

  /// [itemsPerPage] represents the number of items per page.
  /// By default, this value is calculated using the [rowHeight] and the available height of the table
  final int? itemsPerPage;

  /// [paginatorLeading] represents the widget to display before the paginator.
  /// By default, this value is null
  final Widget? paginatorLeading;

  /// [paginatorTrailing] represents the widget to display after the paginator.
  /// By default, this value is null
  final Widget? paginatorTrailing;

  /// [onIdTap] represents the callback when the user taps on a cell.
  final CellTap? onIdTap;

  /// [shouldExpand] represents the callback to check if the table in desktop mode should use `Expanded` widget.
  /// By default, this value is true
  final bool shouldExpand;

  /// [idEnabled] refers to the id column. If this property is false, the id column will be hidden.
  /// By default, this value is true
  final bool idEnabled;

  /// [forceResync] represents the indicator to force the resync of the items.
  /// By default, this value is false
  /// Be careful, this operation can be expensive, because it will recalculate the sizes of the columns.
  final bool forceResync;

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
    this.customTranslations = const {
      'layrz.table.paginator.start': 'First page',
      'layrz.table.paginator.previous': 'Previous page',
      'layrz.table.paginator.page': 'Page {page} of {total}',
      'layrz.table.paginator.next': 'Next page',
      'layrz.table.paginator.end': 'Last page',
      'helpers.buttons.show': 'Show item',
      'helpers.buttons.edit': 'Edit item',
      'helpers.buttons.delete': 'Delete item',
      'helpers.actions': 'Actions',
      'helpers.search': 'Search',
    },
    this.onSelectedItemsChanged,
    this.enableMultiSelectDialog = true,
    this.canEdit = kThemedTableCanTrue,
    this.canDelete = kThemedTableCanTrue,
    this.mobileRowHeight = 72.0,
    this.idLabel = 'ID',
    this.customTitleText,
    this.rowHeight = 40.0,
    this.initialPage = 0,
    this.onPageChanged,
    this.enablePaginator = true,
    this.itemsPerPage,
    this.paginatorLeading,
    this.paginatorTrailing,
    this.onIdTap,
    this.shouldExpand = true,
    this.idEnabled = true,
    this.forceResync = false,
  })  : assert(columns.length > 0),
        assert(columns.length < 99);

  @override
  State<ThemedTable<T>> createState() => _ThemedTableState<T>();
}

class _ThemedTableState<T> extends State<ThemedTable<T>> with TickerProviderStateMixin {
  late AnimationController animationController;
  OverlayEntry? overlayEntry;
  final GlobalKey _key = GlobalKey();

  String get module => widget.module;
  List<T> _items = [];
  List<T> _selectedItems = [];
  Map<int, double> _sizes = {};
  double _height = 0;

  int _currentPage = 0;
  int _itemsPerPage = 10;
  int _totalPages = 0;

  final ScrollController _mobileController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  final Map<int, ScrollController> _rowsController = {};

  List<ThemedColumn<T>> get columns => widget.columns;

  int get minSelectionsBeforeDialog => widget.minSelectionsBeforeDialog;
  bool get multiSelectionEnabled => widget.multiSelectionEnabled;
  double get rowHeight => widget.rowHeight;
  bool get actionsEnabled {
    return widget.onShow != null || widget.onEdit != null || widget.onDelete != null;
  }

  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  BorderSide get border => BorderSide(
        color: Theme.of(context).dividerColor,
        width: 1,
      );
  BorderSide get darkerBorder => BorderSide(
        color: Theme.of(context).dividerColor,
        width: 3,
      );

  TextStyle? get headerStyle {
    if (mounted) {
      return Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600);
    }
    return null;
  }

  TextStyle? get bodyStyle {
    if (mounted) {
      return Theme.of(context).textTheme.bodyMedium;
    }
    return null;
  }

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

  @override
  void initState() {
    super.initState();
    searchText = widget.searchText;
    _currentPage = widget.initialPage;
    if (!widget.idEnabled) {
      sortBy = 0;
    }
    animationController = AnimationController(vsync: this, duration: kHoverDuration);
    _resyncItems(predictSizes: false, paginate: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _predictSizes();
      if (widget.enablePaginator) {
        _paginate();
      }
    });
  }

  @override
  void didUpdateWidget(ThemedTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final eq = const ListEquality().equals;

    if (!eq(oldWidget.items, widget.items) || widget.forceResync) {
      _resyncItems();
    }

    if (!eq(oldWidget.columns, widget.columns) || widget.forceResync) {
      _predictSizes();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    overlayEntry?.remove();
    overlayEntry = null;

    // Scroll controllers
    _mobileController.dispose();
    _horizontalController.dispose();

    for (var controller in _rowsController.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool isMobile = width < widget.mobileBreakpoint;

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color primaryColor = Theme.of(context).primaryColor;

    if (isDark && !useBlack(color: primaryColor)) {
      primaryColor = Colors.white;
    }

    double itemHeight = isMobile ? widget.mobileRowHeight : rowHeight;

    Widget title = Row(
      children: [
        Expanded(
          child: widget.title ??
              Text(
                widget.customTitleText ?? t('$module.title.list', {'count': _items.length}),
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
    );

    double idSize = _sizes[-1] ?? 70;
    double actionsSize = _sizes[100] ?? 100;
    double mutliSelectionSize = _sizes[-2] ?? 60;

    if (!multiSelectionEnabled) {
      mutliSelectionSize = 0;
    }

    Widget desktopListing = ListView.builder(
      itemCount: _items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => desktopBuilder(
        context,
        index,
        itemHeight: itemHeight,
      ),
      itemExtent: itemHeight,
    );

    Widget desktopContent = Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (multiSelectionEnabled) ...[
              drawHeader(
                index: -2,
                width: mutliSelectionSize,
                canSort: false,
                alignment: Alignment.center,
                child: ThemedAnimatedCheckbox(
                  activeColor: checkboxColor,
                  value: _selectedItems.length == _items.length,
                  onChanged: (value) {
                    if (value == true) {
                      setState(() => _selectedItems = _items);
                    } else {
                      setState(() => _selectedItems = []);
                    }

                    validateSelection();
                  },
                ),
              ),
            ],
            if (widget.idEnabled) ...[
              drawHeader(
                index: -1,
                width: idSize,
                child: Text(widget.idLabel, style: headerStyle),
              ),
            ],
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo is ScrollUpdateNotification) {
                    for (var controller in _rowsController.values) {
                      if (controller.positions.isNotEmpty) {
                        controller.jumpTo(scrollInfo.metrics.pixels);
                      }
                    }
                    _horizontalController.jumpTo(scrollInfo.metrics.pixels);
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...columns.asMap().entries.map((entry) {
                        final column = entry.value;
                        final index = entry.key;
                        return drawHeader(
                          index: index,
                          width: _sizes[index] ?? 100,
                          child: column.label ??
                              Text(
                                column.labelText ?? '',
                                style: headerStyle?.copyWith(
                                  color: column.textColor,
                                ),
                              ),
                          color: column.color,
                          textColor: column.textColor,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            if (actionsEnabled) ...[
              drawHeader(
                width: actionsSize,
                index: 100,
                alignment: Alignment.centerRight,
                canSort: false,
                isLast: true,
                child: Icon(
                  MdiIcons.toolboxOutline,
                  size: 20,
                ),
              ),
            ],
          ],
        ),
        if (widget.shouldExpand) ...[
          Expanded(child: desktopListing),
        ] else ...[
          desktopListing,
        ],
        if (widget.enablePaginator) ...[
          SizedBox(
            height: rowHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.paginatorLeading != null) widget.paginatorLeading!,
                ThemedButton(
                  color: isDark ? Colors.white : Colors.black,
                  style: ThemedButtonStyle.filledFab,
                  icon: MdiIcons.chevronDoubleLeft,
                  labelText: t('layrz.table.paginator.start'),
                  isDisabled: _currentPage == 0,
                  onTap: () {
                    setState(() => _currentPage = 0);
                    widget.onPageChanged?.call(_currentPage);
                    _resyncItems(predictSizes: false, paginate: true);
                  },
                ),
                const SizedBox(width: 5),
                ThemedButton(
                  color: isDark ? Colors.white : Colors.black,
                  style: ThemedButtonStyle.filledFab,
                  icon: MdiIcons.chevronLeft,
                  labelText: t('layrz.table.paginator.previous'),
                  isDisabled: _currentPage == 0,
                  onTap: () {
                    setState(() => _currentPage--);
                    widget.onPageChanged?.call(_currentPage);
                    _resyncItems(predictSizes: false, paginate: true);
                  },
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      t(
                        'layrz.table.paginator.page',
                        {'page': _currentPage + 1, 'total': _totalPages},
                      ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _getStrItemsPerPage(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const Spacer(),
                ThemedButton(
                  color: isDark ? Colors.white : Colors.black,
                  style: ThemedButtonStyle.filledFab,
                  icon: MdiIcons.chevronRight,
                  labelText: t('layrz.table.paginator.next'),
                  isDisabled: _currentPage == _totalPages - 1,
                  onTap: () {
                    setState(() => _currentPage++);
                    debugPrint("Items per page: ${_items.length}");
                    debugPrint("Current Page: $_currentPage ");
                    widget.onPageChanged?.call(_currentPage);
                    _resyncItems(predictSizes: false, paginate: true);
                  },
                ),
                const SizedBox(width: 5),
                ThemedButton(
                  color: isDark ? Colors.white : Colors.black,
                  style: ThemedButtonStyle.filledFab,
                  icon: MdiIcons.chevronDoubleRight,
                  labelText: t('layrz.table.paginator.end'),
                  isDisabled: _currentPage == _totalPages - 1,
                  onTap: () {
                    setState(() => _currentPage = _totalPages - 1);
                    widget.onPageChanged?.call(_currentPage);
                    _resyncItems(predictSizes: false, paginate: true);
                  },
                ),
                if (widget.paginatorTrailing != null) widget.paginatorTrailing!,
              ],
            ),
          ),
        ],
      ],
    );

    return Container(
      key: _key,
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(maxWidth: width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 10),
          if (isMobile) ...[
            Expanded(
              child: CustomScrollView(
                controller: _mobileController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => mobileBuilder(
                        context,
                        index,
                        isMobile: isMobile,
                        itemHeight: itemHeight,
                      ),
                      childCount: _items.length,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            if (widget.shouldExpand) ...[
              Expanded(child: desktopContent),
            ] else ...[
              desktopContent,
            ],
          ],
        ],
      ),
    );
  }

  Widget? desktopBuilder(
    BuildContext context,
    int index, {
    required double itemHeight,
  }) {
    if (index >= _items.length) {
      return null;
    }

    final item = _items[index];

    double idSize = _sizes[-1] ?? 70;
    double actionsSize = _sizes[100] ?? 100;
    double mutliSelectionSize = _sizes[-2] ?? 60;

    if (!multiSelectionEnabled) {
      mutliSelectionSize = 0;
    }

    return Row(
      children: [
        if (multiSelectionEnabled) ...[
          drawCell(
            index: -2,
            width: mutliSelectionSize,
            alignment: Alignment.center,
            child: ThemedAnimatedCheckbox(
              activeColor: checkboxColor,
              value: _selectedItems.contains(item),
              onChanged: (value) {
                if (value == true) {
                  setState(() => _selectedItems.add(item));
                } else {
                  setState(() => _selectedItems.remove(item));
                }
                validateSelection();
              },
            ),
          ),
        ],
        if (widget.idEnabled) ...[
          drawCell(
            index: index,
            width: idSize,
            child: Text("#${widget.idBuilder(context, item)}"),
            onTap: widget.onIdTap,
          ),
        ],
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo is ScrollUpdateNotification) {
                _horizontalController.jumpTo(scrollInfo.metrics.pixels);
                for (var controller in _rowsController.values) {
                  if (controller.positions.isNotEmpty) {
                    controller.jumpTo(scrollInfo.metrics.pixels);
                  }
                }
              }
              return true;
            },
            child: SingleChildScrollView(
              controller: _rowsController[index],
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...columns.asMap().entries.map((subentry) {
                    final column = subentry.value;
                    final subindex = subentry.key;

                    Color? color = column.cellColor?.call(item);
                    Color? textColor = column.cellTextColor?.call(item);

                    return drawCell(
                      width: _sizes[subindex] ?? 100,
                      child: column.widgetBuilder?.call(context, item) ??
                          Text(
                            column.valueBuilder(context, item),
                            style: bodyStyle?.copyWith(
                              color: textColor ?? (color != null ? validateColor(color: color) : null),
                            ),
                          ),
                      index: index,
                      onTap: column.onTap,
                      color: color,
                      textColor: textColor,
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
        if (actionsEnabled) ...[
          drawCell(
            index: index,
            width: actionsSize,
            alignment: Alignment.centerRight,
            isLast: true,
            child: ThemedActionsButtons(
              actionsLabel: t('helpers.actions'),
              actions: [
                ...widget.additionalActions?.call(context, item) ?? [],
                if (widget.onShow != null)
                  ThemedActionButton(
                    onlyIcon: true,
                    tooltipPosition: ThemedTooltipPosition.left,
                    labelText: t('helpers.buttons.show'),
                    icon: MdiIcons.magnifyScan,
                    color: Colors.blue,
                    isLoading: widget.isLoading,
                    isCooldown: widget.isCooldown,
                    onCooldownFinish: widget.onCooldown,
                    onTap: () => widget.onShow?.call(context, item),
                  ),
                if (widget.onEdit != null && widget.canEdit.call(context, item))
                  ThemedActionButton(
                    onlyIcon: true,
                    tooltipPosition: ThemedTooltipPosition.left,
                    labelText: t('helpers.buttons.edit'),
                    icon: MdiIcons.squareEditOutline,
                    color: Colors.orange,
                    isLoading: widget.isLoading,
                    isCooldown: widget.isCooldown,
                    onCooldownFinish: widget.onCooldown,
                    onTap: () => widget.onEdit?.call(context, item),
                  ),
                if (widget.onDelete != null && widget.canDelete.call(context, item))
                  ThemedActionButton(
                    onlyIcon: true,
                    tooltipPosition: ThemedTooltipPosition.left,
                    labelText: t('helpers.buttons.delete'),
                    icon: MdiIcons.trashCan,
                    color: Colors.red,
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
          ),
        ],
      ],
    );
  }

  Widget? mobileBuilder(
    BuildContext context,
    int index, {
    bool isMobile = false,
    required double itemHeight,
  }) {
    if (index >= _items.length) {
      return null;
    }

    final item = _items[index];

    Widget actions = ThemedActionsButtons(
      actionsLabel: t('helpers.actions'),
      actions: [
        ...widget.additionalActions?.call(context, item) ?? [],
        if (widget.onShow != null)
          ThemedActionButton(
            onlyIcon: true,
            tooltipPosition: ThemedTooltipPosition.left,
            labelText: t('helpers.buttons.show'),
            icon: MdiIcons.magnifyScan,
            color: Colors.blue,
            isLoading: widget.isLoading,
            isCooldown: widget.isCooldown,
            onCooldownFinish: widget.onCooldown,
            onTap: () => widget.onShow?.call(context, item),
          ),
        if (widget.onEdit != null && widget.canEdit.call(context, item))
          ThemedActionButton(
            onlyIcon: true,
            tooltipPosition: ThemedTooltipPosition.left,
            labelText: t('helpers.buttons.edit'),
            icon: MdiIcons.squareEditOutline,
            color: Colors.orange,
            isLoading: widget.isLoading,
            isCooldown: widget.isCooldown,
            onCooldownFinish: widget.onCooldown,
            onTap: () => widget.onEdit?.call(context, item),
          ),
        if (widget.onDelete != null && widget.canDelete.call(context, item))
          ThemedActionButton(
            onlyIcon: true,
            tooltipPosition: ThemedTooltipPosition.left,
            labelText: t('helpers.buttons.delete'),
            icon: MdiIcons.trashCan,
            color: Colors.red,
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
    );

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
                      if (_selectedItems.contains(item)) {
                        _selectedItems.remove(item);
                      } else {
                        _selectedItems.add(item);
                      }
                    });

                    validateSelection();
                  }
                },
                child: drawAvatar(
                  context: context,
                  size: 35,
                  radius: 35,
                  dynamicAvatar: _selectedItems.contains(item) ? null : avatarInfo.dynamicAvatar,
                  avatar: _selectedItems.contains(item) ? null : avatarInfo.avatar,
                  icon: _selectedItems.contains(item) ? MdiIcons.checkboxMarkedCircleOutline : avatarInfo.icon,
                  name: _selectedItems.contains(item) ? null : avatarInfo.label,
                  color: _selectedItems.contains(item) ? checkboxColor : avatarInfo.color,
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

  /// Validates the multi selection dialog, depends of the number of selected items and
  /// the property [minSelectionsBeforeDialog]
  /// If the number of selected items is greater than [minSelectionsBeforeDialog] the dialog will be shown
  /// otherwise the dialog will be destroyed
  void validateSelection() {
    widget.onSelectedItemsChanged?.call(context, _selectedItems);
    if (!widget.enableMultiSelectDialog) {
      return;
    }

    if (_selectedItems.length >= minSelectionsBeforeDialog) {
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
                                              setState(() => _selectedItems = []);
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
                                                bool result = action.onTap.call(_selectedItems);
                                                if (result) {
                                                  setState(() => _selectedItems = []);
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
                                                          _selectedItems,
                                                        ) ??
                                                        false;
                                                    if (result) {
                                                      setState(() => _selectedItems = []);
                                                    }
                                                  } else {
                                                    setState(() => _selectedItems = []);
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
    required Widget child,
    Alignment alignment = Alignment.centerLeft,
    bool canSort = true,
    bool isLast = false,
    required int index,
    required double width,
    Color? color,
    Color? textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: darkerBorder,
          right: isLast ? BorderSide.none : border,
        ),
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canSort
              ? () {
                  if (sortBy == index) {
                    sortAsc = !sortAsc;
                  } else {
                    sortBy = index;
                    sortAsc = true;
                  }

                  _resyncItems();
                }
              : null,
          child: Container(
            width: width,
            height: rowHeight,
            alignment: alignment,
            padding: ThemedColumn.padding,
            child: canSort
                ? Row(
                    children: [
                      Expanded(child: child),
                      if (sortBy == index) ...[
                        Icon(
                          sortAsc ? MdiIcons.sortAscending : MdiIcons.sortDescending,
                          size: 15,
                          color: textColor ?? (color != null ? validateColor(color: color) : null),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ],
                  )
                : child,
          ),
        ),
      ),
    );
  }

  /// Helper to draw a cell
  Widget drawCell({
    required double width,
    required Widget child,
    Alignment alignment = Alignment.centerLeft,
    bool isLast = false,
    CellTap? onTap,
    required int index,
    Color? color,
    Color? textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: border,
          right: isLast ? BorderSide.none : border,
        ),
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap != null ? () => onTap.call(_items[index]) : null,
          child: Container(
            width: width,
            height: rowHeight,
            alignment: alignment,
            child: Padding(
              padding: ThemedColumn.padding,
              child: child,
            ),
          ),
        ),
      ),
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

  void _resyncItems({bool predictSizes = true, bool paginate = true}) {
    _items = List<T>.from(widget.items);

    if (searchText.isNotEmpty) {
      _items = _items.where((T item) {
        bool c1 = "#${widget.idBuilder(context, item)}".contains(searchText);
        bool c2 = false;

        for (ThemedColumn<T> column in columns) {
          String value = column.valueBuilder(context, item);
          c2 = c2 || value.toLowerCase().contains(searchText.toLowerCase());
        }
        return c1 || c2;
      }).toList();
    }

    _items.sort((a, b) {
      dynamic aValue;
      dynamic bValue;

      if (sortBy == -1) {
        // deafult sort when there are no columns selected
        aValue = int.tryParse(widget.idBuilder(context, a)) ?? 0;
        bValue = int.tryParse(widget.idBuilder(context, b)) ?? 0;
      } else {
        ThemedColumn<T> column = columns[sortBy];

        if (column.customSortingFunction != null) {
          // debugPrint("Sorting using custom function");
          // only if the column has a custom sorting function
          if (sortAsc) {
            // if the sort is ascending
            return column.customSortingFunction!.call(a, b);
          } else {
            // if the sort is descending
            return column.customSortingFunction!.call(b, a);
          }
        }
        aValue = column.valueBuilder(context, a);
        bValue = column.valueBuilder(context, b);
      }
      // default sort using the abstract class Comparable
      if (sortAsc) {
        // if the sort is ascending
        return Comparable.compare(aValue, bValue);
      } else {
        // if the sort is descending
        return Comparable.compare(bValue, aValue);
      }
    });

    setState(() {});

    if (predictSizes) {
      _predictSizes();
    }

    if (paginate && widget.enablePaginator) {
      _paginate();
    }
  }

  void _predictSizes() {
    double width = MediaQuery.sizeOf(context).width;

    if (width < widget.mobileBreakpoint) {
      return;
    }

    _sizes = {};

    if (widget.idEnabled) {
      _sizes[-1] = 70;
    }

    if (multiSelectionEnabled) {
      _sizes[-2] = 60;
    }

    if (actionsEnabled) {
      _sizes[100] = 100;
    }

    for (final entry in columns.asMap().entries) {
      final index = entry.key;
      final column = entry.value;

      final size = column.predictedHeaderSize(context, headerStyle);
      _sizes[index] = size.width;
    }

    int maxId = 0;

    for (final entry in _items.asMap().entries) {
      final item = entry.value;
      final index = entry.key;

      if (_rowsController[index] == null) {
        _rowsController[index] = ScrollController();
      }

      final id = int.tryParse(widget.idBuilder(context, item)) ?? 0;
      if (id > maxId) {
        maxId = id;
      }

      for (final subentry in columns.asMap().entries) {
        final subindex = subentry.key;
        final column = subentry.value;

        final size = column.predictedContentSize(context, item, headerStyle);
        if (size.width > (_sizes[subindex] ?? 0)) {
          _sizes[subindex] = size.width;
        }
      }
    }

    if (widget.idEnabled) {
      final idSize = ThemedColumn.predictedSize(context, "#$maxId", bodyStyle);
      if (idSize.width > _sizes[-1]!) {
        _sizes[-1] = idSize.width;
      }
    }

    double actionsSize = 0;

    if (actionsEnabled) {
      actionsSize = 10;
      if (widget.onShow != null) {
        actionsSize += 50;
      }

      if (widget.onEdit != null) {
        actionsSize += 50;
      }

      if (widget.onDelete != null) {
        actionsSize += 50;
      }

      // Perform the additional actions
      if (widget.additionalActions != null) {
        int maxActions = 0;

        for (T item in _items) {
          int actions = widget.additionalActions!(context, item).length;
          if (actions > maxActions) {
            maxActions = actions;
          }
        }

        actionsSize += maxActions * 50;
      }

      if (actionsSize > _sizes[100]!) {
        _sizes[100] = actionsSize;
      }
    }

    // Calculate the total width
    double usedWidth = _sizes.values.reduce((value, element) => value + element);
    RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
    double availableWidth = box.size.width;

    if (usedWidth < availableWidth) {
      double diff = availableWidth - usedWidth - 4;
      int totalSizes = _sizes.length;

      if (widget.idEnabled) {
        totalSizes--;
      }

      if (multiSelectionEnabled) {
        totalSizes--;
      }

      if (actionsEnabled) {
        totalSizes--;
      }

      double diffPerColumn = diff / totalSizes;
      diffPerColumn -= 5;

      for (final entry in _sizes.entries) {
        // Skip the multi selection and the actions column
        final index = entry.key;
        if (index < 0 || index == 100) {
          continue;
        }
        final size = entry.value;

        _sizes[index] = size + diffPerColumn;
      }
    }

    setState(() {});
  }

  void _paginate() {
    double width = MediaQuery.sizeOf(context).width;

    if (width < widget.mobileBreakpoint) {
      return;
    }

    double height = 0;
    if (_key.currentContext == null) {
      height = rowHeight * 10;
    } else {
      RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
      height = box.size.height;
    }

    // 40 represents the height of the title and the search input
    // rowHeight * 2 means the height of the header and the paginator below
    _height = height - rowHeight - 40 - rowHeight;
    _itemsPerPage = widget.itemsPerPage ?? (_height / rowHeight).floor();
    _totalPages = (_items.length / _itemsPerPage).ceil();

    for (int i = 0; i < _totalPages; i++) {
      if (_rowsController[i] == null) {
        _rowsController[i] = ScrollController();
      }
    }

    int lastItem = (_currentPage + 1) * _itemsPerPage;
    if (lastItem > _items.length) {
      lastItem = _items.length;
    }

    // Check if the current page is greater than the total pages
    // If is true, reset to 0
    if (_currentPage >= _totalPages) {
      _currentPage = 0;
    }

    _items = _items.sublist(_currentPage * _itemsPerPage, lastItem);
  }

  String _getStrItemsPerPage() {
    if (widget.items.isEmpty) return "";
    int firstIndex = max(1, _currentPage * _items.length);
    int secondIndex = min(widget.items.length, (_currentPage + 1) * _items.length);
    if (_currentPage == 0) firstIndex = 1;
    if (_currentPage == _totalPages - 1) {
      firstIndex = (_currentPage) * _itemsPerPage;
      secondIndex = widget.items.length;
    }
    debugPrint("Vizualizacion: $firstIndex - $secondIndex de ${widget.items.length} items");

    String strItemsPerPage = t(
      'layrz.table.paginator.items',
      {
        'firstIndex': firstIndex,
        'secondIndex': secondIndex,
        'totalItems': widget.items.length,
      },
    );

    return strItemsPerPage;
  }
}
