// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:file_picker/file_picker.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/src/file.dart';

/// [pickFile] is a helper function to pick a file from the device.
///
/// This function is only for web implementations
/// To implement this function multiplatform, follow this example
/// ```dart
/// import 'package:layrz_theme/src/helpers/pick_file/native.dart'
///   if (dart.library.js_interop) 'package:layrz_theme/src/helpers/pick_file/web.dart';
/// // ...
/// pickFile() // <- this function
/// ```
///
/// Returns a list of [ThemedFile]s. If the user cancels the picker, it returns null.
///
/// [pickDialogTitle] is the title of the pick dialog. When [i18n] is not null, this is ignored and use the
/// translation `layrz.file.pick` instead.
/// [i18n] is the localization object.
/// [type] is the type of file to pick.
/// [allowedExtensions] is the list of allowed extensions.
/// [allowMultiple] is whether to allow multiple files to be picked.
Future<List<ThemedFile>?> pickFile({
  String? pickDialogTitle,
  LayrzAppLocalizations? i18n,
  FileType type = FileType.any,
  List<String>? allowedExtensions,
  bool allowMultiple = false,
}) async {
  final result = await FilePicker.platform.pickFiles(
    dialogTitle: pickDialogTitle ?? i18n?.t('layrz.file.pick') ?? "Pick a file",
    allowMultiple: allowMultiple,
    type: type,
    allowedExtensions: type == FileType.custom ? allowedExtensions : [],
  );

  if (result != null) {
    return result.files
        .where((file) {
          return file.bytes != null;
        })
        .map((file) {
          return ThemedFile(
            name: file.name,
            bytes: file.bytes!,
          );
        })
        .toList();
  }
  return null;
}
