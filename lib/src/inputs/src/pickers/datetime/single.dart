part of '../../../inputs.dart';

class ThemedDateTimePicker extends StatefulWidget {
  /// [value] is the value of the input.
  final DateTime? value;

  /// [onChanged] is the callback function when the input is changed.
  final void Function(DateTime)? onChanged;

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
  /// - `layrz.monthPicker.year` (Year {year})
  /// - `layrz.monthPicker.back` (Previous year)
  /// - `layrz.monthPicker.next` (Next year)
  /// - `layrz.datetimePicker.date` (Date)
  /// - `layrz.datetimePicker.time` (Time)
  /// - `layrz.timePicker.hours` (Hours)
  /// - `layrz.timePicker.minutes` (Minutes)
  /// - `layrz.calendar.month.back` (Previous month)
  /// - `layrz.calendar.month.next` (Next month)
  /// - `layrz.calendar.today` (Today)
  /// - `layrz.calendar.month` (View as month)
  /// - `layrz.calendar.pickMonth` (Pick a month)
  final Map<String, String> translations;

  /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
  final bool overridesLayrzTranslations;

  /// [disabledMonths] is the list of disabled months.
  final List<DateTime> disabledDays;

  /// [datePattern] is the date pattern of the date. By default is `%Y-%m-%d`.
  final String datePattern;

  /// [timePattern] is the time pattern of the date. By default, depending of [use24HourFormat] we use
  ///  `%I:%M %p` or `%H:%M`. If [timePattern] is submitted, this will be used instead of the default.
  final String? timePattern;

  /// [use24HourFormat] is the flag to use 24 hour format. By default is false, so it will use 12 hour format.
  final bool use24HourFormat;

  /// [patternSeparator] is the separator between date and time. By default is ` ` (space).
  final String patternSeparator;

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

  /// [emptyListText] is the text to be displayed when the list is empty.
  final EdgeInsets? padding;

  /// [ThemedDateTimePicker] is a date time picker input. It is a wrapper of [ThemedTextInput] with a date time picker.
  const ThemedDateTimePicker({
    super.key,
    this.value,
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
      'layrz.monthPicker.year': 'Year {year}',
      'layrz.monthPicker.back': 'Previous year',
      'layrz.monthPicker.next': 'Next year',
      'layrz.datetimePicker.date': 'Date',
      'layrz.datetimePicker.time': 'Time',
      'layrz.timePicker.hours': 'Hours',
      'layrz.timePicker.minutes': 'Minutes',
      'layrz.calendar.month.back': 'Previous month',
      'layrz.calendar.month.next': 'Next month',
      'layrz.calendar.today': 'Today',
      'layrz.calendar.month': 'View as month',
      'layrz.calendar.pickMonth': 'Pick a month',
    },
    this.overridesLayrzTranslations = false,
    this.disabledDays = const [],
    this.datePattern = '%Y-%m-%d',
    this.timePattern,
    this.use24HourFormat = false,
    this.patternSeparator = ' ',
    this.hoverColor = Colors.transparent,
    this.focusColor = Colors.transparent,
    this.splashColor = Colors.transparent,
    this.highlightColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.errors = const [],
    this.hideDetails = false,
    this.padding,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedDateTimePicker> createState() => _ThemedDateTimePickerState();
}

class _ThemedDateTimePickerState extends State<ThemedDateTimePicker> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late TabController _tabController;
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  String get timePattern => widget.timePattern ?? (widget.use24HourFormat ? '%H:%M' : '%I:%M %p');
  String get pattern => '${widget.datePattern}${widget.patternSeparator}$timePattern';

  String? get _parsedName {
    if (widget.value == null) {
      return null;
    }

    return widget.value!.format(pattern: pattern, i18n: i18n);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.text = _parsedName ?? '';
    });
  }

  @override
  void didUpdateWidget(ThemedDateTimePicker oldWidget) {
    if (widget.value != oldWidget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.text = _parsedName ?? '';
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      suffixIcon: LayrzIcons.solarOutlineCalendar,
      disabled: widget.disabled,
      readonly: true,
      onTap: widget.disabled ? null : _showPicker,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
    );
  }

  void _showPicker() async {
    DateTime? selected = await showDialog(
      context: context,
      builder: (context) {
        DateTime now = DateTime.now();
        DateTime? date = DateTime(
          widget.value?.year ?? now.year,
          widget.value?.month ?? now.month,
          widget.value?.day ?? now.day,
        );
        TimeOfDay? time = TimeOfDay(
          hour: widget.value?.hour ?? now.hour,
          minute: widget.value?.minute ?? now.minute,
        );

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: generateContainerElevation(context: context, elevation: 3),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.labelText ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _tabController.index == 0
                                    ? null
                                    : () {
                                        _tabController.animateTo(0);
                                        setState(() {});
                                      },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        _tabController.index == 0 ? Theme.of(context).primaryColor : Colors.transparent,
                                  ),
                                  child: Text(
                                    t('layrz.datetimePicker.date'),
                                    style: TextStyle(
                                      color: _tabController.index == 0
                                          ? isDark
                                              ? Colors.white
                                              : validateColor(color: Theme.of(context).primaryColor)
                                          : null,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _tabController.index == 1
                                    ? null
                                    : () {
                                        _tabController.animateTo(1);
                                        setState(() {});
                                      },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        _tabController.index == 1 ? Theme.of(context).primaryColor : Colors.transparent,
                                  ),
                                  child: Text(
                                    t('layrz.datetimePicker.time'),
                                    style: TextStyle(
                                      color: _tabController.index == 1
                                          ? isDark
                                              ? Colors.white
                                              : validateColor(color: Theme.of(context).primaryColor)
                                          : null,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          ThemedCalendar(
                            focusDay: date,
                            showEntries: false,
                            smallWeekdays: true,
                            disabledDays: widget.disabledDays,
                            translations: widget.translations,
                            overridesLayrzTranslations: widget.overridesLayrzTranslations,
                            onDayTap: (newDate) => setState(() => date = newDate),
                          ),
                          Column(
                            children: [
                              const Spacer(),
                              _ThemedTimeUtility(
                                value: time,
                                use24HourFormat: widget.use24HourFormat,
                                titleText: widget.labelText ?? '',
                                hoursText: t('layrz.timePicker.hours'),
                                minutesText: t('layrz.timePicker.minutes'),
                                saveText: t('actions.save'),
                                cancelText: t('actions.cancel'),
                                inDialog: false,
                                onChanged: (newTime) => setState(() => time = newTime),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ThemedButton.cancel(
                          labelText: t('actions.cancel'),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        ThemedButton.save(
                          labelText: t('actions.save'),
                          onTap: () {
                            if (date != null && time != null) {
                              _tabController.animateTo(0);
                              Navigator.of(context).pop(DateTime(
                                date!.year,
                                date!.month,
                                date!.day,
                                time!.hour,
                                time!.minute,
                                0,
                              ));
                            }
                          },
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

    if (selected != null) {
      widget.onChanged?.call(selected);
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
