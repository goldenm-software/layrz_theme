part of '../../utilities.dart';

extension HumanizeDuration on Duration {
  /// [humanize] returns a human readable string of the [Duration].
  /// It uses the [ThemedHumanizeOptions] to define the format.
  String humanize({ThemedHumanizeOptions? options, ThemedHumanizeLanguage? language}) {
    ThemedHumanizeOptions newOptions = options ?? const .new();
    ThemedHumanizeLanguage newLanguage = language ?? const ThemedHumanizedDurationLanguage();

    int i, len;
    len = newOptions.units.length;

    var ms = inMilliseconds.abs();

    List<_ThemedHumanizePiece> pieces = [];
    ThemedUnits unitName;
    int unitMS, unitCount;

    for (i = 0; i < len; i++) {
      unitName = newOptions.units[i];
      unitMS = unitMeasures[unitName]!;
      unitCount = (ms / unitMS).floor();
      pieces.add(_ThemedHumanizePiece(unitName, unitCount, newLanguage));
      ms -= unitCount * unitMS;
    }

    pieces.removeWhere((e) => e.unitCount <= 0);
    final result = pieces.map((e) => e.format(newOptions.spacer)).toList();

    if (result.isEmpty) {
      ThemedUnits smallestUnit;
      if (newOptions.units.contains(ThemedUnits.millisecond)) {
        smallestUnit = .millisecond;
      } else if (newOptions.units.contains(ThemedUnits.second)) {
        smallestUnit = .second;
      } else if (newOptions.units.contains(ThemedUnits.minute)) {
        smallestUnit = .minute;
      } else if (newOptions.units.contains(ThemedUnits.hour)) {
        smallestUnit = .hour;
      } else if (newOptions.units.contains(ThemedUnits.day)) {
        smallestUnit = .day;
      } else if (newOptions.units.contains(ThemedUnits.week)) {
        smallestUnit = .week;
      } else if (newOptions.units.contains(ThemedUnits.month)) {
        smallestUnit = .month;
      } else if (newOptions.units.contains(ThemedUnits.year)) {
        smallestUnit = .year;
      } else {
        smallestUnit = .second;
      }

      return _ThemedHumanizePiece(smallestUnit, 0, newLanguage).format(newOptions.spacer);
    }

    if (result.length == 1) {
      return result.first;
    }

    if (result.length == 2) {
      return result.join(newOptions.conjunction);
    }

    return '${result.sublist(0, result.length - 1).join(newOptions.delimiter)}'
        '${(newOptions.lastPrefixComma ? "," : "")}'
        '${newOptions.conjunction}${result.last}';
  }
}
