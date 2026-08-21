import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:layrz_theme/layrz_theme.dart';

Widget _buildApp({required String value, ValueChanged<String>? onChanged, bool showLevels = true}) {
  return MaterialApp(
    home: Scaffold(
      body: ThemedPasswordInput(
        labelText: 'Password',
        value: value,
        onChanged: onChanged,
        showLevels: showLevels,
      ),
    ),
  );
}

void main() {
  group('ThemedPasswordInput', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(_buildApp(value: ''));
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('toggles password visibility on eye icon tap', (tester) async {
      await tester.pumpWidget(_buildApp(value: 'Test123!'));

      // Initially should show the "eye" icon (password is hidden)
      expect(find.byIcon(MdiIcons.eyeOutline), findsOneWidget);
      expect(find.byIcon(MdiIcons.eyeOffOutline), findsNothing);

      // Tap the eye icon to show password
      await tester.tap(find.byIcon(MdiIcons.eyeOutline));
      await tester.pump();

      // Now should show the "eye off" icon (password is visible)
      expect(find.byIcon(MdiIcons.eyeOffOutline), findsOneWidget);
      expect(find.byIcon(MdiIcons.eyeOutline), findsNothing);

      // Tap again to hide
      await tester.tap(find.byIcon(MdiIcons.eyeOffOutline));
      await tester.pump();

      expect(find.byIcon(MdiIcons.eyeOutline), findsOneWidget);
    });

    testWidgets('shows shield check icon for valid password', (tester) async {
      // Valid: has lowercase, uppercase, digit, special char
      await tester.pumpWidget(_buildApp(value: 'Abc12345!'));
      expect(find.byIcon(MdiIcons.shieldCheckOutline), findsWidgets);
    });

    testWidgets('shows close circle icon for invalid password', (tester) async {
      // Missing special character
      await tester.pumpWidget(_buildApp(value: 'Abc12345'));
      expect(find.byIcon(MdiIcons.closeCircleOutline), findsWidgets);
    });

    testWidgets('shows close circle icon for empty password', (tester) async {
      await tester.pumpWidget(_buildApp(value: ''));
      expect(find.byIcon(MdiIcons.closeCircleOutline), findsWidgets);
    });

    testWidgets('hides strength indicator when showLevels is false', (tester) async {
      await tester.pumpWidget(_buildApp(value: 'Abc12345!', showLevels: false));
      // Should not find the shield/close icons used in the levels indicator
      expect(find.byIcon(MdiIcons.shieldCheckOutline), findsNothing);
      expect(find.byIcon(MdiIcons.closeCircleOutline), findsNothing);
      // But eye icon should still be present
      expect(find.byIcon(MdiIcons.eyeOutline), findsOneWidget);
    });

    testWidgets('calls onChanged when text is entered', (tester) async {
      String? changedValue;
      await tester.pumpWidget(_buildApp(
        value: '',
        onChanged: (v) => changedValue = v,
      ));

      await tester.enterText(find.byType(TextField), 'hello');
      expect(changedValue, 'hello');
    });
  });
}
