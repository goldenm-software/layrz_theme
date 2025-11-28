part of '../scaffolds.dart';

class ThemedScaffoldCell extends StatelessWidget {
  /// [title] is the title of the cell.
  /// Will be displayed in bold using the [Theme.of(context).textTheme.bodyText1].
  final String title;

  /// [value] is the value of the cell.
  /// Will be displayed using the [Theme.of(context).textTheme.bodyText2].
  final String? value;

  /// [child] is the child of the cell.
  /// Will replace the [value] prop.
  final Widget? child;

  /// [ThemedScaffoldCell] adds the style of a cell to a [Column] widget.
  /// Receives a [title] and a [value] to display.
  const ThemedScaffoldCell({
    super.key,
    required this.title,
    this.value,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 8),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          child ??
              Text(
                value ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
        ],
      ),
    );
  }
}
