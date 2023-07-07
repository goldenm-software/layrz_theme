import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/src/file.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<ThemedFile>?> pickFile({
  String? pickDialogTitle,
  LayrzAppLocalizations? i18n,
  FileType type = FileType.any,
  List<String>? allowedExtensions,
  bool allowMultiple = false,
}) async {
  String dialogTitle = pickDialogTitle ?? i18n?.t('layrz.file.pick') ?? "Pick a file";

  if (Platform.isAndroid) {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: dialogTitle,
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

  if (Platform.isWindows) {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (!status.isGranted) {
      return null;
    }

    final result = await FilePicker.platform.pickFiles(
      dialogTitle: dialogTitle,
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

  if (Platform.isIOS) {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (!status.isGranted) {
      return null;
    }

    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        dialogTitle: dialogTitle,
        allowMultiple: allowMultiple,
        type: type,
        allowedExtensions: type == FileType.custom ? allowedExtensions : [],
      );
    } catch (e) {
      debugPrint("[layrz_theme] Error while picking file: $e");
      result = null;
    }

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

  if (Platform.isMacOS) {
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        dialogTitle: dialogTitle,
        allowMultiple: allowMultiple,
        type: type,
        allowedExtensions: type == FileType.custom ? allowedExtensions : [],
      );
    } catch (e) {
      debugPrint("[layrz_theme] Error while picking file: $e");
      result = null;
    }

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
