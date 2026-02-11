import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('thisWeek / lastWeek', () {
    test('returns correct week boundaries', () {
      DateTime day = DateTime(2023, 8, 1);
      List<DateTime> thisWeek = day.thisWeek;

      expect(thisWeek.first, DateTime(2023, 7, 31));
      expect(thisWeek.last, DateTime(2023, 8, 6));

      List<DateTime> lastWeek = day.lastWeek;

      expect(lastWeek.first, DateTime(2023, 7, 24));
      expect(lastWeek.last, DateTime(2023, 7, 30));
    });

    test('handles Monday correctly', () {
      final monday = DateTime(2023, 8, 7); // Monday
      expect(monday.thisWeek.first, DateTime(2023, 8, 7));
      expect(monday.thisWeek.last, DateTime(2023, 8, 13));
    });

    test('handles Sunday correctly', () {
      final sunday = DateTime(2023, 8, 6); // Sunday
      expect(sunday.thisWeek.first, DateTime(2023, 7, 31));
      expect(sunday.thisWeek.last, DateTime(2023, 8, 6));
    });
  });

  group('thisMonth / lastMonth', () {
    test('returns correct month boundaries for August', () {
      final day = DateTime(2023, 8, 15);
      expect(day.thisMonth.first, DateTime(2023, 8, 1));
      expect(day.thisMonth.last, DateTime(2023, 8, 31));
    });

    test('returns correct lastMonth boundaries', () {
      final day = DateTime(2023, 8, 15);
      expect(day.lastMonth.first, DateTime(2023, 7, 1));
      expect(day.lastMonth.last, DateTime(2023, 7, 31));
    });

    test('handles February in leap year', () {
      final day = DateTime(2024, 2, 15); // 2024 is a leap year
      expect(day.thisMonth.first, DateTime(2024, 2, 1));
      expect(day.thisMonth.last, DateTime(2024, 2, 29));
    });

    test('handles February in non-leap year', () {
      final day = DateTime(2023, 2, 10);
      expect(day.thisMonth.first, DateTime(2023, 2, 1));
      expect(day.thisMonth.last, DateTime(2023, 2, 28));
    });

    test('handles January lastMonth wraps to previous year', () {
      final day = DateTime(2023, 1, 15);
      expect(day.lastMonth.first, DateTime(2022, 12, 1));
      expect(day.lastMonth.last, DateTime(2022, 12, 31));
    });
  });

  group('secondsSinceEpoch', () {
    test('converts milliseconds to seconds', () {
      final day = DateTime.fromMillisecondsSinceEpoch(5000);
      expect(day.secondsSinceEpoch, 5.0);
    });

    test('handles epoch zero', () {
      final day = DateTime.fromMillisecondsSinceEpoch(0);
      expect(day.secondsSinceEpoch, 0.0);
    });
  });

  group('format', () {
    // Use a fixed date: Tuesday, August 1, 2023 14:05:09
    final day = DateTime(2023, 8, 1, 14, 5, 9);

    test('%Y full year', () {
      expect(day.format(pattern: '%Y'), '2023');
    });

    test('%y two-digit year', () {
      expect(day.format(pattern: '%y'), '23');
    });

    test('%m zero-padded month', () {
      expect(day.format(pattern: '%m'), '08');
    });

    test('%d zero-padded day', () {
      expect(day.format(pattern: '%d'), '01');
    });

    test('%H 24-hour format', () {
      expect(day.format(pattern: '%H'), '14');
    });

    test('%I 12-hour format', () {
      expect(day.format(pattern: '%I'), '02');
    });

    test('%p AM/PM indicator', () {
      expect(day.format(pattern: '%p'), 'PM');
      final morning = DateTime(2023, 8, 1, 9, 0, 0);
      expect(morning.format(pattern: '%p'), 'AM');
    });

    test('%M zero-padded minute', () {
      expect(day.format(pattern: '%M'), '05');
    });

    test('%S zero-padded second', () {
      expect(day.format(pattern: '%S'), '09');
    });

    test('%A full weekday name', () {
      expect(day.format(pattern: '%A'), 'Tuesday');
    });

    test('%a abbreviated weekday name', () {
      expect(day.format(pattern: '%a'), 'Tue');
    });

    test('%B full month name', () {
      expect(day.format(pattern: '%B'), 'August');
    });

    test('%b abbreviated month name', () {
      expect(day.format(pattern: '%b'), 'Aug');
    });

    test('%% literal percent', () {
      expect(day.format(pattern: '%%'), '%');
    });

    test('combined pattern', () {
      expect(day.format(pattern: '%Y-%m-%d %H:%M:%S'), '2023-08-01 14:05:09');
    });

    test('%I shows 12 for noon/midnight', () {
      final noon = DateTime(2023, 8, 1, 12, 0, 0);
      expect(noon.format(pattern: '%I'), '12');

      final midnight = DateTime(2023, 8, 1, 0, 0, 0);
      expect(midnight.format(pattern: '%I'), '12');
    });
  });
}
