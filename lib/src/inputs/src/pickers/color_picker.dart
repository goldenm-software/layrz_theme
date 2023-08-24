part of inputs;

class ThemedColorPicker extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final void Function(Color)? onChanged;
  final Color? value;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final EdgeInsets padding;
  final bool dense;
  final IconData? prefixIcon;
  final void Function()? onPrefixTap;
  final String? placeholder;
  final String saveText;
  final String cancelText;
  final List<ColorPickerType> enabledTypes;
  final Widget? customChild;

  /// [ThemedColorPicker] is a [ThemedTextInput] that allows the user to pick a color.
  const ThemedColorPicker({
    super.key,

    /// [labelText] is the text that will be displayed on the label.
    /// If [label] is not null, this will be ignored.
    this.labelText,

    /// [label] is the widget that will be displayed on the label.
    this.label,

    /// [disabled] is the state of the input being disabled.
    this.disabled = false,

    /// [onChanged] is the callback function when the input is changed.
    this.onChanged,

    /// [value] is the value of the input.
    this.value,

    /// [errors] is the list of errors of the input.
    this.errors = const [],

    /// [hideDetails] is the state of hiding the details of the input.
    this.hideDetails = false,

    /// [padding] is the padding of the input.
    this.padding = const EdgeInsets.all(10),

    /// [dense] is the state of the input being dense.
    this.dense = false,

    /// [prefixIcon] is the prefix icon of the input.
    this.prefixIcon,

    /// [onPrefixTap] is the callback function when the prefix is tapped.
    this.onPrefixTap,

    /// [placeholder] is the placeholder of the input.
    this.placeholder,

    /// [saveText] is the text that will be displayed on the save button.
    this.saveText = "OK",

    /// [cancelText] is the text that will be displayed on the cancel button.
    this.cancelText = "Cancel",

    /// [enabledTypes] is the list of enabled color picker types.
    this.enabledTypes = const [
      ColorPickerType.both,
      ColorPickerType.wheel,
    ],

    /// [customChild] is the custom child of the input.
    /// If this is not null, the input will be render as a [ThemedTextInput].
    this.customChild,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedColorPicker> createState() => _ThemedColorPickerState();
}

class _ThemedColorPickerState extends State<ThemedColorPicker> {
  final TextEditingController _controller = TextEditingController();
  late Color _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? kPrimaryColor;

    _controller.text = "#${_value.hex}";
  }

  EdgeInsets get widgetPadding => widget.padding;
  bool get isDense => widget.dense;

  @override
  Widget build(BuildContext context) {
    if (widget.customChild != null) {
      return ThemedTooltip(
        message: widget.labelText ?? widget.label?.toString() ?? "",
        child: InkWell(
          onTap: widget.disabled ? null : _pickAColor,
          child: widget.customChild,
        ),
      );
    }
    return ThemedTextInput(
      label: widget.label,
      labelText: widget.labelText,
      prefixWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SizedBox(
          width: 20,
          height: 20,
          child: Container(
            decoration: BoxDecoration(
              color: _value,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const SizedBox(),
          ),
        ),
      ),
      onPrefixTap: widget.onPrefixTap,
      suffixIcon: MdiIcons.palette,
      disabled: widget.disabled,
      onTap: widget.disabled ? null : _pickAColor,
      dense: widget.dense,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      controller: _controller,
      readonly: true,
    );
  }

  void _pickAColor() async {
    Color value = await showColorPickerDialog(
      context,
      _value,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        copyFormat: ColorPickerCopyFormat.numHexRRGGBB,
        pasteButton: true,
      ),
      actionButtons: ColorPickerActionButtons(
        dialogActionButtons: true,
        dialogActionIcons: false,
        dialogOkButtonType: ColorPickerActionButtonType.outlined,
        dialogCancelButtonType: ColorPickerActionButtonType.text,
        dialogOkButtonLabel: widget.saveText,
        dialogCancelButtonLabel: widget.cancelText,
      ),
      enableShadesSelection: false,
      showColorCode: true,
      enableTonalPalette: false,
      enableOpacity: false,
      colorCodeHasColor: true,
      showColorValue: false,
      pickersEnabled: {
        ColorPickerType.both: widget.enabledTypes.contains(ColorPickerType.both),
        ColorPickerType.primary: widget.enabledTypes.contains(ColorPickerType.primary),
        ColorPickerType.accent: widget.enabledTypes.contains(ColorPickerType.accent),
        ColorPickerType.bw: widget.enabledTypes.contains(ColorPickerType.bw),
        ColorPickerType.custom: widget.enabledTypes.contains(ColorPickerType.custom),
        ColorPickerType.wheel: widget.enabledTypes.contains(ColorPickerType.wheel),
      },
    );

    setState(() {
      _value = value;
    });
    widget.onChanged?.call(value);
    _controller.text = "#${_value.hex}";
  }
}
