part of inputs;

class ThemedRadioInput<T> extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final void Function(T?)? onChanged;
  final T? value;
  final List<ThemedSelectItem<T>> items;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final EdgeInsets padding;
  final Sizes xsSize;
  final Sizes? smSize;
  final Sizes? mdSize;
  final Sizes? lgSize;
  final Sizes? xlSize;

  /// [ThemedRadioInput] is a radio input.
  const ThemedRadioInput({
    super.key,

    /// [labelText] is the label text of the radio input. Avoid submit [label] and [labelText] at the same time.
    this.labelText,

    /// [label] is the label widget of the radio input. Avoid submit [label] and [labelText] at the same time.
    this.label,

    /// [onChanged] is the callback function when the radio input is changed.
    this.onChanged,

    /// [disabled] is the disabled state of the radio input.
    this.disabled = false,

    /// [value] is the value of the radio input.
    this.value,

    /// [items] is the list of items of the radio input.
    required this.items,

    /// [errors] is the list of errors of the radio input.
    this.errors = const [],

    /// [hideDetails] is the state of hiding the details of the radio input.
    this.hideDetails = false,

    /// [padding] is the padding of the radio input.
    this.padding = const EdgeInsets.all(10),

    /// [xsSize] is the size of the radio input in extra small screens.
    this.xsSize = Sizes.col12,

    /// [smSize] is the size of the radio input in small screens.
    this.smSize = Sizes.col6,

    /// [mdSize] is the size of the radio input in medium screens.
    this.mdSize = Sizes.col4,

    /// [lgSize] is the size of the radio input in large screens.
    this.lgSize = Sizes.col3,

    /// [xlSize] is the size of the radio input in extra large screens.
    this.xlSize = Sizes.col2,
  }) : assert(label == null || labelText == null);

  @override
  State<ThemedRadioInput<T>> createState() => _ThemedRadioInputState<T>();
}

class _ThemedRadioInputState<T> extends State<ThemedRadioInput<T>> {
  EdgeInsets get widgetPadding => widget.padding;
  late T? _value;

  @override
  void initState() {
    super.initState();

    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widgetPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.label ?? Text(widget.labelText ?? ''),
              ResponsiveRow.builder(
                itemCount: widget.items.length,
                itemBuilder: (i) {
                  final item = widget.items[i];

                  return ResponsiveCol(
                    xs: widget.xsSize,
                    sm: widget.smSize,
                    md: widget.mdSize,
                    lg: widget.lgSize,
                    xl: widget.xlSize,
                    child: Row(
                      children: [
                        Radio<T>(
                          value: item.value as T,
                          groupValue: _value,
                          onChanged: widget.disabled
                              ? null
                              : (T? value) {
                                  widget.onChanged?.call(value);
                                  setState(() => _value = value);
                                },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: widget.disabled
                                ? null
                                : () {
                                    if (_value != item.value) {
                                      widget.onChanged?.call(item.value);
                                      setState(() => _value = item.value);
                                    }
                                  },
                            child: Text(
                              item.label,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          ThemedFieldDisplayError(errors: widget.errors, hideDetails: widget.hideDetails),
        ],
      ),
    );
  }
}
