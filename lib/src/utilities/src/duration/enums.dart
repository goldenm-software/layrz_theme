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
  .year: 31557600000,
  .month: 2629800000,
  .week: 604800000,
  .day: 86400000,
  .hour: 3600000,
  .minute: 60000,
  .second: 1000,
  .millisecond: 1,
};
