part of '../../inputs.dart';

class ThemedInputLikeContainer extends StatelessWidget {
  /// [errors] is a list of errors to display
  final List<String> errors;

  /// [child] is the child widget
  final Widget child;

  /// [labelText] is the label text
  final String? labelText;

  /// [label] is the label widget
  final Widget? label;

  /// [suffixIcon] is the suffix icon
  final Widget? suffixIcon;

  /// [prefixIcon] is the prefix icon
  final Widget? prefixIcon;

  /// [padding] is the padding of the container
  final EdgeInsets padding;

  /// [ThemedInputLikeContainer] is a container widget that looks like an input
  /// but it is not an input and can have any widget as a child
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
