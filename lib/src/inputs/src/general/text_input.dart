part of inputs;

class ThemedTextInput extends StatefulWidget {
  final TextInputType keyboardType;
  final String? labelText;
  final Widget? label;
  final String? placeholder;
  final String? prefixText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final void Function()? onPrefixTap;
  final IconData? suffixIcon;
  final String? suffixText;
  final void Function()? onSuffixTap;
  final bool obscureText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final String? value;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final EdgeInsets padding;
  final bool dense;
  final bool isRequired;
  final FocusNode? focusNode;
  final bool Function(String)? validator;
  final VoidCallback? onSubmitted;
  final bool readonly;
  final List<TextInputFormatter> inputFormatters;
  final List<String> autofillHints;
  final double? borderRadius;
  final int maxLines;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool autofocus;
  final Widget? suffixWidget;
  final List<String> choices;
  final int maxChoicesToDisplay;
  final bool enableCombobox;
  final String emptyChoicesText;

  /// [ThemedTextInput] is the constructor of the input.
  /// Simplifies (I hope so) the creation of an input using the standard format of Layrz.
  const ThemedTextInput({
    super.key,

    /// [keyboardType] is the type of the keyboard.
    /// By default, it is [TextInputType.text].
    this.keyboardType = TextInputType.text,

    /// [labelText] is the label text of the input. Avoid submit [label] and [labelText] at the same time.
    this.labelText,

    /// [label] is the label widget of the input. Avoid submit [label] and [labelText] at the same time.
    this.label,

    /// [placeholder] is the placeholder of the input.
    this.disabled = false,

    /// [prefixText] is the prefix text of the input.
    this.placeholder,

    /// [prefixIcon] is the prefix icon of the input. Avoid submit [prefixIcon] and [prefixWidget] at the same time.
    this.prefixText,

    /// [prefixWidget] is the prefix widget of the input. Avoid submit [prefixIcon] and [prefixWidget] at the same time.
    this.prefixIcon,

    /// [onPrefixTap] is the callback function when the prefix is tapped.
    this.prefixWidget,

    /// [suffixIcon] is the suffix icon of the input.
    this.onPrefixTap,

    /// [suffixText] is the suffix text of the input.
    this.suffixIcon,

    /// [onSuffixTap] is the callback function when the suffix is tapped.
    this.suffixText,

    /// [obscureText] is the state of the input being obscured.
    this.onSuffixTap,

    /// [controller] is the controller of the input.
    this.onTap,

    /// [onChanged] is the callback function when the input is changed.
    this.obscureText = false,

    /// [onTap] is the callback function when the input is tapped.
    this.controller,

    /// [value] is the value of the input.
    this.onChanged,

    /// [disabled] is the disabled state of the input.
    this.value,

    /// [errors] is the list of errors of the input.
    this.errors = const [],

    /// [hideDetails] is the state of hiding the details of the input.
    this.hideDetails = false,

    /// [padding] is the padding of the input.
    this.padding = const EdgeInsets.all(10),

    /// [dense] is the state of the input being dense.
    this.dense = false,

    /// [isRequired] is the state of the input being required.
    this.isRequired = false,

    /// [focusNode] is the focus node of the input.
    this.focusNode,

    /// [validator] is the validator of the input.
    this.validator,

    /// [onSubmitted] is the callback function when the input is submitted.
    this.onSubmitted,

    /// [readonly] is the state of the input being readonly.
    this.readonly = false,

    /// [inputFormatters] is the list of input formatters of the input.
    this.inputFormatters = const [],

    /// [autofillHints] is the list of autofill hints of the input.
    this.autofillHints = const [],

    /// [autofocus] is the state of the input being autofocus.
    this.borderRadius,

    /// [maxLines] is the maximum number of lines of the input.
    this.maxLines = 1,

    /// [autocorrect] is the state of the input for enabling autocorrect.
    this.autocorrect = true,

    /// [enableSuggestions] is the state of the input to enable suggestions.
    this.enableSuggestions = true,

    /// [autofocus] is the state of the input to be autofocused.
    this.autofocus = false,

    /// [suffixWidget] is the widget of the suffix of the input.
    this.suffixWidget,

    /// [choices] is the list of choices of the input. Only will affect if [enableCombobox] is true.
    this.choices = const [],

    /// [maxChoicesToDisplay] is the maximum number of choices to display.
    this.maxChoicesToDisplay = 5,

    /// [enableCombobox] is the state of the input to enable the combobox.
    this.enableCombobox = false,

    /// [emptyChoicesText] is the text to display when the choices list is empty.
    this.emptyChoicesText = "No choices",
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedTextInput> createState() => _ThemedTextInputState();
}

class _ThemedTextInputState extends State<ThemedTextInput> with TickerProviderStateMixin {
  final StreamController _streamController = StreamController<List<String>>.broadcast();
  late AnimationController _animationController;
  late TextEditingController _controller;
  late String _value;
  late FocusNode _focusNode;
  OverlayEntry? _entry;
  bool _isEntryOnTop = false;

  EdgeInsets get widgetPadding => widget.padding;
  bool get isDense => widget.dense;
  Color get color => Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: kHoverDuration);
    _value = widget.value ?? "";
    _controller = widget.controller ?? TextEditingController(text: _value);
    _focusNode = widget.focusNode ?? FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _entry?.remove();
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
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

    if (widget.choices != oldWidget.choices) {
      _streamController.add(widget.choices);
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

    Widget? suffix;

    if (widget.disabled) {
      suffix = Icon(MdiIcons.lockOutline, size: 18);
    } else if (widget.suffixWidget != null) {
      suffix = InkWell(
        onTap: widget.onSuffixTap,
        child: widget.suffixWidget,
      );
    } else if (widget.suffixIcon != null) {
      suffix = InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onSuffixTap,
        child: Icon(widget.suffixIcon, size: 18),
      );
    }

    InputDecoration decoration = InputDecoration(
      label: label,
      hintText: widget.placeholder,
      hintStyle: Theme.of(context).textTheme.bodySmall,
      prefixText: widget.prefixText,
      prefixIcon: prefix,
      suffixText: widget.suffixText,
      border: _entry != null
          ? UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: !_isEntryOnTop ? Radius.zero : const Radius.circular(10),
                bottomRight: !_isEntryOnTop ? Radius.zero : const Radius.circular(10),
                topLeft: !_isEntryOnTop ? const Radius.circular(10) : Radius.zero,
                topRight: !_isEntryOnTop ? const Radius.circular(10) : Radius.zero,
              ),
              borderSide: BorderSide.none,
            )
          : widget.borderRadius != null
              ? OutlineInputBorder(
                  borderRadius: _entry != null
                      ? BorderRadius.only(
                          topLeft: Radius.circular(widget.borderRadius!),
                          topRight: Radius.circular(widget.borderRadius!),
                        )
                      : BorderRadius.circular(widget.borderRadius!),
                )
              : null,
      suffixIcon: suffix,
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
        focusNode: _focusNode,
        inputFormatters: widget.inputFormatters,
        maxLines: widget.maxLines,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        autofocus: widget.autofocus,
        onChanged: (String value) async {
          if (widget.validator?.call(value) ?? true) {
            setState(() => _value = value);
            widget.onChanged?.call(value);
          }
        },
        autofillHints: widget.autofillHints,
        onTap: widget.disabled
            ? null
            : !widget.enableCombobox
                ? widget.onTap
                : () async {
                    widget.onTap?.call();
                    await _createEntry();
                  },
        onSubmitted: widget.disabled
            ? null
            : (_) {
                _destroyEntry();
                widget.onSubmitted?.call();
              },
      ),
    );
  }

  Future<void> _destroyEntry() async {
    await _animationController.reverse();
    _entry?.remove();
    _entry = null;
    setState(() {});
  }

  Future<void> _createEntry() async {
    _entry?.remove();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    double maxHeight = 300;
    double itemExtent = 30;
    // 20 = padding - 5 = divider
    double height = min(widget.choices.length, widget.maxChoicesToDisplay) * itemExtent + 20 + 5;

    Size screenSize = MediaQuery.of(context).size;
    double left = offset.dx + widgetPadding.left;
    double right = screenSize.width - renderBox.size.width + widgetPadding.right - offset.dx;

    double? top;
    double? bottom;

    double predictedTop = offset.dy + renderBox.size.height - widgetPadding.bottom;

    if (predictedTop + height > screenSize.height) {
      top = offset.dy - height + widgetPadding.top;
      _isEntryOnTop = true;
    } else {
      top = predictedTop;
      _isEntryOnTop = false;
    }

    _entry = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(child: GestureDetector(onTap: _destroyEntry)),
              Positioned(
                top: top,
                left: left,
                bottom: bottom,
                right: right,
                child: FadeTransition(
                  opacity: _animationController,
                  child: StreamBuilder(
                      initialData: widget.choices,
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        List<String> choices = snapshot.data as List<String>;
                        // 20 = padding - 5 = divider
                        height = min(choices.length, widget.maxChoicesToDisplay) * itemExtent + 20 + 5;

                        return AnimatedContainer(
                          duration: kHoverDuration,
                          height: height,
                          constraints: BoxConstraints(maxHeight: maxHeight, minHeight: 50),
                          decoration: BoxDecoration(
                            color: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: _isEntryOnTop ? Radius.zero : const Radius.circular(10),
                              bottomRight: _isEntryOnTop ? Radius.zero : const Radius.circular(10),
                              topLeft: _isEntryOnTop ? const Radius.circular(10) : Radius.zero,
                              topRight: _isEntryOnTop ? const Radius.circular(10) : Radius.zero,
                            ),
                          ),
                          child: Column(
                            children: [
                              if (!_isEntryOnTop) const Divider(),
                              Expanded(
                                child: choices.isEmpty
                                    ? Center(
                                        child: Text(
                                          widget.emptyChoicesText,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: const EdgeInsets.all(10),
                                        itemCount: choices.length,
                                        itemExtent: itemExtent,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final itm = choices[index];
                                          return SizedBox(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius: BorderRadius.circular(5),
                                                onTap: () async {
                                                  await _destroyEntry();
                                                  _controller.text = itm;
                                                  widget.onChanged?.call(itm);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Text(
                                                    itm,
                                                    style: Theme.of(context).textTheme.bodyMedium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              if (_isEntryOnTop) const Divider(),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
    await _animationController.forward();
    setState(() {});
  }
}
