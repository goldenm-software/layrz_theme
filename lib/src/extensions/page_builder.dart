part of layrz_theme;

class ThemedPageTransition extends PageRouteBuilder {
  final Widget page;

  @override
  final RouteSettings settings;

  ThemedPageTransition({required this.page, required this.settings})
      : super(
          settings: settings,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return page;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
