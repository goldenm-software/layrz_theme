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
      return AlertDialog(
        title: Text(i18n.t('actions.${isMultiple ? 'confirmationMultiple' : 'confirmation'}.title')),
        content: Text(i18n.t('actions.${isMultiple ? 'confirmationMultiple' : 'confirmation'}.content')),
        actions: [
          ThemedButton(
            style: ThemedButtonStyle.filledTonal,
            color: Colors.red.shade700,
            labelText: i18n.t('actions.confirmation.dismiss'),
            isLoading: isLoading,
            isCooldown: isCooldown,
            onCooldownFinish: onCooldown,
            onTap: () => Navigator.pop(context, false),
          ),
          ThemedButton(
            style: ThemedButtonStyle.filledTonal,
            color: Colors.green.shade700,
            labelText: i18n.t('actions.confirmation.confirm'),
            isLoading: isLoading,
            isCooldown: isCooldown,
            onCooldownFinish: onCooldown,
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
