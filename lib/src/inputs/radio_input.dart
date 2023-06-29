part of layrz_theme;

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

  const ThemedRadioInput({
    Key? key,
    required this.items,
    this.labelText,
    this.label,
    this.disabled = false,
    this.onChanged,
    this.value,
    this.errors = const [],
    this.hideDetails = false,
    this.padding = const EdgeInsets.all(10),
    this.xsSize = Sizes.col12,
    this.smSize = Sizes.col6,
    this.mdSize = Sizes.col4,
    this.lgSize = Sizes.col3,
    this.xlSize = Sizes.col2,
  })  : assert(label == null || labelText == null),
        super(key: key);

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
