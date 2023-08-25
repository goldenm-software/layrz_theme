part of inputs;

enum ThemedCheckboxInputStyle {
  /// [ThemedCheckboxInputStyle.asField] is a checkbox that is displayed as a field.
  asField,

  /// [ThemedCheckboxInputStyle.asSwitch] is a checkbox that is displayed as a switch.
  asSwitch,

  /// [ThemedCheckboxInputStyle.asFlutterCheckbox] is a checkbox that is displayed as a checkbox (Flutter native).
  asFlutterCheckbox,

  /// [ThemedCheckboxInputStyle.asCheckbox2] is a checkbox that is displayed as a checkbox using the new design.
  asCheckbox2,
}

class ThemedCheckboxInput extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final void Function(bool)? onChanged;
  final bool value;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final EdgeInsets padding;
  final bool dense;
  final ThemedCheckboxInputStyle style;

  /// [ThemedCheckboxInput] is a checkbox input.
  /// It can be a flutter checkbox, field or switch, control that using [style] property.
  const ThemedCheckboxInput({
    super.key,

    /// [labelText] is the label text of the checkbox. Avoid submit [label] and [labelText] at the same time.
    this.labelText,

    /// [label] is the label widget of the checkbox. Avoid submit [label] and [labelText] at the same time.
    this.label,

    /// [onChanged] is the callback function when the checkbox is changed.
    this.disabled = false,

    /// [value] is the value of the checkbox.
    this.onChanged,

    /// [disabled] is the disabled state of the checkbox.
    this.value = false,

    /// [errors] is the list of errors of the checkbox.
    this.errors = const [],

    /// [hideDetails] is the state of hiding the details of the checkbox.
    this.hideDetails = false,

    /// [padding] is the padding of the checkbox.
    this.padding = const EdgeInsets.all(10),

    /// [dense] is the state of the checkbox being dense.
    this.dense = false,

    /// [style] is the style of the checkbox.
    this.style = ThemedCheckboxInputStyle.asCheckbox2,
  }) : assert(label == null || labelText == null);

  @override
  State<ThemedCheckboxInput> createState() => _ThemedCheckboxInputState();
}

class _ThemedCheckboxInputState extends State<ThemedCheckboxInput> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(ThemedCheckboxInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() => _value = widget.value);
    }
  }

  EdgeInsets get widgetPadding => widget.padding;
  bool get isDense => widget.dense;
  // ignore: deprecated_member_use_from_same_package
  ThemedCheckboxInputStyle get style => widget.style;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case ThemedCheckboxInputStyle.asField:
        return _buildAsField();
      case ThemedCheckboxInputStyle.asSwitch:
        return _buildAsSwitch();
      case ThemedCheckboxInputStyle.asFlutterCheckbox:
        return _buildAsCheckbox();
      default:
        return _buildAsCheckbox(asNewDesign: true);
    }
  }

  Widget _buildAsField() {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);

    return ThemedSelectInput<bool>(
      labelText: widget.labelText,
      label: widget.label,
      disabled: widget.disabled,
      onChanged: (value) {
        widget.onChanged?.call(value?.value ?? false);
      },
      value: _value,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      padding: widgetPadding,
      dense: isDense,
      enableSearch: false,
      items: [
        ThemedSelectItem(
          value: true,
          label: i18n?.t('helpers.true') ?? "Yes",
        ),
        ThemedSelectItem(
          value: false,
          label: i18n?.t('helpers.false') ?? "No",
        ),
      ],
    );
  }

  Widget _buildAsSwitch() {
    return Padding(
      padding: widgetPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Switch(
                value: _value,
                onChanged: widget.disabled
                    ? null
                    : (value) {
                        widget.onChanged?.call(value);
                      },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: widget.disabled
                      ? null
                      : () {
                          widget.onChanged?.call(!_value);
                        },
                  child: widget.label ?? Text(widget.labelText ?? ""),
                ),
              ),
            ],
          ),
          ThemedFieldDisplayError(errors: widget.errors, hideDetails: widget.hideDetails),
        ],
      ),
    );
  }

  Widget _buildAsCheckbox({bool asNewDesign = false}) {
    return Padding(
      padding: widgetPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if (asNewDesign) ...[
                ThemedAnimatedCheckbox(
                  value: _value,
                  onChanged: widget.disabled
                      ? null
                      : (bool? value) {
                          widget.onChanged?.call(value ?? false);
                        },
                ),
              ] else ...[
                Checkbox(
                  value: _value,
                  onChanged: widget.disabled
                      ? null
                      : (bool? value) {
                          widget.onChanged?.call(value ?? false);
                        },
                ),
              ],
              Expanded(
                child: GestureDetector(
                  onTap: widget.disabled
                      ? null
                      : () {
                          widget.onChanged?.call(!_value);
                        },
                  child: widget.label ?? Text(widget.labelText ?? ""),
                ),
              ),
            ],
          ),
          ThemedFieldDisplayError(errors: widget.errors, hideDetails: widget.hideDetails),
        ],
      ),
    );
  }
}
