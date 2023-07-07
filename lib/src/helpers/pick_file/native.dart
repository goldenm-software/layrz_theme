import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/src/file.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<ThemedFile>?> pickFile({
  String? pickDialogTitle,
  LayrzAppLocalizations? i18n,
  FileType type = FileType.any,
  List<String>? allowedExtensions,
  bool allowMultiple = false,
}) async {
  String dialogTitle = pickDialogTitle ?? i18n?.t('layrz.file.pick') ?? "Pick a file";

  if (Platform.isAndroid || Platform.isWindows) {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: pickDialogTitle ?? i18n?.t('layrz.file.pick') ?? "Pick a file",
      allowMultiple: allowMultiple,
      type: type,
      allowedExtensions: type == FileType.custom ? allowedExtensions : [],
    );

    if (result != null) {
      return result.files.where((file) {
        return file.path != null;
      }).map((file) {
        return ThemedFile(
          name: file.name,
          path: file.path,
          bytes: File(file.path!).readAsBytesSync(),
        );
      }).toList();
    }

    return null;
  }

  return null;
}
