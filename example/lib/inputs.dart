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
  List<int> selected = [];
  Duration? durationValue = const Duration(
    days: 0,
    seconds: 0,
    minutes: 0,
    hours: 0,
  );
  List<ThemedSelectItem<int>> get choices => List.generate(10, (index) {
        return ThemedSelectItem<int>(
          value: index,
          icon: index % 2 == 0 ? MdiIcons.homeVariant : null,
          label: "Choice $index un papá, un niño",
        );
      });

  bool value = false;

  String textInputValue = "";

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
              const ThemedWipDatePicker(
                labelText: "WIP Date Picker",
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
              ThemedTextInput(
                labelText: 'Text Input',
                value: textInputValue,
                onChanged: (value) {
                  setState(() {
                    textInputValue = value;
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
