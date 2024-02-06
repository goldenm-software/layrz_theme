part of '../scaffolds.dart';

/// Shows a dialog to confirm the deletion of items (Can be single or multiple)
/// Requires the following translations:
/// - actions.confirmation.title
/// - actions.confirmation.content
/// - actions.confirmation.dismiss
/// - actions.confirmation.confirm
/// - actions.confirmationMultiple.title
/// - actions.confirmationMultiple.content
Future<bool> deleteConfirmationDialog({
  required BuildContext context,
  bool isMultiple = false,
  bool isLoading = false,
  bool isCooldown = false,
  VoidCallback? onCooldown,
}) async {
  LayrzAppLocalizations? i18n = LayrzAppLocalizations.maybeOf(context);

  String title = '';
  String content = '';

  if (isMultiple) {
    title = i18n?.t('actions.confirmationMultiple.title') ?? 'Are you sure that you want to delete these items?';
    content = i18n?.t('actions.confirmationMultiple.content') ?? 'Once deleted, you will not be able to recover them.';
  } else {
    title = i18n?.t('actions.confirmation.title') ?? 'Are you sure that you want to delete this item?';
    content = i18n?.t('actions.confirmation.content') ?? 'Once deleted, you will not be able to recover it.';
  }

  bool? result = await showDialog(
    context: context,
    builder: (context) {
      return ThemedDialog(
        titleText: title,
        body: Text(
          content,
          textAlign: TextAlign.center,
        ),
        dismiss: ThemedDialogAction(
          color: Colors.red,
          labelText: i18n?.t('actions.confirmation.dismiss') ?? 'Nevermind',
          isLoading: isLoading,
          isCooldown: isCooldown,
          onCooldown: onCooldown,
          style: ThemedButtonStyle.text,
          onTap: () => Navigator.of(context).pop(false),
        ),
        actions: [
          ThemedDialogAction(
            style: ThemedButtonStyle.filledTonal,
            color: Colors.green,
            labelText: i18n?.t('actions.confirmation.confirm') ?? 'Do it!',
            isLoading: isLoading,
            isCooldown: isCooldown,
            onCooldown: onCooldown,
            onTap: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
