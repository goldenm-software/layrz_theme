part of '../../../inputs.dart';

class ThemedTimeRangePicker extends StatefulWidget {
  /// [value] is the value of the input.
  final List<TimeOfDay> value;

  /// [onChanged] is the callback function when the input is changed.
  final void Function(List<TimeOfDay>)? onChanged;

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

  /// [customChild] is the custom child of the input.
  /// If it is submitted, the input will be ignored.
  final Widget? customChild;

  /// [disabled] is the disabled state of the input.
  final bool disabled;

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
  final Map<String, String> translations;

  /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
  final bool overridesLayrzTranslations;

  /// [pattern] is the pattern of the date. By default, depending of [use24HourFormat] we use `%I:%M %p` or `%H:%M`.
  /// If [pattern] is submitted, this will be used instead of the default.
  final String? pattern;

  /// [use24HourFormat] is the flag to use 24 hour format. By default is false, so it will use 12 hour format.
  final bool use24HourFormat;

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

  /// [errors] is the list of errors of the input.
  final List<String> errors;

  /// [hideDetails] is the state of hiding the details of the input.
  final bool hideDetails;

  /// disables blinking animation of the time selectors
  final bool disableBlink;

  /// [padding] is the padding of the input
  final EdgeInsets? padding;

  /// [ThemedTimeRangePicker] is a time range picker input. It is a wrapper of [ThemedTextInput]
  /// with a time range picker.
  const ThemedTimeRangePicker({
    super.key,
    this.value = const [],
    this.onChanged,
    this.labelText,
    this.label,
    this.placeholder,
    this.prefixText,
    this.prefixIcon,
    this.prefixWidget,
    this.onPrefixTap,
    this.customChild,
    this.disabled = false,
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'layrz.timePicker.hours': 'Hours',
      'layrz.timePicker.minutes': 'Minutes',
      'layrz.timePicker.start': 'Start time',
      'layrz.timePicker.end': 'End time',
    },
    this.overridesLayrzTranslations = false,
    this.pattern,
    this.use24HourFormat = false,
    this.hoverColor = Colors.transparent,
    this.focusColor = Colors.transparent,
    this.splashColor = Colors.transparent,
    this.highlightColor = Colors.transparent,
    this.borderRadius = const .all(.circular(10)),
    this.errors = const [],
    this.hideDetails = false,
    this.disableBlink = false,
    this.padding,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null)),
       assert(value.length == 0 || value.length == 2);

  @override
  State<ThemedTimeRangePicker> createState() => _ThemedTimeRangePickerState();
}

class _ThemedTimeRangePickerState extends State<ThemedTimeRangePicker> {
  final TextEditingController _controller = TextEditingController();
  LayrzAppLocalizations? get i18n => .maybeOf(context);
  String get pattern => widget.pattern ?? (widget.use24HourFormat ? '%H:%M' : '%I:%M %p');

  String? get _parsedName {
    if (widget.value.isEmpty) {
      return null;
    }

    return widget.value
        .map((t) {
          return DateTime(0, 0, 0, t.hour, t.minute, 0).format(pattern: pattern, i18n: i18n);
        })
        .join(' - ');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.text = _parsedName ?? '';
    });
  }

  @override
  void didUpdateWidget(covariant ThemedTimeRangePicker oldWidget) {
    final eq = const ListEquality().equals;
    if (!eq(widget.value, oldWidget.value)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.text = _parsedName ?? '';
      });
    }
    super.didUpdateWidget(oldWidget);
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
      controller: _controller,
      value: _parsedName ?? '',
      labelText: widget.labelText,
      label: widget.label,
      placeholder: widget.placeholder,
      prefixText: widget.prefixText,
      prefixIcon: widget.prefixIcon,
      prefixWidget: widget.prefixWidget,
      onPrefixTap: widget.onPrefixTap,
      suffixIcon: LayrzIcons.solarOutlineClockSquare,
      disabled: widget.disabled,
      readonly: true,
      onTap: widget.disabled ? null : _showPicker,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      padding: widget.padding,
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
            padding: const .all(20),
            constraints: BoxConstraints(maxWidth: 400, maxHeight: widget.use24HourFormat ? 430 : 550),
            decoration: generateContainerElevation(context: context, elevation: 3),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  widget.labelText ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: .bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            t('layrz.timePicker.start'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: .bold),
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
                            disableBlink: widget.disableBlink,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t('layrz.timePicker.end'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: .bold),
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
                            disableBlink: widget.disableBlink,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    ThemedButton.cancel(
                      labelText: t('actions.cancel'),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    ThemedButton.save(
                      labelText: t('actions.save'),
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
    String result = LayrzAppLocalizations.maybeOf(context)?.t(key, args) ?? widget.translations[key] ?? key;

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
