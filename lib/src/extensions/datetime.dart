part of layrz_theme;

extension DateTimeExtension on DateTime {
  double get secondsSinceEpoch {
    return millisecondsSinceEpoch / 1000;
  }

  List<DateTime> get thisWeek {
    DateTime start = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
    return [
      start,
      start.add(const Duration(days: 6)),
    ];
  }

  List<DateTime> get lastWeek {
    DateTime end = DateTime.now().subtract(Duration(days: DateTime.now().weekday + 1));
    return [
      end.subtract(const Duration(days: 6)),
      end,
    ];
  }

  List<DateTime> get thisMonth {
    DateTime now = DateTime.now();
    DateTime beginningNextMonth =
        (now.month != DateTime.december) ? DateTime(now.year, now.month + 1, 1) : DateTime(now.year + 1, 1, 1);
    DateTime end = beginningNextMonth.subtract(const Duration(days: 1));
    return [
      DateTime(now.year, now.month, 1),
      end,
    ];
  }

  List<DateTime> get lastMonth {
    DateTime now = DateTime.now();
    DateTime beginningPreviousMonth =
        (now.month != DateTime.january) ? DateTime(now.year, now.month - 1, 1) : DateTime(now.year - 1, 12, 1);

    return [
      DateTime(beginningPreviousMonth.year, beginningPreviousMonth.month, 1),
      DateTime(now.year, now.month, 1).subtract(const Duration(days: 1)),
    ];
  }

  String get standard => '%Y-%d-%d %I:%M %p %z';

  /// [format] converts the date to a string using a pattern based on Python datetime function strftime and strptime.
  /// By default, will apply the pattern [DateTime.standard].
  /// For pattern equivalences, refer to
  /// https://docs.python.org/3/library/datetime.html#strftime-and-strptime-format-codes
  /// !Note: These patterns are not supported: %j, %U, %W, %c, %x, %X
  /// Additional information: All of return names for months and days are based on the English names.
  ///
  /// Additionally, we added this new patterns
  ///   - %:z - timezone offset in the format of +HH:MM or -HH:MM
  String format({String? pattern, LayrzAppLocalizations? i18n}) {
    String weekdayString = "";

    switch (weekday) {
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

    String monthString = "";
    switch (month) {
      case DateTime.january:
        monthString = i18n?.t('theme.helpers.datetime.january') ?? "January";
        break;
      case DateTime.february:
        monthString = i18n?.t('theme.helpers.datetime.february') ?? "February";
        break;
      case DateTime.march:
        monthString = i18n?.t('theme.helpers.datetime.march') ?? "March";
        break;
      case DateTime.april:
        monthString = i18n?.t('theme.helpers.datetime.april') ?? "April";
        break;
      case DateTime.may:
        monthString = i18n?.t('theme.helpers.datetime.may') ?? "May";
        break;
      case DateTime.june:
        monthString = i18n?.t('theme.helpers.datetime.june') ?? "June";
        break;
      case DateTime.july:
        monthString = i18n?.t('theme.helpers.datetime.july') ?? "July";
        break;
      case DateTime.august:
        monthString = i18n?.t('theme.helpers.datetime.august') ?? "August";
        break;
      case DateTime.september:
        monthString = i18n?.t('theme.helpers.datetime.september') ?? "September";
        break;
      case DateTime.october:
        monthString = i18n?.t('theme.helpers.datetime.october') ?? "October";
        break;
      case DateTime.november:
        monthString = i18n?.t('theme.helpers.datetime.november') ?? "November";
        break;
      case DateTime.december:
        monthString = i18n?.t('theme.helpers.datetime.december') ?? "December";
        break;
    }

    Map<String, String> patterns = {
      '%a': weekdayString.substring(0, 3),
      '%A': weekdayString,
      '%w': weekday.toString(),
      '%d': day.toString().padLeft(2, '0'),
      '%b': monthString.substring(0, 3),
      '%B': monthString,
      '%m': month.toString().padLeft(2, '0'),
      '%y': year.toString().substring(2),
      '%Y': year.toString(),
      '%H': hour.toString().padLeft(2, '0'),
      '%I': (hour % 12).toString().padLeft(2, '0'),
      '%p': (hour < 12) ? "AM" : "PM",
      '%M': minute.toString().padLeft(2, '0'),
      '%S': second.toString().padLeft(2, '0'),
      '%f': microsecond.toString().padLeft(6, '0'),
      '%z': "${timeZoneOffset.isNegative ? '-' : '+'}"
          "${timeZoneOffset.inHours.abs().toString().padLeft(2, '0')}"
          "${(timeZoneOffset.inMinutes % 60).toString().padLeft(2, '0')}",
      '%:z': "${timeZoneOffset.isNegative ? '-' : '+'}"
          "${timeZoneOffset.inHours.abs().toString().padLeft(2, '0')}"
          ":${(timeZoneOffset.inMinutes % 60).toString().padLeft(2, '0')}",
      '%Z': timeZoneName,
      '%%': '%',
    };
    pattern ??= standard;

    String result = pattern;
    patterns.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }
}
