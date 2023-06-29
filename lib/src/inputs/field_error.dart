part of layrz_theme;

class ThemedFieldDisplayError extends StatelessWidget {
  final List<String> errors;
  final bool hideDetails;

  const ThemedFieldDisplayError({
    Key? key,
    this.errors = const [],
    this.hideDetails = false,
  }) : super(key: key);

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
