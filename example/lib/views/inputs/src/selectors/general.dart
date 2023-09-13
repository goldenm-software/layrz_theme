part of inputs;

class GeneralPickersView extends StatefulWidget {
  const GeneralPickersView({super.key});

  @override
  State<GeneralPickersView> createState() => _GeneralPickersViewState();
}

class _GeneralPickersViewState extends State<GeneralPickersView> {
  List<ThemedSelectItem<int>> get _choices => [
        const ThemedSelectItem(
          value: 1,
          label: "Choice 1",
        ),
        const ThemedSelectItem(
          value: 2,
          label: "Choice 2",
        ),
        const ThemedSelectItem(
          value: 3,
          label: "Choice 3",
        ),
        const ThemedSelectItem(
          value: 4,
          label: "Choice 4",
        ),
        const ThemedSelectItem(
          value: 22,
          label: "Choice 22",
        ),
        const ThemedSelectItem(
          value: 12,
          label: "Choice 12",
        ),
      ];

  List<int> selectedMultiple = [];
  int? selectedSingle;

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "We have a lot of pickers, like file pickers, choices picker (aka, select and multi select "
              "or dropdown), color pickers, etc. See the following examples:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              children: [
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Color picker"),
                    ThemedColorPicker(
                      labelText: "Example label",
                    ),
                  ],
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("File picker"),
                    ThemedFilePicker(
                      labelText: "Example label",
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Select input"),
                    ThemedSelectInput<int>(
                      labelText: "Example label",
                      items: _choices,
                      value: selectedSingle,
                      onChanged: (v) => setState(() => selectedSingle = v?.value),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Multiselect input"),
                    ThemedMultiSelectInput<int>(
                      labelText: "Example label",
                      items: _choices,
                      value: selectedMultiple,
                      onChanged: (v) => setState(() => selectedMultiple = v.map((e) => e.value!).toList()),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("DualList input"),
                    ThemedDualListInput<int>(
                      labelText: "Example label",
                      availableListName: 'Veniam do adipisicing officia nisi. Veniam do adipisicing officia nisi.',
                      items: _choices,
                      value: selectedMultiple,
                      onChanged: (v) => setState(() => selectedMultiple = v.map((e) => e.value!).toList()),
                    ),
                  ],
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Avatar picker"),
                    ThemedAvatarPicker(
                      labelText: "Example label",
                    ),
                  ],
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dynamic Avatar picker"),
                    ThemedDynamicAvatarInput(
                      labelText: "Example label",
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Similar to the text inputs, this widget has a error property",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
