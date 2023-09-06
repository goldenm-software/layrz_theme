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

class ThemedPageBuilder<T> extends PageRoute<T> {
  /// [pageBuilder] is the widget to be shown.
  final Widget Function(BuildContext) builder;

  /// [settings] is the settings for the route.
  @override
  final RouteSettings settings;

  @override
  final bool maintainState = true;

  @override
  final Duration transitionDuration = const Duration(milliseconds: 300);

  /// Creates a [PageRoute] that uses a fade transition.
  ThemedPageBuilder({
    required this.builder,
    required this.settings,
  }) : super(settings: settings);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
