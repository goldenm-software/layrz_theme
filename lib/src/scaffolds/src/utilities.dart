part of scaffolds;

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
  LayrzAppLocalizations i18n = LayrzAppLocalizations.of(context)!;

  bool? result = await showDialog(
    context: context,
    builder: (context) {
      return ThemedDialog(
        titleText: i18n.t('actions.${isMultiple ? 'confirmationMultiple' : 'confirmation'}.title'),
        body: Text(
          i18n.t('actions.${isMultiple ? 'confirmationMultiple' : 'confirmation'}.content'),
          textAlign: TextAlign.center,
        ),
        dismiss: ThemedDialogAction(
          color: Colors.red,
          labelText: i18n.t('actions.confirmation.dismiss'),
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
            labelText: i18n.t('actions.confirmation.confirm'),
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
