import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/views/avatars/avatars.dart';
import 'package:layrz_theme_example/views/home.dart';
import 'package:layrz_theme_example/views/inputs/inputs.dart';
import 'package:layrz_theme_example/views/landing.dart';
import 'package:layrz_theme_example/views/layo.dart';
import 'package:layrz_theme_example/views/map/map.dart';
import 'package:layrz_theme_example/views/table/table.dart';
import 'package:layrz_theme_example/views/theme_generation.dart';

Page<void> customTransitionBuilder(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: kHoverDuration * 1.5,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Combine both animations to a single one
      final combinedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      );

      // Fade in
      return FadeTransition(
        opacity: combinedAnimation,
        child: child,
      );
    },
  );
}

final goRoutes = [
  GoRoute(
    path: '/',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const LandingView()),
  ),
  GoRoute(
    path: '/home',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const HomeView()),
  ),
  GoRoute(
    path: '/theme',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const ThemeGenerationView()),
  ),
  GoRoute(
    path: '/layo',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const LayoView()),
  ),
  GoRoute(
    path: '/avatars',
    redirect: (context, state) => '/avatars/static',
  ),
  GoRoute(
    path: '/avatars/static',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const StaticAvatarsView()),
  ),
  GoRoute(
    path: '/avatars/dynamic',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const DynamicAvatarsView()),
  ),
  GoRoute(
    path: '/inputs',
    redirect: (context, state) => '/inputs/text',
  ),
  GoRoute(
    path: '/inputs/text',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const TextInputView()),
  ),
  GoRoute(
    path: '/inputs/buttons',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const ButtonsView()),
  ),
  GoRoute(
    path: '/inputs/checkboxes',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const CheckboxesView()),
  ),
  GoRoute(
    path: '/inputs/radiobuttons',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const RadioButtonsView()),
  ),
  GoRoute(
    path: '/inputs/selectors/general',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const GeneralPickersView()),
  ),
  GoRoute(
    path: '/inputs/selectors/datetime',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const DateTimePickersView()),
  ),
  GoRoute(
    path: '/inputs/calendar',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const CalendarView()),
  ),
  GoRoute(
    path: '/inputs/code',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const CodeInputView()),
  ),
  GoRoute(
    path: '/table',
    redirect: (context, state) => '/table/basic',
  ),
  GoRoute(
    path: '/table/basic',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const BasicTableView()),
  ),

  // Map
  GoRoute(
    path: '/map',
    redirect: (context, state) => '/map/layer',
  ),
  GoRoute(
    path: '/map/layer',
    pageBuilder: (context, state) => customTransitionBuilder(context, state, const MapLayerView()),
  ),
];

final router = GoRouter(
  initialLocation: kDebugMode ? '/table/basic' : '/',
  routes: goRoutes,
);
