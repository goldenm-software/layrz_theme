part of inputs;

class ThemedSelectItem<T> {
  final Widget? content;
  final String label;
  final T? value;
  final IconData? icon;
  final Widget? leading;
  final VoidCallback? onTap;
  final bool canDelete;

  const ThemedSelectItem({
    required this.label,
    required this.value,
    this.icon,
    this.leading,
    this.onTap,
    this.content,
    this.canDelete = false,
  });

  @override
  String toString() => "ThemedSelectItem($label, $value)";

  @override
  bool operator ==(Object other) => identical(this, other) || other is ThemedSelectItem && value == other.value;

  @override
  int get hashCode => label.hashCode ^ value.hashCode ^ icon.hashCode;
}

class _ThemedSelectItem<T> extends StatefulWidget {
  final ThemedSelectItem<T> item;
  final VoidCallback? onTap;
  final bool selected;
  final bool showCheckbox;
  final bool canUnselect;

  const _ThemedSelectItem({
    super.key,
    required this.item,
    this.onTap,
    this.selected = false,
    this.showCheckbox = true,
    this.canUnselect = true,
  });

  @override
  State<_ThemedSelectItem<T>> createState() => __ThemedSelectItemState<T>();

  static const double height = 50;
}

class __ThemedSelectItemState<T> extends State<_ThemedSelectItem<T>> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _ThemedSelectItem.height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          mouseCursor: widget.selected
              ? widget.canUnselect
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          onTap: widget.selected
              ? widget.canUnselect
                  ? widget.onTap
                  : null
              : widget.onTap,
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                if (widget.showCheckbox) ...[
                  ThemedAnimatedCheckbox(value: widget.selected),
                ],
                if (widget.item.content == null) ...[
                  if (widget.item.leading != null) ...[
                    widget.item.leading!,
                    const SizedBox(width: 5),
                  ] else if (widget.item.icon != null) ...[
                    Icon(
                      widget.item.icon,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                  ],
                  Expanded(child: Text(widget.item.label)),
                ] else ...[
                  Expanded(child: widget.item.content!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
