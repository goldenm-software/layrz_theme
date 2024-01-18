part of '../../utilities.dart';

extension HumanizeDuration on Duration {
  /// [humanize] returns a human readable string of the [Duration].
  /// It uses the [ThemedHumanizeOptions] to define the format.
  String humanize({ThemedHumanizeOptions? options, ThemedHumanizeLanguage? language}) {
    ThemedHumanizeOptions _options = options ?? const ThemedHumanizeOptions();
    ThemedHumanizeLanguage _language = language ?? const ThemedHumanizedDurationLanguage();

    int i, len;
    len = _options.units.length;

    var ms = inMilliseconds.abs();

    List<_ThemedHumanizePiece> pieces = [];
    ThemedUnits unitName;
    int unitMS, unitCount;

    for (i = 0; i < len; i++) {
      unitName = _options.units[i];
      unitMS = unitMeasures[unitName]!;
      unitCount = (ms / unitMS).floor();
      pieces.add(_ThemedHumanizePiece(unitName, unitCount, _language));
      ms -= unitCount * unitMS;
    }

    pieces.removeWhere((e) => e.unitCount <= 0);
    final result = pieces.map((e) => e.format(_options.spacer)).toList();

    if (result.isEmpty) {
      ThemedUnits smallestUnit;
      if (_options.units.contains(ThemedUnits.millisecond)) {
        smallestUnit = ThemedUnits.millisecond;
      } else if (_options.units.contains(ThemedUnits.second)) {
        smallestUnit = ThemedUnits.second;
      } else if (_options.units.contains(ThemedUnits.minute)) {
        smallestUnit = ThemedUnits.minute;
      } else if (_options.units.contains(ThemedUnits.hour)) {
        smallestUnit = ThemedUnits.hour;
      } else if (_options.units.contains(ThemedUnits.day)) {
        smallestUnit = ThemedUnits.day;
      } else if (_options.units.contains(ThemedUnits.week)) {
        smallestUnit = ThemedUnits.week;
      } else if (_options.units.contains(ThemedUnits.month)) {
        smallestUnit = ThemedUnits.month;
      } else if (_options.units.contains(ThemedUnits.year)) {
        smallestUnit = ThemedUnits.year;
      } else {
        smallestUnit = ThemedUnits.second;
      }

      return _ThemedHumanizePiece(smallestUnit, 0, _language).format(_options.spacer);
    }

    if (result.length == 1) {
      return result.first;
    }

    if (result.length == 2) {
      return result.join(_options.conjunction);
    }

    return '${result.sublist(0, result.length - 1).join(_options.delimiter)}'
        '${(_options.lastPrefixComma ? "," : "")}'
        '${_options.conjunction}${result.last}';
  }
}
