part of '../table2.dart';

class ThemedTable2<T> extends StatefulWidget {
  final List<T> items;
  final List<ThemedColumn2<T>> columns;
  final List<ThemedActionButton> Function(T)? addtionalActions;
  final double actionsMobileBreakpoint;
  final double headerHeight;
  final String actionsLabelText;
  final bool hasMultiselect;
  final bool hasActions;
  final String loadingLabelText;
  final bool canSearch;

  const ThemedTable2({
    required this.items,
    required this.columns,
    super.key,
    this.addtionalActions,
    this.actionsMobileBreakpoint = kSmallGrid,
    this.headerHeight = 40,
    this.actionsLabelText = "Actions",
    this.hasMultiselect = true,
    this.hasActions = true,
    this.loadingLabelText = "Computing data, please wait...",
    this.canSearch = true,
  }) : assert(columns.length > 0, 'Columns cant be empty');

  @override
  State<ThemedTable2<T>> createState() => _ThemedTable2State<T>();
}

class _ThemedTable2State<T> extends State<ThemedTable2<T>> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Timer? _debounce;
  bool isReversed = false;

  /// [_future] holds the future for the precomputation of the table data
  Future<void>? _future;

  /// [_computedData] holds the raw data for the table after precomputation, this data is not filtered or sorted
  List<_ThemedData<T>> _computedData = [];

  /// [_sizes] holds the computed sizes for each column
  List<double> _sizes = [];

  /// [_actionSize] holds the computed size for the action column
  double _actionSize = 0;

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
  EdgeInsets get _padding => const EdgeInsets.symmetric(horizontal: 10);

  /// [_style] represents the standard text style for the cells
  TextStyle? get _style => Theme.of(context).textTheme.bodyMedium;

  /// [_availableWidth] is the maximum size of the table
  double _availableWidth = 0;

  /// [_totalSize] is the total size of the table
  double _totalSize = 0;

  /// [_layoutSize] is the size of the layout
  BoxConstraints _layoutSize = const BoxConstraints();

  /// [_selected] is the index of the selected column for sorting
  List<int> _selected = [];

  /// [_sortIconSize] is the size of the sort icon
  double get _sortIconSize => 16;

  /// [_search] holds the current search query used to filter items.
  String _search = '';

  /// [_filterComputeData]
  List<_ThemedData<T>> _filteredData = [];
  late ThemedColumn2<T> colSelected;

  @override
  void initState() {
    super.initState();
    colSelected = widget.columns.first;

    _horizontalScrollControllerGroup = SyncScrollControllerGroup();
    _horizontalContentController = _horizontalScrollControllerGroup.addAndGet();
    _horizontalHeaderController = _horizontalScrollControllerGroup.addAndGet();

    _verticalScrollControllerGroup = SyncScrollControllerGroup();
    _multiselectController = _verticalScrollControllerGroup.addAndGet();
    _contentController = _verticalScrollControllerGroup.addAndGet();
    _actionsController = _verticalScrollControllerGroup.addAndGet();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _future = _precompute('INIT_STATE');
      setState(() {});
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();

    _multiselectController.dispose();
    _contentController.dispose();
    _actionsController.dispose();

    _horizontalHeaderController.dispose();
    _horizontalContentController.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(ThemedTable2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final eq = const ListEquality().equals;
    debugPrint("Didupdat called");

    if (!eq(widget.items, oldWidget.items) ||
        !eq(widget.columns, oldWidget.columns) ||
        widget.hasActions != oldWidget.hasActions ||
        widget.hasMultiselect != oldWidget.hasMultiselect) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (_future != null) await _future;
        _future = _precompute('DID_UPDATE_WIDGET');
        _filterData();
        _sortDataAsync();
        setState(() {});
      });
    }
  }

  Future<void> _precompute(String source) async {
    debugPrint("Precomputing table data triggered by $source");
    _computedData = [];
    _sizes = [];
    _actionSize = 0;

    debugPrint("Precomputing table data for ${widget.items.length} items");
    final completer = Completer<void>();

    if (mounted) {
      completer.complete();
    } else {
      Timer.periodic(const Duration(milliseconds: 5), (timer) {
        if (mounted) {
          timer.cancel();
          completer.complete();
        }
      });
    }

    debugPrint("Waiting for context...");
    await completer.future;
    debugPrint("Context is ready, computing data...");

    List<_ThemedData<T>> data = [];

    List<double> colWidths = [];

    for (final header in widget.columns) {
      /// 5 == space beetwen header.headerText and _sortIconSize
      final value = _computeTextWidth(header.headerText) + _sortIconSize + 5;
      colWidths.add(value);
    }

    for (final item in widget.items) {
      List<String> values = [];
      List<List<InlineSpan>?> richTextValues = [];

      for (final entry in widget.columns.asMap().entries) {
        final header = entry.value;

        final value = header.valueBuilder(item);
        final richValue = header.richTextBuilder?.call(item);

        values.add(value);
        richTextValues.add(richValue);

        final index = entry.key;

        double width = 0;
        int extra = 0;
        if (entry.key < widget.columns.length - 1) extra = 1;

        if (header.fixedWidth != null) {
          width = header.fixedWidth! + extra;
        } else if (richValue != null) {
          width = _computeRichTextWidth(richValue) + extra;
        } else {
          width = _computeTextWidth(value) + extra;
        }

        if (colWidths.length <= index) {
          colWidths.add(width);
          continue;
        }

        if (width > colWidths[index]) {
          colWidths[index] = width;
        }
      }

      List<ThemedActionButton> actions = widget.addtionalActions?.call(item) ?? [];
      double actionSize = actions.length * ThemedButton.defaultHeight;

      actionSize += 5 * actions.length;
      actionSize += _padding.horizontal;
      if (actionSize > _actionSize) _actionSize = actionSize;

      data.add(
        _ThemedData<T>(
          item: item,
          values: values,
          richTextValues: richTextValues,
          actions: actions,
        ),
      );
    }

    final totalSize = colWidths.fold<double>(0, (previousValue, element) => previousValue + element);
    _availableWidth = _layoutSize.maxWidth;
    if (widget.hasMultiselect) _availableWidth -= (50 + 1);
    if (widget.hasActions) _availableWidth -= (_actionSize + 1);

    if (_availableWidth <= 0) _availableWidth = 0;

    if (totalSize < _availableWidth) {
      final diff = _availableWidth - totalSize;
      final nonFixedColumns = widget.columns.where((element) => element.fixedWidth == null).length;
      final perItem = diff / nonFixedColumns;
      for (final entry in widget.columns.asMap().entries) {
        if (entry.value.fixedWidth == null) {
          colWidths[entry.key] += perItem;
        }
      }
    }

    _computedData = data;
    _filteredData = data;

    _totalSize = colWidths.fold<double>(0, (previousValue, element) => previousValue + element);
    _sizes = colWidths;

    debugPrint("Computed ${_computedData.length} items, setting state!");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _filterData();

    return LayoutBuilder(
      builder: (context, constraints) {
        _layoutSize = constraints;
        return FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              debugPrint("Building table with ${_computedData.length} items - $_availableWidth");
              return Column(
                children: [
                  // Search
                  if (widget.canSearch) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ThemedSearchInput(
                        value: _search,
                        onSearch: _onSearchChanged,
                        asField: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Header
                  SizedBox(
                    height: widget.headerHeight,
                    child: Row(
                      children: [
                        /// Multiselect
                        if (widget.hasMultiselect) ...[
                          SizedBox(
                            width: 50,
                            child: Checkbox(
                              value: _selected.length == _computedData.length && _computedData.isNotEmpty,
                              onChanged: (val) {
                                if (val == true) {
                                  _selected = List.generate(_computedData.length, (index) => index);
                                } else {
                                  _selected = [];
                                }
                                setState(() {});
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
                              scrollDirection: Axis.horizontal,
                              controller: _horizontalHeaderController,
                              physics: const ClampingScrollPhysics(),
                              itemCount: widget.columns.length,
                              itemBuilder: (context, index) {
                                final ThemedColumn2<T> entry = widget.columns[index];
                                final bool isSelected = entry == colSelected;

                                return Row(
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          if (isSelected) {
                                            isReversed = !isReversed;
                                          } else {
                                            colSelected = entry;
                                            isReversed = false;
                                          }
                                          _future = _sortDataAsync();
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: _sizes[index] - (index < widget.columns.length - 1 ? 1 : 0),
                                          padding: _padding,
                                          alignment: entry.alignment,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                if (isSelected) ...[
                                                  WidgetSpan(
                                                    alignment: PlaceholderAlignment.middle,
                                                    child: Icon(
                                                      isReversed
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
                                                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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
                        if (widget.hasActions) ...[
                          const VerticalDivider(width: 1),
                          Container(
                            width: _actionSize,
                            padding: _padding,
                            alignment: Alignment.centerRight,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      LayrzIcons.solarOutlineTuningSquare2,
                                      size: _sortIconSize,
                                      color: Theme.of(context).textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                  const WidgetSpan(child: SizedBox(width: 5)),
                                  TextSpan(
                                    text: widget.actionsLabelText,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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
                              child: ListView.builder(
                                itemCount: _filteredData.length,
                                itemExtent: 50,
                                controller: _multiselectController,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: _padding,
                                    color: index % 2 == 0 ? null : _stripColor,
                                    child: Checkbox(
                                      value: _selected.contains(index),
                                      onChanged: (val) {
                                        if (val == true) {
                                          if (!_selected.contains(index)) _selected.add(index);
                                        } else {
                                          if (_selected.contains(index)) _selected.remove(index);
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const VerticalDivider(width: 1),
                        ],

                        /// Items.value
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _horizontalContentController,
                            child: ScrollConfiguration(
                              behavior: const ScrollBehavior().copyWith(scrollbars: false),
                              child: SizedBox(
                                width: _totalSize,
                                child: ListView.builder(
                                  itemCount: _filteredData.length,
                                  itemExtent: 50,
                                  controller: _contentController,
                                  itemBuilder: (context, index) {
                                    final data = _filteredData[index];

                                    return Row(
                                      children: [
                                        for (final entry in widget.columns.asMap().entries) ...[
                                          Material(
                                            color: index % 2 == 0 ? null : _stripColor,
                                            child: InkWell(
                                              onTap: entry.value.onTap != null
                                                  ? () => entry.value.onTap?.call(data.item)
                                                  : null,
                                              child: Container(
                                                width:
                                                    _sizes[entry.key] - (entry.key < widget.columns.length - 1 ? 1 : 0),
                                                padding: _padding,
                                                alignment: entry.value.alignment,
                                                child: data.richTextValues[entry.key] != null
                                                    ? RichText(
                                                        text: TextSpan(
                                                          children: data.richTextValues[entry.key],
                                                          style: _style,
                                                        ),
                                                        maxLines: 1,
                                                      )
                                                    : Text(
                                                        data.values[entry.key],
                                                        style: _style,
                                                        maxLines: 1,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          if (entry.key < _sizes.length - 1) const VerticalDivider(width: 1),
                                        ],
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Actions.value
                        if (widget.hasActions) ...[
                          const VerticalDivider(width: 1),
                          SizedBox(
                            width: _actionSize,
                            child: ListView.builder(
                              itemCount: _filteredData.length,
                              itemExtent: 50,
                              controller: _actionsController,
                              itemBuilder: (context, index) {
                                final data = _filteredData[index];
                                return Container(
                                  padding: _padding,
                                  alignment: Alignment.centerRight,
                                  color: index % 2 == 0 ? null : _stripColor,
                                  child: ThemedActionsButtons(
                                    actions: data.actions,
                                    mobileBreakpoint: widget.actionsMobileBreakpoint,
                                    actionPadding: EdgeInsets.only(left: 5),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(widget.loadingLabelText, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  double _computeTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: _style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width + _padding.horizontal;
  }

  double _computeRichTextWidth(List<InlineSpan> richText) {
    final filtered = richText.whereType<TextSpan>().toList();

    final TextPainter textPainter = TextPainter(
      text: TextSpan(children: filtered, style: _style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width + _padding.horizontal;
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _search = value;
      _filterData();
      setState(() {});
    });
  }

  void _filterData() {
    if (_search.isEmpty) {
      _filteredData = _computedData;
    } else {
      _filteredData = _computedData.where((item) {
        return widget.columns.any((col) => col.valueBuilder(item.item).toLowerCase().contains(_search.toLowerCase()));
      }).toList();
    }
  }

  Future<void> _sortDataAsync() async {
    final pairs = _filteredData.map((item) => [colSelected.valueBuilder(item.item), item]).toList();
    final sortedPairs = await compute(
      sortPairsInIsolate,
      {
        'pairs': pairs,
        'isReversed': isReversed,
      },
    );
    _filteredData = sortedPairs.map((pair) => pair[1] as _ThemedData<T>).toList();
  }
}

List sortPairsInIsolate(Map<String, dynamic> params) {
  final List pairs = List.from(params['pairs']);
  final bool isReversed = params['isReversed'];

  int compare(a, b) {
    final valueA = a[0];
    final valueB = b[0];

    // Try to parse as number
    final numA = num.tryParse(valueA);
    final numB = num.tryParse(valueB);
    if (numA != null && numB != null) {
      return isReversed ? numB.compareTo(numA) : numA.compareTo(numB);
    }

    // Try to parse as Duration (format HH:mm:ss)
    Duration? parseDuration(String s) {
      final parts = s.split(':');
      if (parts.length == 3) {
        final h = int.tryParse(parts[0]) ?? 0;
        final m = int.tryParse(parts[1]) ?? 0;
        final sec = int.tryParse(parts[2]) ?? 0;
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

  pairs.sort(compare);
  return pairs;
}
