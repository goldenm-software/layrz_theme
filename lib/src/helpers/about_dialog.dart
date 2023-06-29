part of layrz_theme;

/// [openInfoDialog] is a helper function to open an info dialog using the structure of Layrz.
void openInfoDialog({
  /// [context] is the context to use to open the dialog.
  required BuildContext context,

  /// [appTitle] is the title of the app.
  required String appTitle,

  /// [i18n] is the i18n to use to translate the dialog.
  required LayrzAppLocalizations? i18n,

  /// [logo] is the logo of the app. Only supported from assets.
  required String logo,

  /// [companyName] is the name of the company.
  required String companyName,

  ///
}) {
  showAboutDialog(
    context: context,
    applicationName: appTitle,
    applicationLegalese: "${DateTime.now().year} $companyName\n"
        "${i18n?.t('copyright.powered.by') ?? "Powered by Layrz"}",
    routeSettings: const RouteSettings(name: '/legally'),
    applicationIcon: ThemedImage(
      path: logo,
      width: 50,
      height: 50,
    ),
  );
}
