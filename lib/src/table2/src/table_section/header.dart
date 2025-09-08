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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (enableMultiSelect) ...[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enableMultiSelect ? () => multiSelectOnChange?.call(itemsSelected.length != items.length) : null,
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
          child: Row(
            children: [
              ...columns.map((col) {
                Widget cell = Container(
                  padding: padding,
                  height: headerHeight,
                  decoration: decoration,
                  width: col.width,
                  constraints: BoxConstraints(minWidth: col.minWidth ?? 50),
                  child: Align(
                    alignment: col.alignment,
                    child: Text(
                      col.headerText,
                      style: textStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
                if (col.width != null) {
                  return cell;
                } else {
                  return Expanded(child: cell);
                }
              }),
            ],
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
  }
}
