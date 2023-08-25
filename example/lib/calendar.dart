import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
      showDrawer: true,
      body: Column(
        children: [
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
                  at: DateTime(2023, 8, 1, 8, 0, 0),
                  title: "Evento 2",
                  caption: "Evento 2 caption",
                  color: Colors.green,
                  icon: MdiIcons.calendar,
                ),
                ThemedCalendarEntry(
                  at: DateTime(2023, 8, 1, 12, 0, 0),
                  title: "Evento 3",
                  caption: "Evento 3 caption",
                  color: Colors.blue,
                  icon: MdiIcons.calendar,
                  onTap: () {
                    debugPrint("Evento 3 tapped");
                  },
                ),
              ],
              rangeEntries: [
                ThemedCalendarRangeEntry(
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
