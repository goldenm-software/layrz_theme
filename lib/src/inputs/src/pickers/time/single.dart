part of inputs;

class ThemedTimePicker extends StatefulWidget {
  final TimeOfDay? value;
  final void Function(TimeOfDay)? onChanged;
  final String? labelText;
  final Widget? label;
  final String? placeholder;
  final String? prefixText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final VoidCallback? onPrefixTap;
  final Widget? customChild;
  final bool disabled;
  final Map<String, String> translations;
  final bool overridesLayrzTranslations;
  final String? pattern;
  final bool use24HourFormat;
  final Color hoverColor;
  final Color focusColor;
  final Color splashColor;
  final Color highlightColor;
  final BorderRadius borderRadius;

  /// [ThemedTimePicker] is a time picker input. It is a wrapper of [ThemedTextInput] with a time picker.
  const ThemedTimePicker({
    super.key,

    /// [value] is the value of the input.
    this.value,

    /// [onChanged] is the callback function when the input is changed.
    this.onChanged,

    /// [labelText] is the label text of the input. Avoid submit [label] and [labelText] at the same time.
    this.labelText,

    /// [label] is the label widget of the input. Avoid submit [label] and [labelText] at the same time.
    this.label,

    /// [placeholder] is the placeholder of the input.
    this.placeholder,

    /// [prefixText] is the prefix text of the input.
    this.prefixText,

    /// [prefixIcon] is the prefix icon of the input. Avoid submit [prefixIcon] and [prefixWidget] at the same time.
    this.prefixIcon,

    /// [prefixWidget] is the prefix widget of the input. Avoid submit [prefixIcon] and [prefixWidget] at the same time.
    this.prefixWidget,

    /// [onPrefixTap] is the callback function when the prefix is tapped.
    this.onPrefixTap,

    /// [customChild] is the custom child of the input.
    /// If it is submitted, the input will be ignored.
    this.customChild,

    /// [disabled] is the disabled state of the input.
    this.disabled = false,

    /// [translations] is the translations of the input. By default we use [LayrzAppLocalizations] for translations,
    /// but you can submit your own translations using this property. Consider when [LayrzAppLocalizations] is present,
    /// is the default value of this property.
    /// Required translations:
    /// - `actions.cancel` (Cancel)
    /// - `actions.save` (Save)
    /// - `layrz.timePicker.hours` (Hours)
    /// - `layrz.timePicker.minutes` (Minutes)
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'layrz.timePicker.hours': 'Hours',
      'layrz.timePicker.minutes': 'Minutes',
    },

    /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
    this.overridesLayrzTranslations = false,

    /// [pattern] is the pattern of the date. By default, depending of [use24HourFormat] we use `%I:%M %p` or `%H:%M`.
    /// If [pattern] is submitted, this will be used instead of the default.
    this.pattern,

    /// [use24HourFormat] is the flag to use 24 hour format. By default is false, so it will use 12 hour format.
    this.use24HourFormat = false,

    /// [hoverColor] is the hover color of the input. Only will affect when [customChild] is submitted.
    /// By default, it will use `Colors.transparent`.
    this.hoverColor = Colors.transparent,

    /// [focusColor] is the focus color of the input. Only will affect when [customChild] is submitted.
    /// By default, it will use `Colors.transparent`.
    this.focusColor = Colors.transparent,

    /// [splashColor] is the splash color of the input. Only will affect when [customChild] is submitted.
    /// By default, it will use `Colors.transparent`.
    this.splashColor = Colors.transparent,

    /// [highlightColor] is the highlight color of the input. Only will affect when [customChild] is submitted.
    /// By default, it will use `Colors.transparent`.
    this.highlightColor = Colors.transparent,

    /// [borderRadius] is the border radius of the input. Only will affect when [customChild] is submitted.
    /// By default, it will use `BorderRadius.circular(10)`.
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedTimePicker> createState() => _ThemedTimePickerState();
}

class _ThemedTimePickerState extends State<ThemedTimePicker> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);
  String get pattern => widget.pattern ?? (widget.use24HourFormat ? '%H:%M' : '%I:%M %p');

  String? get _parsedName {
    if (widget.value == null) {
      return null;
    }

    return DateTime(0, 0, 0, widget.value!.hour, widget.value!.minute, 0).format(pattern: pattern, i18n: i18n);
  }

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
      value: _parsedName ?? '',
      labelText: widget.labelText,
      label: widget.label,
      placeholder: widget.placeholder,
      prefixText: widget.prefixText,
      prefixIcon: widget.prefixIcon,
      prefixWidget: widget.prefixWidget,
      onPrefixTap: widget.onPrefixTap,
      suffixIcon: MdiIcons.clockOutline,
      disabled: widget.disabled,
      readonly: true,
      onTap: widget.disabled ? null : _showPicker,
    );
  }

  void _showPicker() async {
    TimeOfDay? result = await showDialog(
      context: context,
      builder: (context) => _ThemedTimeUtility(
        value: widget.value,
        use24HourFormat: widget.use24HourFormat,
        titleText: widget.labelText ?? '',
        hoursText: t('layrz.timePicker.hours'),
        minutesText: t('layrz.timePicker.minutes'),
        saveText: t('actions.save'),
        cancelText: t('actions.cancel'),
        inDialog: true,
      ),
    );

    if (result != null) {
      widget.onChanged?.call(result);
    }
  }

  String t(String key, [Map<String, dynamic> args = const {}]) {
    String result = LayrzAppLocalizations.of(context)?.t(key, args) ?? widget.translations[key] ?? key;

    if (widget.overridesLayrzTranslations) {
      result = widget.translations[key] ?? key;
    }

    if (args.isNotEmpty) {
      args.forEach((key, value) {
        result = result.replaceAll('{$key}', value.toString());
      });
    }

    return result;
  }
}
