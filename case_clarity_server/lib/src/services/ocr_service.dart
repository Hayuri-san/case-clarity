import 'dart:convert';
import 'dart:io';
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

abstract interface class GeminiHttpClient {
  Future<GeminiHttpResponse> post(
    Uri uri, {
    required Map<String, String> headers,
    required String body,
  });
}

class GeminiHttpResponse {
  const GeminiHttpResponse({required this.statusCode, required this.body});

  final int statusCode;
  final String body;
}

class GeminiOcrProvider implements OcrProvider {
  GeminiOcrProvider({
    required this.apiKey,
    GeminiHttpClient? httpClient,
  }) : _httpClient = httpClient ?? const _IoGeminiHttpClient();

  final String apiKey;
  final GeminiHttpClient _httpClient;

  static final Uri endpoint = Uri.https(
    'generativelanguage.googleapis.com',
    '/v1beta/models/gemini-3.5-flash-lite:generateContent',
  );

  @override
  Future<String> extractText({
    required Uint8List documentBytes,
    required String mimeType,
  }) async {
    if (apiKey.trim().isEmpty) throw StateError('Gemini API key is missing.');
    if (mimeType != 'application/pdf' &&
        mimeType != 'image/jpeg' &&
        mimeType != 'image/png') {
      throw ArgumentError('Unsupported OCR media type.');
    }
    final response = await _httpClient.post(
      endpoint,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text':
                    'Extract all readable text from this legal notice. Return only the extracted text. Do not summarize or add commentary.',
              },
              {
                'inline_data': {
                  'mime_type': mimeType,
                  'data': base64Encode(documentBytes),
                },
              },
            ],
          },
        ],
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('Gemini OCR request failed.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid Gemini OCR response.');
    }
    final candidates = decoded['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      throw const FormatException('Gemini OCR response has no candidates.');
    }
    final candidate = candidates.first;
    if (candidate is! Map<String, dynamic>) {
      throw const FormatException('Invalid Gemini OCR candidate.');
    }
    final content = candidate['content'];
    if (content is! Map<String, dynamic>) {
      throw const FormatException('Invalid Gemini OCR content.');
    }
    final parts = content['parts'];
    if (parts is! List) {
      throw const FormatException('Gemini OCR response has no text parts.');
    }
    final text = parts
        .whereType<Map<String, dynamic>>()
        .map((part) => part['text'])
        .whereType<String>()
        .join('\n')
        .trim();
    if (text.isEmpty) {
      throw const FormatException('Gemini OCR returned no text.');
    }
    return text;
  }
}

class _IoGeminiHttpClient implements GeminiHttpClient {
  const _IoGeminiHttpClient();

  @override
  Future<GeminiHttpResponse> post(
    Uri uri, {
    required Map<String, String> headers,
    required String body,
  }) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(uri);
      for (final entry in headers.entries) {
        request.headers.set(entry.key, entry.value);
      }
      request.write(body);
      final response = await request.close();
      return GeminiHttpResponse(
        statusCode: response.statusCode,
        body: await response.transform(utf8.decoder).join(),
      );
    } finally {
      client.close(force: true);
    }
  }
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
