part of inputs;

class ThemedDatePicker extends StatefulWidget {
  final DateTime? value;
  final void Function(DateTime)? onChanged;
  final String? labelText;
  final Widget? label;
  final String? placeholder;
  final String? prefixText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final void Function()? onPrefixTap;
  final Widget? customChild;
  final bool disabled;
  final Map<String, String> translations;
  final bool overridesLayrzTranslations;
  final List<DateTime> disabledDays;
  final String pattern;

  /// [ThemedDatePicker] is a date picker input. It is a wrapper of [ThemedTextInput] with a date picker.
  const ThemedDatePicker({
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
    /// - `layrz.monthPicker.year` (Year {year})
    /// - `layrz.monthPicker.back` (Previous year)
    /// - `layrz.monthPicker.next` (Next year)
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'layrz.monthPicker.year': 'Year {year}',
      'layrz.monthPicker.back': 'Previous year',
      'layrz.monthPicker.next': 'Next year',
    },

    /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
    this.overridesLayrzTranslations = false,

    /// [disabledMonths] is the list of disabled months.
    this.disabledDays = const [],

    /// [pattern] is the pattern of the date. By default is `%Y-%m-%d`.
    this.pattern = '%Y-%m-%d',
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedDatePicker> createState() => _ThemedDatePickerState();
}

class _ThemedDatePickerState extends State<ThemedDatePicker> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  String? get _parsedName {
    if (widget.value == null) {
      return null;
    }

    return widget.value!.format(pattern: widget.pattern, i18n: i18n);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customChild != null) {
      return InkWell(
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
      suffixIcon: MdiIcons.calendar,
      disabled: widget.disabled,
      readonly: true,
      onTap: widget.disabled ? null : _showPicker,
    );
  }

  void _showPicker() async {
    DateTime? selected = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
            decoration: generateContainerElevation(context: context, elevation: 3),
            child: ThemedCalendar(
              focusDay: widget.value,
              showEntries: false,
              smallWeekdays: true,
              disabledDays: widget.disabledDays,
              onDayTap: (day) {
                Navigator.of(context).pop(day);
              },
            ),
          ),
        );
      },
    );

    if (selected != null) {
      widget.onChanged?.call(selected);
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
