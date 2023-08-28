part of layrz_theme;

class ThemedPageTransition extends PageRouteBuilder {
  /// [page] is the widget to be shown.
  final Widget page;

  /// [settings] is the settings for the route.
  @override
  final RouteSettings settings;

  /// Creates a [PageRoute] that uses a fade transition.
  /// If you want to return something, use [ThemedPageBuilder] instead.
  ThemedPageTransition({
    required this.page,
    required this.settings,
  }) : super(
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

class ThemedPageBuilder extends PageRouteBuilder {
  /// [builder] is the widget to be shown.
  final Widget Function(BuildContext context) builder;

  /// [settings] is the settings for the route.
  @override
  final RouteSettings settings;

  /// Creates a [PageRoute] that uses a fade transition.
  /// If you don't want to return something, use [ThemedPageTransition] instead.
  ThemedPageBuilder({
    required this.builder,
    required this.settings,
  }) : super(
          settings: settings,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return builder(context);
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
