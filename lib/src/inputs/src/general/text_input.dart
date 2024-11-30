part of '../../inputs.dart';

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
  final VoidCallback? onPrefixTap;

  /// [suffixIcon] is the suffix icon of the input.
  final IconData? suffixIcon;

  /// [suffixText] is the suffix text of the input.
  final String? suffixText;

  /// [onSuffixTap] is the callback function when the suffix is tapped.
  final VoidCallback? onSuffixTap;

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
  final EdgeInsets? padding;

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

  /// [suffixWidget] is the widget of the suffix of the input.
  final Widget? suffixWidget;

  /// [choices] is the list of choices of the input. Only will affect if [enableCombobox] is true.
  final List<String> choices;

  /// [maxChoicesToDisplay] is the maximum number of choices to display.
  final int maxChoicesToDisplay;

  /// [enableCombobox] is the state of the input to enable the combobox.
  final bool enableCombobox;

  /// [emptyChoicesText] is the text to display when the choices list is empty.
  final String emptyChoicesText;

  /// [position] is the position of the combobox.
  /// By default, it is [ThemedComboboxPosition.below].
  final ThemedComboboxPosition position;

  /// Styles of the text inside the input
  final TextStyle? textStyle;

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
    this.padding,
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
    this.suffixWidget,
    this.choices = const [],
    this.maxChoicesToDisplay = 5,
    this.enableCombobox = false,
    this.emptyChoicesText = "No choices",
    this.position = ThemedComboboxPosition.below,
    this.textStyle,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedTextInput> createState() => _ThemedTextInputState();

  /// [padding] is the padding of the input.
  static EdgeInsets get outerPadding => const EdgeInsets.all(10);
}

class _ThemedTextInputState extends State<ThemedTextInput> with TickerProviderStateMixin {
  final StreamController _streamController = StreamController<List<String>>.broadcast();
  late AnimationController _animationController;
  late TextEditingController _controller;
  late String _value;
  late FocusNode _focusNode;
  OverlayEntry? _entry;
  bool get _isEntryOnTop => widget.position == ThemedComboboxPosition.above;

  EdgeInsets get widgetPadding => widget.padding ?? ThemedTextInput.outerPadding;
  bool get isDense => widget.dense;
  Color get color => Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor;

  @override
  void initState() {
    super.initState();

    debugPrint("InitState");
    _animationController = AnimationController(vsync: this, duration: kHoverDuration);
    _value = widget.value ?? "";
    _controller = widget.controller ?? TextEditingController(text: _value);
    _focusNode = widget.focusNode ?? FocusNode();
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
    super.didUpdateWidget(oldWidget);
    // check if the current value is different from the previous value

    if (widget.choices != oldWidget.choices) {
      _streamController.add(widget.choices);
    }
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
      suffix = Icon(LayrzIcons.solarOutlineLockKeyhole, size: 18);
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
        clipBehavior: Clip.antiAlias,
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
        style: widget.textStyle,
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

    if (widget.position == ThemedComboboxPosition.above) {
      bottom = (screenSize.height - offset.dy) - widgetPadding.top;
      top = null;
    } else {
      top = offset.dy + renderBox.size.height - widgetPadding.bottom;
      bottom = null;
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

/// [ThemedComboboxPosition] is the position of the combobox choices.
enum ThemedComboboxPosition {
  /// [top] is the position of the combobox choices on top of the input.
  above,

  /// [bottom] is the position of the combobox choices below the input.
  below,
}
