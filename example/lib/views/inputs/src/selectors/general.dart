part of '../../inputs.dart';

class GeneralPickersView extends StatefulWidget {
  const GeneralPickersView({super.key});

  @override
  State<GeneralPickersView> createState() => _GeneralPickersViewState();
}

class _GeneralPickersViewState extends State<GeneralPickersView> {
  List<ThemedSelectItem<int>> get _choices => List.generate(3, (i) {
    return ThemedSelectItem(
      value: i + 1,
      label: "Choice ${i + 1}",
      // content: Row(
      //   children: [
      //     drawAvatar(context: context),
      //     const SizedBox(width: 10),
      //     Text("Choice ${i + 1}"),
      //   ],
      // ),
    );
  });

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
                    Text('Select input Current value: $selectedSingle'),
                    ThemedSelectInput<int>(
                      labelText: "Example label",
                      items: _choices,
                      value: selectedSingle,
                      onChanged: (v) => setState(() => selectedSingle = v?.value),
                    ),
                    ThemedSelectInput<int>(
                      labelText: "2nd Example label",
                      autoclose: false,
                      returnNullOnClose: true,
                      items: _choices,
                      value: selectedSingle,
                      onChanged: (v) {
                        setState(() => selectedSingle = v?.value);
                      },
                    ),
                    ThemedSelectInput<int>(
                      labelText: "3rd Example label without onChanged",
                      autoclose: false,
                      returnNullOnClose: true,
                      items: _choices,
                      value: selectedSingle,
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Dynamic Avatar picker"),
                    ThemedDynamicAvatarInput(
                      labelText: "Example label",
                      onChanged: (newVal) {
                        debugPrint("New type: ${newVal?.type}");
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Icon picker"),
                    ThemedIconPicker(
                      labelText: "Example label",
                      onChanged: (newVal) {
                        debugPrint("New type: $newVal");
                      },
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
