part of '../inputs.dart';

class TextInputView extends StatefulWidget {
  const TextInputView({super.key});

  @override
  State<TextInputView> createState() => _TextInputViewState();
}

class _TextInputViewState extends State<TextInputView> {
  num? _value;
  num? _temperature;
  num? _price;
  num? _rating;
  num? _clamped;
  num? _stepped;
  String? _text;
  String _password = "Abc123!@#";
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
                      prefixIcon: LayrzIcons.mdiAccessPoint,
                      suffixIcon: LayrzIcons.mdiAccessPoint,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("With a placeholder"),
                    ThemedTextInput(
                      labelText: "Example label",
                      placeholder: "Example placeholder",
                      textStyle: TextStyle(color: Colors.purple),
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final regex = RegExp(r'^\d+\,?\d*$');
                          if (newValue.text.isEmpty) {
                            return newValue;
                          }
                          if (regex.hasMatch(newValue.text)) {
                            return newValue;
                          }
                          return oldValue;
                        }),
                      ],
                    ),
                    Text(r"With a Regex formater ^\d+\,?\d*$"),
                    ThemedTextInput(
                      labelText: "Example label",
                      placeholder: "Example placeholder",
                      textStyle: TextStyle(color: Colors.purple),
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final regex = RegExp(r'^\d+\,?\d*$');
                          if (newValue.text.isEmpty) {
                            return newValue;
                          }
                          if (regex.hasMatch(newValue.text)) {
                            return newValue;
                          }
                          return oldValue;
                        }),
                      ],
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
              "ThemedNumberInput",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "A number input with built-in formatting, step controls, and min/max constraints.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            const Divider(),

            // Basic usage
            Text("Basic usage", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              "Current value: ${_value ?? 'null'}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            ThemedNumberInput(
              labelText: "A simple number",
              value: _value,
              onChanged: (value) => setState(() => _value = value),
            ),
            const SizedBox(height: 10),

            // Prefix / suffix text
            Text(
              "With prefix and suffix text",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Use prefixText and suffixText to add units or currency symbols.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            ThemedNumberInput(
              labelText: "Price (USD)",
              value: _price,
              prefixText: '\$',
              maximumDecimalDigits: 2,
              onChanged: (value) => setState(() => _price = value),
            ),
            ThemedNumberInput(
              labelText: "Temperature",
              value: _temperature,
              suffixText: '°C',
              maximumDecimalDigits: 1,
              onChanged: (value) => setState(() => _temperature = value),
            ),
            const SizedBox(height: 10),

            // Decimal separators
            Text(
              "Decimal separators",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Use ThemedDecimalSeparator.dot (default) or .comma for European-style formatting.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            ThemedNumberInput(
              labelText: "Dot separator  (1,234.56)",
              value: _value,
              decimalSeparator: ThemedDecimalSeparator.dot,
              maximumDecimalDigits: 4,
              onChanged: (value) => setState(() => _value = value),
            ),
            ThemedNumberInput(
              labelText: "Comma separator  (1.234,56)",
              value: _value,
              decimalSeparator: ThemedDecimalSeparator.comma,
              maximumDecimalDigits: 4,
              onChanged: (value) => setState(() => _value = value),
            ),
            const SizedBox(height: 10),

            // Step controls with min/max
            Text(
              "Step controls + min/max constraints",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "The − and + buttons respect minimum and maximum. Notice how they disable at the boundaries.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            ThemedNumberInput(
              labelText: "Rating (0–10, step 1)",
              value: _rating,
              minimum: 0,
              maximum: 10,
              step: 1,
              onChanged: (value) => setState(() => _rating = value),
            ),
            ThemedNumberInput(
              labelText: "Clamped (−50 to 50, step 5)",
              value: _clamped,
              minimum: -50,
              maximum: 50,
              step: 5,
              onChanged: (value) => setState(() => _clamped = value),
            ),
            ThemedNumberInput(
              labelText: "Fine step (step 0.1)",
              value: _stepped,
              minimum: 0,
              maximum: 1,
              step: 0.1,
              maximumDecimalDigits: 1,
              onChanged: (value) => setState(() => _stepped = value),
            ),
            const SizedBox(height: 10),

            // Dense + disabled + errors
            Text(
              "Dense, disabled & validation errors",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ThemedNumberInput(
              labelText: "Dense mode",
              value: _value,
              dense: true,
              onChanged: (value) => setState(() => _value = value),
            ),
            ThemedNumberInput(
              labelText: "Disabled",
              value: 42,
              disabled: true,
              onChanged: null,
            ),
            ThemedNumberInput(
              labelText: "With validation error",
              value: _value,
              errors: const ["Value must be positive"],
              onChanged: (value) => setState(() => _value = value),
            ),
            ThemedNumberInput(
              labelText: "hideDetails: true (no error space)",
              value: _value,
              hideDetails: true,
              errors: const ["Hidden error"],
              onChanged: (value) => setState(() => _value = value),
            ),
            const SizedBox(height: 10),

            // isRequired
            Text(
              "Required field",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Use isRequired: true to show the * indicator.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            ThemedNumberInput(
              labelText: "Quantity",
              value: _value,
              isRequired: true,
              onChanged: (value) => setState(() => _value = value),
            ),
            const SizedBox(height: 10),

            // hidePrefixSuffixActions
            Text(
              "Hide step actions",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "hidePrefixSuffixActions removes the − / + buttons entirely. Useful when you only want free-form input.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            ThemedNumberInput(
              labelText: "No step buttons",
              value: _value,
              hidePrefixSuffixActions: true,
              onChanged: (value) => setState(() => _value = value),
            ),
            const SizedBox(height: 10),
            const Divider(),
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
            const SizedBox(height: 10),
            Text(
              "Finally, you can also use ThemedPasswordInput to handle passwords easly, like the following example:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ThemedPasswordInput(
              labelText: "Password field",
              value: _password,
              onChanged: (value) {
                debugPrint("Value: $value");
                setState(() => _password = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
