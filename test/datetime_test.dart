import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  test('DateTime.thisWeek', () {
    DateTime day = DateTime(2023, 8, 1);
    List<DateTime> thisWeek = day.thisWeek;

    expect(thisWeek.first, DateTime(2023, 7, 31));
    expect(thisWeek.last, DateTime(2023, 8, 6));

    List<DateTime> lastWeek = day.lastWeek;

    expect(lastWeek.first, DateTime(2023, 7, 24));
    expect(lastWeek.last, DateTime(2023, 7, 30));
  });
}
