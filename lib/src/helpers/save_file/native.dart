import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/src/file.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<ThemedFile?> saveFile({
  required String filename,
  required Uint8List bytes,
  String? saveDialogTitle,
  LayrzAppLocalizations? i18n,
}) async {
  String dialogTitle = saveDialogTitle ?? i18n?.t('layrz.file.save') ?? "Save file";

  if (Platform.isAndroid) {
    final parentDirectory = await getApplicationDocumentsDirectory();
    final directory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: dialogTitle,
      initialDirectory: parentDirectory.path,
    );

    if (directory != null) {
      final file = File("$directory/$filename");
      await file.writeAsBytes(bytes);
      return ThemedFile(
        name: filename,
        bytes: bytes,
        path: file.path,
      );
    }

    return null;
  }

  if (Platform.isWindows) {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      final parentDirectory = await getApplicationDocumentsDirectory();

      FileType type = FileType.any;
      List<String> allowedExtensions = [];
      final mime = lookupMimeType(filename);

      if (mime != null) {
        if (mime.startsWith('image/')) {
          type = FileType.image;
        } else if (mime.startsWith('video/')) {
          type = FileType.video;
        } else if (mime.startsWith('audio/')) {
          type = FileType.audio;
        } else {
          type = FileType.custom;
          allowedExtensions = [extensionFromMime(mime)];
        }
      }

      final directory = await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle,
        initialDirectory: parentDirectory.path,
        fileName: filename,
        type: type,
        allowedExtensions: allowedExtensions,
      );

      if (directory != null) {
        final file = File(directory);
        await file.writeAsBytes(bytes);
        return ThemedFile(
          name: filename,
          bytes: bytes,
          path: file.path,
        );
      }
      return null;
    }
  }

  return null;
}
