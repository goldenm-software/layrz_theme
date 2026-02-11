import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('DateTimeExtension', () {
    test('secondsSinceEpoch returns correct value', () {
      final date = DateTime(2023, 1, 1);
      expect(date.secondsSinceEpoch, date.millisecondsSinceEpoch / 1000);
    });

    test('thisWeek and lastWeek return correct dates', () {
      final date = DateTime(2023, 8, 1); // Tuesday
      final thisWeek = date.thisWeek;
      expect(thisWeek.first, DateTime(2023, 7, 31)); // Monday
      expect(thisWeek.last, DateTime(2023, 8, 6)); // Sunday

      final lastWeek = date.lastWeek;
      expect(lastWeek.first, DateTime(2023, 7, 24)); // Monday
      expect(lastWeek.last, DateTime(2023, 7, 30)); // Sunday
    });

    test('thisMonth and lastMonth return correct dates', () {
      final date = DateTime(2023, 8, 15);
      final thisMonth = date.thisMonth;
      expect(thisMonth.first, DateTime(2023, 8, 1));
      expect(thisMonth.last, DateTime(2023, 8, 31));

      final lastMonth = date.lastMonth;
      expect(lastMonth.first, DateTime(2023, 7, 1));
      expect(lastMonth.last, DateTime(2023, 7, 31));
    });
  });
}
