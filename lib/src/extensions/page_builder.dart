part of layrz_theme;

class ThemedPageTransition extends PageRouteBuilder {
  final Widget page;

  @override
  final RouteSettings settings;

  /// Creates a [PageRoute] that uses a fade transition.
  /// If you want to return something, use [ThemedPageBuilder] instead.
  ThemedPageTransition({
    /// [page] is the widget to be shown.
    required this.page,

    /// [settings] is the settings for the route.
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
  final Widget Function(BuildContext context) builder;

  @override
  final RouteSettings settings;

  /// Creates a [PageRoute] that uses a fade transition.
  /// If you don't want to return something, use [ThemedPageTransition] instead.
  ThemedPageBuilder({
    /// [builder] is the widget to be shown.
    required this.builder,

    /// [settings] is the settings for the route.
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
