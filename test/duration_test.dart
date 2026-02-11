import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('Duration.humanize', () {
    test('single unit', () {
      expect(const Duration(hours: 2).humanize(), '2 hours');
    });

    test('singular unit', () {
      expect(const Duration(hours: 1).humanize(), '1 hour');
    });

    test('two units joined with conjunction', () {
      expect(const Duration(hours: 1, minutes: 30).humanize(), '1 hour and 30 minutes');
    });

    test('three units with delimiter and conjunction', () {
      expect(const Duration(days: 2, hours: 3, minutes: 15).humanize(), '2 days, 3 hours and 15 minutes');
    });

    test('zero duration returns smallest unit with 0', () {
      expect(const Duration().humanize(), '0 minutes');
    });

    test('negative duration uses absolute value', () {
      expect(const Duration(hours: -2).humanize(), '2 hours');
    });

    test('filters out zero-value units', () {
      // 1 day, 0 hours, 5 minutes => should skip hours
      expect(const Duration(days: 1, minutes: 5).humanize(), '1 day and 5 minutes');
    });

    test('lastPrefixComma adds comma before conjunction', () {
      final options = ThemedHumanizeOptions(lastPrefixComma: true);
      expect(
        const Duration(days: 1, hours: 2, minutes: 3).humanize(options: options),
        '1 day, 2 hours, and 3 minutes',
      );
    });

    test('custom delimiter', () {
      final options = ThemedHumanizeOptions(delimiter: ' - ', conjunction: ' & ');
      expect(
        const Duration(days: 1, hours: 2, minutes: 3).humanize(options: options),
        '1 day - 2 hours & 3 minutes',
      );
    });

    test('custom units subset', () {
      final options = ThemedHumanizeOptions(units: [ThemedUnits.hour, ThemedUnits.minute]);
      // 2 days = 48 hours
      expect(const Duration(days: 2, minutes: 30).humanize(options: options), '48 hours and 30 minutes');
    });

    test('zero duration with seconds in units', () {
      final options = ThemedHumanizeOptions(units: [ThemedUnits.hour, ThemedUnits.minute, ThemedUnits.second]);
      expect(const Duration().humanize(options: options), '0 seconds');
    });

    test('large duration includes days and months', () {
      // 400 days worth of milliseconds
      final result = const Duration(days: 400).humanize();
      expect(result, contains('year'));
    });
  });
}
