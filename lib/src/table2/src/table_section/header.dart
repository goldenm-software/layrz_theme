part of '../../new_table.dart';

class HeaderTableSection<T> extends StatelessWidget {
  const HeaderTableSection({
    required this.enableMultiSelect,
    required this.multiSelectOnChange,
    required this.itemsSelected,
    required this.items,
    required this.padding,
    required this.decoration,
    required this.selectWdith,
    required this.textStyle,
    required this.columns,
    required this.actionsWidth,
    required this.itemHeight,
    required this.isSelected,
    required this.headerHeight,
    required this.headerBackgroundColor,
    required this.actionsLabelText,
    required this.actionsIcon,
    required this.horizontalController,
    required this.headerOnTap,
    required this.selectedColumn,
    required this.isReverse,
    super.key,
  });

  final bool enableMultiSelect;
  final Function(bool add)? multiSelectOnChange;
  final List<T> itemsSelected;
  final List<T> items;
  final EdgeInsets padding;
  final BoxDecoration decoration;
  final double selectWdith;
  final TextStyle? textStyle;
  final List<ThemedColumn2<T>> columns;
  final double actionsWidth;
  final double itemHeight;
  final bool isSelected;
  final double headerHeight;
  final Color headerBackgroundColor;
  final String actionsLabelText;
  final IconData actionsIcon;
  final ScrollController horizontalController;
  final Function(ThemedColumn2<T>) headerOnTap;
  final ThemedColumn2<T> selectedColumn;
  final bool isReverse;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double avaliableWidth = constraints.maxWidth;
        final double avaliableContentWidth = avaliableWidth - selectWdith - actionsWidth;
        final double totalColumnsWidth = _getTotal();
        final bool addExpanded = avaliableContentWidth > totalColumnsWidth;
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (enableMultiSelect) ...[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: enableMultiSelect
                      ? () => multiSelectOnChange?.call(itemsSelected.length != items.length)
                      : null,
                  child: Container(
                    width: selectWdith,
                    height: headerHeight,
                    decoration: decoration,
                    child: Center(
                      child: AbsorbPointer(
                        child: ThemedAnimatedCheckbox(
                          value: isSelected,
                          activeColor: validateColor(color: headerBackgroundColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            Expanded(
              child: ColumsHeader<T>(
                horizontalController: horizontalController,
                totalColumnsWidth: totalColumnsWidth,
                headerHeight: headerHeight,
                columns: columns,
                padding: padding,
                decoration: decoration,
                textStyle: textStyle,
                addExpanded: addExpanded,
                avaliableWidth: avaliableWidth,
                headerOnTap: headerOnTap,
                selectedColumn: selectedColumn,
                isReverse: isReverse,
              ),
            ),

            Container(
              padding: padding,
              decoration: decoration,
              width: actionsWidth,
              height: headerHeight,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    actionsLabelText,
                    style: textStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    actionsIcon,
                    size: 16,
                    color: textStyle?.color,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  double _getTotal() {
    double number = 0;

    for (var col in columns) {
      if (col.wantMinWidth) {
        number += col.minWidth;
        continue;
      }
      if (col.fixWidth != null) {
        number += col.fixWidth!;
        continue;
      }
      number += col.minWidth;
      continue;
    }
    return number;
  }
}

class ColumsHeader<T> extends StatelessWidget {
  const ColumsHeader({
    required this.horizontalController,
    required this.totalColumnsWidth,
    required this.headerHeight,
    required this.columns,
    required this.padding,
    required this.decoration,
    required this.textStyle,
    required this.addExpanded,
    required this.avaliableWidth,
    required this.headerOnTap,
    required this.selectedColumn,
    required this.isReverse,
    super.key,
  });

  final ScrollController horizontalController;
  final double totalColumnsWidth;
  final double headerHeight;
  final List<ThemedColumn2<T>> columns;
  final EdgeInsets padding;
  final BoxDecoration decoration;
  final TextStyle? textStyle;
  final bool addExpanded;
  final double avaliableWidth;
  final Function(ThemedColumn2<T>) headerOnTap;
  final ThemedColumn2<T> selectedColumn;
  final bool isReverse;

  @override
  Widget build(BuildContext context) {
    Widget colums = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...columns.map((ThemedColumn2<T> col) {
          Widget cell = Material(
            color: decoration.color,

            child: InkWell(
              onTap: () => headerOnTap(col),
              child: Container(
                padding: padding,
                height: headerHeight,
                decoration: BoxDecoration(border: decoration.border),
                width: col.wantMinWidth ? col.minWidth : col.fixWidth ?? col.minWidth,
                child: Align(
                  alignment: col.alignment,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        col.headerText,
                        style: textStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (col == selectedColumn)
                        Icon(
                          isReverse
                              ? LayrzIcons.mdiSortAlphabeticalDescending
                              : LayrzIcons.mdiSortAlphabeticalAscending,
                          size: 16,
                          color: textStyle?.color,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );

          if (col.fixWidth != null || col.wantMinWidth) {
            return cell;
          }
          if (addExpanded) {
            return Expanded(child: cell);
          } else {
            return cell;
          }
        }),
      ],
    );

    if (!addExpanded) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: horizontalController,

        child: SizedBox(
          width: totalColumnsWidth,
          height: headerHeight,
          child: colums,
        ),
      );
    }
    return colums;
  }
}
