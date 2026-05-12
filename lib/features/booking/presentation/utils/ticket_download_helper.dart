import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/ticket_pdf_download.dart';

/// Method channel paired with the Kotlin side at
/// android/app/src/main/kotlin/com/dilios/lehiboo/MainActivity.kt
const _androidFileSaver = MethodChannel('com.lehiboo.app/file_saver');

/// Result of a ticket save: where it landed, plus a human label that the
/// UI can show in a "saved to <label>" snackbar.
class TicketSaveResult {
  final String path; // Real path on iOS, content:// URI on Android API 29+
  final String displayLocation; // Human-readable (e.g. "Téléchargements/Lehiboo")
  const TicketSaveResult({required this.path, required this.displayLocation});
}

/// Save the ticket PDF to a public, user-visible folder on each platform
/// AND fire the share sheet so the user can also send / forward it.
///
///   iOS    : <App sandbox>/Documents/tickets/<filename>.pdf
///   Android: /Download/Lehiboo/<filename>.pdf via MediaStore on API 29+
///            (scoped storage compatible) or direct file write on older.
Future<TicketSaveResult> shareTicketPdf(TicketPdfDownload download) async {
  final result = await _saveToPublicFolder(download);

  // share_plus needs a real file path — Android MediaStore content:// URIs
  // are not directly shareable. Always stage a temp copy for the share
  // sheet so it works identically on both platforms.
  try {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/${download.filename}');
    await tempFile.writeAsBytes(download.bytes, flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(
            tempFile.path,
            mimeType: 'application/pdf',
            name: download.filename,
          ),
        ],
      ),
    );
  } catch (e) {
    // Persisting succeeded; the share sheet is a nice-to-have.
    debugPrint('🎫 share sheet failed (non-fatal): $e');
  }

  return result;
}

Future<TicketSaveResult> _saveToPublicFolder(TicketPdfDownload download) async {
  if (Platform.isAndroid) {
    final saved = await _androidFileSaver.invokeMethod<String>(
      'saveToDownloads',
      <String, dynamic>{
        'filename': download.filename,
        'bytes': Uint8List.fromList(download.bytes),
        'mimeType': 'application/pdf',
      },
    );
    if (saved == null || saved.isEmpty) {
      throw const FileSystemException('Failed to save PDF to Downloads');
    }
    debugPrint('🎫 saved to Android Downloads: $saved');
    return TicketSaveResult(
      path: saved,
      displayLocation: 'Téléchargements/Lehiboo',
    );
  }

  // iOS (and desktop fallbacks): Documents/tickets/
  final docs = await getApplicationDocumentsDirectory();
  final ticketsDir = Directory('${docs.path}/tickets');
  if (!await ticketsDir.exists()) {
    await ticketsDir.create(recursive: true);
  }
  final file = File('${ticketsDir.path}/${download.filename}');
  await file.writeAsBytes(download.bytes, flush: true);
  debugPrint('🎫 saved to iOS Documents: ${file.path}');
  return TicketSaveResult(
    path: file.path,
    displayLocation: 'Documents › Lehiboo › tickets',
  );
}
