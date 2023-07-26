// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:file_picker/file_picker.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/src/file.dart';

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
    return result.files.where((file) {
      return file.bytes != null;
    }).map((file) {
      return ThemedFile(
        name: file.name,
        bytes: file.bytes!,
      );
    }).toList();
  }
  return null;
}
