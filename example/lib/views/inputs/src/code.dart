part of '../inputs.dart';

class CodeInputView extends StatefulWidget {
  const CodeInputView({super.key});

  @override
  State<CodeInputView> createState() => _CodeInputViewState();
}

class _CodeInputViewState extends State<CodeInputView> {
  List<String> get _errors => [];
  String _lclCode = "CONSTANT(True)";
  String _pythonCode = "def test():\n\treturn 10 >= 20";

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
                    value: _pythonCode,
                    errors: _errors,
                    onLintTap: (code) async {
                      debugPrint("Code linted $code");

                      return [
                        const ThemedCodeError(line: 1, code: 'Holiwis', name: 'GET_PARAM'),
                        const ThemedCodeError(line: 1, code: 'Holiwis', name: 'GET_PARAM'),
                        const ThemedCodeError(line: 1, code: 'Holiwis', name: 'GET_PARAM'),
                        const ThemedCodeError(line: 1, code: 'Holiwis', name: 'GET_PARAM'),
                        const ThemedCodeError(line: 1, code: 'Holiwis', name: 'GET_PARAM'),
                        const ThemedCodeError(line: 1, code: 'Holiwis', name: 'GET_PARAM'),
                        const ThemedCodeError(line: 1, code: 'Holiwis', name: 'GET_PARAM'),
                      ];
                    },
                    onRunTap: (code) async {
                      debugPrint("Code run $code");

                      return "15";
                    },
                    onChanged: (val) {
                      debugPrint("Code: $val");
                      setState(() => _pythonCode = val);
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
                    value: _lclCode,
                    errors: _errors,
                    onChanged: (val) => setState(() => _lclCode = val),
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
                    disabled: true,
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
