part of '../../utilities.dart';

/// [Units] of time. Defines each component of a [Duration] human readable.
enum ThemedUnits {
  year,
  month,
  week,
  day,
  hour,
  minute,
  second,
  millisecond,
}

const arabicDigits = ["۰", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"];

const Map<ThemedUnits, int> unitMeasures = {
  ThemedUnits.year: 31557600000,
  ThemedUnits.month: 2629800000,
  ThemedUnits.week: 604800000,
  ThemedUnits.day: 86400000,
  ThemedUnits.hour: 3600000,
  ThemedUnits.minute: 60000,
  ThemedUnits.second: 1000,
  ThemedUnits.millisecond: 1
};
