part of '../inputs.dart';

class RadioButtonsView extends StatefulWidget {
  const RadioButtonsView({super.key});

  @override
  State<RadioButtonsView> createState() => _RadioButtonsViewState();
}

class _RadioButtonsViewState extends State<RadioButtonsView> {
  // ignore: prefer_final_fields
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Radio buttons",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            ThemedRadioInput(
              value: _value,
              labelText: "Example label",
              items: const [
                ThemedSelectItem(
                  value: 1,
                  label: "Choice 1",
                ),
                ThemedSelectItem(
                  value: 2,
                  label: "Choice 2",
                ),
                ThemedSelectItem(
                  value: 3,
                  label: "Choice 3",
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Similar to the text inputs, this widget has a error property:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ThemedRadioInput(
              value: _value,
              labelText: "Example label",
              errors: const ["Example error"],
              items: const [
                ThemedSelectItem(
                  value: 1,
                  label: "Choice 1",
                ),
                ThemedSelectItem(
                  value: 2,
                  label: "Choice 2",
                ),
                ThemedSelectItem(
                  value: 3,
                  label: "Choice 3",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
