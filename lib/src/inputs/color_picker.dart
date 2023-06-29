part of layrz_theme;

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
  final double? width;
  final double? height;

  const ThemedColorPicker({
    Key? key,
    this.labelText,
    this.label,
    this.disabled = false,
    this.onChanged,
    this.value,
    this.errors = const [],
    this.hideDetails = false,
    this.padding = const EdgeInsets.all(10),
    this.dense = false,
    this.prefixIcon,
    this.onPrefixTap,
    this.placeholder,
    this.width,
    this.height,
    this.saveText = "OK",
  })  : assert((label == null && labelText != null) || (label != null && labelText == null)),
        super(key: key);

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
      onSuffixTap: _pickAColor,
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
      actionButtons: const ColorPickerActionButtons(
        okButton: true,
        closeButton: false,
        dialogActionButtons: false,
        dialogActionIcons: false,
        dialogOkButtonType: ColorPickerActionButtonType.outlined,
        dialogCancelButtonType: ColorPickerActionButtonType.text,
      ),
      enableShadesSelection: false,
      colorCodeHasColor: false,
      showColorValue: false,
      showColorCode: true,
      pickersEnabled: {
        ColorPickerType.wheel: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.custom: true,
        ColorPickerType.both: false,
        ColorPickerType.bw: false,
      },
    );

    setState(() {
      _value = value;
    });
    widget.onChanged?.call(value);
    _controller.text = "#${_value.hex}";
  }
}
