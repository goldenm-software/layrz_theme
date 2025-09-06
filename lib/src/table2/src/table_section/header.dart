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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (enableMultiSelect) ...[
          InkWell(
            onTap: enableMultiSelect ? () => multiSelectOnChange?.call(itemsSelected.length != items.length) : null,
            child: Container(
              padding: padding,
              decoration: decoration,
              width: selectWdith,
              child: Align(
                child: Text(
                  "Select",
                  style: textStyle?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
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
                  decoration: decoration,
                  width: col.width,
                  constraints: BoxConstraints(
                    minWidth: col.minWidth ?? 50,
                  ),
                  child: Align(
                    alignment: col.alignment,
                    child: Text(
                      col.headerText,
                      style: textStyle?.copyWith(fontWeight: FontWeight.bold),
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

          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
              Text(
                "Actions",
                textAlign: TextAlign.right,
                style: textStyle?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Icon(
                LayrzIcons.mdiDotsVertical,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
