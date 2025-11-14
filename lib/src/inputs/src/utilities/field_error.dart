part of '../../inputs.dart';

class ThemedFieldDisplayError extends StatelessWidget {
  /// [errors] is the list of errors of the field.
  final List<String> errors;

  /// [hideDetails] is the state of hiding the details of the field.
  final bool hideDetails;

  /// [padding] is the padding of the widget.
  final EdgeInsets padding;

  /// [maxLines] defines the maximum number of lines the text can have.
  final int maxLines;

  /// [ThemedFieldDisplayError] is a widget that displays the errors of a field.
  const ThemedFieldDisplayError({
    super.key,
    this.errors = const [],
    this.hideDetails = false,
    this.padding = const .symmetric(vertical: 10, horizontal: 5),
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return hideDetails
        ? const SizedBox()
        : Padding(
            padding: padding,
            child: SizedBox(
              width: .infinity,
              child: errors.isEmpty
                  ? const SizedBox()
                  : Text(
                      errors.join(', '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
                      maxLines: maxLines,
                    ),
            ),
          );
  }
}
