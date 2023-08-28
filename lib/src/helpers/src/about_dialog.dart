part of helpers;

/// [openInfoDialog] is a helper function to open an info dialog using the structure of Layrz.
///
/// This function implements the default AboutPage of Flutter. To implement the Layrz-like AboutPage,
/// use the view `ThemedLicensesView` instead.
///
/// [context] is the context to use to open the dialog.
/// [appTitle] is the title of the app.
/// [i18n] is the i18n to use to translate the dialog.
/// [logo] is the logo of the app. Only supported from assets.
/// [companyName] is the name of the company.
void openInfoDialog({
  required BuildContext context,
  required String appTitle,
  required LayrzAppLocalizations? i18n,
  required String logo,
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
