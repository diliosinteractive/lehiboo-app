import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/ticket_pdf_download.dart';

Future<void> shareTicketPdf(TicketPdfDownload download) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/${download.filename}');
  await file.writeAsBytes(download.bytes, flush: true);

  await Share.shareXFiles(
    [XFile(file.path, mimeType: 'application/pdf', name: download.filename)],
  );
}
