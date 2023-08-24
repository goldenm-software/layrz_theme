part of inputs;

class ThemedNumberInput extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final String? placeholder;
  final void Function(num?)? onChanged;
  final num? value;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final EdgeInsets padding;
  final bool dense;
  final bool isRequired;
  final VoidCallback? onSubmitted;
  final bool readonly;
  final List<TextInputFormatter> inputFormatters;
  final double? borderRadius;
  final num? minimum;
  final num? maximum;
  final num? step;

  /// [ThemedNumberInput] is the constructor of the input.
  /// Simplifies (I hope so) the creation of an input using the standard format of Layrz.
  const ThemedNumberInput({
    super.key,

    /// [labelText] is the text of the label of the input.
    this.labelText,

    /// [label] is the widget of the label of the input.
    this.label,

    /// [disabled] is the state of the input being disabled.
    this.disabled = false,

    /// [placeholder] is the placeholder of the input.
    this.placeholder,

    /// [onChanged] is the callback function when the input is changed.
    this.onChanged,

    /// [value] is the value of the input.
    this.value,

    /// [errors] is the list of errors of the input.
    this.errors = const [],

    /// [hideDetails] is the state of the input to hide the details.
    this.hideDetails = false,

    /// [padding] is the padding of the input.
    this.padding = const EdgeInsets.all(10),

    /// [dense] is the state of the input being dense.
    this.dense = false,

    /// [isRequired] is the state of the input being required.
    this.isRequired = false,

    /// [onSubmitted] is the callback function when the input is submitted.
    this.onSubmitted,

    /// [readonly] is the state of the input being readonly.
    this.readonly = false,

    /// [inputFormatters] is the list of input formatters of the input.
    this.inputFormatters = const [],

    /// [borderRadius] is the border radius of the input.
    this.borderRadius,

    /// [minimum] is the minimum value of the input.
    this.minimum,

    /// [maximum] is the maximum value of the input.
    this.maximum,

    /// [step] is the step of the input.
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
