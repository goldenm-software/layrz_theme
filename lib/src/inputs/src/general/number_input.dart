part of inputs;

class ThemedNumberInput extends StatefulWidget {
  /// [labelText] is the text of the label of the input.
  final String? labelText;

  /// [label] is the widget of the label of the input.
  final Widget? label;

  /// [disabled] is the state of the input being disabled.
  final String? placeholder;

  /// [placeholder] is the placeholder of the input.
  final void Function(num?)? onChanged;

  /// [onChanged] is the callback function when the input is changed.
  final num? value;

  /// [value] is the value of the input.
  final bool disabled;

  /// [errors] is the list of errors of the input.
  final List<String> errors;

  /// [hideDetails] is the state of the input to hide the details.
  final bool hideDetails;

  /// [padding] is the padding of the input.
  final EdgeInsets padding;

  /// [dense] is the state of the input being dense.
  final bool dense;

  /// [isRequired] is the state of the input being required.
  final bool isRequired;

  /// [onSubmitted] is the callback function when the input is submitted.
  final VoidCallback? onSubmitted;

  /// [readonly] is the state of the input being readonly.
  final bool readonly;

  /// [inputFormatters] is the list of input formatters of the input.
  final List<TextInputFormatter> inputFormatters;

  /// [borderRadius] is the border radius of the input.
  final double? borderRadius;

  /// [minimum] is the minimum value of the input.
  final num? minimum;

  /// [maximum] is the maximum value of the input.
  final num? maximum;

  /// [step] is the step of the input.
  final num? step;

  /// [ThemedNumberInput] is the constructor of the input.
  /// Simplifies (I hope so) the creation of an input using the standard format of Layrz.
  const ThemedNumberInput({
    super.key,
    this.labelText,
    this.label,
    this.disabled = false,
    this.placeholder,
    this.onChanged,
    this.value,
    this.errors = const [],
    this.hideDetails = false,
    this.padding = const EdgeInsets.all(10),
    this.dense = false,
    this.isRequired = false,
    this.onSubmitted,
    this.readonly = false,
    this.inputFormatters = const [],
    this.borderRadius,
    this.minimum,
    this.maximum,
    this.step,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedNumberInput> createState() => _ThemedNumberInputState();
}

class _ThemedNumberInputState extends State<ThemedNumberInput> {
  EdgeInsets get widgetPadding => widget.padding;
  bool get isDense => widget.dense;
  Color get color => Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedTextInput(
      value: widget.value?.toString(),
      labelText: widget.labelText,
      label: widget.label,
      disabled: widget.disabled,
      placeholder: widget.placeholder,
      prefixIcon: MdiIcons.minus,
      onPrefixTap: () => widget.onChanged?.call((widget.value ?? 0) - (widget.step ?? 1)),
      suffixIcon: MdiIcons.plus,
      onSuffixTap: () => widget.onChanged?.call((widget.value ?? 0) + (widget.step ?? 1)),
      hideDetails: widget.hideDetails,
      errors: widget.errors,
      padding: widget.padding,
      dense: widget.dense,
      isRequired: widget.isRequired,
      onChanged: (value) {
        widget.onChanged?.call(num.tryParse(value));
      },
      onSubmitted: widget.onSubmitted,
    );
  }
}
