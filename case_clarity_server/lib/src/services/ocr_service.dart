import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/case_document.dart';
import '../generated/document_ocr_status.dart';

abstract interface class OcrProvider {
  Future<String> extractText({
    required Uint8List documentBytes,
    required String mimeType,
  });
}

class MockOcrProvider implements OcrProvider {
  const MockOcrProvider();

  static const sampleNotice = '''
CHEQUE RETURN LEGAL NOTICE
Cheque date: 05/03/2026
Cheque presented: 10/03/2026
Dishonour intimation: 11/03/2026
Demand notice sent: 18 March 2026
Please arrange payment within the applicable period after receipt of this notice.
''';

  @override
  Future<String> extractText({
    required Uint8List documentBytes,
    required String mimeType,
  }) async => sampleNotice;
}

class OcrService {
  const OcrService(this.provider);

  final OcrProvider provider;

  Future<void> processDocument(Session session, int documentId) async {
    final document = await CaseDocument.db.findById(session, documentId);
    if (document == null) return;

    await CaseDocument.db.updateRow(
      session,
      document.copyWith(
        ocrStatus: DocumentOcrStatus.processing,
        extractedText: null,
        candidateDates: null,
        errorMessage: null,
      ),
    );

    try {
      final storagePath = document.storagePath;
      if (storagePath == null || storagePath.isEmpty) {
        throw StateError('Document storage path is missing.');
      }
      final file = await session.storage.retrieveFile(
        storageId: 'private',
        path: storagePath,
      );
      final text = await provider.extractText(
        documentBytes: Uint8List.sublistView(file),
        mimeType: document.mimeType,
      );
      await CaseDocument.db.updateRow(
        session,
        document.copyWith(
          ocrStatus: DocumentOcrStatus.completed,
          extractedText: text,
          candidateDates: extractCandidateDates(text),
          errorMessage: null,
        ),
      );
    } catch (_) {
      await CaseDocument.db.updateRow(
        session,
        document.copyWith(
          ocrStatus: DocumentOcrStatus.failed,
          extractedText: null,
          candidateDates: null,
          errorMessage: 'OCR processing failed. Please try again later.',
        ),
      );
    }
  }
}

final _numericDatePattern = RegExp(
  r'\b(?:0?[1-9]|[12][0-9]|3[01])[-/](?:0?[1-9]|1[0-2])[-/]\d{4}\b',
);

final _monthNameDatePattern = RegExp(
  r'\b(?:0?[1-9]|[12][0-9]|3[01])\s+'
  r'(?:January|February|March|April|May|June|July|August|September|October|November|December)'
  r'\s+\d{4}\b',
  caseSensitive: false,
);

List<String> extractCandidateDates(String text) {
  final matches = [
    ..._numericDatePattern.allMatches(text),
    ..._monthNameDatePattern.allMatches(text),
  ]..sort((a, b) => a.start.compareTo(b.start));

  final dates = <String>[];
  final seen = <String>{};
  for (final match in matches) {
    final value = match.group(0)!;
    if (seen.add(value.toLowerCase())) dates.add(value);
  }
  return dates;
}
