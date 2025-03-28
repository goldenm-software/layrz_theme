// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:js_interop';
import 'package:web/web.dart';
import 'package:flutter/foundation.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/src/file.dart';

/// [saveFile] is a helper function to save a file to the device.
///
/// This function is only for native implementations, that is, Android, iOS, Windows, and macOS.
/// To implement this function multiplatform, follow this example
/// ```dart
/// import 'package:layrz_theme/src/helpers/save_file/native.dart'
///   if (dart.library.js_interop) 'package:layrz_theme/src/helpers/save_file/web.dart';
/// // ...
/// saveFile() // <- this function
/// ```
///
/// Returns a [ThemedFile]. If the user cancels the save, it returns null.
///

/// [filename] is the name of the file to save.
/// [bytes] is the bytes of the file to save.
/// [saveDialogTitle] is the title of the pick dialog. When [i18n] is not null, this is ignored and use the
/// translation `layrz.file.save` instead.
/// [i18n] is the localization object.
Future<ThemedFile?> saveFile({
  required String filename,
  required Uint8List bytes,
  String? saveDialogTitle,
  LayrzAppLocalizations? i18n,
}) async {
  final blob = Blob(List<JSAny>.from([bytes.jsify()]).toJS);
  final url = URL.createObjectURL(blob);
  final anchor = document.createElement('a') as HTMLAnchorElement;
  anchor.href = url;
  anchor.download = filename;
  document.body!.appendChild(anchor);
  anchor.click();
  document.body!.removeChild(anchor);
  URL.revokeObjectURL(url);

  return ThemedFile(name: filename, bytes: bytes);
}
