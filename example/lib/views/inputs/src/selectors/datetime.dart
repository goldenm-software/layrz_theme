part of '../../inputs.dart';

class DateTimePickersView extends StatefulWidget {
  const DateTimePickersView({super.key});

  @override
  State<DateTimePickersView> createState() => _DateTimePickersViewState();
}

class _DateTimePickersViewState extends State<DateTimePickersView> {
  DateTime? _selectedDate;
  List<DateTime> _selectedDateRange = [];

  TimeOfDay? _selectedTime;
  List<TimeOfDay> _selectedTimeRange = [];

  DateTime? _selectedDateTime;
  List<DateTime> _selectedDateTimeRange = [];

  ThemedMonth? _selectedMonth;
  List<ThemedMonth> _selectedMonthRange = [];

  late Location tz;
  @override
  void initState() {
    super.initState();
    tz = getLocation('Asia/Tokyo');
    setTimezone(tz);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "We separate the date and time pickers in 4 categories: date, time, date and time and month pickers",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Date pickers",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Classic picker"),

            ThemedDatePicker(
              labelText: "Example label",
              value: _selectedDate,
              onChanged: (val) {
                setState(() => _selectedDate = val);
                if (val is TZDateTime) {
                  debugPrint('Selected date: $val (TZDateTime) in timezone ${tz.name}');
                  _selectedDate = val;
                } else {
                  _selectedDate = TZDateTime.from(val, tz);
                  debugPrint('Selected date: $_selectedDate (converted to TZDateTime) in timezone ${tz.name}');
                }
              },
            ),
            const Text("And the range variant"),
            ThemedDateRangePicker(
              labelText: "Example label",
              value: _selectedDateRange,
              onChanged: (val) => setState(() => _selectedDateRange = val),
            ),
            const SizedBox(height: 10),
            Text(
              "Time pickers",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Classic picker"),
            ThemedTimePicker(
              labelText: "Example label",
              value: _selectedTime,
              onChanged: (val) {
                setState(() {
                  _selectedTime = val;
                  _selectedDateTime = DateTime(
                    _selectedDateTime?.year ?? DateTime.now().year,
                    _selectedDateTime?.month ?? DateTime.now().month,
                    _selectedDateTime?.day ?? DateTime.now().day,
                    val.hour,
                    val.minute,
                  );
                });
              },
              disableBlink: true,
            ),
            const Text("And the range variant"),
            ThemedTimeRangePicker(
              labelText: "Example label",
              value: _selectedTimeRange,
              onChanged: (val) => setState(() => _selectedTimeRange = val),
            ),
            Text(
              "You can use 24 hour format using the property use24HourFormat",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            Text(
              "Date and time pickers",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Classic picker"),
            if (kDebugMode) ...[
              if (_selectedDateTime is TZDateTime)
                Text('Selected date and time: $_selectedDateTime (TZDateTime) in timezone ${tz.name}')
              else if (_selectedDateTime != null)
                Text('Selected date and time: $_selectedDateTime (DateTime, not converted to TZDateTime)'),
            ],
            ThemedDateTimePicker(
              labelText: "Example label",
              value: _selectedDateTime,
              onChanged: (val) {
                debugPrint("Raw selected date and time: $val (${val.runtimeType})");
                if (val is TZDateTime) {
                  debugPrint('Selected date and time: $val (TZDateTime) in timezone ${tz.name}');
                  setState(() => _selectedDateTime = val);
                } else {
                  final converted = TZDateTime.from(val, tz);
                  debugPrint('Selected date and time: $converted (converted to TZDateTime) in timezone ${tz.name}');
                  setState(() => _selectedDateTime = converted);
                }
              },
            ),
            const Text("And the range variant"),
            if (kDebugMode) ...[
              for (final entry in _selectedDateTimeRange.asMap().entries) ...[
                if (entry.value is TZDateTime) ...[
                  Text('[${entry.key}] Selected date and time: ${entry.value} (TZDateTime) in timezone ${tz.name}'),
                ] else ...[
                  Text('[${entry.key}] Selected date and time: ${entry.value} (DateTime, not converted to TZDateTime)'),
                ],
              ],
            ],
            ThemedDateTimeRangePicker(
              labelText: "Example label",
              value: _selectedDateTimeRange,
              onChanged: (val) {
                debugPrint("Raw selected date and time range: $val");
                final convertedRange = val.map((dateTime) {
                  if (dateTime is TZDateTime) {
                    debugPrint('Selected date and time: $dateTime (TZDateTime) in timezone ${tz.name}');
                    return dateTime;
                  } else {
                    final converted = TZDateTime.from(dateTime, tz);
                    debugPrint('Selected date and time: $converted (converted to TZDateTime) in timezone ${tz.name}');
                    return converted;
                  }
                }).toList();
                setState(() => _selectedDateTimeRange = convertedRange);
              },
            ),
            const Text("Stepped variant, after selecting the date, you will select the time"),
            ThemedDateTimeSteppedPicker(
              labelText: "Example label",
              value: _selectedDateTime,
              onChanged: (val) {
                _selectedTime = TimeOfDay(hour: val.hour, minute: val.minute);
                setState(() => _selectedDateTime = val);
              },
            ),
            Text(
              "Similar to the ThemedTimePicker and ThemedTimeRangePicker, using the property use24HourFormat "
              "you can use the 24 hour format",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            Text(
              "Month pickers",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Classic picker"),
            ThemedMonthPicker(
              labelText: "Example label",
              value: _selectedMonth,
              onChanged: (val) => setState(() => _selectedMonth = val),
            ),
            const Text("And the range variant"),
            ThemedMonthRangePicker(
              labelText: "Example label",
              value: _selectedMonthRange,
              onChanged: (val) => setState(() => _selectedMonthRange = val),
            ),
            const Text("Also, you can use the property `consecutive` to force the selection of consecutive months"),
            ThemedMonthRangePicker(
              labelText: "Example label",
              value: _selectedMonthRange,
              consecutive: true,
              onChanged: (val) => setState(() => _selectedMonthRange = val),
            ),
          ],
        ),
      ),
    );
  }
}
