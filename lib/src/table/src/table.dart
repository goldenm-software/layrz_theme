part of '../table.dart';

bool kThemedTableCanTrue(BuildContext context, item) => true;

class ThemedTable<T> extends StatefulWidget {
  /// Represents the columns or headers of the table. This columns only will be displayed in desktop size.
  /// For mobile mode, refer to the [rowTitleBuilder], [rowSubtitleBuilder] and [rowAvatarBuilder] properties.
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

  /// Represents the builders of row avatar when the table is in mobile size.
  /// This will appear at the left of the row, before the title and subtitle.
  final ThemedTableAvatar Function(BuildContext, List<ThemedColumn<T>>, T)? rowAvatarBuilder;

  /// Represents the builders of row title when the table is in mobile size.
  /// This will appear at the center of the row, after the avatar and above the subtitle.
  /// This widget returned will be inside in a [Expanded][Column] widget.
  final Widget Function(BuildContext, List<ThemedColumn<T>>, T)? rowTitleBuilder;

  /// Represents the builders of row subtitle when the table is in mobile size.
  /// This will appear at the center of the row, after the title and below the avatar.
  /// This widget returned will be inside in a [Expanded][Column] widget.
  final Widget Function(BuildContext, List<ThemedColumn<T>>, T)? rowSubtitleBuilder;

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
    @Deprecated('This property was removed, submitting it does not work') this.rowAvatarBuilder,
    @Deprecated('This property was removed, submitting it does not work') this.rowTitleBuilder,
    @Deprecated('This property was removed, submitting it does not work') this.rowSubtitleBuilder,
    required this.idBuilder,
    this.multiSelectionEnabled = true,
    this.multiSelectionActions = const [],
    this.minSelectionsBeforeDialog = 2,
    this.mobileBreakpoint = kExtraSmallGrid,
    this.isLoading = false,
    this.isCooldown = false,
    this.onCooldown,
    this.onRefresh,
    @Deprecated(
      'You can remove it safely. '
      'To support this feature, you must use the following new properties: '
      ' - `paginatorStartText` to customize the text of the first page button '
      ' - `paginatorPreviousText` to customize the text of the previous page button '
      ' - `paginatorShowingText` to customize the text of the showing items label '
      ' - `paginatorNextText` to customize the text of the next page button '
      ' - `paginatorEndText` to customize the text of the last page button '
      ' - `paginatorAutoText` to customize the text of the fit screen button '
      ' - `paginatorRowsPerPageText` to customize the text of the rows per page label '
      ' - `showButtonLabelText` to customize the text of the show button '
      ' - `editButtonLabelText` to customize the text of the edit button '
      ' - `deleteButtonLabelText` to customize the text of the delete button '
      ' - `actionsLabelText` to customize the text of the actions label '
      ' - `searchLabelText` to customize the text of the search label ',
    )
    this.customTranslations = const {
      'layrz.table.paginator.start': 'First page',
      'layrz.table.paginator.previous': 'Previous page',
      'layrz.table.paginator.showing': 'Showing {count} of {total}',
      'layrz.table.paginator.next': 'Next page',
      'layrz.table.paginator.end': 'Last page',
      'layrz.table.paginator.auto': 'Fit screen',
      'layrz.table.paginator.rowsPerPage': 'Rows per page',
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
    @Deprecated('This property was removed, submitting it does not work') this.mobileRowHeight = 72.0,
    this.idLabel = 'ID',
    this.customTitleText,
    this.rowHeight = 40.0,
    @Deprecated('This property was removed, submitting it does not work') this.initialPage = 0,
    @Deprecated('This property was removed, submitting it does not work') this.onPageChanged,
    @Deprecated('This property was removed, submitting it does not work') this.enablePaginator = true,
    @Deprecated('Use `rowsPerPage` instead '
        'This property was removed, submitting it does not work.')
    this.itemsPerPage,
    @Deprecated('This property was removed, submitting it does not work') this.paginatorLeading,
    @Deprecated('This property was removed, submitting it does not work') this.paginatorTrailing,
    this.onIdTap,
    @Deprecated('This property was removed, submitting it does not work') this.shouldExpand = true,
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
    Color color = Theme.of(context).primaryColor;

    if (isDark && !useBlack(color: color)) {
      return Colors.white;
    }
    return color;
  }

  /// [actionsEnabled] predicts if the actions should be displayed.
  bool get actionsEnabled {
    return widget.onShow != null || widget.onEdit != null || widget.onDelete != null;
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
  int _sortBy = -2;

  /// [_sortAsc] represents the direction of the sort.
  /// If this value is true, the sort is ascending.
  bool _sortAsc = true;

  /// [_actionSize] represents the size of the actions individual buttons.
  double get _actionSize => 40;

  /// [_idWidth] represents the width of the id column.
  /// This is used to calculate the width of the table.
  double get _idWidth {
    if (!widget.idEnabled) {
      return 0;
    }

    return 80;
  }

  /// [_idIndex] is the index of the id column.
  int get _idIndex => -2;

  /// [_checkboxWidth] represents the width of the checkbox column.
  /// This is used to calculate the width of the table.
  double get _checkboxWidth {
    if (!widget.multiSelectionEnabled) {
      return 0;
    }

    return 60;
  }

  /// [border] refers to the style of the border of the cells.
  BorderSide get border => BorderSide(
        // color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        color: Theme.of(context).dividerColor,
        width: 1.5,
      );

  /// [_selectedItems] represents the list of selected items.
  List<T> _selectedItems = [];

  /// [_isAllSelected] represents if all the items are selected.
  bool get _isAllSelected => _selectedItems.length == _items.length;

  /// [_horizontalScroll] represents the scroll controller of the table.
  final ScrollController _horizontalScroll = ScrollController();

  /// [_verticalScroll] represents the scroll controller of the table.
  final ScrollController _verticalScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _searchText = widget.searchText;

    if (!widget.idEnabled) {
      _sortBy = 0;
    }

    _items = widget.items;
    _sort();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    debugPrint("Items: ${widget.items.length} - $_searchText");
    _items = widget.items;
    _sort();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateRowsPerPage();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  didChangeMetrics() {
    _calculateRowsPerPage();
  }

  /// [_predictSizes] predicts the sizes of the columns.
  Map<String, dynamic> _predictSizes({
    required BoxConstraints constraints,
    required List<T> items,
    required bool multiSelectionEnabled,
  }) {
    Map<int, double> sizes = {
      -3: _checkboxWidth,
      _idIndex: _idWidth,
      -1: 0,
    };

    if (!multiSelectionEnabled) {
      sizes[-3] = 0;
    }

    if (actionsEnabled) {
      if (constraints.maxWidth < widget.mobileBreakpoint) {
        sizes[-1] = 60;
      } else {
        double width = 0;
        if (widget.onShow != null) {
          width += _actionSize;
        }

        if (widget.onEdit != null) {
          width += _actionSize;
        }

        if (widget.onDelete != null) {
          width += _actionSize;
        }
        double additionalWidth = 0;

        for (T item in items) {
          additionalWidth = max(
            additionalWidth,
            (widget.additionalActions?.call(context, item).length ?? 0) * _actionSize,
          );
        }
        width += additionalWidth;

        sizes[-1] = max(width, 100);
      }
    }

    List<double> usedSizes = [];

    for (final entry in widget.columns.asMap().entries) {
      int index = entry.key;
      ThemedColumn<T> column = entry.value;

      sizes[index] = column.predictedHeaderSize(context, _headerStyle).width;
      usedSizes.add(sizes[index] ?? 0);
    }

    for (T item in items) {
      for (final entry in widget.columns.asMap().entries) {
        int index = entry.key;
        ThemedColumn<T> column = entry.value;

        sizes[index] = max(
          sizes[index] ?? 0,
          column.predictedContentSize(context, item, _rowStyle).width,
        );

        usedSizes[index] = sizes[index] ?? 0;
      }
    }

    double usedSize = sizes.values.reduce((value, element) => value + element);
    double emptySize = constraints.maxWidth - usedSize;

    if (emptySize > 0) {
      // Distruibute the empty space between the columns
      double size = emptySize / widget.columns.length;
      for (int index = 0; index < widget.columns.length; index++) {
        double prevSize = sizes[index] ?? 0;
        sizes[index] = prevSize + size;
      }
    }

    return {
      'hasHorizontalScroll': usedSize > constraints.maxWidth,
      'sizes': sizes,
    };
  }

  /// [_calculateRowsPerPage] calculates the number of rows per page.
  void _calculateRowsPerPage() {
    RenderBox? box = _tableKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      _itemsPerPage = widget.rowsPerPage ?? (widget.rowHeight * 10).round();
    } else {
      _itemsPerPage = widget.rowsPerPage ?? (box.size.height / widget.rowHeight).floor();
    }
    _calculatedItemsPerPage = _itemsPerPage;
  }

  /// [_sort] sorts the items.
  void _sort() {
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

      if (_sortBy == _idIndex) {
        // deafult sort when there are no columns selected
        aValue = int.tryParse(widget.idBuilder(context, a)) ?? 0;
        bValue = int.tryParse(widget.idBuilder(context, b)) ?? 0;
      } else {
        ThemedColumn<T> column = widget.columns[_sortBy];

        if (column.customSortingFunction != null) {
          // debugPrint("Sorting using custom function");
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
      }
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < widget.mobileBreakpoint;
        bool multiSelectionEnabled = widget.multiSelectionEnabled;

        if (isMobile) {
          multiSelectionEnabled = false;
        }

        final items = _getRows(_currentPage * _itemsPerPage, _itemsPerPage);
        final prediction = _predictSizes(
          constraints: constraints,
          items: items,
          multiSelectionEnabled: multiSelectionEnabled,
        );

        final hasHorizontalScroll = prediction['hasHorizontalScroll'] as bool;
        final sizes = prediction['sizes'] as Map<int, double>;

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
                // Search text
                ThemedSearchInput(
                  value: _searchText,
                  labelText: t('helpers.search'),
                  onSearch: (value) {
                    setState(() => _searchText = value);
                    _sort();
                  },
                ),

                // Actions
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
                trackVisibility: !isMobile && hasHorizontalScroll,
                thumbVisibility: !isMobile && hasHorizontalScroll,
                child: Scrollbar(
                  controller: _verticalScroll,
                  notificationPredicate: (notif) => notif.depth == 1,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
                                            }).toList(),
                                            if (actionsEnabled) ...[
                                              _drawCell(
                                                index: -1,
                                                alignment: Alignment.centerRight,
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
                                                sizes: sizes,
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                    }).toList(),
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
            ),
            const SizedBox(height: 5),
            _buildPaginator(constraints: constraints),
          ],
        );
      },
    );
  }

  Widget _buildPaginator({required BoxConstraints constraints}) {
    String pageInfoStr = t('layrz.table.paginator.showing', {
      'count': _itemsPerPage,
      'total': _items.length,
    });
    String currentPageStr = "${_currentPage + 1}";

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

    List<Widget> navigator = [
      SizedBox(
        width: availableWidth,
        child: ThemedSelectInput<int?>(
          labelText: t('layrz.table.paginator.rowsPerPage'),
          dense: true,
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
            }).toList(),
          ],
          onChanged: (value) {
            setState(() {
              _itemsPerPage = value?.value ?? _calculatedItemsPerPage;
            });
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
      Text(currentPageStr, style: pageInfoStyle),
      const SizedBox(width: 5),
      ThemedButton(
        labelText: t('layrz.table.paginator.next'),
        color: paginatorColor,
        style: ThemedButtonStyle.fab,
        icon: MdiIcons.chevronRight,
        isDisabled: _currentPage == (_items.length ~/ _itemsPerPage),
        onTap: () {
          if (_currentPage < (_items.length ~/ _itemsPerPage)) {
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
      width: width,
      height: widget.rowHeight,
      alignment: column.alignment,
      padding: ThemedColumn.padding,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: border.color,
            width: 3,
          ),
          left: borderLeft,
        ),
      ),
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
    );

    if (column.isSortable) {
      return InkWell(
        onTap: () {
          if (_sortBy == index) {
            _sortAsc = !_sortAsc;
          } else {
            _sortBy = index;
            _sortAsc = true;
          }
          _sort();
        },
        child: itm,
      );
    }

    return itm;
  }

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
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);

    if (i18n != null) {
      return i18n.t(key, args);
    }

    String? result;
    if (_getEquivalence(key) != key) {
      result = _getEquivalence(key);
    }

    if (result == null && widget.customTranslations.containsKey(key)) {
      result = widget.customTranslations[key]!;
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
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);

    if (i18n != null) {
      return i18n.tc(key, count, args);
    }

    String? result;
    if (_getEquivalence(key) != key) {
      result = _getEquivalence(key);
    }

    if (result == null && widget.customTranslations.containsKey(key)) {
      result = widget.customTranslations[key]!;
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

    double width = MediaQuery.of(context).size.width * 0.8;
    if (width > 500) {
      width = 500;
    }

    ScrollController actionsController = ScrollController();

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
                                    controller: actionsController,
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
