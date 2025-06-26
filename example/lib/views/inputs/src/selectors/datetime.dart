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
              onChanged: (val) => setState(() => _selectedDate = val),
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
              onChanged: (val) => setState(() => _selectedTime = val),
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
            ThemedDateTimePicker(
              labelText: "Example label",
              value: _selectedDateTime,
              onChanged: (val) => setState(() => _selectedDateTime = val),
            ),
            const Text("And the range variant"),
            ThemedDateTimeRangePicker(
              labelText: "Example label",
              value: _selectedDateTimeRange,
              onChanged: (val) => setState(() => _selectedDateTimeRange = val),
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
