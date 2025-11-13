part of '../extensions.dart';

extension I18nExtension on BuildContext {
  // Returns the `LayrzAppLocalizations` instance for the current context.
  LayrzAppLocalizations get i18n => .of(this);
}
