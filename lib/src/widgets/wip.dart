part of layrz_theme;

class WorkInProgressView extends StatelessWidget {
  /// [WorkInProgressView] is a helper view to display "Work in progress"
  const WorkInProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(MdiIcons.accountHardHat, size: 60),
        Text(
          'Work in progress',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
