part of inputs;

class ThemedFieldDisplayError extends StatelessWidget {
  /// [errors] is the list of errors of the field.
  final List<String> errors;

  /// [hideDetails] is the state of hiding the details of the field.
  final bool hideDetails;

  /// [padding] is the padding of the widget.
  final EdgeInsets padding;

  /// [ThemedFieldDisplayError] is a widget that displays the errors of a field.
  const ThemedFieldDisplayError({
    super.key,
    this.errors = const [],
    this.hideDetails = false,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
  });

  @override
  Widget build(BuildContext context) {
    return hideDetails
        ? const SizedBox()
        : Padding(
            padding: padding,
            child: SizedBox(
              width: double.infinity,
              child: errors.isEmpty
                  ? const SizedBox()
                  : Text(
                      errors.join(', '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red.shade800,
                          ),
                    ),
            ),
          );
  }
}
