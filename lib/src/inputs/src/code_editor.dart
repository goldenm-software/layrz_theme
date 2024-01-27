part of '../inputs.dart';

class ThemedCodeEditor extends StatefulWidget {
  /// Is the label of the field, you should use or [label] or [labelText] but not both. Also, [labelText] helps you
  /// to handle dark mode or related things
  final String? labelText;

  /// Is the label of the field, you should use or [label] or [labelText] but not both. Also, [labelText] helps you
  /// to handle dark mode or related things
  final Widget? label;

  /// [onChanged] is the function that will be called when the text changes
  final void Function(String)? onChanged;

  /// The [value] of the text field
  /// If you don't provide a value, the widget will create one for you.
  /// Important: Is you perform changes on the value of this field, consider using the controller, because when the
  /// widget is build again, the value will not propagate to internal variables.
  final String? value;

  /// [disabled] indicates if the field is disabled or not
  final bool disabled;

  /// [errors] is the list of strings with the errors of the field
  final List<String> errors;

  /// [padding] is the padding of the field
  final EdgeInsets padding;

  /// The [focusNode] of the field
  /// If you don't provide a focus node, the widget will create one for you.
  final FocusNode? focusNode;

  /// [onSubmitted]  is the function that will be called when the user submits the field
  /// This is useful when you want to perform an action when the user press enter.
  final VoidCallback? onSubmitted;

  /// [language] is the language of the editor
  final LayrzSupportedLanguage language;

  /// [constraints] is the constraints of the editor
  final BoxConstraints? constraints;

  /// [lintErrors] is the list of errors of the editor
  final List<LintError> lintErrors;

  /// [i18n] is the i18n of the editor
  final LayrzAppLocalizations? i18n;

  /// [customInsers] is a list of Strings to add a shurtcut to insert them in the editor
  final List<String> customInserts;

  const ThemedCodeEditor({
    super.key,
    this.labelText,
    this.label,
    this.onChanged,
    this.value,
    this.disabled = false,
    this.errors = const [],
    this.padding = const EdgeInsets.all(10),
    this.focusNode,
    this.onSubmitted,
    this.language = LayrzSupportedLanguage.lcl,
    this.constraints,
    this.lintErrors = const [],
    this.i18n,
    this.customInserts = const [],
  });

  @override
  State<ThemedCodeEditor> createState() => _ThemedCodeEditorState();
}

class _ThemedCodeEditorState extends State<ThemedCodeEditor> {
  late CodeController controller;
  String _value = '';

  Mode get _language {
    switch (widget.language) {
      case LayrzSupportedLanguage.lml:
        return lml.lml;
      case LayrzSupportedLanguage.lcl:
        return lcl.lcl;
      case LayrzSupportedLanguage.mjml:
        return mjml.mjml;
      case LayrzSupportedLanguage.python:
        return python.python;
      default:
        return Mode();
    }
  }

  Map<String, TextStyle> get _theme {
    switch (widget.language) {
      case LayrzSupportedLanguage.lml:
        return lml.theme;
      case LayrzSupportedLanguage.lcl:
        return lcl.theme;
      case LayrzSupportedLanguage.mjml:
        return mjml.theme;
      case LayrzSupportedLanguage.python:
        return python.theme;
      default:
        return const {
          'root': TextStyle(backgroundColor: Color(0xff1a1a1a), color: Color(0xffecf0f1)),
        };
    }
  }

  AbstractAnalyzer get _analyzer {
    switch (widget.language) {
      case LayrzSupportedLanguage.lml:
        return lml.LmlAnalizer();
      case LayrzSupportedLanguage.lcl:
        return lcl.LclAnalizer();
      case LayrzSupportedLanguage.mjml:
        return mjml.MjmlAnalizer();
      case LayrzSupportedLanguage.python:
        return python.PythonAnalizer();
      default:
        return EmptyAnalyzer();
    }
  }

  Color? get backgroundColor => _theme['root']!.backgroundColor;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? '';
    controller = CodeController(
      text: _value,
      language: _language,
      analyzer: _analyzer,
    );
  }

  @override
  void didUpdateWidget(ThemedCodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.setLanguage(_language, analyzer: _analyzer);

    if (widget.value != null && widget.value != oldWidget.value) {
      _value = widget.value ?? '';
      controller.text = _value;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: generateContainerElevation(context: context, color: backgroundColor, elevation: 2),
        child: ConstrainedBox(
          constraints: widget.constraints ?? const BoxConstraints(maxHeight: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: widget.label ??
                    Text(
                      widget.labelText ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: validateColor(color: backgroundColor ?? Colors.black),
                            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                          ),
                    ),
              ),
              Divider(
                color: validateColor(color: backgroundColor ?? Colors.black).withOpacity(0.2),
                indent: 10,
                endIndent: 10,
              ),
              Theme(
                data: ThemeData.dark().copyWith(
                  textTheme: GoogleFonts.jetBrainsMonoTextTheme(),
                ),
                child: CodeTheme(
                  data: CodeThemeData(styles: _theme),
                  child: Expanded(
                    child: CodeField(
                        controller: controller,
                        onChanged: (value) {
                          widget.onChanged?.call(value);
                          setState(() => _value = value);
                        }),
                  ),
                ),
              ),
              ThemedFieldDisplayError(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                errors: widget.errors +
                    widget.lintErrors.map<String>((error) {
                      String err = t(
                        'larzLanguage.errors.${error.code}',
                        {
                          'function': error.function,
                          'element': error.element,
                          'required': error.req,
                          'given': error.given,
                        },
                      );
                      return "${error.line ?? 1}: $err";
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String t(String key, [Map<String, dynamic> args = const {}]) {
    return widget.i18n?.t(key, args) ?? "I18n missing $key";
  }
}

enum LayrzSupportedLanguage {
  /// Python v3.10 language support for Sensors, Triggers, Reports and Charts.
  python,

  /// LCL or Layrz Compute Language support for Sensors and Triggers.
  lcl,

  /// LML or Layrz Markup Language support for Operations.
  lml,

  /// TXT or Plain text
  txt,

  /// MJML or MailJet Markup Language support for Emails.
  mjml,
  ;
}

class EmptyAnalyzer extends AbstractAnalyzer {
  @override
  Future<AnalysisResult> analyze(Code code) async {
    return const AnalysisResult(issues: []);
  }
}
