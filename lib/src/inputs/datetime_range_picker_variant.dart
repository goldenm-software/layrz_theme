part of inputs;

enum DatePickerQuickOptions {
  today,
  yesterday,
  lastWeek,
  lastMonth,
  lastYear;

  String label({
    /// translation function
    required String Function(String) translation,
  }) {
    switch (this) {
      case DatePickerQuickOptions.today:
        return translation('calendar.today');
      case DatePickerQuickOptions.yesterday:
        return translation('calendar.yesterday');
      case DatePickerQuickOptions.lastWeek:
        return translation('calendar.last_week');
      case DatePickerQuickOptions.lastMonth:
        return translation('calendar.last_month');
      case DatePickerQuickOptions.lastYear:
        return translation('calendar.last_year');
    }
  }
}

class ThemedDateTimeRangePickerVariant extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final List<DateTime>? value;
  final String? placeholder;
  final IconData? prefixIcon;
  final String? prefixText;
  final void Function()? onPrefixTap;
  final void Function(List<DateTime>)? onChanged;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final LayrzAppLocalizations? i18n;

  const ThemedDateTimeRangePickerVariant({
    super.key,
    this.i18n,
    this.value,
    this.labelText,
    this.label,
    this.disabled = false,
    this.placeholder,
    this.prefixIcon,
    this.prefixText,
    this.onPrefixTap,
    this.onChanged,
    this.errors = const [],
    this.hideDetails = false,
  })  : assert(label == null || labelText == null),
        assert(value == null || value.length == 2);

  @override
  State<ThemedDateTimeRangePickerVariant> createState() => _ThemedDateTimeRangePickerVariantState();
}

class _ThemedDateTimeRangePickerVariantState extends State<ThemedDateTimeRangePickerVariant> {
  late List<DateTime> _value;
  late DateTime _search;
  final TextEditingController _controller = TextEditingController();
  late ThemeData theme;

  DatePickerQuickOptions _quickOption = DatePickerQuickOptions.today;

  Map<String, String> get _internalTranslations => {
        'calendar.weekdays.monday': 'Monday',
        'calendar.weekdays.tuesday': 'Tuesday',
        'calendar.weekdays.wednesday': 'Wednesday',
        'calendar.weekdays.thursday': 'Thursday',
        'calendar.weekdays.friday': 'Friday',
        'calendar.weekdays.saturday': 'Saturday',
        'calendar.weekdays.sunday': 'Sunday',
        'calendar.months.1': 'January',
        'calendar.months.2': 'February',
        'calendar.months.3': 'March',
        'calendar.months.4': 'April',
        'calendar.months.5': 'May',
        'calendar.months.6': 'June',
        'calendar.months.7': 'July',
        'calendar.months.8': 'August',
        'calendar.months.9': 'September',
        'calendar.months.10': 'October',
        'calendar.months.11': 'November',
        'calendar.months.12': 'December',
        'calendar.actions.save': 'Save',
        'calendar.actions.cancel': 'Cancel',
        'calendar.actions.today': 'Today',
        'calendar.time.hour': 'Hour',
        'calendar.time.minute': 'Minute',
        'calendar.startAt.time': 'Start time',
        'calendar.endAt.time': 'End time',
        'calendar.today': 'Today',
        'calendar.yesterday': 'Yesterday',
        'calendar.last_week': 'Last week',
        'calendar.last_month': 'Last month',
        'calendar.last_year': 'Last year',
        'calendar.end_date': 'End date',
        'calendar.start_date': 'Start date',
        'calendar.actions.year': 'Year',
        'calendar.actions.month': 'Month',
        'calendar.actions.day': 'Day',
        'calendar.actions.quick_actions': 'Quick actions',
      };

  final List<DateTime> _temporalPicks = [];

  // List<ThemedSelectItem<int>> get _hours => List.generate(24, (i) {
  //       return ThemedSelectItem<int>(
  //         value: i,
  //         label: i.toString().padLeft(2, '0'),
  //       );
  //     }).toList();

  // List<ThemedSelectItem<int>> get _minutes => List.generate(60, (i) {
  //       return ThemedSelectItem<int>(
  //         value: i,
  //         label: i.toString().padLeft(2, '0'),
  //       );
  //     }).toList();

  String get parsedDate {
    String start = "";
    String end = "";

    if (_temporalPicks.isNotEmpty) {
      start = _temporalPicks.first.format(pattern: '%Y-%m-%d %H:%M');
      end = "N/A";
    } else {
      if (_value.isNotEmpty) {
        start = _value.first.format(pattern: '%Y-%m-%d %H:%M');
      } else {
        start = "N/A";
      }

      if (_value.length > 1) {
        end = _value.last.format(pattern: '%Y-%m-%d %H:%M');
      } else {
        end = "N/A";
      }
    }

    return "$start - $end";
  }

  late Size size;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _value = widget.value ?? [now, now.add(const Duration(hours: 1))];
    _search = _value.first;

    _controller.text = parsedDate;
  }

  @override
  void didUpdateWidget(ThemedDateTimeRangePickerVariant oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value && _temporalPicks.isEmpty) {
      final now = DateTime.now();
      _value = widget.value ?? [now, now.add(const Duration(hours: 1))];
      _search = _value.first;
      _controller.text = parsedDate;
      Future.delayed(Duration.zero, () {
        widget.onChanged?.call(_value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    return ThemedTextInput(
      key: widget.key,
      label: widget.label,
      labelText: widget.labelText,
      prefixIcon: widget.prefixIcon,
      prefixText: widget.prefixText,
      onPrefixTap: widget.onPrefixTap,
      suffixIcon: MdiIcons.calendar,
      disabled: widget.disabled,
      onTap: _showModal,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      controller: _controller,
      readonly: true,
    );
  }

  void _showModal() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            List<List<_InternalDateDraw>> month = generateMonth(_search);
            return Dialog(
              child: PointerInterceptor(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                    maxHeight: size.height * 0.9,
                  ),
                  height: 725,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(10).subtract(const EdgeInsets.only(bottom: 10)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    t('calendar.months.${_search.month}'),
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: validateColor(color: Theme.of(context).primaryColor),
                                        ),
                                  ),
                                ),

                                /// Quick options
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: DropdownButtonFormField<DatePickerQuickOptions>(
                                      // isExpanded: true,
                                      menuMaxHeight: 300,
                                      value: _quickOption,
                                      // hint: Text(t('calendar.actions.quick_actions')),
                                      icon: Icon(
                                        MdiIcons.chevronDown,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        label: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                            t('calendar.actions.quick_actions'),
                                          ),
                                        ),
                                      ),
                                      items: DatePickerQuickOptions.values.map((option) {
                                        return DropdownMenuItem<DatePickerQuickOptions>(
                                          value: option,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              option.label(translation: t),
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        _quickOption = value!;
                                        updateDateFromQuickPick(_quickOption);
                                        setLocalState(() {});
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                // Focus Today
                                Tooltip(
                                  message: t('calendar.actions.today'),
                                  child: InkWell(
                                    child: Icon(
                                      MdiIcons.calendar,
                                      color: validateColor(color: Theme.of(context).primaryColor),
                                    ),
                                    onTap: () {
                                      setLocalState(() {
                                        // _value = [DateTime.now(), DateTime.now()];
                                        _search = DateTime.now();
                                      });
                                    },
                                  ),
                                ),
                                VerticalDivider(
                                  color: validateColor(color: Theme.of(context).primaryColor),
                                ),

                                /// previous month
                                InkWell(
                                  child: Icon(
                                    MdiIcons.chevronLeft,
                                    color: validateColor(color: Theme.of(context).primaryColor),
                                  ),
                                  onTap: () {
                                    setLocalState(() {
                                      _search = _search.subtract(
                                        Duration(days: _search.day + 1),
                                      );
                                    });
                                  },
                                ),

                                /// next month
                                InkWell(
                                  child: Icon(
                                    MdiIcons.chevronRight,
                                    color: validateColor(color: Theme.of(context).primaryColor),
                                  ),
                                  onTap: () {
                                    setLocalState(() {
                                      DateTime newSearch = _search.add(Duration(days: _search.day + 1));
                                      if (newSearch.month == _search.month) {
                                        _search = newSearch.add(const Duration(days: 2));
                                      } else {
                                        _search = newSearch;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                'sunday',
                                'monday',
                                'tuesday',
                                'wednesday',
                                'thursday',
                                'friday',
                                'saturday',
                              ].map((e) {
                                return Expanded(
                                  child: drawDay(t('calendar.weekdays.$e').substring(0, 1), isHeader: true),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: month.map((week) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: week.map((e) {
                                return Expanded(
                                  child: drawDay(
                                    e.value.day.toString().padLeft(2, '0'),
                                    setLocalState: setLocalState,
                                    value: e.value,
                                    obscure: e.obscure,
                                    selected: validateIfInside(e.value),
                                    disabled: e.disabled,
                                  ),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ),
                      Center(
                        child: Text(t('calendar.start_date')),
                      ),

                      /// Row to change start date: year, month and day
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: DropdownButtonFormField<int>(
                                  menuMaxHeight: 300,
                                  value: _value.first.month,
                                  icon: Icon(
                                    MdiIcons.chevronDown,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: t('calendar.actions.month'),
                                  ),
                                  items: List.generate(12, (index) {
                                    return DropdownMenuItem<int>(
                                      value: index + 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          t('calendar.months.${index + 1}'),
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setLocalState(() {
                                      _value.first = DateTime(_value.first.year, value!, _value.first.day);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: DropdownButtonFormField<int>(
                                  menuMaxHeight: 300,
                                  value: _value.first.day,
                                  icon: Icon(
                                    MdiIcons.chevronDown,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: t('calendar.actions.day'),
                                  ),
                                  items: List.generate(31, (index) {
                                    return DropdownMenuItem<int>(
                                      value: index + 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          (index + 1).toString(),
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setLocalState(() {
                                      _value.first = DateTime(_value.first.year, _value.first.month, value!);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: DropdownButtonFormField<int>(
                                  menuMaxHeight: 300,
                                  value: _value.first.year,
                                  icon: Icon(
                                    MdiIcons.chevronDown,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: t('calendar.actions.year'),
                                  ),
                                  items: List.generate(20, (index) {
                                    int year = DateTime.now().year + 1 - index;
                                    return DropdownMenuItem<int>(
                                      value: year,
                                      child: Text(
                                        (year).toString(),
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setLocalState(() {
                                      _value.first = DateTime(value!, _value.first.month, _value.first.day);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(t('calendar.end_date')),
                      ),

                      /// Row to change the end date: year, month and day
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: DropdownButtonFormField<int>(
                                  menuMaxHeight: 300,
                                  value: _value.last.month,
                                  icon: Icon(
                                    MdiIcons.chevronDown,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: t('calendar.actions.month'),
                                  ),
                                  items: List.generate(12, (index) {
                                    return DropdownMenuItem<int>(
                                      value: index + 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          t('calendar.months.${index + 1}'),
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setLocalState(() {
                                      _value.last = DateTime(_value.last.year, value!, _value.last.day);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: DropdownButtonFormField<int>(
                                  menuMaxHeight: 300,
                                  value: _value.last.day,
                                  icon: Icon(
                                    MdiIcons.chevronDown,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: t('calendar.actions.day'),
                                  ),
                                  items: List.generate(31, (index) {
                                    return DropdownMenuItem<int>(
                                      value: index + 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          (index + 1).toString(),
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setLocalState(() {
                                      _value.last = DateTime(_value.last.year, _value.last.month, value!);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: DropdownButtonFormField<int>(
                                  menuMaxHeight: 300,
                                  value: _value.last.year,
                                  icon: Icon(
                                    MdiIcons.chevronDown,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: t('calendar.actions.year'),
                                  ),
                                  items: List.generate(20, (index) {
                                    int year = DateTime.now().year + 1 - index;
                                    return DropdownMenuItem<int>(
                                      value: year,
                                      child: Text(
                                        (year).toString(),
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setLocalState(() {
                                      _value.last = DateTime(value!, _value.last.month, _value.last.day);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: ThemedButton(
                                style: ThemedButtonStyle.filledTonal,
                                labelText: t('calendar.actions.save'),
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Update the selected range based of the quick options
  void updateDateFromQuickPick(DatePickerQuickOptions option) {
    //
    switch (option) {
      case DatePickerQuickOptions.today:
        _value = [DateTime.now(), DateTime.now()];
        break;
      case DatePickerQuickOptions.yesterday:
        _value = [
          DateTime.now().subtract(const Duration(days: 1)),
          DateTime.now().subtract(const Duration(days: 1)),
        ];
        break;
      case DatePickerQuickOptions.lastWeek:
        _value = [
          DateTime.now().subtract(const Duration(days: 7)),
          DateTime.now(),
        ];
        break;
      case DatePickerQuickOptions.lastMonth:
        _value = [
          DateTime.now().subtract(const Duration(days: 30)),
          DateTime.now(),
        ];
        break;
      case DatePickerQuickOptions.lastYear:
        _value = [
          DateTime.now().subtract(const Duration(days: 365)),
          DateTime.now(),
        ];
        break;
    }
  }

  void updateAllDependencies() {
    _controller.text = parsedDate;
    if (_temporalPicks.isEmpty) {
      Future.delayed(Duration.zero, () {
        widget.onChanged?.call(_value);
      });
    }
  }

  bool validateIfInside(DateTime day) {
    if (_temporalPicks.isEmpty) {
      bool contains = false;
      DateTime today = DateTime(day.year, day.month, day.day, 12, 0, 0);
      DateTime start = DateTime(_value.first.year, _value.first.month, _value.first.day, 0, 0, 0);
      contains = today.isAfter(start);
      DateTime end = DateTime(_value.last.year, _value.last.month, _value.last.day, 23, 59, 59);
      contains = contains && today.isBefore(end);

      return contains;
    }

    DateTime today = DateTime(day.year, day.month, day.day, 0, 0, 0);
    DateTime start = DateTime(_temporalPicks.first.year, _temporalPicks.first.month, _temporalPicks.first.day, 0, 0, 0);
    return today == start;
  }

  Widget drawDay(
    String label, {
    DateTime? value,
    bool obscure = false,
    bool selected = false,
    bool disabled = false,
    dynamic setLocalState,
    bool isHeader = false,
  }) {
    Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    if (obscure || disabled) {
      textColor = textColor.withOpacity(0.5);
    }

    if (selected) {
      textColor = validateColor(color: Theme.of(context).primaryColor);
    }

    if (isHeader) {
      textColor = validateColor(color: Theme.of(context).primaryColor);
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: setLocalState == null || value == null || disabled
              ? null
              : () {
                  setLocalState(() {
                    if (_temporalPicks.length == 2) {
                      _temporalPicks.clear();
                    }

                    DateTime valueToSave = value;

                    if (_temporalPicks.isEmpty) {
                      valueToSave = DateTime(valueToSave.year, valueToSave.month, valueToSave.day, _value.first.hour,
                          _value.first.minute, 0);
                    } else {
                      valueToSave = DateTime(valueToSave.year, valueToSave.month, valueToSave.day, _value.last.hour,
                          _value.last.minute, 0);
                    }
                    _temporalPicks.add(valueToSave);

                    if (_temporalPicks.length == 2) {
                      _value = [..._temporalPicks];
                      _temporalPicks.clear();
                    }
                    updateAllDependencies();
                  });
                },
          child: Container(
            decoration: BoxDecoration(
              color: selected ? Theme.of(context).primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String t(String key) {
    return widget.i18n?.t(key) ?? _internalTranslations[key] ?? key;
  }
}
