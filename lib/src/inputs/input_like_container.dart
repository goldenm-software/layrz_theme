part of inputs;

class ThemedInputLikeContainer extends StatelessWidget {
  /// A list of errors to display
  final List<String> errors;

  /// The child widget
  final Widget child;

  /// The label text
  final String? labelText;

  /// The label widget
  final Widget? label;

  /// The suffix icon
  final Widget? suffixIcon;

  /// The prefix icon
  final Widget? prefixIcon;

  final EdgeInsets padding;

  /// A container widget that looks like an input
  /// but it is not an input
  ///
  /// and can have any widget as a child
  ///
  const ThemedInputLikeContainer({
    super.key,
    this.errors = const [],
    required this.child,
    this.labelText,
    this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.padding = const EdgeInsets.all(10.0),
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  Widget build(BuildContext context) {
    Widget inputLabel = label ??
        Text(
          labelText ?? "",
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
          ),
        );
    InputDecoration decoration = InputDecoration(
      label: inputLabel,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    );
    if (errors.isNotEmpty) {
      decoration = decoration.copyWith(
        errorText: errors.join(", "),
        errorMaxLines: 3,
      );
    }
    return Padding(
      padding: padding,
      child: InputDecorator(
        decoration: decoration,
        child: child,
      ),
    );
  }
}
