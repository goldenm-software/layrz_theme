// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/src/file.dart';

Future<ThemedFile?> saveFile({
  required String filename,
  required Uint8List bytes,
  String? saveDialogTitle,
  LayrzAppLocalizations? i18n,
}) async {
  final blob = Blob([bytes]);
  final url = Url.createObjectUrlFromBlob(blob);
  final anchor = document.createElement('a') as AnchorElement
    ..href = url
    ..download = filename;
  document.body!.append(anchor);
  anchor.click();
  Url.revokeObjectUrl(url);
  return ThemedFile(name: filename, bytes: bytes);
}
