part of '../../../inputs.dart';

class ThemedDateRangePicker extends StatefulWidget {
  /// [value] is the value of the input.
  final List<DateTime> value;

  /// [onChanged] is the callback function when the input is changed.
  final void Function(List<DateTime>)? onChanged;

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
  final Map<String, String> translations;

  /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
  final bool overridesLayrzTranslations;

  /// [pattern] is the pattern of the date. By default is `%Y-%m-%d`.
  final String pattern;

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

  /// [ThemedDateRangePicker] is a date picker input. It is a wrapper of [ThemedTextInput] with a date picker.
  const ThemedDateRangePicker({
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
      'layrz.monthPicker.year': 'Year {year}',
      'layrz.monthPicker.back': 'Previous year',
      'layrz.monthPicker.next': 'Next year',
    },
    this.overridesLayrzTranslations = false,
    this.pattern = '%Y-%m-%d',
    this.hoverColor = Colors.transparent,
    this.focusColor = Colors.transparent,
    this.splashColor = Colors.transparent,
    this.highlightColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.errors = const [],
    this.hideDetails = false,
    this.padding,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null)),
       assert(value.length == 0 || value.length == 2);

  @override
  State<ThemedDateRangePicker> createState() => _ThemedDateRangePickerState();
}

class _ThemedDateRangePickerState extends State<ThemedDateRangePicker> {
  final TextEditingController _controller = TextEditingController();
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  String? get _parsedName {
    if (widget.value.isEmpty) {
      return null;
    }

    return widget.value.map((e) => e.format(pattern: widget.pattern, i18n: i18n)).join(' - ');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.text = _parsedName ?? '';
    });
  }

  @override
  void didUpdateWidget(covariant ThemedDateRangePicker oldWidget) {
    if (widget.value != oldWidget.value) {
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
      suffixIcon: LayrzIcons.solarOutlineCalendar,
      disabled: widget.disabled,
      readonly: true,
      onTap: widget.disabled ? null : _showPicker,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      padding: widget.padding,
    );
  }

  void _showPicker() async {
    List<DateTime> filledDates = [];

    if (widget.value.isNotEmpty) {
      filledDates.add(widget.value.first);
      while (true) {
        final temp = filledDates.last.add(const Duration(days: 1));
        if (temp.isAfter(widget.value.last)) {
          break;
        }

        filledDates.add(temp);
      }
    }

    DateTime? tempDate;

    List<DateTime>? selected = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
            decoration: generateContainerElevation(context: context, elevation: 3),
            child: StatefulBuilder(
              builder: (context, setState) {
                return ThemedCalendar(
                  highlightedDays: tempDate != null ? [] : filledDates,
                  focusDay: tempDate,
                  focusOnHighlightedDays: tempDate == null,
                  isHighlightDaysAsRange: tempDate == null,
                  showEntries: false,
                  smallWeekdays: true,
                  todayIndicator: false,
                  todayButton: false,
                  onDayTap: (day) {
                    if (tempDate == null) {
                      tempDate = day;
                      setState(() {});
                      return;
                    }
                    if (tempDate!.isAfter(day)) {
                      Navigator.of(context).pop([day, tempDate!]);
                    } else {
                      Navigator.of(context).pop([tempDate!, day]);
                    }
                  },
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
