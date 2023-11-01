part of inputs;

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  List<int> selected = [];
  List<ThemedSelectItem<int>> get choices => [];
  ThemedCalendarMode mode = ThemedCalendarMode.week;
  DateTime focusDay = DateTime(2023, 8, 1, 8, 0, 0);
  bool showEntries = false;

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This is an example of our calendar, you can show or hide the entries using the button below.",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          ThemedButton(
            labelText: "Show / hide entries",
            onTap: () => setState(() => showEntries = !showEntries),
          ),
          Expanded(
            child: ThemedCalendar(
              isHighlightDaysAsRange: true,
              focusDay: focusDay,
              // mode: mode,
              showEntries: showEntries,
              entries: [
                ThemedCalendarEntry(
                  textAlign: TextAlign.center,
                  at: DateTime(2023, 8, 1),
                  title: "Evento 1",
                  caption: "Evento 1 caption",
                  color: Colors.red,
                  icon: MdiIcons.calendar,
                  onTap: () {
                    debugPrint("Evento 1 tapped");
                  },
                ),
                ThemedCalendarEntry(
                  textAlign: TextAlign.left,
                  at: DateTime(2023, 8, 1, 8, 0, 0),
                  title: "Evento 2",
                  caption: "Evento 2 caption",
                  color: Colors.green,
                  icon: MdiIcons.calendar,
                ),
                ThemedCalendarEntry(
                  textAlign: TextAlign.right,
                  at: DateTime(2023, 8, 1, 12, 0, 0),
                  title: "Evento 3",
                  caption: "Evento 3 caption",
                  color: Colors.blue,
                  icon: MdiIcons.calendar,
                  onTap: () {
                    debugPrint("Evento 3 tapped");
                  },
                ),
                ThemedCalendarEntry(
                  at: DateTime(2023, 8, 10, 12, 0, 0),
                  title: "Evento 1",
                  caption: "Evento 3 caption",
                  color: Colors.pink,
                  icon: MdiIcons.calendar,
                  onTap: () {
                    debugPrint("Evento 3 tapped");
                  },
                ),
              ],
              rangeEntries: [
                ThemedCalendarRangeEntry(
                  textAlign: TextAlign.right,
                  startAt: DateTime(2023, 8, 1, 8, 0, 0),
                  endAt: DateTime(2023, 8, 5, 8, 0, 0),
                  title: "Evento 1 de rango",
                  caption: "Evento 1 caption",
                  color: Colors.purple,
                  icon: MdiIcons.calendar,
                  onTap: () {
                    debugPrint("Evento 1 de rango tapped");
                  },
                ),
              ],
              highlightedDays: [
                DateTime(2023, 8, 1, 8, 0, 0),
                DateTime(2023, 8, 2, 8, 0, 0),
                DateTime(2023, 8, 3, 8, 0, 0),
                DateTime(2023, 8, 4, 8, 0, 0),
                DateTime(2023, 8, 5, 8, 0, 0),
              ],
              // onModeChanged: (newMode) {
              //   debugPrint("Mode changed to $newMode");
              //   setState(() => mode = newMode);
              // },
              onDayTap: (day) {
                debugPrint("Day tapped: $day");
                setState(() => focusDay = day);
              },
            ),
          ),
        ],
      ),
    );
  }
}
