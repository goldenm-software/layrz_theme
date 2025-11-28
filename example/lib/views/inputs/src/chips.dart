part of '../inputs.dart';

class ChipsView extends StatefulWidget {
  const ChipsView({super.key});

  @override
  State<ChipsView> createState() => _ChipsViewState();
}

class _ChipsViewState extends State<ChipsView> {
  double width = 300;
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: SizedBox(
          width: .infinity,
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .start,
            spacing: 10,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: .middle,
                      child: ThemedChip(labelText: 'Chips'),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: 'everywhere!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: .bold),
                    ),
                  ],
                ),
              ),
              Text(
                "Chips are a great way to display information in a compact way. "
                "They can be used to display tags, categories, or any other type of information that "
                "can be represented in a small space.",
              ),
              Text("We provide ThemedChip with an standarized styling, such as:"),
              for (final style in ThemedChipStyle.values) ...[
                ThemedChip(
                  labelText: 'This is a ${style.name} chip',
                  color: Colors.purple,
                  style: style,
                ),
              ],
              Text("All of the ThemedChip's can support dismissable property, if you want to add a remove icon."),
              for (final style in ThemedChipStyle.values) ...[
                ThemedChip(
                  labelText: 'This is a dismissable ${style.name} chip',
                  color: Colors.orange,
                  style: style,
                  onDismiss: () {
                    ThemedSnackbarMessenger.of(context).showSnackbar(
                      ThemedSnackbar(message: 'Dismissed a ${style.name} chip!'),
                    );
                  },
                ),
              ],
              Text("You can add an icon to the leading side, like this:"),
              ThemedChip(
                labelText: 'Chip with leading icon',
                color: Colors.indigo,
                leadingIcon: LayrzIcons.solarOutlinePlain3,
              ),
              Text("Or, it can be customized with padding and border radius:"),
              ThemedChip(
                labelText: 'Customized padding and border radius',
                color: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                borderRadius: 20,
              ),
              Text("And finally, can be grouped, it means that you can display multiple chips in a row:"),
              ThemedChipGroup(
                alignment: .center,
                chips: [
                  ThemedChip(
                    labelText: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                    color: Colors.blue,
                  ),
                  ThemedChip(
                    labelText: 'Chip 2',
                    color: Colors.green,
                  ),
                  ThemedChip(
                    labelText: 'Chip 3',
                    color: Colors.red,
                    // padding: const EdgeInsets.all(20),
                  ),
                  ThemedChip(
                    labelText: 'Chip 4',
                    color: Colors.purple,
                  ),
                  ThemedChip(
                    labelText: 'Chip 5',
                    color: Colors.orange,
                  ),
                ],
                behavior: ThemedChipGroupBehavior.scrollable,
              ),
              Text("Or, clamp the width to the available space:"),
              Text(
                "For this scenario, we used ConstrainedBox to limit the width of the chip group, you can see that"
                " when there are too many chips to fit in the available space, it will show a '+N' chip indicating"
                " how many chips are hidden.",
              ),
              ThemedNumberInput(
                labelText: 'Max Width',
                value: width,
                minimum: 100,
                step: 10,
                onChanged: (value) {
                  setState(() {
                    width = value?.toDouble() ?? 300;
                  });
                },
              ),
              Align(
                alignment: .centerRight,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  constraints: BoxConstraints(maxWidth: width),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 1),
                  ),
                  child: ThemedChipGroup(
                    alignment: .centerRight,
                    chips: List.generate(10, (index) {
                      return ThemedChip(
                        labelText: 'Chip $index',
                        leadingIcon: LayrzIcons.solarOutlinePlain3,
                        color: Colors.blue,
                      );
                    }),
                    behavior: ThemedChipGroupBehavior.clampWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
