part of '../new_table.dart';

class ThemedTableToolbar extends StatelessWidget {
  final List<Widget> additionalButtons;
  final String labelText;
  final String search;
  final void Function(String) onSearch;
  final int itemCount;
  const ThemedTableToolbar({
    required this.labelText,
    required this.search,
    required this.onSearch,
    required this.itemCount,
    super.key,
    this.additionalButtons = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Expanded(
          child: Text(
            "$labelText ($itemCount)",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ThemedSearchInput(
          value: search,
          onSearch: onSearch,
          asField: true,
        ),
        ...additionalButtons,
      ],
    );
  }
}
