part of layrz_theme;

class ThemedScaffoldCell extends StatelessWidget {
  /// [title] is the title of the cell.
  /// Will be displayed in bold using the [Theme.of(context).textTheme.bodyText1].
  final String title;

  /// [value] is the value of the cell.
  /// Will be displayed using the [Theme.of(context).textTheme.bodyText2].
  final String value;

  /// [ThemedScaffoldCell] adds the style of a cell to a [Column] widget.
  /// Receives a [title] and a [value] to display.
  const ThemedScaffoldCell({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
