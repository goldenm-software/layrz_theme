part of '../../inputs.dart';

class ThemedRadioInput<T> extends StatefulWidget {
  /// [labelText] is the label text of the radio input. Avoid submit [label] and [labelText] at the same time.
  final String? labelText;

  /// [label] is the label widget of the radio input. Avoid submit [label] and [labelText] at the same time.
  final Widget? label;

  /// [onChanged] is the callback function when the radio input is changed.
  final void Function(T?)? onChanged;

  /// [disabled] is the disabled state of the radio input.
  final T? value;

  /// [value] is the value of the radio input.
  final List<ThemedSelectItem<T>> items;

  /// [items] is the list of items of the radio input.
  final bool disabled;

  /// [errors] is the list of errors of the radio input.
  final List<String> errors;

  /// [hideDetails] is the state of hiding the details of the radio input.
  final bool hideDetails;

  /// [padding] is the padding of the radio input.
  final EdgeInsets padding;

  /// [xsSize] is the size of the radio input in extra small screens.
  final Sizes xsSize;

  /// [smSize] is the size of the radio input in small screens.
  final Sizes? smSize;

  /// [mdSize] is the size of the radio input in medium screens.
  final Sizes? mdSize;

  /// [lgSize] is the size of the radio input in large screens.
  final Sizes? lgSize;

  /// [xlSize] is the size of the radio input in extra large screens.
  final Sizes? xlSize;

  /// [ThemedRadioInput] is a radio input.
  const ThemedRadioInput({
    super.key,
    this.labelText,
    this.label,
    this.onChanged,
    this.disabled = false,
    this.value,
    required this.items,
    this.errors = const [],
    this.hideDetails = false,
    this.padding = const EdgeInsets.all(10),
    this.xsSize = Sizes.col12,
    this.smSize = Sizes.col6,
    this.mdSize = Sizes.col4,
    this.lgSize = Sizes.col3,
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
