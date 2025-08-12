part of '../../inputs.dart';

class ThemedSelectItem<T> {
  /// [content] is the content of the item.
  final Widget? content;

  /// [label] is the label of the item. Depending of the implementation of this class, we priorize in this order:
  ///
  /// [content] > [leading] > [icon] > [label].
  /// Usually, this class is used on the [ThemedSelectInput], [ThemedMultiSelectInput] and [ThemedDualListInput].
  final String label;

  /// [value] is the value of the item.
  final T? value;

  /// [icon] is the icon of the item.
  final IconData? icon;

  /// [leading] is the leading widget of the item.
  final Widget? leading;

  /// [onTap] is the callback function when the item is tapped.
  final VoidCallback? onTap;

  /// [canDelete] is the flag to enable the delete button of the item.
  final bool canDelete;

  /// [searchableAtributes] is the list of searchable attributes of the item.
  /// Intended to be used on the inputs that have a search field.
  /// Allowing that any other visible atributes may also be searchable.
  final Set<String> searchableAttributes;

  /// Indicates whether the item has been marked as removed.
  /// This is only used when the [ThemedSelectInput] has the property `canUnselect` set to true.
  final bool isRemoved;

  /// [ThemedSelectItem] is the item of the [ThemedSelectInput], [ThemedMultiSelectInput] and [ThemedDualListInput].
  const ThemedSelectItem({
    required this.label,
    required this.value,
    this.icon,
    this.leading,
    this.onTap,
    this.content,
    this.canDelete = false,
    this.searchableAttributes = const {},
    this.isRemoved = false,
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
                  Expanded(child: Text(widget.item.label, maxLines: 2)),
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
