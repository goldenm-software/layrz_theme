import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeView extends StatefulWidget {
  final String name;
  final VoidCallback toggleTheme;
  const HomeView({
    super.key,
    this.name = 'Generic View',
    required this.toggleTheme,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<int> selected = [];
  List<ThemedSelectItem<int>> get choices => [];

  @override
  Widget build(BuildContext context) {
    return Layout(
      toggleTheme: widget.toggleTheme,
      showDrawer: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThemedButton(
              labelText: "Show snackbar [simple]",
              onTap: () {
                showThemedSnackbar(ThemedSnackbar(
                  icon: Icons.help,
                  context: context,
                  message: "Esta situación puede generarse por problemas de permisos en la cuenta de Wialon "
                      "y/o problemas con las credenciales.",
                ));
              },
            ),
            ThemedButton(
              labelText: "Show snackbar [test]",
              onTap: () {
                showThemedSnackbar(ThemedSnackbar(
                  icon: Icons.help,
                  context: context,
                  message: "Translation missing external.accounts.errors.syncFailed.caption",
                ));
              },
            ),
            const SizedBox(height: 10),
            ThemedButton(
              labelText: "Show snackbar [w/ title]",
              onTap: () {
                showThemedSnackbar(ThemedSnackbar(
                  icon: Icons.help,
                  context: context,
                  title: 'Lo sentimos, pero no hemos podido extraer información de la cuenta indicada.',
                  message: "Usualmente esto se debe a errores en las credenciales de Wialon. Por favor verifíquelas "
                      "y vuelva a intentarlo",
                ));
              },
            ),
            const SizedBox(height: 10),
            ThemedButton(
              labelText: "Save file",
              icon: MdiIcons.contentSave,
              color: Colors.orange,
              onTap: () async {
                final bytes = await rootBundle.load('assets/image-test.jpg');
                saveFile(
                  filename: 'testimage.jpg',
                  bytes: bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
                );
              },
            ),
            const SizedBox(height: 10),
            ThemedButton(
              labelText: "Pick file (Single)",
              icon: MdiIcons.file,
              color: Colors.green,
              onTap: () async {
                final files = await pickFile();
                if (files != null) {
                  for (final file in files) {
                    debugPrint("File: ${file.name} - Size: ${file.bytes.length} - Mime: ${file.mimeType}");
                  }
                }
              },
            ),
            ThemedButton(
              labelText: "Pick file (Multiple)",
              icon: MdiIcons.file,
              color: Colors.green,
              onTap: () async {
                final files = await pickFile(type: FileType.image, allowMultiple: true);
                if (files != null) {
                  for (final file in files) {
                    debugPrint("File: ${file.name} - Size: ${file.bytes.length} - Mime: ${file.mimeType}");
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
