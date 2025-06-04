part of '../../inputs.dart';

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
  final EdgeInsets? padding;

  /// [dense] is the state of the input being dense.
  final bool dense;

  /// [isRequired] is the state of the input being required.
  final bool isRequired;

  /// [onSubmitted] is the callback function when the input is submitted.
  final VoidCallback? onSubmitted;

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

  /// [keyboardType] is the keyboard type of the input. Default is [TextInputType.number].
  final TextInputType keyboardType;

  /// [format] is the format of the input. Uses the `NumberFormat.decimalPattern()` by default and
  /// the class comes from `intl` package (Exported by the `layrz_theme` package).
  final NumberFormat? format;

  /// [ThemedDecimalSeparator] is the decimal separator of the input.
  ///
  /// When the [format] is not null, you must provide the [inputRegExp] to filter the input.
  final ThemedDecimalSeparator decimalSeparator;

  /// [inputRegExp] is the regular expression of the input.
  ///
  /// When the [format] is not null, you must provide the [inputRegExp] to filter the input.
  final RegExp? inputRegExp;

  /// Defaults to 4 decimal digits. Maximum is 15 decimal digits.
  final int maximumDecimalDigits;

  /// [suffixText] is the suffix text of the input.
  final String? suffixText;

  /// [prefixText] is the prefix text of the input.
  final String? prefixText;

  /// [hidePrefixSuffixActions] is the state of the input to hide the prefix and suffix actions. on the input
  final bool hidePrefixSuffixActions;

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
    this.padding,
    this.dense = false,
    this.isRequired = false,
    this.onSubmitted,
    this.inputFormatters = const [],
    this.borderRadius,
    this.minimum,
    this.maximum,
    this.step,
    this.keyboardType = TextInputType.number,
    this.format,
    this.decimalSeparator = ThemedDecimalSeparator.dot,
    this.inputRegExp,
    this.maximumDecimalDigits = 4,
    this.suffixText,
    this.prefixText,
    this.hidePrefixSuffixActions = false,
  }) : assert(
         (label == null && labelText != null) || (label != null && labelText == null),
         'You must provide either a labelText or a label, but not both.',
       ),
       assert(
         (format != null && inputRegExp != null) || (format == null),
         'When the format is not null, you must provide the inputRegExp to filter the input.',
       );

  @override
  State<ThemedNumberInput> createState() => _ThemedNumberInputState();
}

class _ThemedNumberInputState extends State<ThemedNumberInput> {
  bool get _hideActionButtons => widget.hidePrefixSuffixActions || widget.disabled;

  RegExp get _regex => RegExp(r'[-0-9\,.]');
  final _controller = TextEditingController();
  bool get isDense => widget.dense;
  Color get color => Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor;
  NumberFormat get format {
    if (widget.format != null) return widget.format!;
    var formatToUse = NumberFormat.decimalPattern();

    if (widget.decimalSeparator == ThemedDecimalSeparator.comma) {
      formatToUse = NumberFormat.decimalPattern('pt');
    }

    formatToUse.significantDigitsInUse = false;
    formatToUse.maximumFractionDigits = min(15, widget.maximumDecimalDigits);

    return formatToUse;
  }

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value == null ? '' : format.format(widget.value);
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
  }

  @override
  void didUpdateWidget(ThemedNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateCursorOffset(oldWidget);
  }

  void _updateCursorOffset(ThemedNumberInput oldWidget) {
    if (widget.value == null) {
      _controller.text = '';
      return;
    }
    if (oldWidget.value != widget.value) {
      // save the current cursor offset
      int previousCursorOffset = _controller.selection.extentOffset;

      String oldValue = oldWidget.value != null ? format.format(oldWidget.value) : '';
      String newValue = format.format(widget.value);

      String thousandSeparator = ThemedDecimalSeparator.comma == widget.decimalSeparator ? '.' : ',';

      // Count how many separators are before the cursor in the old text
      int oldSeparatorsBeforeCursor = 0;
      for (int i = 0; i < previousCursorOffset && i < oldValue.length; i++) {
        // Count commas or dots depending on your separator
        if (oldValue[i] == thousandSeparator) {
          oldSeparatorsBeforeCursor++;
        }
      }

      // Count how many separators would be in the new text at similar position
      int approximatePosition = min(previousCursorOffset, newValue.length);
      int newSeparatorsBeforeCursor = 0;
      for (int i = 0; i < approximatePosition; i++) {
        if (newValue[i] == thousandSeparator) {
          newSeparatorsBeforeCursor++;
        }
      }

      // Adjust cursor position based on difference in separators
      int adjustedPosition = previousCursorOffset + (newSeparatorsBeforeCursor - oldSeparatorsBeforeCursor);

      // Ensure the position is within valid range
      adjustedPosition = max(0, min(adjustedPosition, newValue.length));

      // update the current value in the controller
      _controller.text = newValue;
      // update the cursor offset
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: adjustedPosition));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedTextInput(
      controller: _controller,
      value: widget.value == null ? null : format.format(widget.value),
      labelText: widget.labelText,
      label: widget.label,
      disabled: widget.disabled,
      placeholder: widget.placeholder,
      prefixText: widget.prefixText,
      suffixText: widget.suffixText,
      prefixIcon: _hideActionButtons ? null : LayrzIcons.solarOutlineMinusSquare,
      onPrefixTap: () {
        if (_hideActionButtons) return;
        num newValue = (widget.value ?? 0) - (widget.step ?? 1);
        if (newValue < (widget.minimum ?? double.negativeInfinity)) {
          return;
        }
        widget.onChanged?.call(newValue);
      },
      suffixIcon: _hideActionButtons ? null : LayrzIcons.solarOutlineAddSquare,
      onSuffixTap: () {
        if (_hideActionButtons) return;
        num newValue = (widget.value ?? 0) + (widget.step ?? 1);
        if (newValue > (widget.maximum ?? double.infinity)) {
          return;
        }
        widget.onChanged?.call(newValue);
      },
      hideDetails: widget.hideDetails,
      errors: widget.errors,
      padding: widget.padding,
      dense: widget.dense,
      isRequired: widget.isRequired,
      keyboardType: widget.keyboardType,
      inputFormatters: [
        FilteringTextInputFormatter.allow(_regex),
        ...widget.inputFormatters,
      ],
      onChanged: (value) {
        if (value.isEmpty) return widget.onChanged?.call(null);
        if (value == '-') return;

        final castedValue = format.tryParse(value);

        widget.onChanged?.call(castedValue);
      },
      onSubmitted: widget.onSubmitted,
    );
  }
}

enum ThemedDecimalSeparator {
  dot,
  comma,
}
