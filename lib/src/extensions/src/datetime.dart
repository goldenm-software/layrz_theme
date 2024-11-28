part of '../extensions.dart';

/// [DateTimeExtension] is an extension to extend the [DateTime] class.
extension DateTimeExtension on DateTime {
  /// [secondsSinceEpoch] is an extension to get the seconds since epoch.
  double get secondsSinceEpoch {
    return millisecondsSinceEpoch / 1000;
  }

  /// [thisWeek] is an extension to get the first and last day of the week.
  List<DateTime> get thisWeek {
    DateTime start = subtract(Duration(days: weekday - 1));
    DateTime end = add(Duration(days: DateTime.daysPerWeek - weekday));

    return [start, end];
  }

  /// [lastWeek] is an extension to get the first and last day of the last week.
  List<DateTime> get lastWeek {
    DateTime start = subtract(Duration(days: weekday + DateTime.daysPerWeek - 1));
    DateTime end = subtract(Duration(days: weekday));

    return [start, end];
  }

  /// [thisMonth] is an extension to get the first and last day of the month.
  List<DateTime> get thisMonth {
    DateTime start = DateTime(year, month, 1);
    DateTime end = DateTime(year, month + 1, 1).subtract(const Duration(days: 1));

    return [start, end];
  }

  /// [lastMonth] is an extension to get the first and last day of the last month.
  List<DateTime> get lastMonth {
    DateTime start = DateTime(year, month - 1, 1);
    DateTime end = DateTime(year, month, 1).subtract(const Duration(days: 1));

    return [start, end];
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
  String format({
    /// [pattern] is the pattern to apply to the date.
    String? pattern,

    /// [i18n] is the localization to apply to the date.
    LayrzAppLocalizations? i18n,

    /// [translationOverrides] is the translation overrides to apply to the date.
    ///
    /// The required translations are:
    /// - `theme.helpers.datetime.monday`: `Monday`
    /// - `theme.helpers.datetime.tuesday`: `Tuesday`
    /// - `theme.helpers.datetime.wednesday`: `Wednesday`
    /// - `theme.helpers.datetime.thursday`: `Thursday`
    /// - `theme.helpers.datetime.friday`: `Friday`
    /// - `theme.helpers.datetime.saturday`: `Saturday`
    /// - `theme.helpers.datetime.sunday`: `Sunday`
    /// - `theme.helpers.datetime.january`: `January`
    /// - `theme.helpers.datetime.february`: `February`
    /// - `theme.helpers.datetime.march`: `March`
    /// - `theme.helpers.datetime.april`: `April`
    /// - `theme.helpers.datetime.may`: `May`
    /// - `theme.helpers.datetime.june`: `June`
    /// - `theme.helpers.datetime.july`: `July`
    /// - `theme.helpers.datetime.august`: `August`
    /// - `theme.helpers.datetime.september`: `September`
    /// - `theme.helpers.datetime.october`: `October`
    /// - `theme.helpers.datetime.november`: `November`
    /// - `theme.helpers.datetime.december`: `December`
    ///
    /// When `LayrzAppLocalizations.maybeOf(context)` is null or the translation was not found,
    /// the default [translationOverrides] will be used.
    Map<String, String> translationOverrides = const {
      'theme.helpers.datetime.monday': 'Monday',
      'theme.helpers.datetime.tuesday': 'Tuesday',
      'theme.helpers.datetime.wednesday': 'Wednesday',
      'theme.helpers.datetime.thursday': 'Thursday',
      'theme.helpers.datetime.friday': 'Friday',
      'theme.helpers.datetime.saturday': 'Saturday',
      'theme.helpers.datetime.sunday': 'Sunday',
      'theme.helpers.datetime.january': 'January',
      'theme.helpers.datetime.february': 'February',
      'theme.helpers.datetime.march': 'March',
      'theme.helpers.datetime.april': 'April',
      'theme.helpers.datetime.may': 'May',
      'theme.helpers.datetime.june': 'June',
      'theme.helpers.datetime.july': 'July',
      'theme.helpers.datetime.august': 'August',
      'theme.helpers.datetime.september': 'September',
      'theme.helpers.datetime.october': 'October',
      'theme.helpers.datetime.november': 'November',
      'theme.helpers.datetime.december': 'December',
    },

    /// [useTranslationOverridesFirst] is a flag to indicate if the [translationOverrides] should be used first.
    bool useTranslationOverridesFirst = false,
  }) {
    String weekdayString = "";

    switch (weekday) {
      case DateTime.monday:
        weekdayString = _translate(
          'theme.helpers.datetime.monday',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.tuesday:
        weekdayString = _translate(
          'theme.helpers.datetime.tuesday',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.wednesday:
        weekdayString = _translate(
          'theme.helpers.datetime.wednesday',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.thursday:
        weekdayString = _translate(
          'theme.helpers.datetime.thursday',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.friday:
        weekdayString = _translate(
          'theme.helpers.datetime.friday',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.saturday:
        weekdayString = _translate(
          'theme.helpers.datetime.saturday',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.sunday:
      default:
        weekdayString = _translate(
          'theme.helpers.datetime.sunday',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
    }

    String monthString = "";
    switch (month) {
      case DateTime.january:
        monthString = _translate(
          'theme.helpers.datetime.january',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.february:
        monthString = _translate(
          'theme.helpers.datetime.february',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.march:
        monthString = _translate(
          'theme.helpers.datetime.march',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.april:
        monthString = _translate(
          'theme.helpers.datetime.april',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.may:
        monthString = _translate(
          'theme.helpers.datetime.may',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.june:
        monthString = _translate(
          'theme.helpers.datetime.june',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.july:
        monthString = _translate(
          'theme.helpers.datetime.july',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.august:
        monthString = _translate(
          'theme.helpers.datetime.august',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.september:
        monthString = _translate(
          'theme.helpers.datetime.september',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.october:
        monthString = _translate(
          'theme.helpers.datetime.october',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.november:
        monthString = _translate(
          'theme.helpers.datetime.november',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
        break;
      case DateTime.december:
        monthString = _translate(
          'theme.helpers.datetime.december',
          i18n: i18n,
          translationOverrides: translationOverrides,
          useTranslationOverridesFirst: useTranslationOverridesFirst,
        );
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
      '%I': ((hour % 12 == 0) ? 12 : hour % 12).toString().padLeft(2, '0'),
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

  String _translate(
    String key, {
    LayrzAppLocalizations? i18n,
    required Map<String, String> translationOverrides,
    bool useTranslationOverridesFirst = false,
  }) {
    String result = "";

    if (useTranslationOverridesFirst) {
      if (translationOverrides.containsKey(key)) {
        result = translationOverrides[key]!;
      } else if (i18n?.hasTranslation(key) ?? false) {
        result = i18n!.t(key);
      } else {
        result = "Translation missing $key";
      }
    } else {
      if (i18n?.hasTranslation(key) ?? false) {
        result = i18n!.t(key);
      } else if (translationOverrides.containsKey(key)) {
        result = translationOverrides[key]!;
      } else {
        result = "Translation missing $key";
      }
    }

    return result;
  }
}
