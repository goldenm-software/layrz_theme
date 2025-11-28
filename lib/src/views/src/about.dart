part of '../views.dart';

void showThemedAboutDialog({
  required BuildContext context,
  String companyName = 'Golden M, Inc,',
  String? version,
  AppThemedAsset? logo,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return ThemedAboutDialog(companyName: companyName, version: version, logo: logo);
    },
  );
}

class ThemedAboutDialog extends StatefulWidget {
  /// [companyName] is the name of the company.
  final String companyName;

  /// [version] is the version of the app.
  final String? version;

  /// [logo] is the logo of the app. Only supported from assets.
  final AppThemedAsset? logo;

  /// [ThemedAboutDialog] is the about dialog of the app.
  const ThemedAboutDialog({
    super.key,
    this.companyName = 'Golden M, Inc,',
    this.version,
    this.logo,
  });

  @override
  State<ThemedAboutDialog> createState() => _ThemedAboutDialogState();
}

class _ThemedAboutDialogState extends State<ThemedAboutDialog> {
  LayrzAppLocalizations? get i18n => .maybeOf(context);
  bool get isDark => Theme.of(context).brightness == .dark;

  Color get _spinnerColor => isDark ? Colors.white : Theme.of(context).primaryColor;

  String get _logoUri => isDark
      ? (widget.logo?.white ?? 'https://cdn.layrz.com/resources/layrz/logo/white.png')
      : (widget.logo?.normal ?? 'https://cdn.layrz.com/resources/layrz/logo/normal.png');

  List<ThemedLicense> _parsedLicenses = [];
  String _searchText = '';
  bool _isLoading = true;

  List<ThemedLicense> get _filteredLicenses => _parsedLicenses.where((license) {
    if (_searchText.isEmpty) return true;

    return license.package.toLowerCase().contains(_searchText.toLowerCase());
  }).toList();

  List<String> get _publicLayrzPackages => [
    'layrz_theme',
    'layrz_models',
    'layrz_icons',
    'layrz_logging',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLicenses();
    });
  }

  Future<void> _getLicenses() async {
    Set<String> packages = {};
    List<LicenseEntry> licenses = [];

    await for (LicenseEntry license in LicenseRegistry.licenses) {
      packages.addAll(license.packages);
      licenses.add(license);
    }

    _parsedLicenses = [];

    final sortedPackages = packages.toList()
      ..sort((a, b) {
        return a.toLowerCase().compareTo(b.toLowerCase());
      });

    for (final package in sortedPackages) {
      if (package.startsWith('layrz') && !_publicLayrzPackages.contains(package)) {
        continue;
      }

      List<String> excerpts = [];
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

      if (!mounted) return;
      final String excerpt = excerpts.length > 1
          ? MaterialLocalizations.of(context).licensesPackageDetailText(excerpts.length)
          : excerpts.join('\n');

      _parsedLicenses.add(
        ThemedLicense(
          package: package,
          excerpt: excerpt,
        ),
      );
    }

    _isLoading = false;
    if (mounted) setState(() {});
  }

  Future<String> _getParagraphs(ThemedLicense package) async {
    String paragraphs = '';

    await for (LicenseEntry license in LicenseRegistry.licenses) {
      if (license.packages.contains(package.package)) {
        for (final paragraph in license.paragraphs) {
          paragraphs += paragraph.text;
        }
        break;
      }
    }

    return paragraphs;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const .all(20),
        decoration: generateContainerElevation(context: context, elevation: 3),
        padding: const .all(20),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          crossAxisAlignment: .center,
          mainAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            ThemedImage(
              path: _logoUri,
              width: 200,
              height: 40,
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "© ${DateTime.now().year} ${widget.companyName}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: .bold),
                  ),
                  const WidgetSpan(
                    child: SizedBox(width: 5),
                  ),
                  TextSpan(
                    text: i18n?.t('copyright.powered.by') ?? "Powered by Layrz",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${i18n?.t('copyright.platform.os') ?? "Platform"}: ",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: .bold),
                  ),
                  TextSpan(
                    text: kThemedPlatform.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            if (widget.version != null)
              Text(
                "v${widget.version}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 10),
            if (_isLoading) ...[
              Padding(
                padding: const .all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    color: _spinnerColor,
                  ),
                ),
              ),
            ] else ...[
              ThemedTextInput(
                labelText: i18n?.t('about.search') ?? 'Search package',
                dense: true,
                padding: .zero,
                prefixIcon: LayrzIcons.solarOutlineMagnifier,
                onChanged: (value) => setState(() => _searchText = value),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredLicenses.length,
                  itemBuilder: (context, index) {
                    final package = _filteredLicenses[index];

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: FutureBuilder<String>(
                                future: _getParagraphs(package),
                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      padding: const .all(20),
                                      decoration: generateContainerElevation(context: context, elevation: 3),
                                      constraints: const BoxConstraints(maxWidth: 600),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: .start,
                                          mainAxisAlignment: .start,
                                          mainAxisSize: .min,
                                          children: [
                                            Text(
                                              package.package,
                                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: .bold),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              snapshot.data ?? 'N/A',
                                              style: Theme.of(context).textTheme.bodyMedium,
                                              maxLines: 100,
                                              textAlign: .justify,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return Center(
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: generateContainerElevation(
                                        context: context,
                                        elevation: 3,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: validateColor(color: Theme.of(context).primaryColor),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            package.package,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
