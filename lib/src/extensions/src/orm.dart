part of '../extensions.dart';

/// [ThemedOrm] is a helper component to handle Layrz Translations errors.
class ThemedOrm {
  static Map<String, dynamic> _errors = {};
  static LayrzAppLocalizations? _i18n;

  /// Get raw errors
  /// Should only be used for testing
  /// or custom error handling
  static Map<String, dynamic> get rawErrors => _errors;

  /// [setErrors] sets the errors to be used by the [ThemedOrm].
  static void setErrors({required Map<String, dynamic> errors}) {
    _errors = errors;
  }

  /// [setI18n] sets the i18n to be used by the [ThemedOrm], the [i18n] argument should be
  /// [LayrzAppLocalizations] instance.
  static void setI18n({required LayrzAppLocalizations i18n}) {
    _i18n = i18n;
  }

  /// [getError] returns a list of errors translated using [LayrzAppLocalizations].
  static List<String> getErrors({
    /// [key] is the key of the error to be retrieved.
    required String key,

    /// [context] is the [BuildContext] to be used to translate the errors.
    BuildContext? context,
  }) {
    List<dynamic> raw = _errors[key] ?? [];
    List<String> errors = [];

    for (Map<String, dynamic> error in raw) {
      if (['minLength', 'maxLength'].contains(error['code'])) {
        String fallback = error['code'];
        error.forEach((key, value) {
          if (key != 'code') {
            fallback += ':$key=$value';
          }
        });

        String msg = _i18n?.t("errors.${error['code']}", error) ?? fallback;

        if (context != null) {
          msg = LayrzAppLocalizations.maybeOf(context)?.t("errors.${error['code']}", error) ?? msg;
        }

        errors.add(msg);
      } else {
        String msg = _i18n?.t("errors.${error['code']}", error) ?? error['code'];

        if (context != null) {
          msg = LayrzAppLocalizations.maybeOf(context)?.t("errors.${error['code']}") ?? msg;
        }

        errors.add(msg);
      }
    }

    return errors;
  }

  /// [hasErrors] returns true if the [key] has errors.
  static bool hasErrors({required String key}) {
    return getErrors(key: key).isNotEmpty;
  }

  /// [hasContainerErrors] works similar as [hasErrors] but it returns true any of the errors starts with [key]
  static bool hasContainerErrors({required String key}) {
    return _errors.keys.where((err) => err.startsWith(key)).isNotEmpty;
  }
}

extension ThemedOrn on BuildContext {
  /// [setErrors] sets the errors to be used by the [ThemedOrm].
  void setErrors({required Map<String, dynamic> errors}) {
    ThemedOrm.setErrors(errors: errors);
  }

  /// [getErrors] returns a list of errors translated using [LayrzAppLocalizations].
  List<String> getErrors({required String key}) {
    return ThemedOrm.getErrors(key: key, context: this);
  }

  /// [hasErrors] returns true if the [key] has errors.
  bool hasErrors({required String key}) {
    return ThemedOrm.hasErrors(key: key);
  }

  /// [hasContainerErrors] works similar as [hasErrors] but it returns true any of the errors starts with [key]
  bool hasContainerErrors({required String key}) {
    return ThemedOrm.hasContainerErrors(key: key);
  }
}
