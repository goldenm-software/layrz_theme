// ignore_for_file: unused_element

part of inputs;

class _InternalDateDraw {
  final DateTime value;
  final bool obscure;
  final bool disabled;

  const _InternalDateDraw({
    required this.value,
    this.obscure = false,
    this.disabled = false,
  });

  @override
  String toString() {
    return '_InternalDateDraw{value: $value, obscure: $obscure}';
  }
}

// ignore: library_private_types_in_public_api
List<List<_InternalDateDraw>> generateMonth(DateTime? dayToSearch, {List<DateTime> disabledDates = const []}) {
  List<DateTime> days = [];

  DateTime now = dayToSearch ?? DateTime.now();
  DateTime start = DateTime(now.year, now.month, 1, 0, 0, 0);

  if (start.weekday == 7) {
    start = DateTime(now.year, now.month, 1, 0, 0, 0);
  } else {
    start = DateTime(now.year, now.month, 1, 0, 0, 0).subtract(Duration(days: start.weekday));
  }

  DateTime end = DateTime(now.year, now.month + 1, 1, 0, 0, 0).subtract(const Duration(days: 1));
  if (end.weekday == DateTime.sunday) {
    end = end.add(const Duration(days: 5));
  } else {
    end = end.add(Duration(days: 7 - end.weekday - 1));
  }

  // Populate days with empty days
  days.add(start);
  DateTime last = start;

  while (last.isBefore(end)) {
    DateTime preLast = last.add(const Duration(days: 1));
    if (preLast.day == last.day) {
      last = preLast.add(Duration(hours: (24 - preLast.hour)));
    } else {
      last = preLast;
    }
    days.add(last);
  }

  List<List<_InternalDateDraw>> calendar = [];

  for (int i = 0; i < days.length; i++) {
    if (i % 7 == 0) {
      calendar.add([]);
    }
    calendar[calendar.length - 1].add(_InternalDateDraw(
      value: days[i],
      obscure: days[i].month != now.month,
    ));
  }

  return calendar;
}
