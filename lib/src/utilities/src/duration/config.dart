part of '../../utilities.dart';

class ThemedHumanizeOptions {
  /// List of units to use.
  /// It can be one, or a combination of any possible unit.
  /// By default, it uses:
  /// - [ThemedUnits.year]
  /// - [ThemedUnits.month]
  /// - [ThemedUnits.day]
  /// - [ThemedUnits.hour]
  /// - [ThemedUnits.minute]
  final List<ThemedUnits> units;

  /// String to display between each value and unit.
  /// By default, it uses a whitespace.
  final String spacer;

  /// String to display between the previous unit and the next value.
  /// By default, it uses a comma and a whitespace.
  final String delimiter;

  /// String to include before the final unit.
  /// You can also set `lastPrefixComma` to `false` to eliminate the final comma.
  final String conjunction;

  /// The comma set before the last value.
  final bool lastPrefixComma;

  /// [ThemedHumanizeOptions] is the configuration for [Duration.humanize] function.
  const ThemedHumanizeOptions({
    this.units = const [ThemedUnits.year, ThemedUnits.month, ThemedUnits.day, ThemedUnits.hour, ThemedUnits.minute],
    this.spacer = ' ',
    this.delimiter = ', ',
    this.conjunction = ' and ',
    this.lastPrefixComma = false,
  });
}

abstract class ThemedHumanizeLanguage {
  /// [name] is the name of the language, only used internally to identify the language.
  String name() => 'default';

  /// [year] is the translation for the year unit.
  String year(int value) => 'year';

  /// [month] is the translation for the month unit.
  String month(int value) => 'month';

  /// [week] is the translation for the week unit.
  String week(int value) => 'week';

  /// [day] is the translation for the day unit.
  String day(int value) => 'day';

  /// [hour] is the translation for the hour unit.
  String hour(int value) => 'hour';

  /// [minute] is the translation for the minute unit.
  String minute(int value) => 'minute';

  /// [second] is the translation for the second unit.
  String second(int value) => 'second';

  /// [millisecond] is the translation for the millisecond unit.
  String millisecond(int value) => 'millisecond';

  /// [ThemedHumanizeLanguage] is the default language for [Duration.humanize] function.
  /// You can create your own language by extending this class and overriding the methods.
  const ThemedHumanizeLanguage();
}

class ThemedHumanizedDurationLanguage implements ThemedHumanizeLanguage {
  /// [i18n] is the [LayrzAppLocalizations] instance to use for translations.
  final LayrzAppLocalizations? i18n;

  /// [ThemedHumanizedDurationLanguage] is the default language for [Duration.humanize] function.
  /// If you use [LayrzAppLocalizations], it will use the following keys:
  /// - `helpers.dynamic.days` and the ideal translation should be `day | days`
  /// - `helpers.dynamic.hours` and the ideal translation should be `hour | hours`
  /// - `helpers.dynamic.milliseconds` and the ideal translation should be `millisecond | milliseconds`
  /// - `helpers.dynamic.minutes` and the ideal translation should be `minute | minutes`
  /// - `helpers.dynamic.months` and the ideal translation should be `month | months`
  /// - `helpers.dynamic.seconds` and the ideal translation should be `second | seconds`
  /// - `helpers.dynamic.weeks` and the ideal translation should be `week | weeks`
  /// - `helpers.dynamic.years` and the ideal translation should be `year | years`
  ///
  /// All translations uses [tc] function from [LayrzAppLocalizations] to pluralize the translation.
  const ThemedHumanizedDurationLanguage({this.i18n});

  @override
  String name() => 'layrz';

  @override
  String day(int value) => i18n?.tc('helpers.dynamic.days', value) ?? (value == 1 ? 'day' : 'days');

  @override
  String hour(int value) => i18n?.tc('helpers.dynamic.hours', value) ?? (value == 1 ? 'hour' : 'hours');

  @override
  String millisecond(int value) =>
      i18n?.tc('helpers.dynamic.milliseconds', value) ?? (value == 1 ? 'millisecond' : 'milliseconds');

  @override
  String minute(int value) => i18n?.tc('helpers.dynamic.minutes', value) ?? (value == 1 ? 'minute' : 'minutes');

  @override
  String month(int value) => i18n?.tc('helpers.dynamic.months', value) ?? (value == 1 ? 'month' : 'months');

  @override
  String second(int value) => i18n?.tc('helpers.dynamic.seconds', value) ?? (value == 1 ? 'second' : 'seconds');

  @override
  String week(int value) => i18n?.tc('helpers.dynamic.weeks', value) ?? (value == 1 ? 'week' : 'weeks');

  @override
  String year(int value) => i18n?.tc('helpers.dynamic.years', value) ?? (value == 1 ? 'year' : 'years');
}

class _ThemedHumanizePiece {
  final ThemedUnits unitName;
  final int unitCount;
  final ThemedHumanizeLanguage language;

  _ThemedHumanizePiece(this.unitName, this.unitCount, this.language);

  String format(String spacer) {
    if (language.name().toLowerCase() == 'ar') {
      return '${_toArabicDigits(unitCount.toString())}$spacer$unitLanguage';
    }
    return '$unitCount$spacer$unitLanguage';
  }

  String get unitLanguage {
    switch (unitName) {
      case ThemedUnits.day:
        return language.day(unitCount);
      case ThemedUnits.hour:
        return language.hour(unitCount);
      case ThemedUnits.minute:
        return language.minute(unitCount);
      case ThemedUnits.second:
        return language.second(unitCount);
      case ThemedUnits.millisecond:
        return language.millisecond(unitCount);
      case ThemedUnits.year:
        return language.year(unitCount);
      case ThemedUnits.month:
        return language.month(unitCount);
      case ThemedUnits.week:
        return language.week(unitCount);
      default:
        throw Exception('Unknown unit name: $unitName');
    }
  }

  String _toArabicDigits(String digit) {
    var character = '';
    for (var i = 0; i < digit.length; i++) {
      character += arabicDigits[int.parse(digit[i])];
    }
    return character;
  }
}
