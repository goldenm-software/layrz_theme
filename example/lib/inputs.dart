import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  List<int> selected = [];
  Duration? durationValue = const Duration(
    days: 0,
    seconds: 0,
    minutes: 0,
    hours: 0,
  );
  List<String> searchChoices = [];
  ThemedMonth? _selectedMonth = const ThemedMonth(year: 2023, month: Month.july);
  List<ThemedMonth> _selectedMonths = const [
    ThemedMonth(year: 2023, month: Month.july),
    ThemedMonth(year: 2023, month: Month.august),
  ];
  List<ThemedMonth> _selectedMonths2 = const [
    ThemedMonth(year: 2023, month: Month.july),
    ThemedMonth(year: 2023, month: Month.august),
  ];
  List<ThemedSelectItem<int>> get choices => List.generate(10, (index) {
        return ThemedSelectItem<int>(
          value: index,
          icon: index % 2 == 0 ? MdiIcons.homeVariant : null,
          label: "Choice $index un papá, un niño",
        );
      });

  bool value = false;

  String textInputValue = "";
  String textInputValue2 = "";

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
              ThemedTextInput(
                labelText: 'Text Input [Plain]',
                value: textInputValue,
                onChanged: (value) {
                  setState(() {
                    textInputValue = value;
                  });
                },
              ),

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
                labelText: 'Text Input [Combobox]',
                value: textInputValue2,
                choices: searchChoices,
                onChanged: (value) {
                  setState(() {
                    textInputValue2 = value;
                  });
                },
              ),
              ThemedMonthPicker(
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
                labelText: 'Color picker',
                onChanged: (color) {
                  debugPrint("Color: $color");
                },
              ),
              Text(durationValue.toString()),
              ThemedDurationInput(
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
              const SizedBox(height: 30),
              const Divider(),
              const Text('Text Input reactive cursor example'),
              ThemedButton(
                labelText: "Update text input value",
                onTap: () {
                  setState(() {
                    textInputValue = "Updated value";
                  });
                },
              ),
              Text('Value: $textInputValue'),
              const Divider(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    ThemedSearchInput(
                      value: '',
                      onSearch: (value) {
                        debugPrint("Search: $value");
                      },
                    ),
                    const Spacer(),
                    const Text("< Search input >"),
                    const Spacer(),
                    ThemedSearchInput(
                      value: '',
                      onSearch: (value) {
                        debugPrint("Search 2: $value");
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ThemedTextInput(
                      labelText: 'Text Input [Combobox]',
                      value: textInputValue2,
                      choices: searchChoices,
                      onChanged: (value) {
                        setState(() {
                          textInputValue2 = value;
                        });
                      },
                      onTap: () {
                        debugPrint("Combobox tapped");
                      },
                    ),
                  ),
                  Expanded(
                    child: ThemedTextInput(
                      labelText: 'Text Input [Combobox]',
                      value: textInputValue2,
                      choices: searchChoices,
                      onChanged: (value) {
                        setState(() {
                          textInputValue2 = value;
                        });
                      },
                      onTap: () {
                        debugPrint("Combobox tapped");
                      },
                    ),
                  ),
                ],
              ),
              const ThemedDynamicAvatarInput(
                labelText: "Dynamic Avatar Input",
              ),
              ThemedIconPicker(
                labelText: "Icon picker",
                onChanged: (icon) {
                  debugPrint("Icon: $icon");
                },
              ),
              ThemedEmojiPicker(
                value: "🍊",
                labelText: "Emoji picker",
                onChanged: (emoji) {
                  debugPrint("Emoji: $emoji");
                },
              ),
              const ThemedCodeEditor(
                labelText: "Code Editor",
              ),
              ThemedTextInput(
                labelText: "Text Input",
                prefixText: "prefix.",
                suffixIcon: MdiIcons.homeVariant,
              ),
              const ThemedFileInput(
                labelText: "File Input",
              ),
              ThemedTextInput(
                labelText: "Text Input",
                prefixText: "prefix.",
                suffixIcon: MdiIcons.homeVariant,
                dense: true,
              ),
              const ThemedDateTimePicker(
                labelText: "Date Time Picker",
                showTime: true,
              ),
              const ThemedDateTimeRangePicker(
                labelText: "Date Time range Picker",
              ),
              ThemedMultiSelectInput<int>(
                labelText: "MultiSelect Input",
                items: choices,
                value: null,
                onChanged: (value) {
                  setState(() {
                    selected = value.map((e) => e.value!).toList();
                  });
                },
              ),
              ...ThemedCheckboxInputStyle.values.map((style) {
                return ThemedCheckboxInput(
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
              ThemedSelectInput<int>(
                labelText: "Select Input",
                items: choices,
              ),
              ThemedRadioInput<int>(
                labelText: "Radio Input",
                items: choices,
              ),
              ThemedDualListInput(
                labelText: "Dual List Input",
                items: choices,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
