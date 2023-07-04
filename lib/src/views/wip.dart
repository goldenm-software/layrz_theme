part of layrz_theme;

/// [WorkInProgressView] is a helper view to display "Work in progress"
class WorkInProgressView extends StatelessWidget {
  const WorkInProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(MdiIcons.accountHardHat, size: 60),
          Text('Work in progress', style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}
