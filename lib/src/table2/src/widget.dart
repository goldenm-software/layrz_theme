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
  });

  @override
  State<NewThemedTable<T>> createState() => _NewThemedTableState<T>();
}

class _NewThemedTableState<T> extends State<NewThemedTable<T>> {
  String search = '';
  TextStyle get textStyleDefault => Theme.of(context).textTheme.bodyMedium!;
  List<T> itemsSelected = [];
  bool isLoading = true;
  List<ThemedColumn2<T>> columnsFiltered = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _assignMinWidthToColumns();
      setState(() => isLoading = false);
    });
  }

  @override
  void didUpdateWidget(covariant NewThemedTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.columns != oldWidget.columns) {
      _assignMinWidthToColumns();
    }
  }

  Future<void> _assignMinWidthToColumns() async {
    columnsFiltered.clear();
    for (final col in widget.columns) {
      debugPrint("Col: ${col.headerText} - Width: ${col.width}");

      // Medir el ancho del header (labelText)
      final headerPainter = TextPainter(
        text: TextSpan(
          text: col.headerText,
          style: textStyleDefault.copyWith(fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      /// must to add 24 pixels of possible icon
      double minWidth = headerPainter.size.width + 24;
      int count = 1;
      for (final item in widget.items) {
        double cellWidth;
        final text = col.value(item);
        final painter = TextPainter(
          text: TextSpan(text: text, style: textStyleDefault),
          textDirection: TextDirection.ltr,
        )..layout();
        cellWidth = painter.size.width;
        if (cellWidth > minWidth) minWidth = cellWidth;
        count++;
        if (count == 100) break;
      }

      /// Add padding
      col.minWidth = minWidth + 20;

      columnsFiltered.add(col);
      debugPrint("final Col min width: ${col.minWidth} - Max: ${col.minWidth}\n");
      debugPrint("--------");
    }
  }

  @override
  Widget build(BuildContext context) {
    _filterList();

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
            itemCount: widget.items.length,
            search: search,
            onSearch: (String value) => setState(() => search = value),
          ),
          // Table
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : TableSection<T>(
                    items: widget.items,
                    columns: widget.columns,
                    textStyle: textStyleDefault,
                    onShow: widget.onShow,
                    onEdit: widget.onEdit,
                    onDelete: widget.onDelete,
                    addtionalActions: widget.addtionalActions,
                    enableMultiSelect: true,
                    multiSelectOnChange: (bool add) {
                      setState(() {
                        if (add) {
                          itemsSelected = List.from(widget.items);
                        } else {
                          itemsSelected.clear();
                        }
                      });
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _filterList() {
    debugPrint("Filtering list with search: $search");
  }
}
