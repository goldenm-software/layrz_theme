part of '../../inputs.dart';

class ThemedPasswordInput extends StatefulWidget {
  /// [labelText] is the text of the label of the input.
  final String? labelText;

  /// [label] is the widget of the label of the input.
  final Widget? label;

  /// [placeholder] is the placeholder of the input.
  final String? placeholder;

  /// [onChanged] is the callback function when the input is changed.
  final ValueChanged<String>? onChanged;

  /// [value] is the value of the input.
  final String? value;

  /// [disabled] is the state of the input being disabled.
  final bool disabled;

  /// [errors] is the list of errors of the input.
  final List<String> errors;

  /// [hideDetails] is the state of the input to hide the details.
  final bool hideDetails;

  /// [padding] is the padding of the input.
  final EdgeInsets? padding;

  /// [isRequired] is the state of the input being required.
  final bool isRequired;

  /// [onSubmitted] is the callback function when the input is submitted.
  final VoidCallback? onSubmitted;

  /// [borderRadius] is the border radius of the input.
  final double? borderRadius;

  /// [focusNode] is the focus node of the input.
  final FocusNode? focusNode;

  /// [controller] is the text editing controller of the input.
  final TextEditingController? controller;

  /// [showLevels] is the state of the input to show the strength levels of the password.
  /// If true, the input will show a linear progress indicator that fills up based on the strength of the password.
  /// The strength is calculated based on the requirements and levels defined in the input.
  /// The progress indicator will fill up to 25% for each requirement met and for each level reached.
  final bool showLevels;

  /// [ThemedPasswordInput] is the constructor of the input.
  /// Simplifies (I hope so) the creation of an input using the standard format of Layrz.
  const ThemedPasswordInput({
    super.key,
    this.labelText,
    this.label,
    this.placeholder,
    this.disabled = false,
    this.onChanged,
    this.value,
    this.errors = const [],
    this.hideDetails = false,
    this.padding,
    this.isRequired = false,
    this.onSubmitted,
    this.borderRadius,
    this.focusNode,
    this.controller,
    this.showLevels = true,
  }) : assert(
         (label == null && labelText != null) || (label != null && labelText == null),
         'You must provide either a labelText or a label, but not both.',
       );

  @override
  State<ThemedPasswordInput> createState() => _ThemedPasswordInputState();
}

class _ThemedPasswordInputState extends State<ThemedPasswordInput> {
  bool _showPassword = false;

  /// [requirements] is the list of regular expressions that define the requirements for a valid password.
  Map<RegExp, String> get requirements => {
    RegExp(r'[a-z]'): 'password.requirements.lowercase.letter',
    RegExp(r'[A-Z]'): 'password.requirements.uppercase.letter',
    RegExp(r'[0-9]'): 'password.requirements.digit',
    RegExp(
      r'[!@#$%^&*()_\-+=\[\]{};:'
      "'"
      r'",.<>/?`~|\\]',
    ): 'password.requirements.special.character',
  };

  /// [allowed] is the regular expression that defines the allowed characters in the password.
  RegExp get allowed => RegExp(
    r'^[A-Za-z\d!@#$%^&*()_\-+=\[\]{};:'
    "'"
    r'",.<>/?`~|\\]+$',
  );

  /// [_matches] is the list of regular expressions that match the requirements met by the current password value.
  Map<String, bool> get _matches {
    final matches = <String, bool>{};
    for (final requirement in requirements.keys) {
      matches[requirements[requirement]!] = requirement.hasMatch(widget.value ?? '');
    }
    return matches;
  }

  /// [_isValid] is the state of the password being valid based on the requirements and allowed characters.
  bool get _isValid {
    if (widget.value == null || widget.value!.isEmpty) return false;
    if (!allowed.hasMatch(widget.value!)) return false;
    for (final requirement in _matches.values) {
      if (!requirement) return false;
    }
    return true;
  }

  /// [_level] is the current strength level of the password.
  int get _level {
    if (!_isValid) return 0;
    if (widget.value == null) return 0;
    final length = widget.value!.length;
    if (length < 8) return 0;
    if (length < 12) return 1;
    if (length < 16) return 2;
    if (length < 20) return 3;
    return 4;
  }

  /// [_color] is the color of the progress indicator based on the current strength level of the password.
  Color get _color {
    switch (_level) {
      case 0:
        return Colors.red;
      case 1:
      case 2:
        return Colors.orange;
      case 3:
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// [_icon] is the icon of the progress indicator based on the current strength level of the password.
  IconData get _icon {
    if (!_isValid) return LayrzIcons.solarOutlineCloseCircle;
    return LayrzIcons.solarOutlineShieldCheck;
  }

  @override
  Widget build(BuildContext context) {
    return ThemedTextInput(
      controller: widget.controller,
      focusNode: widget.focusNode,
      value: widget.value,
      labelText: widget.labelText,
      label: widget.label,
      disabled: widget.disabled,
      placeholder: widget.placeholder,
      hideDetails: widget.hideDetails,
      errors: widget.errors,
      padding: widget.padding,
      isRequired: widget.isRequired,
      obscureText: !_showPassword,
      suffixWidget: Row(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        spacing: 10,
        children: [
          if (widget.showLevels) ...[
            Tooltip(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              richMessage: TextSpan(
                children: [
                  for (final requirement in requirements.keys) ...[
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _matches[requirements[requirement]!]!
                                  ? LayrzIcons.solarOutlineCheckCircle
                                  : LayrzIcons.solarOutlineCloseCircle,
                              size: 16,
                              color: _matches[requirements[requirement]!]! ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _translate(requirements[requirement]!),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: validateColor(color: Theme.of(context).scaffoldBackgroundColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const TextSpan(text: '\n'),
                  ],
                  // Add a final level indicator
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _icon,
                            size: 16,
                            color: _color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${_translate('password.strength.level')}: ${widget.value?.length ?? 0}",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: validateColor(color: Theme.of(context).scaffoldBackgroundColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              child: Icon(
                _icon,
                size: 20,
                color: _color,
              ),
            ),
            SizedBox(
              width: 1,
              height: 30,
              child: const VerticalDivider(),
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _showPassword = !_showPassword),
              child: Icon(
                _showPassword ? LayrzIcons.mdiEyeOffOutline : LayrzIcons.mdiEyeOutline,
                size: 20,
                color: Theme.of(context).inputDecorationTheme.suffixIconColor,
              ),
            ),
          ),
        ],
      ),
      onChanged: (value) => widget.onChanged?.call(value),
      onSubmitted: widget.onSubmitted,
    );
  }

  String _translate(String key) {
    final i18n = LayrzAppLocalizations.maybeOf(context);
    if (i18n != null && i18n.hasTranslation(key)) return i18n.t(key);

    switch (key) {
      case 'password.requirements.lowercase.letter':
        return 'At least one lowercase letter';
      case 'password.requirements.uppercase.letter':
        return 'At least one uppercase letter';
      case 'password.requirements.digit':
        return 'At least one digit';
      case 'password.requirements.special.character':
        return 'At least one special character';
      case 'password.strength.level':
        return 'Password Length';
      default:
        return key;
    }
  }
}
