part of '../new_table.dart';

class NewThemedTable<T> extends StatefulWidget {
  final String labelText;
  final List<T> items;
  final List<ThemedColumn2<T>> columns;
  final EdgeInsets? padding;
  final Future<void> Function(BuildContext, T)? onShow;
  final Future<void> Function(BuildContext, T)? onEdit;
  final Future<void> Function(BuildContext, T)? onDelete;
  final List<ThemedActionButton> addtionalActions;
  final double actionsMobileBreakpoint;
  final double? actionWidth;
  final double headerHeight;
  final Color? headerBackgroundColor;
  final String actionsLabelText;
  final IconData? actionsIcon;
  final Color? evenColor;
  final Color? oddColor;

  const NewThemedTable({
    required this.labelText,
    required this.items,
    required this.columns,
    super.key,
    this.padding,
    this.onShow,
    this.onEdit,
    this.onDelete,
    this.addtionalActions = const [],
    this.actionsMobileBreakpoint = kSmallGrid,
    this.headerHeight = 40,
    this.headerBackgroundColor,
    this.actionsLabelText = "Actions",
    this.actionsIcon,
    this.evenColor,
    this.oddColor,
    this.actionWidth,
  });

  @override
  State<NewThemedTable<T>> createState() => _NewThemedTableState<T>();
}

class _NewThemedTableState<T> extends State<NewThemedTable<T>> {
  String search = '';
  TextStyle get textStyleDefault => Theme.of(context).textTheme.titleSmall!;
  List<T> itemsSelected = [];
  bool isLoading = true;
  List<ThemedColumn2<T>> columsOverrieded = [];
  List<T> itemsFiltered = [];
  double minActionsWidth = 100;
  Timer? _debounce;
  final ScrollController _horizontalScrollController = ScrollController();
  late ThemedColumn2<T> selectedColumn;
  bool isReversed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      itemsFiltered = widget.items;
      selectedColumn = widget.columns.first;
      await _assignMinWidthToColumns();
      setState(() => isLoading = false);
    });
  }

  @override
  void didUpdateWidget(covariant NewThemedTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _filterList();
    }
    if (widget.columns != oldWidget.columns) {
      _assignMinWidthToColumns();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  Future<void> _assignMinWidthToColumns() async {
    columsOverrieded.clear();
    for (final col in widget.columns) {
      // Calculate min width based on header
      final headerPainter = TextPainter(
        text: TextSpan(
          text: col.headerText,
          style: textStyleDefault.copyWith(fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      /// must to add 24 pixels of possible icon
      double minWidth = headerPainter.size.width + 16 + 16;
      // ignore: unused_local_variable
      int count = 1;
      // debugPrint("Col name: ${col.headerText} - $minWidth");

      for (final item in widget.items) {
        double cellWidth;
        final text = col.valueBuilder(item);
        final painter = TextPainter(
          text: TextSpan(text: text, style: textStyleDefault),
          textDirection: TextDirection.ltr,
        )..layout();

        /// I DONT KNOW WHY, but if you dont add 30 px some cells could be in overflow
        cellWidth = painter.size.width + 16 + 30;
        // debugPrint("${col.headerText} Min: $minWidth - Cell: ${painter.size.width} - Cell + P: $cellWidth");

        if (cellWidth > minWidth) minWidth = cellWidth;
        // debugPrint("Final width: $minWidth");
        count++;
        // TODO: ask mra1796
        // if (count == 100) break;
      }

      /// Add padding
      col.minWidth = minWidth + 20;
      columsOverrieded.add(col);
    }

    if (widget.actionWidth != null) {
      minActionsWidth = widget.actionWidth!;
    } else {
      /// Calculate min width for actions
      final actionHeaderPainter = TextPainter(
        text: TextSpan(
          text: widget.actionsLabelText,
          style: textStyleDefault.copyWith(fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      /// LabelText + Padding + Icon
      minActionsWidth = actionHeaderPainter.size.width + 20 + 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // Toolbar
          ThemedTableToolbar(
            labelText: widget.labelText,
            itemCount: itemsFiltered.length,
            search: search,
            onSearch: _onSearchChanged,
          ),
          // Table
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : TableSection<T>(
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
                    headerOntap: (col) {
                      if (selectedColumn == col) {
                        isReversed = !isReversed; // Alterna el orden
                      } else {
                        isReversed = false; // Nuevo orden ascendente
                        selectedColumn = col;
                      }
                      _sortList(isReversed);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      search = value;
      _filterList();
      setState(() {});
    });
  }

  void _filterList() {
    if (search.isEmpty) {
      itemsFiltered = widget.items;
    } else {
      itemsFiltered = widget.items.where((item) {
        return widget.columns.any((col) => col.valueBuilder(item).toLowerCase().contains(search.toLowerCase()));
      }).toList();
    }
  }

  void _sortList(bool isReversed) {
    debugPrint("Is reversed: $isReversed");
    itemsFiltered.sort((a, b) {
      final valueA = selectedColumn.valueBuilder(a);
      final valueB = selectedColumn.valueBuilder(b);

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
    });
    setState(() {});
  }
}
