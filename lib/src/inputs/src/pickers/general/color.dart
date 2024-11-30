part of '../../../inputs.dart';

class ThemedColorPicker extends StatefulWidget {
  /// [labelText] is the text that will be displayed on the label.
  /// Avoid submit [label] and [labelText] at the same time. We priorize [label] over [labelText].
  final String? labelText;

  /// [label] is the widget that will be displayed on the label.
  /// Avoid submit [label] and [labelText] at the same time. We priorize [label] over [labelText].
  final Widget? label;

  /// [disabled] is the state of the input being disabled.
  final void Function(Color)? onChanged;

  /// [onChanged] is the callback function when the input is changed.
  final Color? value;

  /// [value] is the value of the input.
  final bool disabled;

  /// [errors] is the list of errors of the input.
  final List<String> errors;

  /// [hideDetails] is the state of hiding the details of the input.
  final bool hideDetails;

  /// [padding] is the padding of the input.
  final EdgeInsets? padding;

  /// [dense] is the state of the input being dense.
  final bool dense;

  /// [prefixIcon] is the prefix icon of the input.
  final IconData? prefixIcon;

  /// [onPrefixTap] is the callback function when the prefix is tapped.
  final VoidCallback? onPrefixTap;

  /// [placeholder] is the placeholder of the input.
  final String? placeholder;

  /// [saveText] is the text that will be displayed on the save button.
  final String saveText;

  /// [cancelText] is the text that will be displayed on the cancel button.
  final String cancelText;

  /// [enabledTypes] is the list of enabled color picker types.
  final List<ColorPickerType> enabledTypes;

  /// [customChild] is the custom child of the input.
  /// If this is not null, the input will be render as a [ThemedTextInput].
  final Widget? customChild;

  /// [hoverColor] is the hover color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color hoverColor;

  /// [focusColor] is the focus color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color focusColor;

  /// [splashColor] is the splash color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color splashColor;

  /// [highlightColor] is the highlight color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color highlightColor;

  /// [borderRadius] is the border radius of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `BorderRadius.circular(10)`.
  final BorderRadius borderRadius;

  /// [maxWidth] is the max width of the dialog.
  final double maxWidth;

  /// [ThemedColorPicker] is a [ThemedTextInput] that allows the user to pick a color.
  const ThemedColorPicker({
    super.key,
    this.labelText,
    this.label,
    this.disabled = false,
    this.onChanged,
    this.value,
    this.errors = const [],
    this.hideDetails = false,
    this.padding,
    this.dense = false,
    this.prefixIcon,
    this.onPrefixTap,
    this.placeholder,
    this.saveText = "OK",
    this.cancelText = "Cancel",
    this.enabledTypes = const [
      ColorPickerType.both,
      ColorPickerType.wheel,
    ],
    this.customChild,
    this.hoverColor = Colors.transparent,
    this.focusColor = Colors.transparent,
    this.splashColor = Colors.transparent,
    this.highlightColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.maxWidth = 400,
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

  EdgeInsets get widgetPadding => widget.padding ?? ThemedTextInput.outerPadding;
  bool get isDense => widget.dense;

  @override
  Widget build(BuildContext context) {
    if (widget.customChild != null) {
      return InkWell(
        hoverColor: widget.hoverColor,
        focusColor: widget.focusColor,
        splashColor: widget.splashColor,
        highlightColor: widget.highlightColor,
        borderRadius: widget.borderRadius,
        onTap: widget.disabled ? null : _showPicker,
        child: widget.customChild!,
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
      suffixIcon: LayrzIcons.solarOutlinePalette2,
      disabled: widget.disabled,
      onTap: widget.disabled ? null : _showPicker,
      dense: widget.dense,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      controller: _controller,
      readonly: true,
      padding: widget.padding,
    );
  }

  void _showPicker() async {
    Color? value = await showDialog<Color>(
      context: context,
      builder: (context) {
        Color currentColor = _value;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: generateContainerElevation(context: context, elevation: 3),
            constraints: BoxConstraints(maxWidth: widget.maxWidth),
            padding: const EdgeInsets.all(10),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ColorPicker(
                      color: currentColor,
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
                      onColorChanged: (value) {
                        setState(() {
                          currentColor = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ThemedButton.cancel(
                          labelText: widget.cancelText,
                          onTap: () => Navigator.of(context).pop(null),
                        ),
                        ThemedButton.save(
                          labelText: widget.saveText,
                          onTap: () => Navigator.of(context).pop(currentColor),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    if (value == null) return;
    setState(() => _value = value);
    widget.onChanged?.call(value);
    _controller.text = "#${_value.hex}";
  }
}
