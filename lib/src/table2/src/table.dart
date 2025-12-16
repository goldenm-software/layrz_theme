part of '../table2.dart';

class ThemedTable2<T> extends StatefulWidget {
  /// [items] is the list of data objects to display in the table.
  final List<T> items;

  /// [columns] defines the columns of the table, including their headers and value builders.
  final List<ThemedColumn2<T>> columns;

  /// [actionsBuilder] is an optional function that returns a list of action buttons for each item.
  final List<ThemedActionButton> Function(T item)? actionsBuilder;

  /// [actionsMobileBreakpoint] sets the screen width at which the actions column switches to mobile layout.
  final double actionsMobileBreakpoint;

  /// [headerHeight] sets the height of the table header row.
  final double headerHeight;

  /// [actionsLabelText] is the label shown for the actions column.
  final String actionsLabelText;

  /// [hasMultiselect] enables or disables the multi-select checkbox column.
  final bool hasMultiselect;

  /// [actionsCount] is the maximum number of actions per row. if you expect 5 actions in a single row, the expected
  /// value is 5.
  ///
  /// If the supplied value is 0, it will be ignored as column.
  final int actionsCount;

  /// [loadingLabelText] is the text shown while the table is loading or computing data.
  final String loadingLabelText;

  /// [canSearch] enables or disables the search input above the table.
  final bool canSearch;

  /// [minColumnWidth] sets the minimum width for each column when calculating flexible widths.
  final double minColumnWidth;

  /// [multiSelectionTitleText] replaces the text of the multi selection title.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String multiSelectionTitleText;

  /// [multiSelectionContentText] replaces the text of the multi selection content.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String multiSelectionContentText;

  /// [multiSelectionCancelLabelText] replaces the text of the multi selection cancel button.
  /// This property only will work when `LayrzAppLocalizations` is null.
  final String multiSelectionCancelLabelText;

  /// [multiselectActions] is a list of action buttons that will be shown when one or more items are selected.
  ///
  /// Consider that the list will be appened with the clear button
  final List<ThemedActionButton> multiselectActions;

  /// [multiselectValue] is the value change listener for the multi-select checkbox list.
  final ValueNotifier<List<T>>? multiselectValue;

  /// [populateDelay] is the delay in milliseconds before populating the table with data.
  final Duration populateDelay;

  /// [reloadOnDidUpdate] if true, the table will reload its data when the widget is updated.
  /// This is useful on development stages to see changes on hot reload.
  /// Defaults to false.
  ///
  /// Note: This property is ignored on production builds.
  final bool reloadOnDidUpdate;

  /// [onTapDefaultBehavior] sets the default behavior for onTap events on table cells.
  final ThemedTable2OnTapBehavior onTapDefaultBehavior;

  /// [copyToClipboardText] is the title shown when copying to clipboard.
  /// By default, it will uses the translation key `helpers.copiedToClipboard`.
  /// In case the translation does not exists, it will fallback to this property, and if is not supplied,
  /// it will fallback to the constant text `"Copied to clipboard"`.
  final String? copyToClipboardText;

  /// [controller] is an optional controller to programmatically control the table.
  final ThemedTable2Controller<T>? controller;

  const ThemedTable2({
    required this.items,
    required this.columns,
    super.key,
    this.actionsBuilder,
    this.actionsMobileBreakpoint = kSmallGrid,
    this.headerHeight = 40,
    this.actionsLabelText = "Actions",
    this.hasMultiselect = true,
    this.actionsCount = 0,
    this.loadingLabelText = "Computing data, please wait...",
    this.canSearch = true,
    this.minColumnWidth = 250,
    this.multiselectActions = const [],
    this.multiSelectionTitleText = "Multiple items selected",
    this.multiSelectionContentText = "You have selected multiple items. What do you want to do?",
    this.multiSelectionCancelLabelText = "Clear",
    this.multiselectValue,
    this.populateDelay = const Duration(milliseconds: 150),
    this.reloadOnDidUpdate = false,
    this.onTapDefaultBehavior = .copyToClipboard,
    this.copyToClipboardText,
    this.controller,
  }) : assert(columns.length > 0, 'Columns cant be empty'),
       assert(actionsCount >= 0, 'Actions count cant be negative'),
       assert(minColumnWidth > 0, 'Min column width must be greater than 0'),
       assert(
         actionsCount == 0 || actionsBuilder != null,
         'If actionsCount is greater than 0, actionsBuilder must be provided',
       ),
       assert(
         (multiselectActions.length > 0 && hasMultiselect) || !hasMultiselect,
         'If hasMultiselect is true, multiselectActions must be provided',
       );

  @override
  State<ThemedTable2<T>> createState() => _ThemedTable2State<T>();
}

class _ThemedTable2State<T> extends State<ThemedTable2<T>> {
  bool get isDark => Theme.of(context).brightness == .dark;

  /// [_stripColor] represents the color of the strip item.
  Color get _stripColor => isDark ? Colors.grey.shade900 : Colors.grey.shade100;

  /// [_verticalScrollControllerGroup] groups the vertical scroll controllers
  late final SyncScrollControllerGroup _verticalScrollControllerGroup;

  /// [_multiselectController] controls the multi-select checkbox list scroll
  late final ScrollController _multiselectController;

  /// [_contentController] controls the main content scroll
  late final ScrollController _contentController;

  /// [_actionsController] controls the actions scroll
  late final ScrollController _actionsController;

  /// [_horizontalScrollControllerGroup] groups the horizontal scroll controllers
  late final SyncScrollControllerGroup _horizontalScrollControllerGroup;

  /// [_horizontalHeaderController] controls the horizontal scroll
  late final ScrollController _horizontalHeaderController;

  /// [_horizontalContentController] controls the horizontal scroll
  late final ScrollController _horizontalContentController;

  /// [_padding] represents the standard padding for the cells
  EdgeInsets get _padding => const .symmetric(horizontal: 10);

  /// [_actionsPadding] represents the standard padding for the action cells
  EdgeInsets get _actionsPadding => const .only(left: 5);

  /// [_style] represents the standard text style for the cells
  TextStyle? get _style => Theme.of(context).textTheme.bodyMedium;

  /// [_sortIconSize] is the size of the sort icon
  double get _sortIconSize => 16;

  /// [_searchController] holds the current search query used to filter items.
  final TextEditingController _searchController = TextEditingController();

  /// [_filteredData] holds the filtered and sorted data currently displayed in the table.
  final ValueNotifier<List<T>> _filteredData = ValueNotifier([]);

  /// [_itemsStrings] holds a precomputed list of string representations of the items for efficient searching.
  Map<int, Map<int, String>> _itemsStrings = {};

  /// [_colSelected] is the currently selected column used for sorting.
  late ThemedColumn2<T> _colSelected;

  /// [_debounce] is a timer used to debounce the search input.
  Timer? _debounce;

  /// [_isReversed] indicates whether the current sort order is descending (true) or ascending (false).
  bool _isReversed = false;

  /// [_isLoading] indicates whether the table is currently loading or computing data.
  final ValueNotifier<bool> _isLoading = .new(false);

  /// [_selectedItems] holds the list of currently selected items in multi-select mode.
  late ValueNotifier<List<T>> _selectedItems;

  @override
  void initState() {
    super.initState();
    _colSelected = widget.columns.first;

    _horizontalScrollControllerGroup = SyncScrollControllerGroup();
    _horizontalContentController = _horizontalScrollControllerGroup.addAndGet();
    _horizontalHeaderController = _horizontalScrollControllerGroup.addAndGet();

    _verticalScrollControllerGroup = SyncScrollControllerGroup();
    _multiselectController = _verticalScrollControllerGroup.addAndGet();
    _contentController = _verticalScrollControllerGroup.addAndGet();
    _actionsController = _verticalScrollControllerGroup.addAndGet();

    _selectedItems = widget.multiselectValue ?? .new([]);

    widget.controller?.addListener(_onControllerEvent);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _filterAndSort('INIT_STATE');
    });
  }

  @override
  void didUpdateWidget(covariant ThemedTable2<T> oldWidget) {
    final eq = const DeepCollectionEquality().equals;
    final bool c1 = !eq(oldWidget.items, widget.items);
    final bool c2 = !eq(oldWidget.columns, widget.columns);
    final bool c3 = oldWidget.actionsCount != widget.actionsCount;
    final bool c4 = oldWidget.canSearch != widget.canSearch;
    bool c5 = false;
    if (kDebugMode && widget.reloadOnDidUpdate) c5 = true;

    if (c1 || c2 || c3 || c4 || c5) _filterAndSort('DID_UPDATE');
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _filterAndSort(String source) async {
    debugPrint("layrz_theme/ThemedTable2: Starting _filterAndSortAsync from $source...");
    if (_isLoading.value) {
      debugPrint('layrz_theme/ThemedTable2: Skipping _filterAndSortAsync from $source because is already loading');
      return;
    }

    _isLoading.value = true;
    await Future.delayed(widget.populateDelay);
    try {
      List<T> items = .from(widget.items, growable: true);
      if (items.isEmpty) {
        debugPrint("layrz_theme/ThemedTable2: No items to filter and sort from $source.");
        _filteredData.value = items;
        return;
      }

      debugPrint("layrz_theme/ThemedTable2: Precomputing data from $source...");
      _itemsStrings = {};
      for (final item in widget.items) {
        int rowHashCode = item.hashCode;
        _itemsStrings[rowHashCode] = {};

        for (final col in widget.columns) {
          final colHashCode = col.hashCode;
          _itemsStrings[rowHashCode]![colHashCode] = col.valueBuilder(item);
        }
      }

      if (_searchController.text.isNotEmpty) {
        debugPrint("layrz_theme/ThemedTable2: Filtering data from $source...");
        final searchLower = _searchController.text.toLowerCase();
        items = items.where((row) {
          final rowHashCode = row.hashCode;
          final cols = _itemsStrings[rowHashCode];
          if (cols == null) return false;
          for (final entry in cols.entries) {
            if (entry.value.toLowerCase().contains(searchLower)) return true;
          }
          return false;
        }).toList();
      }

      debugPrint("layrz_theme/ThemedTable2: Sorting data...");

      _filteredData.value = await compute(
        _sort,
        _SortParams<T>(
          items: items,
          column: _colSelected.isolateSafety,
          isReversed: _isReversed,
          itemsStrings: _itemsStrings,
        ),
      );
    } finally {
      debugPrint("layrz_theme/ThemedTable2: Finished filtering and sorting from $source.");
      _isLoading.value = false;
      if (mounted) WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _isLoading.dispose();
    _filteredData.dispose();
    _searchController.dispose();

    _debounce?.cancel();

    _multiselectController.dispose();
    _contentController.dispose();
    _actionsController.dispose();

    _horizontalHeaderController.dispose();
    _horizontalContentController.dispose();

    widget.controller?.removeListener(_onControllerEvent);

    super.dispose();
  }

  void _onControllerEvent(ThemedTable2Event event) {
    if (event is ThemedTable2SortEvent<T>) {
      final columnIndex = event.columnIndex;
      final ascending = event.ascending;

      if (columnIndex < 0 || columnIndex >= widget.columns.length) {
        debugPrint('layrz_theme/ThemedTable2: Invalid column index $columnIndex for sorting');
        return;
      }

      _colSelected = widget.columns[columnIndex];
      _isReversed = !ascending;

      _filterAndSort('CONTROLLER_SORT');
      return;
    }

    if (event is ThemedTable2RefreshEvent<T>) {
      _filterAndSort('CONTROLLER_REFRESH');
      return;
    }

    debugPrint('layrz_theme/ThemedTable2: Unknown controller event type: ${event.runtimeType}');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (context, value, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < widget.actionsMobileBreakpoint;
            Map<int, double> sizes = {};
            double actionsSize;
            if (isMobile) {
              actionsSize = ThemedButton.defaultHeight + _padding.horizontal;
            } else {
              actionsSize = widget.actionsCount * (ThemedButton.defaultHeight + _actionsPadding.horizontal);
              actionsSize += _padding.horizontal;
            }

            double maxWidth = constraints.maxWidth;
            if (widget.hasMultiselect) {
              maxWidth -= 50;
              maxWidth -= 1; // Divider
            }
            if (widget.actionsCount > 0) {
              maxWidth -= actionsSize;
              maxWidth -= 1; // Divider
            }

            double availableWidth = maxWidth;

            int fixedColumns = 0;
            for (final entry in widget.columns.asMap().entries) {
              final col = entry.value;

              if (col.width != null) {
                fixedColumns++;
                sizes[entry.key] = col.width! - 1; // Divider
                availableWidth -= col.width! - 1; // Divider
              }
            }

            int flexColumns = widget.columns.length - fixedColumns;
            double flexWidth = flexColumns > 0 ? availableWidth / flexColumns : 0;
            if (flexWidth < widget.minColumnWidth) flexWidth = widget.minColumnWidth;

            for (final entry in widget.columns.asMap().entries) {
              final col = entry.value;

              if (col.width == null) {
                sizes[entry.key] = flexWidth - 1; // Divider
              }
            }

            return Column(
              children: [
                // Search
                if (widget.canSearch) ...[
                  SizedBox(
                    width: .infinity,
                    child: ThemedTextInput(
                      labelText: LayrzAppLocalizations.maybeOf(context)?.t('actions.search') ?? 'Search...',
                      prefixIcon: LayrzIcons.solarOutlineMagnifier,
                      padding: .zero,
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      dense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_debounce?.isActive ?? false) ...[
                    LinearProgressIndicator(
                      value: null,
                      minHeight: 2,
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                      backgroundColor: Colors.transparent,
                    ),
                  ] else ...[
                    const SizedBox(height: 2),
                  ],
                  const SizedBox(height: 8),
                ],
                if (value) ...[
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 10),
                          Text(widget.loadingLabelText, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  //
                  // Header
                  SizedBox(
                    height: widget.headerHeight,
                    child: Row(
                      children: [
                        /// Multiselect
                        if (widget.hasMultiselect) ...[
                          SizedBox(
                            width: 50,
                            child: ValueListenableBuilder(
                              valueListenable: _selectedItems,
                              builder: (context, value, child) {
                                return Checkbox(
                                  value: value.length == widget.items.length && widget.items.isNotEmpty,
                                  onChanged: (val) {
                                    if (val == true) {
                                      _selectedItems.value = .from(widget.items);
                                    } else {
                                      _selectedItems.value = [];
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          const VerticalDivider(width: 1),
                        ],

                        /// Items
                        ScrollConfiguration(
                          behavior: const ScrollBehavior().copyWith(scrollbars: false),
                          child: Expanded(
                            child: ListView.builder(
                              scrollDirection: .horizontal,
                              controller: _horizontalHeaderController,
                              physics: const ClampingScrollPhysics(),
                              itemCount: widget.columns.length,
                              itemBuilder: (context, index) {
                                final ThemedColumn2<T> entry = widget.columns[index];
                                final bool isSelected = entry == _colSelected;

                                return Row(
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          if (isSelected) {
                                            _isReversed = !_isReversed;
                                          } else {
                                            _colSelected = entry;
                                            _isReversed = false;
                                          }

                                          _filterAndSort('SORT');
                                        },
                                        child: Container(
                                          width: sizes[index]! - (index < widget.columns.length - 1 ? 1 : 0),
                                          padding: _padding,
                                          alignment: entry.alignment,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                if (isSelected) ...[
                                                  WidgetSpan(
                                                    alignment: .middle,
                                                    child: Icon(
                                                      _isReversed
                                                          ? LayrzIcons.solarBoldSortFromBottomToTop
                                                          : LayrzIcons.solarBoldSortFromTopToBottom,
                                                      size: _sortIconSize,
                                                      color: Theme.of(context).textTheme.bodyMedium?.color,
                                                    ),
                                                  ),
                                                  const WidgetSpan(child: SizedBox(width: 5)),
                                                ],

                                                TextSpan(
                                                  text: entry.headerText,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium?.copyWith(fontWeight: .bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (index < widget.columns.length - 1) const VerticalDivider(width: 1),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),

                        /// Actions
                        if (widget.actionsCount > 0) ...[
                          const VerticalDivider(width: 1),
                          Container(
                            width: actionsSize,
                            padding: _padding,
                            alignment: .centerRight,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    alignment: .middle,
                                    child: Icon(
                                      LayrzIcons.solarOutlineTuningSquare2,
                                      size: _sortIconSize,
                                      color: Theme.of(context).textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                  const WidgetSpan(child: SizedBox(width: 5)),
                                  TextSpan(
                                    text: widget.actionsLabelText,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: .bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // /Header
                  const Divider(height: 1),
                  // Content
                  Expanded(
                    child: Row(
                      children: [
                        if (widget.hasMultiselect) ...[
                          SizedBox(
                            width: 50,
                            child: ScrollConfiguration(
                              behavior: const ScrollBehavior().copyWith(scrollbars: false),
                              child: ValueListenableBuilder(
                                valueListenable: _filteredData,
                                builder: (context, value, child) {
                                  return ListView.builder(
                                    itemCount: value.length,
                                    itemExtent: 50,
                                    controller: _multiselectController,
                                    itemBuilder: (context, index) {
                                      final item = value[index];
                                      return Container(
                                        padding: _padding,
                                        color: index % 2 == 0 ? null : _stripColor,
                                        child: ValueListenableBuilder(
                                          valueListenable: _selectedItems,
                                          builder: (context, value, child) {
                                            return Checkbox(
                                              value: value.contains(item),
                                              onChanged: (val) {
                                                if (val == true) {
                                                  if (!value.contains(item)) _selectedItems.value = [...value, item];
                                                } else {
                                                  if (value.contains(item)) {
                                                    _selectedItems.value = value.where((i) => i != item).toList();
                                                  }
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          const VerticalDivider(width: 1),
                        ],

                        /// Items.value
                        Expanded(
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: _horizontalContentController,
                            child: ScrollConfiguration(
                              behavior: const ScrollBehavior().copyWith(scrollbars: true),
                              child: SingleChildScrollView(
                                scrollDirection: .horizontal,
                                controller: _horizontalContentController,

                                child: ScrollConfiguration(
                                  behavior: const ScrollBehavior().copyWith(scrollbars: false),
                                  child: SizedBox(
                                    width: sizes.values.sum,
                                    child: ValueListenableBuilder(
                                      valueListenable: _filteredData,
                                      builder: (context, value, child) {
                                        return ListView.builder(
                                          itemCount: value.length,
                                          itemExtent: 50,
                                          controller: _contentController,
                                          itemBuilder: (context, index) {
                                            final data = value[index];
                                            List<Widget> children = [];

                                            for (final entry in widget.columns.asMap().entries) {
                                              final header = entry.value;
                                              final colIndex = entry.key;

                                              String text =
                                                  _itemsStrings[data.hashCode]?[header.hashCode] ??
                                                  header.valueBuilder(data);

                                              Widget child;
                                              if (header.richTextBuilder != null) {
                                                child = RichText(
                                                  text: TextSpan(
                                                    children: header.richTextBuilder!.call(data),
                                                    style: _style,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: .ellipsis,
                                                );
                                              } else {
                                                child = Text(
                                                  text,
                                                  style: _style,
                                                  maxLines: 1,
                                                  overflow: .ellipsis,
                                                );
                                              }

                                              void Function(T)? onTap;
                                              if (header.onTap != null) {
                                                onTap = header.onTap;
                                              } else if (widget.onTapDefaultBehavior == .copyToClipboard) {
                                                onTap = (item) {
                                                  Clipboard.setData(ClipboardData(text: text));
                                                  String copiedText =
                                                      widget.copyToClipboardText ??
                                                      LayrzAppLocalizations.maybeOf(
                                                        context,
                                                      )?.t('helpers.copiedToClipboard') ??
                                                      "Copied to clipboard";

                                                  ThemedSnackbarMessenger.maybeOf(context)?.show(
                                                    ThemedSnackbar(
                                                      message: copiedText,
                                                      icon: LayrzIcons.solarOutlineClipboard,
                                                      color: Colors.green,
                                                    ),
                                                  );
                                                };
                                              }

                                              children.add(
                                                Material(
                                                  color: index % 2 == 0 ? null : _stripColor,
                                                  child: InkWell(
                                                    onTap: onTap != null ? () => onTap!.call(data) : null,
                                                    child: Container(
                                                      width:
                                                          sizes[colIndex]! -
                                                          (colIndex < widget.columns.length - 1 ? 1 : 0),
                                                      padding: _padding,
                                                      alignment: header.alignment,
                                                      child: child,
                                                    ),
                                                  ),
                                                ),
                                              );
                                              if (colIndex < widget.columns.length - 1) {
                                                children.add(const VerticalDivider(width: 1));
                                              }
                                            }

                                            return Row(children: children);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Actions.value
                        if (widget.actionsCount > 0) ...[
                          const VerticalDivider(width: 1),
                          SizedBox(
                            width: actionsSize,
                            child: ValueListenableBuilder(
                              valueListenable: _filteredData,
                              builder: (context, value, child) {
                                return ListView.builder(
                                  itemCount: value.length,
                                  itemExtent: 50,
                                  controller: _actionsController,
                                  itemBuilder: (context, index) {
                                    final data = value[index];
                                    return Container(
                                      padding: _padding,
                                      alignment: .centerRight,
                                      color: index % 2 == 0 ? null : _stripColor,
                                      child: ThemedActionsButtons(
                                        actions: (widget.actionsBuilder?.call(data) ?? []).map((action) {
                                          if (isMobile) return action;
                                          return action.copyWith(onlyIcon: true);
                                        }).toList(),
                                        mobileBreakpoint: widget.actionsMobileBreakpoint,
                                        actionPadding: _actionsPadding,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // /Content
                  // Actions
                  ValueListenableBuilder(
                    valueListenable: _selectedItems,
                    builder: (context, value, child) {
                      if (value.isEmpty) return const SizedBox.shrink();

                      return Container(
                        width: .infinity,
                        margin: const .all(5),
                        padding: const .all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).inputDecorationTheme.fillColor,
                          borderRadius: .circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.multiSelectionTitleText,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: .bold),
                              maxLines: 1,
                            ),
                            Text(widget.multiSelectionContentText, maxLines: 1),
                            const SizedBox(height: 10),
                            Center(
                              child: SingleChildScrollView(
                                child: Row(
                                  spacing: 5,
                                  mainAxisAlignment: .center,
                                  crossAxisAlignment: .center,
                                  children: [
                                    ThemedButton(
                                      labelText: widget.multiSelectionCancelLabelText,
                                      color: Colors.orange,
                                      icon: LayrzIcons.solarOutlineEraser,
                                      onTap: () => _selectedItems.value = [],
                                    ),
                                    ...widget.multiselectActions.map((action) {
                                      return ThemedButton(
                                        labelText: action.labelText,
                                        icon: action.icon,
                                        color: action.color,
                                        onTap: action.onTap,
                                        isLoading: action.isLoading,
                                        isCooldown: action.isCooldown,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // /Actions
                ],
              ],
            );
          },
        );
      },
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _filterAndSort('SEARCH');
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }
}

class _SortParams<T> {
  final List<T> items;
  final ThemedColumn2<T> column;
  final bool isReversed;
  final Map<int, Map<int, String>> itemsStrings;

  _SortParams({
    required this.items,
    required this.column,
    required this.isReversed,
    this.itemsStrings = const {},
  });
}

/// [_sort] sorts the given list of items based on the specified column and order.
///
/// Requires the [_SortParams] containing:
/// - [items]: The list of items to sort.
/// - [column]: The column to sort by.
/// - [isReversed]: Whether to sort in descending order.
/// - [itemsStrings]: A precomputed map of string representations of items for efficient sorting.
///
/// This function runs on an Isolated thread to ensure non-blocking UI performance, the only issue with this
/// is, you cannot use complexes objects or functions that are not sendable between isolates.
List<T> _sort<T>(_SortParams<T> params) {
  if (params.column.customSort != null) {
    params.items.sort((a, b) => params.column.customSort!.call(a, b, !params.isReversed));
  } else {
    params.items.sort(
      (a, b) => _defaultSort(
        a,
        b,
        colSelected: params.column,
        isReversed: params.isReversed,
        itemsStrings: params.itemsStrings,
      ),
    );
  }
  return params.items;
}

/// [_defaultSort] is the default sorting function used when no custom sort is provided.
int _defaultSort<T>(
  T a,
  T b, {
  required ThemedColumn2<T> colSelected,
  required bool isReversed,
  required Map<int, Map<int, String>> itemsStrings,
}) {
  final colHashCode = colSelected.hashCode;
  final rowAHashCode = a.hashCode;
  final rowBHashCode = b.hashCode;

  final valueA = itemsStrings[rowAHashCode]?[colHashCode] ?? colSelected.valueBuilder.call(a);
  final valueB = itemsStrings[rowBHashCode]?[colHashCode] ?? colSelected.valueBuilder.call(b);

  final numA = num.tryParse(valueA);
  final numB = num.tryParse(valueB);
  if (numA != null && numB != null) {
    if (numB == numA) return 0;
    if (isReversed) {
      return numB > numA ? 1 : -1;
    }
    return numA > numB ? 1 : -1;
  }

  Duration? parseDuration(String s) {
    final parts = s.split(':');
    if (parts.length > 2) {
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      int sec = 0;
      if (parts.length == 3) sec = int.tryParse(parts[2]) ?? 0;
      return Duration(hours: h, minutes: m, seconds: sec);
    }
    return null;
  }

  final durA = parseDuration(valueA);
  final durB = parseDuration(valueB);
  if (durA != null && durB != null) {
    return isReversed ? durB.compareTo(durA) : durA.compareTo(durB);
  }

  // Try to parse as DateTime
  final dateA = DateTime.tryParse(valueA);
  final dateB = DateTime.tryParse(valueB);
  if (dateA != null && dateB != null) {
    return isReversed ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
  }

  // Default: compare as string (case insensitive)
  return isReversed
      ? valueB.toLowerCase().compareTo(valueA.toLowerCase())
      : valueA.toLowerCase().compareTo(valueB.toLowerCase());
}
