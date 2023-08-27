part of inputs;

class ThemedTimeRangePicker extends StatefulWidget {
  final List<TimeOfDay> value;
  final void Function(List<TimeOfDay>)? onChanged;
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
  final String? pattern;
  final bool use24HourFormat;

  /// [ThemedTimeRangePicker] is a time range picker input. It is a wrapper of [ThemedTextInput]
  /// with a time range picker.
  const ThemedTimeRangePicker({
    super.key,

    /// [value] is the value of the input.
    this.value = const [],

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
    /// - `layrz.timePicker.start` (Start time)
    /// - `layrz.timePicker.end` (End time)
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'layrz.timePicker.hours': 'Hours',
      'layrz.timePicker.minutes': 'Minutes',
      'layrz.timePicker.start': 'Start time',
      'layrz.timePicker.end': 'End time',
    },

    /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
    this.overridesLayrzTranslations = false,

    /// [pattern] is the pattern of the date. By default, depending of [use24HourFormat] we use `%I:%M %p` or `%H:%M`.
    /// If [pattern] is submitted, this will be used instead of the default.
    this.pattern,

    /// [use24HourFormat] is the flag to use 24 hour format. By default is false, so it will use 12 hour format.
    this.use24HourFormat = false,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedTimeRangePicker> createState() => _ThemedTimeRangePickerState();
}

class _ThemedTimeRangePickerState extends State<ThemedTimeRangePicker> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);
  String get pattern => widget.pattern ?? (widget.use24HourFormat ? '%H:%M' : '%I:%M %p');

  String? get _parsedName {
    if (widget.value.isEmpty) {
      return null;
    }

    return widget.value.map((t) {
      return DateTime(0, 0, 0, t.hour, t.minute, 0).format(pattern: pattern, i18n: i18n);
    }).join(' - ');
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
      suffixIcon: MdiIcons.clockOutline,
      disabled: widget.disabled,
      readonly: true,
      onTap: widget.disabled ? null : _showPicker,
    );
  }

  void _showPicker() async {
    TimeOfDay? start;
    TimeOfDay? end;

    if (widget.value.length == 2) {
      start = widget.value[0];
      end = widget.value[1];
    }

    List<TimeOfDay?>? result = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: BoxConstraints(maxWidth: 400, maxHeight: widget.use24HourFormat ? 430 : 530),
            decoration: generateContainerElevation(context: context, elevation: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.labelText ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t('layrz.timePicker.start'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          _ThemedTimeUtility(
                            value: start,
                            use24HourFormat: widget.use24HourFormat,
                            titleText: widget.labelText ?? '',
                            hoursText: t('layrz.timePicker.hours'),
                            minutesText: t('layrz.timePicker.minutes'),
                            saveText: t('actions.save'),
                            cancelText: t('actions.cancel'),
                            inDialog: false,
                            onChanged: (time) => setState(() => start = time),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t('layrz.timePicker.end'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          _ThemedTimeUtility(
                            value: end,
                            use24HourFormat: widget.use24HourFormat,
                            titleText: widget.labelText ?? '',
                            hoursText: t('layrz.timePicker.hours'),
                            minutesText: t('layrz.timePicker.minutes'),
                            saveText: t('actions.save'),
                            cancelText: t('actions.cancel'),
                            inDialog: false,
                            onChanged: (time) => setState(() => end = time),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ThemedButton(
                      labelText: t('actions.cancel'),
                      color: Colors.red,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    ThemedButton(
                      labelText: t('actions.save'),
                      color: Colors.green,
                      onTap: () => Navigator.of(context).pop([start, end]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      if (result.whereType<TimeOfDay>().length == 2) {
        final sorted = result.map((e) => e!).toList();
        sorted.sort((a, b) {
          if (a.hour == b.hour) {
            return a.minute.compareTo(b.minute);
          }

          return a.hour.compareTo(b.hour);
        });
        widget.onChanged?.call(sorted);
      }
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
