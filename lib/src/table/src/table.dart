part of '../table.dart';

bool kThemedTableCanTrue(BuildContext context, item) => true;

class ThemedTable<T> extends StatefulWidget {
  /// Represents the columns or headers of the table. This columns only will be displayed in desktop size.
  ///
  /// You can display many columns as you want, but I don't recommend it.
  /// Our performance tests show that the table can display 30 columns without any problem.
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

  /// Represents the builder of the id of the item.
  /// This will be used to sort the items by id, and will appear as the first column of the table.
  final String Function(BuildContext, T) idBuilder;

  /// Represents the multiple selection is enabled
  final bool multiSelectionEnabled;

  /// Represents the additional actions to display when the multiple selection is enabled
  final List<ThemedTableAction<T>> multiSelectionActions;

  /// Represents the minimum selected items before show the dialog
  final int minSelectionsBeforeDialog;

  /// Represents the breakpoint to switch to mobile size. By default is [kExtraSmallGrid]
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

  /// [idLabel] represents the label of the id column.
  /// By default, this value is `ID`
  final String idLabel;

  /// [customTitleText] represents the custom title text of the table.
  /// If this property is null, the title will be generated using the [module] property.
  final String? customTitleText;

  /// [rowHeight] represents the height of the row when the table is in desktop size.
  /// By default, this value is 40.0
  final double rowHeight;

  /// [onIdTap] represents the callback when the user taps on a cell.
  final CellTap? onIdTap;

  /// [idEnabled] refers to the id column. If this property is false, the id column will be hidden.
  /// By default, this value is true
  final bool idEnabled;

  /// [rowsPerPage] represents the number of rows per page.
  /// By default this value is calculated using the [rowHeight] and the available height of the table
  final int? rowsPerPage;

  /// [availableRowsPerPage] represents the list of rows per page to display in the dropdown.
  /// By default, this value is [10, 25, 50, 100]
  final List<int> availableRowsPerPage;

  /// [paginatorStartText] replaces the text of the first page button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String paginatorStartText;

  /// [paginatorPreviousText] replaces the text of the previous page button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String paginatorPreviousText;

  /// [paginatorShowingText] replaces the text of the showing items label.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String paginatorShowingText;

  /// [paginatorNextText] replaces the text of the next page button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String paginatorNextText;

  /// [paginatorEndText] replaces the text of the last page button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String paginatorEndText;

  /// [paginatorAutoText] replaces the text of the fit screen button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String paginatorAutoText;

  /// [paginatorRowsPerPageText] replaces the text of the rows per page label.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String paginatorRowsPerPageText;

  /// [showButtonLabelText] replaces the text of the show button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String showButtonLabelText;

  /// [editButtonLabelText] replaces the text of the edit button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String editButtonLabelText;

  /// [deleteButtonLabelText] replaces the text of the delete button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String deleteButtonLabelText;

  /// [actionsLabelText] replaces the text of the actions label.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String actionsLabelText;

  /// [searchLabelText] replaces the text of the search label.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String searchLabelText;

  /// [multiSelectionTitleText] replaces the text of the multi selection title.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String multiSelectionTitleText;

  /// [multiSelectionContentText] replaces the text of the multi selection content.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String multiSelectionContentText;

  /// [multiSelectionCancelLabelText] replaces the text of the multi selection cancel button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String multiSelectionCancelLabelText;

  /// [multiSelectionDeleteLabelText] replaces the text of the multi selection delete button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String multiSelectionDeleteLabelText;

  /// [tableTitleText] replaces the text of the table title.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String tableTitleText;

  /// [addButtonLabelText] replaces the text of the table add button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String addButtonLabelText;

  /// [refreshButtonLabelText] replaces the text of the refresh button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String refreshButtonLabelText;

  /// [fixedColumnsCount] represents the number of fixed rows in the table.
  /// By default, this value is 3 (multiselection, id and name)
  ///
  /// Note: When the [mobileBreakpoint] is reached, the fixed columns will be disabled. In other terms,
  /// this value will be overridden to `0`.
  final int fixedColumnsCount;

  /// [disablePaginator] represents if the paginator should be disabled.
  /// By default, this value is false, aka, the paginator is enabled.
  ///
  /// Disclaimer: This property is not recommended to use, because if you have a lot of items,
  /// the performance of the view will be affected.
  final bool disablePaginator;

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
    required this.idBuilder,
    this.multiSelectionEnabled = true,
    this.multiSelectionActions = const [],
    this.minSelectionsBeforeDialog = 2,
    this.mobileBreakpoint = kExtraSmallGrid,
    this.isLoading = false,
    this.isCooldown = false,
    this.onCooldown,
    this.onRefresh,
    this.onSelectedItemsChanged,
    this.enableMultiSelectDialog = true,
    this.canEdit = kThemedTableCanTrue,
    this.canDelete = kThemedTableCanTrue,
    this.idLabel = 'ID',
    this.customTitleText,
    this.rowHeight = 40.0,
    this.onIdTap,
    this.idEnabled = true,
    this.rowsPerPage,
    this.availableRowsPerPage = const [10, 25, 50, 100],
    this.paginatorStartText = 'First page',
    this.paginatorPreviousText = 'Previous page',
    this.paginatorShowingText = 'Showing {count} of {total}',
    this.paginatorNextText = 'Next page',
    this.paginatorEndText = 'Last page',
    this.paginatorAutoText = 'Fit screen',
    this.paginatorRowsPerPageText = 'Rows per page',
    this.showButtonLabelText = 'Show item',
    this.editButtonLabelText = 'Edit item',
    this.deleteButtonLabelText = 'Delete item',
    this.actionsLabelText = 'Actions',
    this.searchLabelText = 'Search item',
    this.multiSelectionTitleText = 'Multiselection mode',
    this.multiSelectionContentText = 'What do you want to do with the selected items?',
    this.multiSelectionCancelLabelText = 'Cancel',
    this.multiSelectionDeleteLabelText = 'Delete',
    this.tableTitleText = 'My items ({count})',
    this.addButtonLabelText = 'Add new item',
    this.refreshButtonLabelText = 'Reload list',
    this.fixedColumnsCount = 3,
    this.disablePaginator = false,
  })  : assert(columns.length > 0),
        assert(rowHeight > 0);

  @override
  State<ThemedTable<T>> createState() => _ThemedTableState<T>();
}

class _ThemedTableState<T> extends State<ThemedTable<T>> with TickerProviderStateMixin, WidgetsBindingObserver {
  /// [_overlayEntry] represents the overlay entry of the dialog.
  /// This is used to display the dialog when the user selects multiple items.
  OverlayEntry? _overlayEntry;

  /// [_animation] represents the animation controller of the dialog.
  /// This is used to animate the dialog when the user selects multiple items.
  late AnimationController _animation;

  /// [isDark] predicts if the device is in dark mode.
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  /// [primaryColor] predicts the primary color for buttons, icons, etc.
  ///
  /// This prediction is based on the following rules:
  /// - Mainly, the primary color comes from the theme `primaryColor` property.
  /// - If the device is in dark mode, we check if the color should be in white or black background.
  /// - If the color should be in a black background, the color.
  /// - Otherwise, the color will be white.
  /// - If the device is using a light theme, the color will be the same as the theme `primaryColor`.
  Color get primaryColor {
    Color color = Colors.lightBlue;

    if (isDark && !useBlack(color: color)) {
      return Colors.white;
    }
    return color;
  }

  /// [_actionsEnabled] predicts if the actions should be displayed.
  bool get _actionsEnabled {
    return widget.onShow != null ||
        widget.onEdit != null ||
        widget.onDelete != null ||
        widget.additionalActions != null;
  }

  /// [module] represents the module name of the table.
  /// This is used to generate the titleText and the add button label.
  ///
  /// It's a shortcut to [widget.module]
  String get module => widget.module;

  /// [searchText] represents the default search value of the table.
  String _searchText = '';

  /// [_items] represents the list of items to display.
  /// This is not the same as [widget.items], because this list can be filtered or sorted.
  List<T> _items = [];

  /// [_itemsPerPage] represents the number of rows per page.
  int _itemsPerPage = 10;

  /// [_calculatedItemsPerPage] represents the number of rows per page.
  /// This is used to calculate the [_itemsPerPage] property.
  int _calculatedItemsPerPage = 10;

  /// [_currentPage] represents the current page of the table.
  int _currentPage = 0;

  /// [_tableKey] represents the key of the table.
  /// This is used to get the available height of the table.
  final GlobalKey _tableKey = GlobalKey();

  /// [paginatorColor] represents the color of the paginator.
  /// This color is used to generate the color of the paginator buttons.
  Color get paginatorColor => isDark ? Colors.white : Colors.black;

  /// [_headerStyle] represents the style of the header.
  TextStyle? get _headerStyle => Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      );

  /// [_rowStyle] represents the style of the header.
  TextStyle? get _rowStyle => Theme.of(context).textTheme.bodyMedium;

  /// [_sortBy] represents the index of the column to sort.
  /// If this value is -1, the sort is by id.
  late int _sortBy;

  /// [_sortAsc] represents the direction of the sort.
  /// If this value is true, the sort is ascending.
  bool _sortAsc = true;

  /// [_idWidth] represents the width of the id column.
  /// This is used to calculate the width of the table.
  double get _idWidth => 50;

  /// [_checkboxWidth] represents the width of the checkbox column.
  /// This is used to calculate the width of the table.
  double get _checkboxWidth => 40;

  /// [border] refers to the style of the border of the cells.
  BorderSide get border => BorderSide(
        // color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        color: Theme.of(context).dividerColor,
        width: 1,
      );

  /// [_selectedItems] represents the list of selected items.
  List<T> _selectedItems = [];

  /// [_isAllSelected] represents if all the items are selected.
  bool get _isAllSelected => _selectedItems.length == _items.length;

  late final SyncScrollControllerGroup _controllerGroup;

  /// [_horizontalScroll] represents the scroll controller of the table.
  final ScrollController _horizontalScroll = ScrollController();

  /// [_verticalScroll] represents the scroll controller of the table.
  late final ScrollController _verticalScroll;

  /// [_verticalActionsScroll] represents the scroll controller of the actions.
  late final ScrollController _verticalActionsScroll;

  /// [_isUserChangeItemsPerPage] represents if the user changes the items per page.
  bool _isUserChangeItemsPerPage = false;

  /// [_actionSize] represents the size of the action buttons.
  double get _actionSize => ThemedButton.defaultHeight;

  /// [_actionsPadding] represents the padding of the action buttons.
  EdgeInsets get _actionsPadding => const EdgeInsets.symmetric(horizontal: 5);

  /// [_columns] represents the columns of the table.
  List<ThemedColumn<T>> get _columns => [
        if (_multiSelectionEnabled) ...[
          ThemedColumn<T>(
            isSortable: false,
            label: Center(
              child: ThemedAnimatedCheckbox(
                value: _isAllSelected,
                onChanged: (value) {
                  if (value) {
                    _selectedItems = [..._items];
                  } else {
                    _selectedItems = [];
                  }

                  _validateSelection();
                },
              ),
            ),
            valueBuilder: (context, item) => '',
            widgetBuilder: (context, item) {
              return Center(
                child: ThemedAnimatedCheckbox(
                  value: _selectedItems.contains(item),
                  onChanged: (value) {
                    if (value) {
                      _selectedItems.add(item);
                    } else {
                      _selectedItems.remove(item);
                    }

                    _validateSelection();
                  },
                ),
              );
            },
            width: _checkboxWidth,
          ),
        ],
        if (widget.idEnabled) ...[
          ThemedColumn<T>(
            label: Text(widget.idLabel, style: _headerStyle),
            valueBuilder: widget.idBuilder,
            customSortingFunction: (a, b) {
              int aValue = int.tryParse(widget.idBuilder(context, a)) ?? 0;
              int bValue = int.tryParse(widget.idBuilder(context, b)) ?? 0;

              if (aValue == bValue) return 0;
              if (aValue > bValue) return 1;
              return -1;
            },
            widgetBuilder: (context, item) {
              return InkWell(
                onTap: widget.onIdTap == null ? null : () => widget.onIdTap?.call(item),
                child: Text(widget.idBuilder(context, item)),
              );
            },
            width: _idWidth,
          ),
        ],
        ...widget.columns,
      ];

  /// [_hoveredIndex] represents the index of the hovered item.
  int? _hoveredIndex;

  /// [_hoverColor] represents the color of the hovered item.
  Color get _hoverColor => isDark ? Colors.grey.shade800 : Colors.grey.shade200;

  /// [_stripColor] represents the color of the strip item.
  Color get _stripColor => isDark ? Colors.grey.shade900 : Colors.grey.shade100;

  /// [_selectedItemsPerPage] represents the selected items per page, the value selected in the paginator.
  int? _selectedItemsPerPage;

  /// [_multiSelectionEnabled] represents if the multiple selection is enabled.
  bool _multiSelectionEnabled = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _searchText = widget.searchText;

    _items = widget.items;
    if (widget.idEnabled) {
      if (widget.multiSelectionEnabled) {
        _sortBy = 1;
      } else {
        _sortBy = 0;
      }
    } else {
      if (widget.multiSelectionEnabled) {
        _sortBy = 1;
      } else {
        _sortBy = 0;
      }
    }

    _controllerGroup = SyncScrollControllerGroup();
    _verticalScroll = _controllerGroup.addAndGet();
    _verticalActionsScroll = _controllerGroup.addAndGet();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sort(isFirst: true);
      _calculateRowsPerPage();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animation.dispose();
    _horizontalScroll.dispose();
    _verticalScroll.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ThemedTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _items = widget.items;
    _sort();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isUserChangeItemsPerPage) _calculateRowsPerPage();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  didChangeMetrics() {
    _calculateRowsPerPage();
  }

  /// [_prictSizes] pricts the sizes of the columns.
  _CalculatedThings<T> _predictSizes({
    required List<T> items,
    required bool multiSelectionEnabled,
  }) {
    Map<int, double> sizes = {
      -1: 0, // Actions
    };

    double maxWidth;
    RenderBox? box = _tableKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      maxWidth = MediaQuery.sizeOf(context).width;
    } else {
      maxWidth = box.size.width;
    }

    if (_actionsEnabled) {
      if (maxWidth < widget.mobileBreakpoint) {
        sizes[-1] = 60;
      } else {
        double width = 0;
        if (widget.onShow != null) {
          width += _actionSize + _actionsPadding.horizontal;
        }

        if (widget.onEdit != null) {
          width += _actionSize + _actionsPadding.horizontal;
        }

        if (widget.onDelete != null) {
          width += _actionSize + _actionsPadding.horizontal;
        }

        width += ThemedColumn.padding.horizontal;

        double additionalWidth = 0;

        for (T item in items) {
          int totalAdditionalActions = widget.additionalActions?.call(context, item).length ?? 0;
          additionalWidth = max(
            additionalWidth,
            totalAdditionalActions * (_actionSize + _actionsPadding.horizontal),
          );
        }
        width += additionalWidth;

        sizes[-1] = max(width, 150);
      }
    }

    List<int> fixedIndexes = [];

    for (final entry in _columns.asMap().entries) {
      int index = entry.key;
      ThemedColumn<T> column = entry.value;
      if (column.widgetBuilder != null) {
        if (widget.multiSelectionEnabled && index == 0) {
          fixedIndexes.add(index);
        } else if (widget.idEnabled && widget.multiSelectionEnabled && index == 1) {
          fixedIndexes.add(index);
        } else if (widget.idEnabled && !widget.multiSelectionEnabled && index == 0) {
          fixedIndexes.add(index);
        }
      }

      sizes[index] = column.predictedHeaderSize(context, _headerStyle).width;
    }

    for (T item in items) {
      for (final entry in _columns.asMap().entries) {
        int index = entry.key;
        ThemedColumn<T> column = entry.value;

        sizes[index] = max(
          sizes[index] ?? 0,
          column.predictedContentSize(context, item, _rowStyle).width,
        );
      }
    }

    double usedSize = 0;
    for (final entry in sizes.entries) {
      if (entry.key == -1) continue;
      usedSize += entry.value;
    }

    int columnCount = 0;

    for (final entry in sizes.entries) {
      if (entry.key == -1) continue;
      columnCount++;
    }

    /// Calculate the empty space
    ///
    /// The correction factor 6 is used to fix the horizontal scroll, idk why but it works.
    double emptySize = maxWidth - usedSize - (sizes[-1] ?? 0);

    if (emptySize > 0) {
      // Distruibute the empty space between the columns
      int movableColumns = columnCount - fixedIndexes.length;
      double size = emptySize / movableColumns;

      for (int index = 0; index < _columns.length; index++) {
        if (fixedIndexes.contains(index)) {
          continue;
        }
        double prevSize = sizes[index] ?? 0;
        sizes[index] = prevSize + size;
      }
    }

    return _CalculatedThings(
      items: [],
      sizes: sizes,
      hasHorizontalScroll: usedSize > maxWidth,
    );
  }

  /// [_calculateRowsPerPage] calculates the number of rows per page.
  void _calculateRowsPerPage() {
    RenderBox? box = _tableKey.currentContext?.findRenderObject() as RenderBox?;
    if (!mounted) return;
    Size windowSize = MediaQuery.sizeOf(context);
    if (box == null) {
      double screenHeight = windowSize.height;
      _itemsPerPage = widget.rowsPerPage ?? ((screenHeight / widget.rowHeight).floor() - 1);
    } else {
      double height = box.size.height;

      if (windowSize.width < widget.mobileBreakpoint) {
        height -= 50;
      }

      _itemsPerPage = widget.rowsPerPage ?? ((height / widget.rowHeight).floor() - 1);
    }

    _calculatedItemsPerPage = _itemsPerPage;

    _toggleMultiSelectionEnabled();
  }

  /// [_toggleMultiSelectionEnabled] toggles the multi selection enabled.
  void _toggleMultiSelectionEnabled() {
    double screenWidth = MediaQuery.sizeOf(context).width;
    _multiSelectionEnabled = screenWidth < widget.mobileBreakpoint ? false : widget.multiSelectionEnabled;
    setState(() {});
  }

  /// [_sort] sorts the items.
  /// and searches all the items with the [_searchText].
  void _sort({bool isFirst = false}) {
    int sortIndex = _sortBy;
    if (isFirst) {
      sortIndex = _columns.indexWhere((column) => column.isSortable);
    }

    _items = widget.items.where((T item) {
      if (_searchText.isEmpty) return true;
      bool c1 = "#${widget.idBuilder(context, item)}".contains(_searchText);
      bool c2 = false;

      for (ThemedColumn<T> column in widget.columns) {
        String value = column.valueBuilder(context, item);
        c2 = c2 || value.toLowerCase().contains(_searchText.toLowerCase());
      }
      return c1 || c2;
    }).toList();

    _items.sort((a, b) {
      dynamic aValue;
      dynamic bValue;

      ThemedColumn<T> column = _columns[sortIndex];

      if (column.customSortingFunction != null) {
        // only if the column has a custom sorting function
        if (_sortAsc) {
          // if the sort is ascending
          return column.customSortingFunction!.call(a, b);
        } else {
          // if the sort is descending
          return column.customSortingFunction!.call(b, a);
        }
      }

      aValue = column.valueBuilder(context, a);
      bValue = column.valueBuilder(context, b);

      // default sort using the abstract class Comparable
      if (_sortAsc) {
        // if the sort is ascending
        return Comparable.compare(aValue, bValue);
      } else {
        // if the sort is descending
        return Comparable.compare(bValue, aValue);
      }
    });

    setState(() {});
  }

  _CalculatedThings<T> _calculateThings() {
    List<T> items = widget.disablePaginator ? _items : _getRows(_currentPage * _itemsPerPage, _itemsPerPage);

    _CalculatedThings<T> data = _predictSizes(
      items: items,
      multiSelectionEnabled: _multiSelectionEnabled,
    );

    return data.copyWith(items: items);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < widget.mobileBreakpoint;
        bool isVerySmall = constraints.maxWidth <= 210;

        final calculatedData = _calculateThings();
        final items = calculatedData.items;
        final sizes = calculatedData.sizes;

        double searchLength = constraints.maxWidth * 0.3;
        if (searchLength > 300) searchLength = 300;

        return Column(
          children: [
            Row(
              children: [
                // Title
                Expanded(
                  child: widget.title ??
                      Text(
                        widget.customTitleText ?? t('$module.title.list', {'count': widget.items.length}),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                ),

                /// Search bar
                //

                ThemedSearchInput(
                  asField: !isMobile,
                  maxWidth: isMobile ? 300 : searchLength,
                  value: _searchText,
                  inputPadding: const EdgeInsets.symmetric(vertical: 2),
                  labelText: t('helpers.search'),
                  onSearch: (value) {
                    _searchText = value;
                    _currentPage = 0;
                    setState(() {});
                    _sort();
                  },
                ),
                const SizedBox(width: 5),

                // Actions
                ...widget.additionalButtons,
                if (widget.onAdd != null) ...[
                  const SizedBox(width: 5),
                  ThemedButton(
                    labelText: t('$module.title.new'),
                    icon: MdiIcons.plus,
                    style: isMobile ? ThemedButtonStyle.filledTonalFab : ThemedButtonStyle.filledTonal,
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
                    labelText: t('helpers.refresh'),
                    icon: MdiIcons.refresh,
                    style: ThemedButtonStyle.filledTonalFab,
                    color: primaryColor,
                    onTap: widget.onRefresh,
                    isLoading: widget.isLoading,
                    isCooldown: widget.isCooldown,
                    onCooldownFinish: widget.onCooldown,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Scrollbar(
                controller: _horizontalScroll,
                trackVisibility: !isMobile,
                thumbVisibility: !isMobile,
                thickness: 8,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    key: _tableKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TableView.builder(
                            cacheExtent: 500,
                            columnCount: _columns.length,
                            rowCount: items.length + 1,
                            pinnedRowCount: 1,
                            pinnedColumnCount: isMobile
                                ? 0
                                : _columns.isEmpty
                                    ? 0
                                    : widget.fixedColumnsCount,
                            verticalDetails: ScrollableDetails.vertical(controller: _verticalScroll),
                            horizontalDetails: ScrollableDetails.horizontal(controller: _horizontalScroll),
                            columnBuilder: (index) {
                              double size = sizes[index] ?? 10;
                              return TableSpan(
                                extent: FixedTableSpanExtent(size),
                                foregroundDecoration: SpanDecoration(
                                  border: SpanBorder(leading: border),
                                ),
                              );
                            },
                            rowBuilder: (index) {
                              bool isHovering = _hoveredIndex == index && index != 0;

                              Color? color = index == 0
                                  ? null
                                  : index.isEven
                                      ? _stripColor
                                      : null;
                              return TableSpan(
                                extent: FixedTableSpanExtent(widget.rowHeight),
                                backgroundDecoration: SpanDecoration(
                                  color: isHovering ? _hoverColor : color,
                                  border: SpanBorder(
                                    leading: index == 0 ? BorderSide.none : border,
                                    trailing: index == items.length ? BorderSide.none : border,
                                  ),
                                ),
                              );
                            },
                            cellBuilder: (context, vicinity) {
                              final column = _columns[vicinity.column];

                              if (vicinity.row == 0) {
                                Widget content = column.label ??
                                    Text(
                                      column.labelText ?? '',
                                      style: _headerStyle,
                                    );

                                if (column.isSortable) {
                                  content = Expanded(child: content);
                                }

                                return TableViewCell(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: column.isSortable
                                          ? () {
                                              if (_sortBy == vicinity.column) {
                                                _sortAsc = !_sortAsc;
                                              } else {
                                                _sortBy = vicinity.column;
                                                _sortAsc = true;
                                              }
                                              _sort();
                                            }
                                          : null,
                                      child: Container(
                                        alignment: column.alignment,
                                        padding: ThemedColumn.padding,
                                        child: column.isSortable
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  if (_sortBy == vicinity.column) ...[
                                                    Icon(
                                                      _sortAsc ? MdiIcons.sortAscending : MdiIcons.sortDescending,
                                                      size: ThemedColumn.sortIconSize,
                                                    ),
                                                    const SizedBox(width: 5),
                                                  ],
                                                  content,
                                                ],
                                              )
                                            : content,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final item = items[vicinity.row - 1];

                              return TableViewCell(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: column.onTap == null ? null : () => column.onTap?.call(item),
                                    child: Container(
                                      alignment: column.alignment,
                                      padding: ThemedColumn.padding,
                                      child: column.widgetBuilder?.call(context, item) ??
                                          Text(column.valueBuilder.call(context, item)),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (_actionsEnabled) ...[
                          SizedBox(
                            width: sizes[-1] ?? _actionSize,
                            child: Column(
                              children: [
                                Container(
                                  height: widget.rowHeight,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: border,
                                      left: border,
                                    ),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: ThemedColumn.padding,
                                  child: Icon(MdiIcons.toolbox, size: 20),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: items.length,
                                    controller: _verticalActionsScroll,
                                    itemBuilder: (context, index) {
                                      bool isHovering = _hoveredIndex == index && index != 0;
                                      final item = items[index];

                                      return Container(
                                        height: widget.rowHeight,
                                        decoration: BoxDecoration(
                                          color: isHovering
                                              ? _hoverColor
                                              : index.isOdd
                                                  ? _stripColor
                                                  : null,
                                          border: Border(
                                            top: border,
                                            bottom: index == items.length - 1 ? BorderSide.none : border,
                                            left: border,
                                          ),
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding: ThemedColumn.padding,
                                        child: Container(
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
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!widget.disablePaginator) ...[
              isVerySmall
                  ? _buildVerySmallPaginator(constraints: constraints, isDark: isDark)
                  : _buildWebPaginator(constraints: constraints, isMobile: isMobile, isDark: isDark),
            ],
          ],
        );
      },
    );
  }

  Widget _buildVerySmallPaginator({required BoxConstraints constraints, required bool isDark}) {
    String pageInfoStr = t('layrz.table.paginator.verySmall.showing', {
      'count': _itemsPerPage,
      'total': _items.length,
    });
    String currentPageStr = "${_currentPage + 1}";
    int maxPages = _items.length ~/ _itemsPerPage;
    String maxPagesStr = "${maxPages + 1}";
    TextStyle? pageInfoStyle = Theme.of(context).textTheme.bodySmall;
    Color backgrondFilterColor = Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).canvasColor;

    List<Widget> pageInfo = [
      ThemedSelectInput<int?>(
        labelText: t('layrz.table.paginator.rowsPerPage'),
        dense: true,
        customChild: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            color: backgrondFilterColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(MdiIcons.filter, color: isDark ? Colors.white : Colors.black.withOpacity(0.6)),
              Text(
                pageInfoStr,
                style: pageInfoStyle,
              ),
            ],
          ),
        ),
        items: [
          ThemedSelectItem(
            label: t('layrz.table.paginator.auto'),
            value: null,
          ),
          ...widget.availableRowsPerPage.map((page) {
            return ThemedSelectItem(
              value: page,
              label: page.toString(),
            );
          }),
        ],
        onChanged: (value) {
          _setItemPerPage(value?.value);
        },
      ),
    ];

    final painter = TextPainter(
      text: TextSpan(
        text: currentPageStr,
        style: pageInfoStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double currentPageWidth = painter.width;

    double buttonWidth = 30;
    double availableWidth = constraints.maxWidth - (buttonWidth * 4) - (currentPageWidth + 10) - 5;

    if (constraints.maxWidth >= widget.mobileBreakpoint) {
      final painter2 = TextPainter(
        text: TextSpan(
          text: pageInfoStr,
          style: pageInfoStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      availableWidth -= painter2.width;
    }

    availableWidth = min(availableWidth, 300);

    List<Widget> navigator = [
      // const SizedBox(width: 5),

      /// Double left
      ThemedButton(
        labelText: t('layrz.table.paginator.start'),
        color: paginatorColor,
        style: ThemedButtonStyle.fab,
        icon: MdiIcons.chevronDoubleLeft,
        onTap: () => setState(() => _currentPage = 0),
      ),

      /// Left
      ThemedButton(
        labelText: t('layrz.table.paginator.previous'),
        color: paginatorColor,
        style: ThemedButtonStyle.fab,
        icon: MdiIcons.chevronLeft,
        isDisabled: _currentPage == 0,
        onTap: () {
          if (_currentPage > 0) {
            setState(() => _currentPage -= 1);
          }
        },
      ),
      const SizedBox(width: 5),

      /// Current page
      Text("$currentPageStr/$maxPagesStr", style: pageInfoStyle),
      const SizedBox(width: 5),

      /// Right
      ThemedButton(
        labelText: t('layrz.table.paginator.next'),
        color: paginatorColor,
        style: ThemedButtonStyle.fab,
        icon: MdiIcons.chevronRight,
        isDisabled: _currentPage == maxPages,
        onTap: () {
          if (_currentPage < maxPages) {
            setState(() => _currentPage += 1);
          }
        },
      ),

      /// Double right
      ThemedButton(
        labelText: t('layrz.table.paginator.end'),
        color: paginatorColor,
        style: ThemedButtonStyle.fab,
        icon: MdiIcons.chevronDoubleRight,
        onTap: () => setState(() => _currentPage = _items.length ~/ _itemsPerPage),
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: pageInfo,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: navigator,
        ),
      ],
    );
  }

  Widget _buildWebPaginator({required BoxConstraints constraints, required bool isMobile, required bool isDark}) {
    String pageInfoStr = t('layrz.table.paginator.showing', {
      'count': _itemsPerPage,
      'total': _items.length,
    });
    String currentPageStr = "${_currentPage + 1}";
    int maxPages = _items.length ~/ _itemsPerPage;
    String maxPagesStr = "${maxPages + 1}";

    TextStyle? pageInfoStyle = Theme.of(context).textTheme.bodySmall;
    List<Widget> pageInfo = [
      Text(pageInfoStr, style: pageInfoStyle),
    ];

    final painter = TextPainter(
      text: TextSpan(
        text: currentPageStr,
        style: pageInfoStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double currentPageWidth = painter.width;

    double buttonWidth = 30;
    double availableWidth = constraints.maxWidth - (buttonWidth * 4) - (currentPageWidth + 10) - 5;

    if (constraints.maxWidth >= widget.mobileBreakpoint) {
      final painter2 = TextPainter(
        text: TextSpan(
          text: pageInfoStr,
          style: pageInfoStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      availableWidth -= painter2.width;
    }

    availableWidth = min(availableWidth, 300);
    Color backgrondFilterColor = Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).canvasColor;

    List<Widget> navigator = [
      SizedBox(
        width: isMobile ? null : availableWidth,
        child: ThemedSelectInput<int?>(
          labelText: t('layrz.table.paginator.rowsPerPage'),
          dense: true,
          customChild: isMobile
              ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                    color: backgrondFilterColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(MdiIcons.filter, color: isDark ? Colors.white : Colors.black.withOpacity(0.6)),
                      Text(
                        _itemsPerPage.toString(),
                        style: pageInfoStyle,
                      ),
                    ],
                  ),
                )
              : null,
          items: [
            ThemedSelectItem(
              label: t('layrz.table.paginator.auto'),
              value: null,
            ),
            ...widget.availableRowsPerPage.map((page) {
              return ThemedSelectItem(
                value: page,
                label: page.toString(),
              );
            }),
          ],
          value: _selectedItemsPerPage,
          onChanged: (value) {
            _setItemPerPage(value?.value);
          },
        ),
      ),
      const SizedBox(width: 5),
      ThemedButton(
        labelText: t('layrz.table.paginator.start'),
        color: paginatorColor,
        style: ThemedButtonStyle.fab,
        icon: MdiIcons.chevronDoubleLeft,
        onTap: () => setState(() => _currentPage = 0),
      ),
      ThemedButton(
        labelText: t('layrz.table.paginator.previous'),
        color: paginatorColor,
        style: ThemedButtonStyle.fab,
        icon: MdiIcons.chevronLeft,
        isDisabled: _currentPage == 0,
        onTap: () {
          if (_currentPage > 0) {
            setState(() => _currentPage -= 1);
          }
        },
      ),
      const SizedBox(width: 5),
      Text("$currentPageStr/$maxPagesStr", style: pageInfoStyle),
      const SizedBox(width: 5),
      ThemedButton(
        labelText: t('layrz.table.paginator.next'),
        color: paginatorColor,
        style: ThemedButtonStyle.fab,
        icon: MdiIcons.chevronRight,
        isDisabled: _currentPage == maxPages,
        onTap: () {
          if (_currentPage < maxPages) {
            setState(() => _currentPage += 1);
          }
        },
      ),
      ThemedButton(
        labelText: t('layrz.table.paginator.end'),
        color: paginatorColor,
        style: ThemedButtonStyle.fab,
        icon: MdiIcons.chevronDoubleRight,
        onTap: () => setState(() => _currentPage = _items.length ~/ _itemsPerPage),
      ),
    ];

    if (constraints.maxWidth < widget.mobileBreakpoint) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: pageInfo,
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: navigator,
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...pageInfo,
        const SizedBox(width: 5),
        ...navigator,
      ],
    );
  }

  /// This function is used to set the number of items per page in `_buildVerySmallPaginator` and `_buildWebPaginator`
  _setItemPerPage(int? value) {
    int? prevValue = _selectedItemsPerPage;

    _itemsPerPage = value ?? _calculatedItemsPerPage;
    _selectedItemsPerPage = value;
    _isUserChangeItemsPerPage = true;

    if (_selectedItemsPerPage != prevValue) {
      _currentPage = 0;
    }
    setState(() {});
  }

  /// [_getRows] gets the rows to display.
  List<T> _getRows(int firstRowIndex, int rowsPerPage) {
    final List<T> result = [];

    for (int index = firstRowIndex; index < firstRowIndex + rowsPerPage; index++) {
      if (index >= _items.length) {
        break;
      }
      result.add(_items[index]);
    }
    return result;
  }

  /// [t] is a wrapper to handle the translations using first the [LayrzAppLocalizations]
  /// and then the custom labels
  ///
  /// You can replace variables in the translation using the following format: `{variableName}`
  /// The variables changes depending of the implementation in this component.
  String t(String key, [Map<String, dynamic> args = const {}]) {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.maybeOf(context);

    if (i18n != null) {
      return i18n.t(key, args);
    }

    String? result;
    if (_getEquivalence(key) != key) {
      result = _getEquivalence(key);
    }

    result ??= 'Missing translation for key $key : $args';

    args.forEach((key, value) => result = result!.replaceAll('{$key}', value.toString()));
    return result!;
  }

  /// [tc] is a translation helper for singular / plural detection
  /// Works similar to [t] but with the difference that this method
  /// will detect if the translation should be singular or plural
  ///
  /// To a correct use of this method, your translation should be
  /// in the following format: `singular | plural`
  /// Is important to have the ` | ` character with the spaces before and after to work correctly
  ///
  /// For example: `You have {count} item | You have {count} items`
  String tc(String key, int count, {Map<String, dynamic> args = const {}}) {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.maybeOf(context);

    if (i18n != null) {
      return i18n.tc(key, count, args);
    }

    String? result;
    if (_getEquivalence(key) != key) {
      result = _getEquivalence(key);
    }

    result ??= 'Missing translation for key $key : $args';

    args.forEach((key, value) => result = result!.replaceAll('{$key}', value.toString()));

    List<String> parts = result!.split(' | ');
    if (parts.length == 2) {
      return count == 1 ? parts[0] : parts[1];
    }

    return result!;
  }

  /// Validates the multi selection dialog, depends of the number of selected items and
  /// the property [minSelectionsBeforeDialog]
  /// If the number of selected items is greater than [minSelectionsBeforeDialog] the dialog will be shown
  /// otherwise the dialog will be destroyed
  void _validateSelection() {
    widget.onSelectedItemsChanged?.call(context, _selectedItems);
    if (!widget.enableMultiSelectDialog) {
      return;
    }

    setState(() {});

    if (_selectedItems.length >= widget.minSelectionsBeforeDialog) {
      _buildOverlay();
    } else {
      _destroyOverlay();
    }
  }

  /// Builds the overlay using the [overlayEntry] property
  /// If the [overlayEntry] is not null, the method will return without doing anything
  /// Otherwise, the overlay will be built
  void _buildOverlay() {
    if (_overlayEntry != null) {
      return;
    }

    double width = MediaQuery.sizeOf(context).width * 0.8;
    if (width > 500) {
      width = 500;
    }

    _overlayEntry = OverlayEntry(
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
                      scale: Tween<double>(begin: 0.3, end: 1).animate(
                        CurvedAnimation(
                          parent: _animation,
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        t('helpers.multipleSelection.title'),
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    ThemedButton(
                                      style: ThemedButtonStyle.filledTonalFab,
                                      icon: MdiIcons.close,
                                      color: isDark ? Colors.white : Colors.black,
                                      labelText: t('helpers.multipleSelection.actions.cancel'),
                                      isLoading: widget.isLoading,
                                      isCooldown: widget.isCooldown,
                                      onCooldownFinish: widget.onCooldown,
                                      onTap: () {
                                        _destroyOverlay(callback: () {
                                          setState(() => _selectedItems = []);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  t('helpers.multipleSelection.caption'),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: width,
                                  child: SingleChildScrollView(
                                    reverse: true,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
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
                                              _destroyOverlay(callback: () {
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
                                            style: ThemedButtonStyle.filled,
                                            color: Colors.red,
                                            icon: MdiIcons.trashCan,
                                            labelText: t('helpers.multipleSelection.actions.delete'),
                                            isLoading: widget.isLoading,
                                            isCooldown: widget.isCooldown,
                                            onCooldownFinish: widget.onCooldown,
                                            onTap: () {
                                              _destroyOverlay(
                                                callback: () async {
                                                  bool confirmation = await deleteConfirmationDialog(
                                                    context: context,
                                                    isMultiple: true,
                                                    isCooldown: widget.isCooldown,
                                                    isLoading: widget.isLoading,
                                                    onCooldown: widget.onCooldown,
                                                  );

                                                  if (confirmation && mounted) {
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

    Overlay.of(context).insert(_overlayEntry!);
    _animation.forward();
  }

  /// Destroys the overlay using the [_overlayEntry] property
  void _destroyOverlay({VoidCallback? callback}) async {
    await _animation.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
    callback?.call();
  }

  /// [_getEquivalence] gets the equivalence value of a translation key using the different
  /// new properties
  String _getEquivalence(String key) {
    if (key == 'layrz.table.paginator.start') return widget.paginatorStartText;
    if (key == 'layrz.table.paginator.previous') return widget.paginatorPreviousText;
    if (key == 'layrz.table.paginator.showing') return widget.paginatorShowingText;
    if (key == 'layrz.table.paginator.next') return widget.paginatorNextText;
    if (key == 'layrz.table.paginator.end') return widget.paginatorEndText;
    if (key == 'layrz.table.paginator.auto') return widget.paginatorAutoText;
    if (key == 'layrz.table.paginator.rowsPerPage') return widget.paginatorRowsPerPageText;
    if (key == 'helpers.buttons.show') return widget.showButtonLabelText;
    if (key == 'helpers.buttons.edit') return widget.editButtonLabelText;
    if (key == 'helpers.buttons.delete') return widget.deleteButtonLabelText;
    if (key == 'helpers.actions') return widget.actionsLabelText;
    if (key == 'helpers.search') return widget.searchLabelText;
    if (key == 'helpers.multipleSelection.title') return widget.multiSelectionTitleText;
    if (key == 'helpers.multipleSelection.caption') return widget.multiSelectionContentText;
    if (key == 'helpers.multipleSelection.actions.cancel') return widget.multiSelectionCancelLabelText;
    if (key == 'helpers.multipleSelection.actions.delete') return widget.multiSelectionDeleteLabelText;
    if (key == '${widget.module}.title.list') return widget.tableTitleText;
    if (key == '${widget.module}.title.new') return widget.addButtonLabelText;
    if (key == 'helpers.refresh') return widget.refreshButtonLabelText;

    return key;
  }
}

class _CalculatedThings<T> {
  final bool hasHorizontalScroll;
  final Map<int, double> sizes;
  final List<T> items;

  _CalculatedThings({
    required this.hasHorizontalScroll,
    required this.sizes,
    required this.items,
  });

  _CalculatedThings<T> copyWith({
    bool? hasHorizontalScroll,
    Map<int, double>? sizes,
    List<T>? items,
  }) {
    return _CalculatedThings<T>(
      hasHorizontalScroll: hasHorizontalScroll ?? this.hasHorizontalScroll,
      sizes: sizes ?? this.sizes,
      items: items ?? this.items,
    );
  }
}
