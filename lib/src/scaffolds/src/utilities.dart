part of '../scaffolds.dart';

/// Shows a dialog to confirm the deletion of items (Can be single or multiple)
/// Requires the following translations:
/// - actions.confirmation.title
/// - actions.confirmation.content
/// - actions.confirmation.dismiss
/// - actions.confirmation.confirm
/// - actions.confirmationMultiple.title
/// - actions.confirmationMultiple.content
///  If the content is to be customized without i18n, use the customTitle and customContent parameters.
Future<bool> deleteConfirmationDialog({
  required BuildContext context,
  bool isMultiple = false,
  bool isLoading = false,
  bool isCooldown = false,
  VoidCallback? onCooldown,
  String? customTitle,
  String? customContent,
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

  if (customTitle != null) {
    title = customTitle;
  }
  if (customContent != null) {
    content = customContent;
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
                maxLines: 10,
                textAlign: TextAlign.justify,
              ),
              Text(
                content,
                textAlign: TextAlign.justify,
                maxLines: 10,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
