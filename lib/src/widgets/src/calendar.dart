part of '../widgets.dart';

class ThemedCalendar extends StatefulWidget {
  /// [focusDay] is the day that will be focused when the calendar is first displayed.
  /// If [focusDay] is null, the calendar will default to the current day.
  final DateTime? focusDay;

  /// [translations] is the translations of the calendar. By default we use [LayrzAppLocalizations] for translations,
  /// but you can submit your own translations using this property. Consider when [LayrzAppLocalizations] is present,
  /// is the default value of this property.
  /// Required translations:
  /// - `layrz.calendar.year.back` (Previous year)
  /// - `layrz.calendar.year.next` (Next year)
  /// - `layrz.calendar.month.back` (Previous month)
  /// - `layrz.calendar.month.next` (Next month)
  /// - `layrz.calendar.week.back` (Previous week)
  /// - `layrz.calendar.week.next` (Next week)
  /// - `layrz.calendar.day.back` (Previous day)
  /// - `layrz.calendar.day.next` (Next day)
  /// - `layrz.calendar.today` (Today)
  /// - `layrz.calendar.year` (View as year)
  /// - `layrz.calendar.month` (View as month)
  /// - `layrz.calendar.week` (View as week)
  /// - `layrz.calendar.day` (View as day)
  /// - `layrz.calendar.view_as` (View as)
  /// - `layrz.calendar.pickMonth` (Pick a month)
  ///
  /// Note: The translations of weekdays and months is from [LayrzAppLocalizations], you cannot override it.
  /// Read more about it in `DateTime.format()` extension included in Layrz Theme.
  final Map<String, String> translations;

  /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
  final bool overridesLayrzTranslations;

  /// [dayFormat] is the format of the day. By default, we use `%A %B %Y`.
  /// For pattern equivalences, refer to `DateTime` extension format method included in Layrz Theme.
  final String dayFormat;

  /// [weekFormat] is the format of the week. By default, we use `%B %Y`.
  /// For pattern equivalences, refer to `DateTime` extension format method included in Layrz Theme.
  final String weekFormat;

  /// [monthFormat] is the format of the month. By default, we use `%B %Y`.
  /// For pattern equivalences, refer to `DateTime` extension format method included in Layrz Theme.
  final String monthFormat;

  /// [yearFormat] is the format of the year. By default, we use `%Y`.
  /// For pattern equivalences, refer to `DateTime` extension format method included in Layrz Theme.
  final String yearFormat;

  /// [entries] is the list of entries that will be displayed in the calendar.
  final List<ThemedCalendarEntry> entries;

  /// [rangeEntries] is the list of range entries that will be displayed in the calendar.
  /// A range entry is an entry that has a start date and an end date.
  final List<ThemedCalendarRangeEntry> rangeEntries;

  /// [highlightedDays] is the list of days that will be highlighted in the calendar.
  /// When the calendar is in `day` or `week`, the highlight will consider the time-part of the dates.
  final List<DateTime> highlightedDays;

  /// [showEntries] is the flag to hide the entries in the calendar.
  /// By default, the entries will be displayed.
  final bool showEntries;

  /// [onDayTap] is the callback that will be called when the user taps a day.
  /// If [onDayTap] is null, the days will not be tappable.
  final void Function(DateTime)? onDayTap;

  /// [onDayPreviousMonthTap] is the callback that will be called when the user taps the previous month button.
  /// If [onDayPreviousMonthTap] is null, the previous month button will not be tappable.
  final void Function(DateTime)? onDayPreviousMonthTap;

  /// [onDayNextMonthTap] is the callback that will be called when the user taps the next month button.
  /// If [onDayNextMonthTap] is null, the next month button will not be tappable.
  final void Function(DateTime)? onDayNextMonthTap;

  /// [isHighlightDaysAsRange] is the flag to highlight the days as a range.
  /// By default, the days will be highlighted as a single day using the default style
  final bool isHighlightDaysAsRange;

  /// [smallWeekdays] is the flag to display the weekdays in a small size.
  /// By default, the weekdays will be displayed in a normal size.
  final bool smallWeekdays;

  /// [disabledDays] is the list of disabled days.
  /// Does not work when [isHighlightDaysAsRange] is true.
  final List<DateTime> disabledDays;

  /// [todayIndicator] is the flag to display the today indicator.
  /// By default, the today indicator will be displayed.
  final bool todayIndicator;

  /// [todayButton] is the flag to display the today button.
  /// By default, the today button will be displayed.
  final bool todayButton;

  /// [mode] is the mode that the calendar will be displayed in.
  /// By default, the calendar will be displayed in [ThemedCalendarMode.month] mode.
  // final ThemedCalendarMode mode;

  /// [onModeChanged] is a callback that will be called when the user changes the mode of the calendar.
  /// If [onModeChanged] is null, the calendar will not be able to change modes.
  // final void Function(ThemedCalendarMode)? onModeChanged;

  /// [ThemedCalendar] is a widget that displays a calendar.
  /// To do:
  /// - Add support for other modes. Right now we only support `month` mode.

  /// [aditionalButtons] is a list of buttons that will be displayed in the calendar.
  final List<ThemedButton> aditionalButtons;

  /// [focusOnHighlightedDays] allows to focus the calendar in a day between the highlighted days.
  final bool focusOnHighlightedDays;

  const ThemedCalendar({
    super.key,
    this.focusDay,
    this.translations = const {
      'layrz.calendar.year.back': 'Previous year',
      'layrz.calendar.year.next': 'Next year',
      'layrz.calendar.month.back': 'Previous month',
      'layrz.calendar.month.next': 'Next month',
      'layrz.calendar.week.back': 'Previous week',
      'layrz.calendar.week.next': 'Next week',
      'layrz.calendar.day.back': 'Previous day',
      'layrz.calendar.day.next': 'Next day',
      'layrz.calendar.today': 'Today',
      'layrz.calendar.year': 'View as year',
      'layrz.calendar.month': 'View as month',
      'layrz.calendar.week': 'View as week',
      'layrz.calendar.day': 'View as day',
      'layrz.calendar.view_as': 'View as',
      'layrz.calendar.pickMonth': 'Pick a month',
    },
    this.overridesLayrzTranslations = false,
    this.dayFormat = '%A %B %Y',
    this.weekFormat = '%B %Y',
    this.monthFormat = '%B %Y',
    this.yearFormat = '%Y',
    this.entries = const [],
    this.rangeEntries = const [],
    this.highlightedDays = const [],
    this.showEntries = true,
    this.onDayTap,
    this.onDayPreviousMonthTap,
    this.onDayNextMonthTap,
    this.isHighlightDaysAsRange = false,
    this.smallWeekdays = false,
    this.disabledDays = const [],
    this.todayIndicator = true,
    this.todayButton = true,
    this.aditionalButtons = const [],
    this.focusOnHighlightedDays = false,
  });

  @override
  State<ThemedCalendar> createState() => _ThemedCalendarState();
}

class _ThemedCalendarState extends State<ThemedCalendar> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  ThemedCalendarMode get mode => ThemedCalendarMode.month;
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get primaryColor => isDark ? Colors.white : Theme.of(context).primaryColor;

  late DateTime _focusDay;
  late DateTime _dayGenerator;

  String get _title {
    switch (mode) {
      case ThemedCalendarMode.year:
        return _dayGenerator.format(pattern: widget.yearFormat, i18n: i18n);
      case ThemedCalendarMode.month:
        return _dayGenerator.format(pattern: widget.monthFormat, i18n: i18n);
      case ThemedCalendarMode.week:
        return _dayGenerator.format(pattern: widget.weekFormat, i18n: i18n);
      case ThemedCalendarMode.day:
        return _dayGenerator.format(pattern: widget.dayFormat, i18n: i18n);
    }
  }

  String get _backLabel {
    switch (mode) {
      case ThemedCalendarMode.year:
        return t('layrz.calendar.year.back');
      case ThemedCalendarMode.month:
        return t('layrz.calendar.month.back');
      case ThemedCalendarMode.week:
        return t('layrz.calendar.week.back');
      case ThemedCalendarMode.day:
        return t('layrz.calendar.day.back');
    }
  }

  String get _forwardLabel {
    switch (mode) {
      case ThemedCalendarMode.year:
        return t('layrz.calendar.year.next');
      case ThemedCalendarMode.month:
        return t('layrz.calendar.month.next');
      case ThemedCalendarMode.week:
        return t('layrz.calendar.week.next');
      case ThemedCalendarMode.day:
        return t('layrz.calendar.day.next');
    }
  }

  @override
  void initState() {
    super.initState();
    _overrideDayGenerator();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(ThemedCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusDay != oldWidget.focusDay) {
      _overrideDayGenerator();
    }
  }

  void _overrideDayGenerator() {
    if (widget.focusOnHighlightedDays) {
      // Get a middle day between the highlighted days
      List<DateTime> sortedHighlightedDays = widget.highlightedDays..sort((a, b) => a.compareTo(b));
      if (sortedHighlightedDays.isEmpty) {
        _focusDay = widget.focusDay ?? DateTime.now();
        _dayGenerator = _focusDay.copyWith(day: 1);
      } else {
        DateTime middle = sortedHighlightedDays.first.add(
          sortedHighlightedDays.last.difference(sortedHighlightedDays.first) ~/ 2,
        );
        _focusDay = middle;
        _dayGenerator = middle.copyWith(day: 1);
      }
    } else {
      _focusDay = widget.focusDay ?? DateTime.now();
      _dayGenerator = _focusDay.subtract(Duration(days: _focusDay.day - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ThemedMonthPicker(
                labelText: t('layrz.calendar.pickMonth'),
                value: ThemedMonth(
                  year: _dayGenerator.year,
                  month: Month.values[_dayGenerator.month - 1],
                ),
                onChanged: (newMonth) {
                  _dayGenerator = DateTime(
                    newMonth.year,
                    newMonth.month.index + 1,
                    _dayGenerator.day,
                    0,
                    0,
                    0,
                  );
                  setState(() {});
                },
                customChild: ThemedTooltip(
                  message: t('layrz.calendar.pickMonth'),
                  child: Icon(
                    LayrzIcons.solarOutlineCalendar,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // if (widget.onModeChanged != null) ...[
              //   ConstrainedBox(
              //     constraints: const BoxConstraints(maxWidth: 300),
              //     child: ThemedSelectInput<ThemedCalendarMode>(
              //       labelText: t('layrz.calendar.view_as'),
              //       hideDetails: true,
              //       dense: true,
              //       items: ThemedCalendarMode.values.map((mode) {
              //         return ThemedSelectItem<ThemedCalendarMode>(
              //           value: mode,
              //           label: t(mode.translation),
              //         );
              //       }).toList(),
              //       value: mode,
              //       onChanged: (newMode) => widget.onModeChanged?.call(newMode?.value ?? ThemedCalendarMode.month),
              //     ),
              //   ),
              // ],
              ThemedButton(
                labelText: _backLabel,
                style: ThemedButtonStyle.fab,
                icon: LayrzIcons.solarOutlineAltArrowLeft,
                onTap: _back,
              ),
              if (widget.todayButton) ...[
                ThemedButton(
                  labelText: t('layrz.calendar.today'),
                  style: ThemedButtonStyle.fab,
                  icon: LayrzIcons.solarOutlineCalendar,
                  onTap: () {
                    setState(() => _focusDay = DateTime.now());
                    widget.onDayTap?.call(DateTime.now());
                  },
                ),
              ],
              ThemedButton(
                labelText: _forwardLabel,
                style: ThemedButtonStyle.fab,
                icon: LayrzIcons.solarOutlineAltArrowRight,
                onTap: _forward,
              ),
              ...widget.aditionalButtons.map((button) => button),
            ],
          ),
          if (mode == ThemedCalendarMode.year) ...[
            // TO DO - Yearly calendar
          ] else if (mode == ThemedCalendarMode.month) ...[
            _buildMonthCalendar(),
          ] else if (mode == ThemedCalendarMode.week) ...[
            // TO DO - Weekly calendar
          ] else if (mode == ThemedCalendarMode.day) ...[
            // TO DO - Daily calendar
          ],
        ],
      ),
    );
  }

  /// [_forward] goes forward in the calendar.
  void _forward() {
    late DateTime next;
    switch (mode) {
      case ThemedCalendarMode.year:
        next = DateTime(
          _dayGenerator.year + 1,
          _dayGenerator.month,
          _dayGenerator.day,
          _dayGenerator.hour,
          _dayGenerator.minute,
          _dayGenerator.second,
        );
        break;
      case ThemedCalendarMode.month:
        if (_dayGenerator.month == 12) {
          next = DateTime(
            _dayGenerator.year + 1,
            1,
            _dayGenerator.day,
            _dayGenerator.hour,
            _dayGenerator.minute,
            _dayGenerator.second,
          );
        } else {
          next = DateTime(
            _dayGenerator.year,
            _dayGenerator.month + 1,
            _dayGenerator.day,
            _dayGenerator.hour,
            _dayGenerator.minute,
            _dayGenerator.second,
          );
        }
        break;
      case ThemedCalendarMode.week:
        final thisWeek = _dayGenerator.thisWeek;
        next = thisWeek.last.add(const Duration(days: 1));
        break;
      case ThemedCalendarMode.day:
        int lastDay = 31;
        if (_dayGenerator.month == DateTime.february) {
          if (_dayGenerator.month % 4 == 0) {
            lastDay = 29;
          } else {
            lastDay = 28;
          }
        } else if (_dayGenerator.month == DateTime.april ||
            _dayGenerator.month == DateTime.june ||
            _dayGenerator.month == DateTime.september ||
            _dayGenerator.month == DateTime.november) {
          lastDay = 30;
        } else {
          lastDay = 31;
        }

        if (_dayGenerator.day == lastDay) {
          if (_dayGenerator.month == 12) {
            next = DateTime(
              _dayGenerator.year + 1,
              1,
              1,
              _dayGenerator.hour,
              _dayGenerator.minute,
              _dayGenerator.second,
            );
          } else {
            next = DateTime(
              _dayGenerator.year,
              _dayGenerator.month + 1,
              1,
              _dayGenerator.hour,
              _dayGenerator.minute,
              _dayGenerator.second,
            );
          }
        } else {
          next = DateTime(
            _dayGenerator.year,
            _dayGenerator.month,
            _dayGenerator.day + 1,
            _dayGenerator.hour,
            _dayGenerator.minute,
            _dayGenerator.second,
          );
        }
        break;
    }

    _dayGenerator = next;
    widget.onDayNextMonthTap?.call(next);
    setState(() {});
  }

  /// [_back] goes back in the calendar.
  void _back() {
    late DateTime next;
    switch (mode) {
      case ThemedCalendarMode.year:
        next = DateTime(
          _dayGenerator.year - 1,
          _dayGenerator.month,
          _dayGenerator.day,
          _dayGenerator.hour,
          _dayGenerator.minute,
          _dayGenerator.second,
        );
        break;
      case ThemedCalendarMode.month:
        if (_dayGenerator.month == 1) {
          next = DateTime(
            _dayGenerator.year - 1,
            12,
            _dayGenerator.day,
            _dayGenerator.hour,
            _dayGenerator.minute,
            _dayGenerator.second,
          );
        } else {
          next = DateTime(
            _dayGenerator.year,
            _dayGenerator.month - 1,
            _dayGenerator.day,
            _dayGenerator.hour,
            _dayGenerator.minute,
            _dayGenerator.second,
          );
        }
        break;
      case ThemedCalendarMode.week:
        final thisWeek = _dayGenerator.thisWeek;
        next = thisWeek.first.subtract(const Duration(days: 1));
        break;
      case ThemedCalendarMode.day:
        if (_dayGenerator.day == 1) {
          if (_dayGenerator.month == 1) {
            next = DateTime(
              _dayGenerator.year - 1,
              12,
              31,
              _dayGenerator.hour,
              _dayGenerator.minute,
              _dayGenerator.second,
            );
          } else {
            int lastDay = 31;
            if (_dayGenerator.month == DateTime.march) {
              if (_dayGenerator.month % 4 == 0) {
                lastDay = 29;
              } else {
                lastDay = 28;
              }
            } else if (_dayGenerator.month == DateTime.may ||
                _dayGenerator.month == DateTime.july ||
                _dayGenerator.month == DateTime.october ||
                _dayGenerator.month == DateTime.december) {
              lastDay = 30;
            } else {
              lastDay = 31;
            }
            next = DateTime(
              _dayGenerator.year,
              _dayGenerator.month - 1,
              lastDay,
              _dayGenerator.hour,
              _dayGenerator.minute,
              _dayGenerator.second,
            );
          }
        } else {
          next = DateTime(
            _dayGenerator.year,
            _dayGenerator.month,
            _dayGenerator.day - 1,
            _dayGenerator.hour,
            _dayGenerator.minute,
            _dayGenerator.second,
          );
        }
        break;
    }
    _dayGenerator = next;
    widget.onDayPreviousMonthTap?.call(next);
    setState(() {});
  }

  /// [_buildMonthCalendar] builds the month calendar.
  Widget _buildMonthCalendar() {
    List<DateTime> fullMonth = _generateThisMonth();

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double height = (constraints.maxHeight - 30 - 20) / (fullMonth.length / 7);
          double width = (constraints.maxWidth - 20) / 7;

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  height: 30,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Row(
                    children: List.generate(7, (i) {
                      String weekdayString = "";
                      switch (i + 1) {
                        case DateTime.monday:
                          weekdayString = i18n?.t('theme.helpers.datetime.monday') ?? "Monday";
                          break;
                        case DateTime.tuesday:
                          weekdayString = i18n?.t('theme.helpers.datetime.tuesday') ?? "Tuesday";
                          break;
                        case DateTime.wednesday:
                          weekdayString = i18n?.t('theme.helpers.datetime.wednesday') ?? "Wednesday";
                          break;
                        case DateTime.thursday:
                          weekdayString = i18n?.t('theme.helpers.datetime.thursday') ?? "Thursday";
                          break;
                        case DateTime.friday:
                          weekdayString = i18n?.t('theme.helpers.datetime.friday') ?? "Friday";
                          break;
                        case DateTime.saturday:
                          weekdayString = i18n?.t('theme.helpers.datetime.saturday') ?? "Saturday";
                          break;
                        case DateTime.sunday:
                        default:
                          weekdayString = i18n?.t('theme.helpers.datetime.sunday') ?? "Sunday";
                          break;
                      }
                      return Container(
                        width: width,
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          widget.smallWeekdays ? weekdayString.substring(0, 3) : weekdayString,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: ThemedGridDelegateWithFixedHeight(
                      height: height,
                      crossAxisCount: 7,
                    ),
                    itemCount: fullMonth.length,
                    itemBuilder: (context, index) {
                      DateTime day = fullMonth[index];
                      List<ThemedCalendarEntry> dayEntries = _getEntriesOfDay(day);
                      List<ThemedCalendarRangeEntry> dayRangeEntries = _getRangeEntriesOfDay(day);
                      List<ThemedCalendarEntry> joinedEntries = [
                        ...dayRangeEntries.map((entry) {
                          return ThemedCalendarEntry(
                            textAlign: entry.textAlign,
                            at: day,
                            color: entry.color,
                            icon: entry.icon,
                            title: entry.title,
                            caption: entry.caption,
                            onTap: entry.onTap,
                          );
                        }),
                        ...dayEntries,
                      ];

                      DateTime now = DateTime(day.year, day.month, day.day);
                      bool isFocusDay =
                          day.year == _focusDay.year && day.month == _focusDay.month && day.day == _focusDay.day;
                      bool isDisabled = widget.disabledDays
                          .map((disabled) {
                            return DateTime(disabled.year, disabled.month, disabled.day);
                          })
                          .contains(now);

                      if (widget.isHighlightDaysAsRange) {
                        isFocusDay = false;
                        isDisabled = false;
                      }

                      bool isCurrentMonth = day.month == _dayGenerator.month;

                      List<DateTime> highlightedDays = widget.highlightedDays.map((highlight) {
                        return DateTime(highlight.year, highlight.month, highlight.day);
                      }).toList();

                      bool hightlight = highlightedDays.contains(now);

                      Color? containerColor = (hightlight || isFocusDay) && isCurrentMonth ? primaryColor : null;

                      return Opacity(
                        opacity: isDisabled
                            ? 0.3
                            : isCurrentMonth
                            ? 1
                            : 0.5,
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (!widget.showEntries) const Spacer(),
                              Container(
                                width: widget.showEntries ? 30 : height * 0.5,
                                height: widget.showEntries ? 30 : height * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(height / 6),
                                  color: containerColor?.withValues(alpha: 0.3),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    hoverColor: !widget.showEntries ? null : Colors.transparent,
                                    splashColor: !widget.showEntries ? null : Colors.transparent,
                                    mouseCursor: isDisabled
                                        ? SystemMouseCursors.forbidden
                                        : !widget.showEntries
                                        ? null
                                        : SystemMouseCursors.basic,
                                    onTap: isDisabled ? null : () => widget.onDayTap?.call(day),
                                    child: Center(
                                      child: Text(
                                        day.day.toString(),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: widget.showEntries ? null : height * 0.2,
                                          color: containerColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (!widget.showEntries) ...[
                                const Spacer(),
                              ] else ...[
                                const SizedBox(height: 5),
                                if (joinedEntries.isEmpty) ...[
                                  Center(
                                    child: Opacity(
                                      opacity: 0.3,
                                      child: Icon(
                                        LayrzIcons.solarOutlineCalendar,
                                        size: 20,
                                        color: containerColor,
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: joinedEntries.length,
                                      itemExtent: 25,
                                      itemBuilder: (context, index) {
                                        ThemedCalendarEntry item = joinedEntries[index];
                                        Color cardColor = item.color ?? primaryColor;

                                        BorderRadius borderRadius = BorderRadius.circular(5);

                                        return Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: cardColor,
                                              borderRadius: borderRadius,
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: item.onTap ?? () {},
                                                splashColor: item.onTap == null ? Colors.transparent : null,
                                                mouseCursor: item.onTap == null ? SystemMouseCursors.basic : null,
                                                hoverColor: item.onTap == null ? Colors.transparent : null,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    if (item.icon != null) ...[
                                                      const SizedBox(width: 5),
                                                      Icon(
                                                        item.icon,
                                                        color: validateColor(color: cardColor),
                                                        size: 10,
                                                      ),
                                                    ],
                                                    const SizedBox(width: 5),
                                                    Expanded(
                                                      child: Text(
                                                        item.title,
                                                        textAlign: item.textAlign,
                                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          color: validateColor(color: cardColor),
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// [_getEntriesOfDay] gets the entries of a day.
  List<ThemedCalendarEntry> _getEntriesOfDay(DateTime day) {
    List<ThemedCalendarEntry> entries = widget.entries.where((entry) {
      switch (mode) {
        case ThemedCalendarMode.month:
          return entry.at.year == day.year && entry.at.month == day.month && entry.at.day == day.day;
        default:
          return false;
      }
    }).toList();
    return entries;
  }

  /// [_getRangeEntriesOfDay] gets the range entries of a day.
  /// A range entry is an entry that has a start date and an end date.
  List<ThemedCalendarRangeEntry> _getRangeEntriesOfDay(DateTime day) {
    List<ThemedCalendarRangeEntry> entries = widget.rangeEntries.where((entry) {
      switch (mode) {
        case ThemedCalendarMode.month:
          return day.isAfter(entry.startAt) && day.isBefore(entry.endAt);
        default:
          return false;
      }
    }).toList();

    return entries;
  }

  /// [_validateIfIsToday] validates if the day is today.
  // bool _validateIfIsToday(DateTime day) {
  //   switch (mode) {
  //     case ThemedCalendarMode.year:
  //       return day.year == _today.year && day.month == _today.month;
  //     case ThemedCalendarMode.month:
  //     case ThemedCalendarMode.week:
  //       return day.year == _today.year && day.month == _today.month && day.day == _today.day;
  //     case ThemedCalendarMode.day:
  //       return day.year == _today.year &&
  //           day.month == _today.month &&
  //           day.day == _today.day &&
  //           day.hour == _today.hour &&
  //           day.minute == _today.minute;
  //   }
  // }

  /// [_generateThisMonth] generates a list of days that are in the same month as [_focusDay].
  List<DateTime> _generateThisMonth() {
    List<DateTime> days = [];
    final interval = _dayGenerator.thisMonth;

    DateTime start = interval.first;
    if (start.weekday != DateTime.monday) {
      while (true) {
        start = start.subtract(const Duration(days: 1));
        if (start.weekday == DateTime.monday) {
          break;
        }
      }
    }

    DateTime end = interval.last;
    if (end.weekday != DateTime.sunday) {
      while (true) {
        end = end.add(const Duration(days: 1));
        if (end.weekday == DateTime.sunday) {
          break;
        }
      }
    }

    while (start.isBefore(end)) {
      days.add(start);
      start = start.add(const Duration(days: 1));
    }

    days.add(end);
    days.sort((a, b) => a.compareTo(b));

    return days;
  }

  /// [t] is a wrapper to handle the translations using first the [LayrzAppLocalizations]
  /// and then the custom labels
  ///
  /// You can replace variables in the translation using the following format: `{variableName}`
  /// The variables changes depending of the implementation in this component.
  String t(String key, [Map<String, dynamic> args = const {}]) {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.maybeOf(context);

    if (i18n != null) {
      return i18n.t(key, args);
    }

    String? result;
    if (widget.translations.containsKey(key)) {
      result = widget.translations[key]!;
    }

    result ??= 'Missing translation for key $key : $args';

    args.forEach((key, value) => result = result!.replaceAll('{$key}', value.toString()));
    return result!;
  }
}

/// [ThemedCalendarMode] is an enum that represents the different modes that the calendar can be displayed in.
enum ThemedCalendarMode {
  /// [ThemedCalendarMode.day] displays a single month of days.
  day,

  /// [ThemedCalendarMode.week] displays a single week of days.
  week,

  /// [ThemedCalendarMode.month] displays a single month of weeks.
  month,

  /// [ThemedCalendarMode.year] displays a single year of months.
  year;

  String get translation {
    switch (this) {
      case ThemedCalendarMode.year:
        return 'layrz.calendar.year';
      case ThemedCalendarMode.month:
        return 'layrz.calendar.month';
      case ThemedCalendarMode.week:
        return 'layrz.calendar.week';
      case ThemedCalendarMode.day:
        return 'layrz.calendar.day';
    }
  }
}

class ThemedCalendarEntry {
  /// [at] is the date and time of the entry.
  final DateTime at;

  /// [color] is the color of the entry. Only will apply when the [ThemedCalendar] is in `day` or `week`.
  /// In `month` or `year`, the color will be ignored.
  final Color? color;

  /// [icon] is the icon of the entry. Only will apply when the [ThemedCalendar] is in `day` or `week`.
  /// In `month` or `year`, the icon will be ignored.
  final IconData? icon;

  /// [title] is the title of the entry. Only will apply when the [ThemedCalendar] is in `day` or `week`.
  /// In `month` or `year`, the title will be ignored.
  final String title;

  /// [caption] is the caption of the entry. Only will apply when the [ThemedCalendar] is in `day` or `week`.
  /// In `month` or `year`, the caption will be ignored.
  final String? caption;

  /// [onTap] is the callback that will be called when the user taps the entry.
  /// Only will apply when the [ThemedCalendar] is in `day` or `week`.
  /// In `month` or `year`, the onTap will be ignored.
  final VoidCallback? onTap;

  /// [textAlign] is the alignment of the text of the entry.
  final TextAlign textAlign;

  /// [ThemedCalendarEntry] is a class that represents an entry in the calendar.
  /// When the [ThemedCalendar] is in `day` or `week`, we'll use the time-part of the [at] to display the entry.
  /// When the [ThemedCalendar] is in `month` or `year`, we'll use the date-part of the [at] to display the entry.
  const ThemedCalendarEntry({
    required this.at,
    this.color,
    this.icon,
    required this.title,
    this.caption,
    this.onTap,
    this.textAlign = TextAlign.justify,
  });

  @override
  String toString() {
    return 'ThemedCalendarEntry(at: $at, title: $title)';
  }
}

class ThemedCalendarRangeEntry {
  /// [startAt] is the start date and time of the entry.
  final DateTime startAt;

  /// [endAt] is the end date and time of the entry.
  final DateTime endAt;

  /// [color] is the color of the entry. Only will apply when the [ThemedCalendar] is in `day` or `week`.
  /// In `month` or `year`, the color will be ignored.
  final Color? color;

  /// [icon] is the icon of the entry. Only will apply when the [ThemedCalendar] is in `day` or `week`.
  /// In `month` or `year`, the icon will be ignored.
  final IconData? icon;

  /// [title] is the title of the entry. Only will apply when the [ThemedCalendar] is in `day` or `week`.
  /// In `month` or `year`, the title will be ignored.
  final String title;

  /// [caption] is the caption of the entry. Only will apply when the [ThemedCalendar] is in `day` or `week`.
  /// In `month` or `year`, the caption will be ignored.
  final String? caption;

  /// [onTap] is the callback that will be called when the user taps the entry.
  /// Only will apply when the [ThemedCalendar] is in `day` or `week`.
  /// In `month` or `year`, the onTap will be ignored.
  final VoidCallback? onTap;

  /// [textAlign] is the alignment of the text of the entry.
  final TextAlign textAlign;

  /// [ThemedCalendarEntry] is a class that represents an entry in the calendar.
  /// When the [ThemedCalendar] is in `day` or `week`, we'll use the time-part of the [startAt] and [endAt]
  /// to display the entry.
  /// When the [ThemedCalendar] is in `month` or `year`, we'll use the date-part of the [startAt] and [endAt]
  /// to display the entry.
  const ThemedCalendarRangeEntry({
    required this.startAt,
    required this.endAt,
    this.color,
    this.icon,
    required this.title,
    this.caption,
    this.onTap,
    this.textAlign = TextAlign.justify,
  });
}
