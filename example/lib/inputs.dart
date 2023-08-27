import 'dart:math';

import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InputsView extends StatefulWidget {
  final String name;

  const InputsView({
    super.key,
    this.name = 'Generic View',
  });

  @override
  State<InputsView> createState() => _InputsViewState();
}

class _InputsViewState extends State<InputsView> {
  bool isDisabled = false;
  List<int> selected = [];
  Duration? durationValue = const Duration(
    days: 0,
    seconds: 0,
    minutes: 0,
    hours: 0,
  );
  List<String> searchChoices = [];

  DateTime _selectedDateTime = DateTime.now();
  List<DateTime> _selectedDateTimes = [
    DateTime(2023, 8, 22, 15, 30),
    DateTime(2023, 8, 26, 16, 30),
  ];

  TimeOfDay _selectedTime = const TimeOfDay(hour: 15, minute: 30);
  List<TimeOfDay> _selectedTimes = [
    const TimeOfDay(hour: 15, minute: 30),
    const TimeOfDay(hour: 16, minute: 30),
  ];
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _selectedDates = [
    DateTime(2023, 8, 22),
    DateTime(2023, 8, 26),
  ];
  ThemedMonth? _selectedMonth = const ThemedMonth(year: 2023, month: Month.july);
  List<ThemedMonth> _selectedMonths = const [
    ThemedMonth(year: 2023, month: Month.july),
    ThemedMonth(year: 2023, month: Month.august),
  ];
  List<ThemedMonth> _selectedMonths2 = const [
    ThemedMonth(year: 2023, month: Month.july),
    ThemedMonth(year: 2023, month: Month.august),
  ];
  List<ThemedSelectItem<int>> choices = [
    ...List.generate(1, (index) {
      return ThemedSelectItem<int>(
        value: index,
        icon: index % 2 == 0 ? MdiIcons.homeVariant : null,
        label: "Choice $index un papá, un niño",
      );
    }),
    ThemedSelectItem<int>(
      value: -1,
      label: 'Leading',
      leading: Container(
        width: 10,
        height: 10,
        color: Colors.red,
      ),
    ),
    ThemedSelectItem<int>(
      value: -2,
      label: 'Content',
      content: Container(
        width: 10,
        height: 10,
        color: Colors.blue,
      ),
    ),
  ];
  late ThemedSelectItem<int> choice;
  late List<ThemedSelectItem<int>> selectedChoices;

  bool value = false;

  String textInputValue = "";
  String textInputValue2 = "";

  @override
  void initState() {
    super.initState();
    choice = choices.last;
    selectedChoices = [choices.first, choices.last];
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      showDrawer: true,
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  ThemedButton(
                    labelText: "Fill choices",
                    onTap: () {
                      setState(() {
                        searchChoices = List.generate(10, (index) => "Choice $index");
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  ThemedButton(
                    labelText: "Clear choices",
                    onTap: () {
                      setState(() {
                        searchChoices = [];
                      });
                    },
                  ),
                ],
              ),

              ThemedTextInput(
                disabled: isDisabled,
                labelText: 'Text Input [Combobox]',
                value: textInputValue2,
                choices: searchChoices,
                enableCombobox: true,
                onChanged: (value) {
                  setState(() {
                    textInputValue2 = value;
                    searchChoices = List.generate(Random().nextInt(10), (index) {
                      return "Choice $index";
                    });
                    debugPrint("Search: $value - ${searchChoices.length}");
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    ThemedSearchInput(
                      position: ThemedSearchPosition.right,
                      value: '',
                      onSearch: (value) {
                        debugPrint("Search full left: $value");
                      },
                    ),
                    const Spacer(),
                    ThemedSearchInput(
                      position: ThemedSearchPosition.right,
                      value: '',
                      onSearch: (value) {
                        debugPrint("Search middle left: $value");
                      },
                    ),
                    const Text("< Search input >"),
                    ThemedSearchInput(
                      position: ThemedSearchPosition.left,
                      value: '',
                      onSearch: (value) {
                        debugPrint("Search middle right: $value");
                      },
                    ),
                    const Spacer(),
                    ThemedSearchInput(
                      position: ThemedSearchPosition.left,
                      value: '',
                      onSearch: (value) {
                        debugPrint("Search full right: $value");
                      },
                    ),
                  ],
                ),
              ),
              ThemedButton(
                labelText: "Lock / Unlock",
                onTap: () {
                  setState(() {
                    isDisabled = !isDisabled;
                  });
                },
              ),
              ThemedButton(
                labelText: "Append choices",
                onTap: () {
                  int random = Random().nextInt(100);
                  setState(() {
                    choices.add(ThemedSelectItem(
                      label: "Random $random",
                      value: random,
                    ));
                  });
                },
              ),
              ThemedDualListInput<int>(
                disabled: isDisabled,
                labelText: "Dual List Input",
                items: choices,
                value: selectedChoices.map((e) => e.value!).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedChoices = value;
                  });
                },
              ),
              ThemedMultiSelectInput<int>(
                disabled: isDisabled,
                labelText: "MultiSelect Input",
                items: choices,
                value: selectedChoices.map((e) => e.value!).toList(),
                onChanged: (value) {
                  setState(() {
                    selected = value.map((e) => e.value!).toList();
                  });
                },
              ),
              ThemedSelectInput<int>(
                disabled: isDisabled,
                value: choice.value,
                labelText: "Select Input",
                items: choices,
              ),
              ThemedIconPicker(
                disabled: isDisabled,
                labelText: 'Icon Picker',
                onChanged: (value) {
                  debugPrint("Icon: $value");
                },
              ),

              ThemedEmojiPicker(
                disabled: isDisabled,
                labelText: 'Emoji Picker',
                onChanged: (value) {
                  debugPrint("Emoji: $value");
                },
              ),
              ThemedTextInput(
                disabled: isDisabled,
                labelText: 'Text Input [Combobox]',
                value: textInputValue2,
                choices: searchChoices,
                enableCombobox: true,
                position: ThemedComboboxPosition.above,
                onChanged: (value) {
                  setState(() {
                    textInputValue2 = value;
                    searchChoices = List.generate(Random().nextInt(10), (index) {
                      return "Choice $index";
                    });
                    debugPrint("Search: $value - ${searchChoices.length}");
                  });
                },
              ),
              ThemedAvatarPicker(
                disabled: isDisabled,
                labelText: 'Avatar picker',
                onChanged: (value) {
                  debugPrint("File: ${value?.length}");
                },
              ),
              ThemedDateTimeRangePicker(
                use24HourFormat: true,
                disabled: isDisabled,
                labelText: 'DateTime picker [24h]',
                value: _selectedDateTimes,
                onChanged: (value) {
                  setState(() {
                    _selectedDateTimes = value;
                  });
                },
              ),
              ThemedDateTimeRangePicker(
                disabled: isDisabled,
                labelText: 'DateTime picker [AM/PM]',
                value: _selectedDateTimes,
                onChanged: (value) {
                  setState(() {
                    _selectedDateTimes = value;
                  });
                },
              ),
              ThemedDateTimePicker(
                use24HourFormat: true,
                disabled: isDisabled,
                labelText: 'DateTime picker [24h]',
                value: _selectedDateTime,
                onChanged: (value) {
                  setState(() {
                    _selectedDateTime = value;
                  });
                },
              ),
              ThemedDateTimePicker(
                disabled: isDisabled,
                labelText: 'DateTime picker [AM/PM]',
                value: _selectedDateTime,
                onChanged: (value) {
                  setState(() {
                    _selectedDateTime = value;
                  });
                },
              ),
              ThemedTimeRangePicker(
                use24HourFormat: true,
                disabled: isDisabled,
                labelText: 'Time picker [24h]',
                value: _selectedTimes,
                onChanged: (value) {
                  setState(() {
                    _selectedTimes = value;
                  });
                },
              ),
              ThemedTimeRangePicker(
                disabled: isDisabled,
                labelText: 'Time picker [AM/PM]',
                value: _selectedTimes,
                onChanged: (value) {
                  setState(() {
                    _selectedTimes = value;
                  });
                },
              ),
              ThemedTimePicker(
                use24HourFormat: true,
                disabled: isDisabled,
                labelText: 'Time picker [24h]',
                value: _selectedTime,
                onChanged: (value) {
                  setState(() {
                    _selectedTime = value;
                  });
                },
              ),
              ThemedTimePicker(
                disabled: isDisabled,
                labelText: 'Time picker [AM/PM]',
                value: _selectedTime,
                onChanged: (value) {
                  setState(() {
                    _selectedTime = value;
                  });
                },
              ),
              ThemedTextInput(
                disabled: isDisabled,
                labelText: 'Text Input [Plain]',
                value: textInputValue,
                onChanged: (value) {
                  setState(() {
                    textInputValue = value;
                  });
                },
              ),

              ThemedDatePicker(
                disabled: isDisabled,
                labelText: "Date picker",
                value: _selectedDate,
                disabledDays: [
                  DateTime(2023, 8, 20),
                  DateTime(2023, 8, 26),
                ],
                onChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              ThemedDateRangePicker(
                disabled: isDisabled,
                labelText: "Date range picker",
                value: _selectedDates,
                pattern: '%B %d, %Y',
                onChanged: (dates) {
                  setState(() {
                    _selectedDates = dates;
                  });
                },
              ),
              ThemedMonthPicker(
                disabled: isDisabled,
                labelText: "Month picker",
                value: _selectedMonth,
                minimum: const ThemedMonth(year: 2023, month: Month.january),
                maximum: const ThemedMonth(year: 2023, month: Month.december),
                disabledMonths: const [
                  ThemedMonth(year: 2023, month: Month.january),
                  ThemedMonth(year: 2023, month: Month.february),
                  ThemedMonth(year: 2023, month: Month.march),
                ],
                onChanged: (month) {
                  setState(() {
                    _selectedMonth = month;
                  });
                },
              ),
              ThemedMonthRangePicker(
                disabled: isDisabled,
                labelText: "Month range picker [Random]",
                value: _selectedMonths,
                minimum: const ThemedMonth(year: 2023, month: Month.january),
                maximum: const ThemedMonth(year: 2023, month: Month.december),
                disabledMonths: const [
                  ThemedMonth(year: 2023, month: Month.january),
                  ThemedMonth(year: 2023, month: Month.february),
                  ThemedMonth(year: 2023, month: Month.march),
                ],
                onChanged: (months) {
                  setState(() {
                    _selectedMonths = months;
                  });
                },
              ),
              ThemedMonthRangePicker(
                disabled: isDisabled,
                labelText: "Month range picker [Consecutive]",
                value: _selectedMonths2,
                consecutive: true,
                minimum: const ThemedMonth(year: 2022, month: Month.january),
                maximum: const ThemedMonth(year: 2024, month: Month.december),
                disabledMonths: const [
                  ThemedMonth(year: 2023, month: Month.january),
                  ThemedMonth(year: 2023, month: Month.february),
                  ThemedMonth(year: 2023, month: Month.march),
                ],
                onChanged: (months) {
                  setState(() {
                    _selectedMonths2 = months;
                  });
                },
              ),
              ThemedColorPicker(
                disabled: isDisabled,
                labelText: 'Color picker',
                onChanged: (color) {
                  debugPrint("Color: $color");
                },
              ),
              Text(durationValue.toString()),
              ThemedDurationInput(
                disabled: isDisabled,
                value: durationValue,
                // visibleValues: const [
                //   ThemedDurationInputVisibleValues.hours,
                //   ThemedDurationInputVisibleValues.minutes,
                // ],
                labelText: "Duration Input",
                onChanged: (value) {
                  setState(() {
                    durationValue = value;
                  });
                },
              ),
              // set duration button
              ThemedButton(
                labelText: "Set duration",
                onTap: () {
                  setState(() {
                    durationValue = const Duration(minutes: 99);
                  });
                },
              ),
              const SizedBox(height: 30),
              const ThemedInputLikeContainer(
                labelText: "Input like container",
                child: Text(""),
              ),
              const SizedBox(height: 10),
              ThemedDynamicAvatarInput(
                disabled: isDisabled,
                labelText: "Dynamic Avatar Input",
              ),
              ThemedIconPicker(
                disabled: isDisabled,
                labelText: "Icon picker",
                onChanged: (icon) {
                  debugPrint("Icon: $icon");
                },
              ),
              ThemedEmojiPicker(
                disabled: isDisabled,
                value: "🍊",
                labelText: "Emoji picker",
                onChanged: (emoji) {
                  debugPrint("Emoji: $emoji");
                },
              ),
              ThemedCodeEditor(
                disabled: isDisabled,
                labelText: "Code Editor",
              ),
              ThemedTextInput(
                disabled: isDisabled,
                labelText: "Text Input",
                prefixText: "prefix.",
                suffixIcon: MdiIcons.homeVariant,
              ),
              ThemedFileInput(
                disabled: isDisabled,
                labelText: "File Input",
              ),
              ThemedTextInput(
                disabled: isDisabled,
                labelText: "Text Input",
                prefixText: "prefix.",
                suffixIcon: MdiIcons.homeVariant,
                dense: true,
              ),
              ...ThemedCheckboxInputStyle.values.map((style) {
                return ThemedCheckboxInput(
                  disabled: isDisabled,
                  labelText: "Checkbox Input with style $style",
                  style: style,
                  value: value,
                  onChanged: (value) {
                    setState(() {
                      this.value = value;
                    });
                  },
                );
              }).toList(),
              ThemedRadioInput<int>(
                disabled: isDisabled,
                labelText: "Radio Input",
                items: choices,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
