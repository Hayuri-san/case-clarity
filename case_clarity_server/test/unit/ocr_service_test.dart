import 'dart:typed_data';

import 'package:case_clarity_server/src/services/ocr_service.dart';
import 'package:test/test.dart';

void main() {
  test('extracts supported candidate date formats in text order', () {
    final dates = extractCandidateDates(
      '05/03/2026 then 06-03-2026, then 12 March 2026; '
      'repeat 05/03/2026 and ignore 2026-03-12.',
    );
    expect(dates, ['05/03/2026', '06-03-2026', '12 March 2026']);
  });

  test(
    'mock provider returns an offline sample cheque return notice',
    () async {
      final text = await const MockOcrProvider().extractText(
        documentBytes: Uint8List(0),
        mimeType: 'application/pdf',
      );
      expect(text, contains('05/03/2026'));
      expect(text, contains('10/03/2026'));
      expect(text, contains('11/03/2026'));
      expect(text, contains('18 March 2026'));
    },
  );

  test('Gemini provider sends inline media and extracts response text', () async {
    final fake = _FakeGeminiHttpClient(
      GeminiHttpResponse(
        statusCode: 200,
        body:
            '{"candidates":[{"content":{"parts":[{"text":"Cheque date: 05/03/2026"},{"text":"Notice sent: 18 March 2026"}]}}]}',
      ),
    );
    final provider = GeminiOcrProvider(apiKey: 'test-key', httpClient: fake);

    final text = await provider.extractText(
      documentBytes: Uint8List.fromList([1, 2, 3]),
      mimeType: 'image/jpeg',
    );

    expect(text, 'Cheque date: 05/03/2026\nNotice sent: 18 March 2026');
    expect(fake.uri, GeminiOcrProvider.endpoint);
    expect(fake.headers?['x-goog-api-key'], 'test-key');
    expect(fake.body, contains('"mime_type":"image/jpeg"'));
    expect(fake.body, contains('"data":"AQID"'));
    expect(fake.body, contains('Return only the extracted text'));
  });

  test('Gemini provider rejects unsuccessful responses safely', () async {
    final provider = GeminiOcrProvider(
      apiKey: 'test-key',
      httpClient: _FakeGeminiHttpClient(
        const GeminiHttpResponse(
          statusCode: 503,
          body: 'private provider detail',
        ),
      ),
    );

    await expectLater(
      provider.extractText(
        documentBytes: Uint8List.fromList([1]),
        mimeType: 'image/png',
      ),
      throwsA(isA<StateError>()),
    );
  });
}

class _FakeGeminiHttpClient implements GeminiHttpClient {
  _FakeGeminiHttpClient(this.response);

  final GeminiHttpResponse response;
  Uri? uri;
  Map<String, String>? headers;
  String? body;

  @override
  Future<GeminiHttpResponse> post(
    Uri uri, {
    required Map<String, String> headers,
    required String body,
  }) async {
    this.uri = uri;
    this.headers = headers;
    this.body = body;
    return response;
  }
}
