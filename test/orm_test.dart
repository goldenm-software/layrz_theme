import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  setUp(() {
    // Clear errors before each test
    ThemedOrm.setErrors(errors: {});
  });

  group('setErrors() and getErrors()', () {
    test('stores and retrieves errors correctly', () {
      final errors = {
        'username': [
          {'code': 'required'},
        ],
      };

      ThemedOrm.setErrors(errors: errors);
      final retrieved = ThemedOrm.getErrors(key: 'username');

      expect(retrieved, isNotEmpty);
      expect(retrieved.length, 1);
      expect(retrieved.first, 'required');
    });

    test('retrieves empty list for non-existent key', () {
      ThemedOrm.setErrors(errors: {});
      final retrieved = ThemedOrm.getErrors(key: 'nonexistent');

      expect(retrieved, isEmpty);
    });

    test('handles multiple errors for same key', () {
      final errors = {
        'password': [
          {'code': 'required'},
          {'code': 'minLength', 'min': 8},
        ],
      };

      ThemedOrm.setErrors(errors: errors);
      final retrieved = ThemedOrm.getErrors(key: 'password');

      expect(retrieved.length, 2);
    });

    test('replaces existing errors when setErrors called again', () {
      ThemedOrm.setErrors(errors: {
        'field1': [
          {'code': 'error1'},
        ],
      });

      ThemedOrm.setErrors(errors: {
        'field2': [
          {'code': 'error2'},
        ],
      });

      expect(ThemedOrm.getErrors(key: 'field1'), isEmpty);
      expect(ThemedOrm.getErrors(key: 'field2'), isNotEmpty);
    });
  });

  group('hasErrors()', () {
    test('returns true when key has errors', () {
      ThemedOrm.setErrors(errors: {
        'email': [
          {'code': 'invalid'},
        ],
      });

      expect(ThemedOrm.hasErrors(key: 'email'), true);
    });

    test('returns false when key has no errors', () {
      ThemedOrm.setErrors(errors: {});
      expect(ThemedOrm.hasErrors(key: 'email'), false);
    });

    test('returns false for non-existent key', () {
      ThemedOrm.setErrors(errors: {
        'username': [
          {'code': 'required'},
        ],
      });

      expect(ThemedOrm.hasErrors(key: 'email'), false);
    });
  });

  group('hasContainerErrors()', () {
    test('returns true when any key starts with prefix', () {
      ThemedOrm.setErrors(errors: {
        'user.name': [
          {'code': 'required'},
        ],
        'user.email': [
          {'code': 'invalid'},
        ],
      });

      expect(ThemedOrm.hasContainerErrors(key: 'user'), true);
    });

    test('returns false when no keys match prefix', () {
      ThemedOrm.setErrors(errors: {
        'profile.name': [
          {'code': 'required'},
        ],
      });

      expect(ThemedOrm.hasContainerErrors(key: 'user'), false);
    });

    test('exact match works as prefix', () {
      ThemedOrm.setErrors(errors: {
        'username': [
          {'code': 'required'},
        ],
      });

      expect(ThemedOrm.hasContainerErrors(key: 'username'), true);
    });

    test('returns false when errors map is empty', () {
      ThemedOrm.setErrors(errors: {});
      expect(ThemedOrm.hasContainerErrors(key: 'user'), false);
    });
  });

  group('Error code handling without i18n', () {
    test('returns error code as fallback when no i18n set', () {
      ThemedOrm.setErrors(errors: {
        'field': [
          {'code': 'required'},
        ],
      });

      final errors = ThemedOrm.getErrors(key: 'field');
      expect(errors.first, 'required');
    });

    test('minLength error includes parameters in fallback', () {
      ThemedOrm.setErrors(errors: {
        'password': [
          {'code': 'minLength', 'min': 8},
        ],
      });

      final errors = ThemedOrm.getErrors(key: 'password');
      expect(errors.first, contains('minLength'));
      expect(errors.first, contains('min=8'));
    });

    test('maxLength error includes parameters in fallback', () {
      ThemedOrm.setErrors(errors: {
        'bio': [
          {'code': 'maxLength', 'max': 500},
        ],
      });

      final errors = ThemedOrm.getErrors(key: 'bio');
      expect(errors.first, contains('maxLength'));
      expect(errors.first, contains('max=500'));
    });

    test('minLength with multiple parameters in fallback', () {
      ThemedOrm.setErrors(errors: {
        'field': [
          {'code': 'minLength', 'min': 8, 'actual': 5},
        ],
      });

      final errors = ThemedOrm.getErrors(key: 'field');
      expect(errors.first, contains('minLength'));
      expect(errors.first, contains('min=8'));
      expect(errors.first, contains('actual=5'));
    });
  });

  group('Multiple error codes', () {
    test('handles mix of standard and length errors', () {
      ThemedOrm.setErrors(errors: {
        'password': [
          {'code': 'required'},
          {'code': 'minLength', 'min': 8},
          {'code': 'weak'},
        ],
      });

      final errors = ThemedOrm.getErrors(key: 'password');
      expect(errors.length, 3);
      expect(errors[0], 'required');
      expect(errors[1], contains('minLength'));
      expect(errors[2], 'weak');
    });
  });

  group('Raw errors access', () {
    test('rawErrors returns the internal error map', () {
      final errorMap = {
        'field1': [
          {'code': 'error1'},
        ],
      };

      ThemedOrm.setErrors(errors: errorMap);
      expect(ThemedOrm.rawErrors, equals(errorMap));
    });

    test('rawErrors is empty after setting empty map', () {
      ThemedOrm.setErrors(errors: {'field': []});
      ThemedOrm.setErrors(errors: {});

      expect(ThemedOrm.rawErrors, isEmpty);
    });
  });

  group('Edge cases', () {
    test('handles empty error list for key', () {
      ThemedOrm.setErrors(errors: {
        'field': [],
      });

      final errors = ThemedOrm.getErrors(key: 'field');
      expect(errors, isEmpty);
    });

    test('handles error with empty code', () {
      ThemedOrm.setErrors(errors: {
        'field': [
          {'code': ''},
        ],
      });

      final errors = ThemedOrm.getErrors(key: 'field');
      expect(errors.first, '');
    });

    test('handles special characters in error keys', () {
      ThemedOrm.setErrors(errors: {
        'user.profile.settings.email': [
          {'code': 'invalid'},
        ],
      });

      expect(ThemedOrm.hasErrors(key: 'user.profile.settings.email'), true);
      expect(ThemedOrm.hasContainerErrors(key: 'user.profile'), true);
    });
  });
}
