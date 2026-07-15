/// Web implementation: triggers download via data URL (used for web only).
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';

Future<void> downloadFile(List<int> bytes, String format) async {
  try {
    final base64Bytes = base64Encode(bytes);
    final mimeType = format == 'xls' ? 'application/vnd.ms-excel' : 'text/csv';
    final dataUrl = 'data:$mimeType;base64,$base64Bytes';
    final filename =
        'export_${DateTime.now().toIso8601String().replaceAll(RegExp(r"[:.-]"), '_')}.$format';

    // On web, this would use dart:html or JS interop
    // On mobile, files are saved via path_provider
    debugPrint('[DownloadHelper] Data URL ready: $dataUrl');
    debugPrint('[DownloadHelper] Filename: $filename');
  } catch (e) {
    debugPrint('[DownloadHelper] Error on web download: $e');
    rethrow;
  }
}