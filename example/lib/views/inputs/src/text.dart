part of '../inputs.dart';

class TextInputView extends StatefulWidget {
  const TextInputView({super.key});

  @override
  State<TextInputView> createState() => _TextInputViewState();
}

class _TextInputViewState extends State<TextInputView> {
  num? _value = 0;
  String? _text;
  Duration? _dur = const Duration();
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Basic text input",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            ThemedButton(
              labelText: "Set value to 123456",
              onTap: () {
                setState(() => _text = "123456");
              },
            ),
            ThemedTextInput(
              labelText: "Example label",
              value: _text,
              onChanged: (value) {
                debugPrint("Value: $value");
                setState(() => _text = value);
              },
            ),
            ThemedTextInput(
              labelText: "2nd Example label showing shared state",
              value: _text,
              onChanged: (value) {
                debugPrint("Value: $value");
                setState(() => _text = value);
              },
            ),
            const SizedBox(height: 10),
            Text(
              "But, that's not all, you can also personalize it, see the following examples:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("With a prefix and suffix icon"),
                    ThemedTextInput(
                      labelText: "Example label",
                      prefixIcon: MdiIcons.accessPoint,
                      suffixIcon: MdiIcons.accessPoint,
                    ),
                  ],
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("With a placeholder"),
                    ThemedTextInput(
                      labelText: "Example label",
                      placeholder: "Example placeholder",
                      textStyle: TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("With errors"),
                    ThemedTextInput(
                      labelText: "Example label",
                      errors: ["Error 1", "Error 2"],
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("As a combobox"),
                    const ThemedTextInput(
                      labelText: "Example label",
                      choices: ["Choice 1", "Choice 2", "Choice 3"],
                      enableCombobox: true,
                    ),
                    Text(
                      "Warning, this combobox changes the direction using the property position, "
                      "so is possible that you cannot see the complete overlay if you use it in a small "
                      "screen and/or positioned your scroll near to the bottom of the screen.",
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 3,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "But, you can also use ThemedNumberInput to handle numbers easly, like the following example:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            ThemedNumberInput(
              labelText: "Example label",
              value: _value,
              decimalSeparator: ThemedDecimalSeparator.dot,
              onChanged: (value) {
                debugPrint("Value: $value");
                setState(() => _value = value);
              },
            ),
            const SizedBox(height: 10),
            Text(
              "Or handle durations, to do that, you can use ThemedDurationInput to handle easly, "
              "like the following example:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            ThemedDurationInput(
              labelText: "Example label",
              value: _dur,
              onChanged: (value) => setState(() => _dur = value),
            ),
          ],
        ),
      ),
    );
  }
}
