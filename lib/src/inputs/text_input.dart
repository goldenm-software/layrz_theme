part of layrz_theme;

class ThemedTextInput extends StatefulWidget {
  /// [keyboardType] is the type of the keyboard.
  /// By default, it is [TextInputType.text].
  final TextInputType keyboardType;

  /// [labelText] is the label text of the input. Avoid submit [label] and [labelText] at the same time.
  final String? labelText;

  /// [label] is the label widget of the input. Avoid submit [label] and [labelText] at the same time.
  final Widget? label;

  /// [placeholder] is the placeholder of the input.
  final String? placeholder;

  /// [prefixText] is the prefix text of the input.
  final String? prefixText;

  /// [prefixIcon] is the prefix icon of the input. Avoid submit [prefixIcon] and [prefixWidget] at the same time.
  final IconData? prefixIcon;

  /// [prefixWidget] is the prefix widget of the input. Avoid submit [prefixIcon] and [prefixWidget] at the same time.
  final Widget? prefixWidget;

  /// [onPrefixTap] is the callback function when the prefix is tapped.
  final void Function()? onPrefixTap;

  /// [suffixIcon] is the suffix icon of the input.
  final IconData? suffixIcon;

  /// [suffixText] is the suffix text of the input.
  final String? suffixText;

  /// [onSuffixTap] is the callback function when the suffix is tapped.
  final void Function()? onSuffixTap;

  /// [obscureText] is the state of the input being obscured.
  final bool obscureText;

  /// [controller] is the controller of the input.
  final TextEditingController? controller;

  /// [onChanged] is the callback function when the input is changed.
  final void Function(String)? onChanged;

  /// [onTap] is the callback function when the input is tapped.
  final VoidCallback? onTap;

  /// [value] is the value of the input.
  final String? value;

  /// [disabled] is the disabled state of the input.
  final bool disabled;

  /// [errors] is the list of errors of the input.
  final List<String> errors;

  /// [hideDetails] is the state of hiding the details of the input.
  final bool hideDetails;

  /// [padding] is the padding of the input.
  final EdgeInsets padding;

  /// [dense] is the state of the input being dense.
  final bool dense;

  /// [isRequired] is the state of the input being required.
  final bool isRequired;

  /// [focusNode] is the focus node of the input.
  final FocusNode? focusNode;

  /// [validator] is the validator of the input.
  final bool Function(String)? validator;

  /// [onSubmitted] is the callback function when the input is submitted.
  final VoidCallback? onSubmitted;

  /// [readonly] is the state of the input being readonly.
  final bool readonly;

  /// [inputFormatters] is the list of input formatters of the input.
  final List<TextInputFormatter> inputFormatters;

  /// [autofillHints] is the list of autofill hints of the input.
  final List<String> autofillHints;

  /// [autofocus] is the state of the input being autofocus.
  final double? borderRadius;

  /// [maxLines] is the maximum number of lines of the input.
  final int maxLines;

  /// [autocorrect] is the state of the input for enabling autocorrect.
  final bool autocorrect;

  /// [enableSuggestions] is the state of the input to enable suggestions.
  final bool enableSuggestions;

  /// [autofocus] is the state of the input to be autofocused.
  final bool autofocus;

  /// [ThemedTextInput] is the constructor of the input.
  /// Simplifies (I hope so) the creation of an input using the standard format of Layrz.
  const ThemedTextInput({
    super.key,
    this.keyboardType = TextInputType.text,
    this.labelText,
    this.label,
    this.disabled = false,
    this.placeholder,
    this.prefixText,
    this.prefixIcon,
    this.prefixWidget,
    this.onPrefixTap,
    this.suffixIcon,
    this.suffixText,
    this.onSuffixTap,
    this.onTap,
    this.obscureText = false,
    this.controller,
    this.onChanged,
    this.value,
    this.errors = const [],
    this.hideDetails = false,
    this.padding = const EdgeInsets.all(10),
    this.dense = false,
    this.isRequired = false,
    this.focusNode,
    this.validator,
    this.onSubmitted,
    this.readonly = false,
    this.inputFormatters = const [],
    this.autofillHints = const [],
    this.borderRadius,
    this.maxLines = 1,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.autofocus = false,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedTextInput> createState() => _ThemedTextInputState();
}

class _ThemedTextInputState extends State<ThemedTextInput> {
  late TextEditingController _controller;
  late String _value;

  EdgeInsets get widgetPadding => widget.padding;
  bool get isDense => widget.dense;
  Color get color => Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor;

  @override
  void initState() {
    _value = widget.value ?? "";
    _controller = widget.controller ?? TextEditingController(text: _value);
    super.initState();
  }

  @override
  void didUpdateWidget(ThemedTextInput oldWidget) {
    // check if the current value is different from the previous value
    if (oldWidget.value != widget.value) {
      // save the current cursor offset
      int previousCursorOffset = _controller.selection.extentOffset;

      // update the current value in the value
      _value = widget.value ?? "";
      // update the current value in the controller
      _controller.text = _value;
      // check that the cursor offset is not greater than the length of the value
      if (_value.length <= previousCursorOffset) {
        previousCursorOffset = _value.length;
      }

      // update the cursor offset
      _controller.selection = TextSelection.fromPosition(
        TextPosition(
          offset: previousCursorOffset,
        ),
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<String> errors = [];

    Widget label = widget.label ??
        Text(
          widget.labelText ?? "",
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
          ),
        );

    if (widget.isRequired) {
      label = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("*"),
          const SizedBox(width: 4),
          label,
        ],
      );
    }

    errors.addAll(widget.errors);

    Widget? prefix;

    if (widget.prefixWidget != null) {
      prefix = InkWell(
        onTap: widget.onPrefixTap,
        child: widget.prefixWidget,
      );
    } else if (widget.prefixIcon != null) {
      prefix = InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onPrefixTap,
        child: Icon(widget.prefixIcon, size: 18),
      );
    }

    InputDecoration decoration = InputDecoration(
      label: label,
      hintText: widget.placeholder,
      hintStyle: Theme.of(context).textTheme.bodySmall,
      prefixText: widget.prefixText,
      prefixIcon: prefix,
      suffixText: widget.suffixText,
      border: widget.borderRadius != null
          ? OutlineInputBorder(borderRadius: BorderRadius.circular(widget.borderRadius!))
          : null,
      suffixIcon: widget.disabled
          ? Icon(MdiIcons.lockOutline, size: 18)
          : widget.suffixIcon == null
              ? null
              : InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: widget.onSuffixTap,
                  child: Icon(widget.suffixIcon, size: 18),
                ),
    );

    if (isDense) {
      decoration = decoration.copyWith(
        contentPadding: const EdgeInsets.all(10).subtract(const EdgeInsets.symmetric(vertical: 5)),
        isDense: true,
      );
    }

    if (errors.isNotEmpty && !widget.hideDetails) {
      decoration = decoration.copyWith(
        errorText: errors.join(", "),
        errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              overflow: TextOverflow.clip,
              color: Theme.of(context).colorScheme.error,
            ),
        errorMaxLines: 3,
      );
    }

    if (widget.maxLines > 1) {
      decoration = decoration.copyWith(
        isDense: false,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      );
    }

    return Padding(
      padding: widgetPadding,
      child: TextField(
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        controller: _controller,
        readOnly: widget.disabled || widget.readonly,
        enabled: !widget.disabled,
        decoration: decoration,
        focusNode: widget.focusNode,
        inputFormatters: widget.inputFormatters,
        maxLines: widget.maxLines,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        autofocus: widget.autofocus,
        onChanged: (String value) {
          if (widget.validator?.call(value) ?? true) {
            setState(() => _value = value);
            widget.onChanged?.call(value);
          }
        },
        autofillHints: widget.autofillHints,
        onTap: widget.disabled ? null : widget.onTap,
        onSubmitted: widget.disabled
            ? null
            : (_) {
                widget.onSubmitted?.call();
              },
      ),
    );
  }
}
