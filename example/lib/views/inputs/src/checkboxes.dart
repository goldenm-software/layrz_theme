part of '../inputs.dart';

class CheckboxesView extends StatefulWidget {
  const CheckboxesView({super.key});

  @override
  State<CheckboxesView> createState() => _CheckboxesViewState();
}

class _CheckboxesViewState extends State<CheckboxesView> {
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
              "\"Classic\"-like checkbox",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            ThemedCheckboxInput(
              value: _value,
              style: ThemedCheckboxInputStyle.asFlutterCheckbox,
              labelText: "Example label",
              onChanged: (val) => setState(() => _value = val),
            ),
            const SizedBox(height: 10),
            Text(
              "But, you can change the design of the checkbox, see the following examples:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              children: [
                ...ThemedCheckboxInputStyle.values.map((style) {
                  return [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Style ${style.name}"),
                        ThemedCheckboxInput(
                          value: _value,
                          labelText: "Style ${style.name}",
                          style: style,
                          hideDetails: true,
                          onChanged: (val) => setState(() => _value = val),
                        ),
                      ],
                    ),
                    if (style == ThemedCheckboxInputStyle.asCheckbox2) ...[
                      Text(
                        "This design was created by our CEO, Orlando Monagas to make a more rounded checkbox, "
                        "like a radio button.",
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                      ),
                    ],
                    const SizedBox(height: 5),
                    const Divider(),
                    const SizedBox(height: 5),
                  ];
                }).expand((element) => element),
              ],
            ),
            Text(
              "Similar to the text inputs, this widget has a error property:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            ThemedCheckboxInput(
              value: _value,
              labelText: "Example label",
              errors: const ["Error 1", "Error 2"],
              onChanged: (val) => setState(() => _value = val),
            ),
          ],
        ),
      ),
    );
  }
}
