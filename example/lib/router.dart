import 'package:go_router/go_router.dart';
import 'package:layrz_theme_example/avatars.dart';
import 'package:layrz_theme_example/buttons.dart';
import 'package:layrz_theme_example/dynamic_credentials.dart';
import 'package:layrz_theme_example/empty.dart';
import 'package:layrz_theme_example/home.dart';
import 'package:layrz_theme_example/inputs.dart';
import 'package:layrz_theme_example/layo.dart';
import 'package:layrz_theme_example/login_example.dart';
import 'package:layrz_theme_example/tab_bar.dart';
import 'package:layrz_theme_example/table.dart';
import 'package:layrz_theme_example/text.dart';
import 'package:layrz_theme_example/cards.dart';

final goRoutes = [
  GoRoute(
    path: '/home',
    builder: (context, state) {
      return const HomeView(name: 'Home');
    },
  ),
  GoRoute(
    path: '/layo',
    builder: (context, state) => const LayoView(name: 'Layo'),
  ),
  GoRoute(
    path: '/table',
    builder: (context, state) => const TableView(name: 'Table'),
  ),
  GoRoute(
    path: '/inputs',
    builder: (context, state) => const InputsView(name: 'Inputs'),
  ),
  GoRoute(
    path: '/text',
    builder: (context, state) => const TextView(name: 'Text'),
  ),
  GoRoute(
    path: '/cards',
    builder: (context, state) => const CardsView(name: 'Cards'),
  ),
  GoRoute(
    path: '/tabBar',
    builder: (context, state) => const TabView(name: 'Tab Bar'),
  ),
  GoRoute(
    path: '/buttons',
    builder: (context, state) => const ButtonsView(name: 'Empty'),
  ),
  GoRoute(
    path: '/avatars',
    builder: (context, state) => const AvatarsView(name: 'Avatars'),
  ),
  GoRoute(
    path: '/dynamic_credentials',
    builder: (context, state) => const DynamicCredentialsView(name: 'Dynamic Credentials'),
  ),
  GoRoute(
    path: '/empty',
    builder: (context, state) => const EmptyView(name: 'Empty'),
  ),
  GoRoute(
    path: '/nested',
    redirect: (context, state) => '/nested/test2',
  ),
  GoRoute(
    path: '/nested/test0',
    builder: (context, state) => const EmptyView(name: 'Test 0'),
  ),
  GoRoute(
    path: '/nested/test1',
    builder: (context, state) => const EmptyView(name: 'Test 1'),
  ),
  GoRoute(
    path: '/nested/test2',
    builder: (context, state) => const EmptyView(name: 'Test 2'),
  ),
  GoRoute(
    path: '/nested/test3',
    builder: (context, state) => const EmptyView(name: 'Test 3'),
  ),
  GoRoute(
    path: '/nested/test4',
    builder: (context, state) => const EmptyView(name: 'Test 4'),
  ),
  GoRoute(
    path: '/login_example',
    builder: (context, state) => const LoginExampleView(name: 'Login Example'),
  ),
];

final router = GoRouter(initialLocation: '/home', routes: goRoutes);

final nativeRoutes = {
  '/home': (context) => const HomeView(name: 'Home'),
  '/table': (context) => const TableView(name: 'Table'),
  '/inputs': (context) => const InputsView(name: 'Inputs'),
  '/text': (context) => const TextView(name: 'Text'),
  '/cards': (context) => const CardsView(name: 'Cards'),
  '/tabBar': (context) => const TabView(name: 'Tab Bar'),
  '/buttons': (context) => const ButtonsView(name: 'Empty'),
  '/avatars': (context) => const AvatarsView(name: 'Avatars'),
  '/dynamic_credentials': (context) => const DynamicCredentialsView(name: 'Dynamic Credentials'),
  '/empty': (context) => const EmptyView(name: 'Empty'),
  '/nested/test0': (context) => const EmptyView(name: 'Test 0'),
  '/nested/test1': (context) => const EmptyView(name: 'Test 1'),
  '/nested/test2': (context) => const EmptyView(name: 'Test 2'),
  '/nested/test3': (context) => const EmptyView(name: 'Test 3'),
  '/nested/test4': (context) => const EmptyView(name: 'Test 4'),
  '/login_example': (context) => const LoginExampleView(name: 'Login Example'),
};
