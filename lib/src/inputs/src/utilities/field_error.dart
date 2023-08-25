part of inputs;

class ThemedFieldDisplayError extends StatelessWidget {
  final List<String> errors;
  final bool hideDetails;

  /// [ThemedFieldDisplayError] is a widget that displays the errors of a field.
  const ThemedFieldDisplayError({
    super.key,

    /// [errors] is the list of errors of the field.
    this.errors = const [],

    /// [hideDetails] is the state of hiding the details of the field.
    this.hideDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return hideDetails
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
