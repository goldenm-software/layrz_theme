part of '../views.dart';

class ThemedLicensesView extends StatefulWidget {
  /// [companyName] is the name of the company.
  final String companyName;

  /// [version] is the version of the app.
  final String? version;

  /// [logo] is the logo of the app. Only supported from assets.
  final AppThemedAsset? logo;

  /// [ThemedLicensesView] is a custom view to show the licenses of the app.
  ///
  /// It's a replacement of the default [AboutPage] of Flutter.
  const ThemedLicensesView({
    super.key,
    required this.companyName,
    this.version,
    this.logo,
  });
  @override
  ThemedLicensesViewState createState() => ThemedLicensesViewState();
}

class ThemedLicensesViewState extends State<ThemedLicensesView> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  String get logoUri => isDark
      ? (widget.logo?.white ?? 'https://cdn.layrz.com/resources/layrz/logo/white.png')
      : (widget.logo?.normal ?? 'https://cdn.layrz.com/resources/layrz/logo/normal.png');

  List<ThemedLicense> parsedLicenses = [];
  ThemedLicense? selectedLicense;
  String paragraph = '';

  List<String> get publicLayrzPackages => [
        'layrz_theme',
        'layrz_models',
      ];

  @override
  void initState() {
    super.initState();
    _getLicenses();
  }

  Future<void> _getLicenses() async {
    Set<String> packages = {};
    List<LicenseEntry> licenses = [];

    await for (LicenseEntry license in LicenseRegistry.licenses) {
      packages.addAll(license.packages);
      licenses.add(license);
    }

    parsedLicenses = [];

    final sortedPackages = packages.toList()
      ..sort(
        (String a, String b) => a.toLowerCase().compareTo(b.toLowerCase()),
      );

    for (final package in sortedPackages) {
      if (package.startsWith('layrz') && !publicLayrzPackages.contains(package)) {
        continue;
      }
      final excerpts = <String>[];
      for (final license in licenses) {
        if (license.packages.contains(package)) {
          final p = license.paragraphs.first.text.trim();
          // Third party such as `asn1lib`, the license is a link
          final reg = RegExp(p.startsWith('http') ? r' |,|，' : r'\.|。');
          var excerpt = p.split(reg).first.trim();
          if (excerpt.startsWith('//') || excerpt.startsWith('/*')) {
            // Ignore symbol of comment in LICENSE file
            excerpt = excerpt.substring(2).trim();
          }
          if (excerpt.length > 70) {
            // Avoid sub title too long
            excerpt = '${excerpt.substring(0, 70)}...';
          }
          excerpts.add(excerpt);
        }
      }

      final String excerpt = excerpts.length > 1
          ? MaterialLocalizations.of(context).licensesPackageDetailText(excerpts.length)
          : excerpts.join('\n');

      parsedLicenses.add(
        ThemedLicense(
          package: package,
          excerpt: excerpt,
        ),
      );
    }

    if (mounted) setState(() {});
  }

  Future<void> _getParagraphs(ThemedLicense package) async {
    String paragraphs = '';

    await for (LicenseEntry license in LicenseRegistry.licenses) {
      if (license.packages.contains(package.package)) {
        for (final paragraph in license.paragraphs) {
          paragraphs += paragraph.text;
        }
        break;
      }
    }

    if (mounted) setState(() => paragraph = paragraphs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < kSmallGrid;

            double width = constraints.maxWidth / 4;

            Widget listOfLicenses = Column(
              children: [
                Text(
                  i18n?.t('layrz.about.licenses') ?? "Open source licenses used",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: parsedLicenses.isNotEmpty
                      ? ListView.builder(
                          itemCount: parsedLicenses.length,
                          itemBuilder: (context, index) {
                            ThemedLicense license = parsedLicenses[index];

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    paragraph = '';
                                    selectedLicense = license;
                                  });
                                  if (isMobile) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(license.package),
                                          content: FutureBuilder(
                                            future: _getParagraphs(license),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return const SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: Center(
                                                    child: CircularProgressIndicator(),
                                                  ),
                                                );
                                              }

                                              return SingleChildScrollView(
                                                child: Text(
                                                  paragraph,
                                                  overflow: TextOverflow.visible,
                                                  textAlign: TextAlign.justify,
                                                ),
                                              );
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text(i18n?.t('actions.close') ?? "Close"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    _getParagraphs(license);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        license.package,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                      Text(
                                        license.excerpt,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ],
            );

            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ThemedImage(
                        path: logoUri,
                        width: 200,
                        height: 40,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "© ${DateTime.now().year} ${widget.companyName}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 10, height: 20, child: VerticalDivider()),
                      Text(
                        i18n?.t('copyright.powered.by') ?? "Powered by Layrz",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (isMobile) ...[
                    Expanded(
                      child: listOfLicenses,
                    ),
                  ] else ...[
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: width,
                            decoration: generateContainerElevation(context: context),
                            padding: const EdgeInsets.all(10),
                            child: listOfLicenses,
                          ),
                          const SizedBox(width: 30),
                          if (selectedLicense != null) ...[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedLicense!.package,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  Expanded(
                                      child: paragraph.isNotEmpty
                                          ? SingleChildScrollView(
                                              child: Text(
                                                paragraph,
                                                overflow: TextOverflow.visible,
                                                textAlign: TextAlign.justify,
                                              ),
                                            )
                                          : const Center(
                                              child: CircularProgressIndicator(),
                                            )),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ThemedButton(
                      icon: LayrzIcons.solarOutlineAltArrowLeft,
                      labelText: i18n?.t('actions.back') ?? "Back",
                      color: Colors.red,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
