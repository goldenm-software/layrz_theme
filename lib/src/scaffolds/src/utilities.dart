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
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
          decoration: generateContainerElevation(context: context, elevation: 5),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                content,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ThemedButton.cancel(
                    labelText: i18n?.t('actions.confirmation.dismiss') ?? 'Nevermind',
                    onTap: () => Navigator.of(context).pop(false),
                    isCooldown: isCooldown,
                    isLoading: isLoading,
                  ),
                  ThemedButton.save(
                    labelText: i18n?.t('actions.confirmation.confirm') ?? 'Do it!',
                    onTap: () => Navigator.of(context).pop(true),
                    isCooldown: isCooldown,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}
