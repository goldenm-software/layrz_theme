part of '../inputs.dart';

class CodeInputView extends StatefulWidget {
  const CodeInputView({super.key});

  @override
  State<CodeInputView> createState() => _CodeInputViewState();
}

class _CodeInputViewState extends State<CodeInputView> {
  List<String> get _errors => ['Error 1', 'Error 2', 'Error 3'];

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Code editor input",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            ResponsiveRow(
              children: [
                ResponsiveCol(
                  xs: Sizes.col12,
                  md: Sizes.col6,
                  child: ThemedCodeEditor(
                    labelText: "Python example",
                    language: LayrzSupportedLanguage.python,
                    value: "10 + 10",
                    errors: _errors,
                    onChanged: (val) {
                      debugPrint("Code: $val");
                    },
                  ),
                ),
                ResponsiveCol(
                  xs: Sizes.col12,
                  md: Sizes.col6,
                  child: ThemedCodeEditor(
                    labelText: "Plain text example",
                    language: LayrzSupportedLanguage.txt,
                    value: "Test text",
                    errors: _errors,
                    onChanged: (val) {
                      debugPrint("Code: $val");
                    },
                  ),
                ),
                ResponsiveCol(
                  xs: Sizes.col12,
                  md: Sizes.col6,
                  child: ThemedCodeEditor(
                    labelText: "LCL example",
                    language: LayrzSupportedLanguage.lcl,
                    value: "CONSTANT(True)",
                    errors: _errors,
                    onChanged: (val) {
                      debugPrint("Code: $val");
                    },
                  ),
                ),
                ResponsiveCol(
                  xs: Sizes.col12,
                  md: Sizes.col6,
                  child: ThemedCodeEditor(
                    labelText: "LML example",
                    language: LayrzSupportedLanguage.lml,
                    value: "Positive of {{assetName}} at {{assetPositionLatitude}}",
                    errors: _errors,
                    onChanged: (val) {
                      debugPrint("Code: $val");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
