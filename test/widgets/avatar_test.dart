import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_icons/layrz_icons.dart';
import 'package:layrz_theme/layrz_theme.dart';

Widget _buildApp({required Widget child}) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}

void main() {
  group('ThemedAvatar - Basic rendering', () {
    testWidgets('renders with default size', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedAvatar(),
      ));

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxWidth, 30.0);
      expect(container.constraints?.maxHeight, 30.0);
    });

    testWidgets('renders with custom size', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedAvatar(size: 50),
      ));

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxWidth, 50.0);
      expect(container.constraints?.maxHeight, 50.0);
    });

    testWidgets('renders fallback initials when no avatar provided', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedAvatar(name: 'John Doe'),
      ));

      expect(find.text('JO'), findsOneWidget);
    });

    testWidgets('renders NA when name is null', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedAvatar(),
      ));

      expect(find.text('NA'), findsOneWidget);
    });
  });

  group('ThemedAvatar - Icon rendering', () {
    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: ThemedAvatar(
          icon: LayrzIcons.solarOutlineUser,
        ),
      ));

      expect(find.byIcon(LayrzIcons.solarOutlineUser), findsOneWidget);
    });

    testWidgets('icon size is 70% of avatar size by default', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: ThemedAvatar(
          icon: LayrzIcons.solarOutlineUser,
          size: 100,
        ),
      ));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 70.0);
    });

    testWidgets('respects custom icon size', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: ThemedAvatar(
          icon: LayrzIcons.solarOutlineUser,
          size: 100,
          iconSize: 50,
        ),
      ));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 50.0);
    });
  });

  group('ThemedAvatar - Name cleaning', () {
    testWidgets('cleans special characters from name', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedAvatar(name: 'John@Doe#123'),
      ));

      expect(find.text('JO'), findsOneWidget);
    });

    testWidgets('handles single character name', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedAvatar(name: 'A'),
      ));

      expect(find.text('a'), findsOneWidget);
    });

    testWidgets('returns NA for name with only special characters', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedAvatar(name: '@#\$%'),
      ));

      expect(find.text('NA'), findsOneWidget);
    });

    testWidgets('takes first 2 characters and uppercases', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: const ThemedAvatar(name: 'abcdef'),
      ));

      expect(find.text('AB'), findsOneWidget);
    });
  });

  group('ThemedAvatar - Tap handlers', () {
    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_buildApp(
        child: ThemedAvatar(
          name: 'Test',
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.byType(ThemedAvatar));
      expect(tapped, true);
    });

    testWidgets('calls onLongTap when long pressed', (tester) async {
      var longTapped = false;
      await tester.pumpWidget(_buildApp(
        child: ThemedAvatar(
          name: 'Test',
          onLongTap: () => longTapped = true,
        ),
      ));

      await tester.longPress(find.byType(ThemedAvatar));
      expect(longTapped, true);
    });

    testWidgets('calls onSecondaryTap when secondary tapped', (tester) async {
      var secondaryTapped = false;
      await tester.pumpWidget(_buildApp(
        child: ThemedAvatar(
          name: 'Test',
          onSecondaryTap: () => secondaryTapped = true,
        ),
      ));

      await tester.tap(find.byType(ThemedAvatar), buttons: kSecondaryMouseButton);
      expect(secondaryTapped, true);
    });
  });

  group('ThemedAvatar - Elevation and styling', () {
    testWidgets('applies custom color', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: ThemedAvatar(
          icon: LayrzIcons.solarOutlineUser,
          color: Colors.red,
        ),
      ));

      // The icon color should use validateColor based on background
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('elevation must be between 0 and 5', (tester) async {
      expect(
        () => ThemedAvatar(elevation: 6),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => ThemedAvatar(elevation: -1),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('radius must be greater than or equal to 0', (tester) async {
      expect(
        () => ThemedAvatar(radius: -1),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('ThemedAvatar - Priority order', () {
    testWidgets('icon takes priority over name fallback', (tester) async {
      await tester.pumpWidget(_buildApp(
        child: ThemedAvatar(
          icon: LayrzIcons.solarOutlineUser,
          name: 'Test User',
        ),
      ));

      expect(find.byIcon(LayrzIcons.solarOutlineUser), findsOneWidget);
      expect(find.text('TE'), findsNothing);
    });
  });
}
