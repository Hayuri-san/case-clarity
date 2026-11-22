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

  test('mock provider returns an offline sample cheque return notice', () async {
    final text = await const MockOcrProvider().extractText(
      documentBytes: Uint8List(0),
      mimeType: 'application/pdf',
    );
    expect(text, contains('05/03/2026'));
    expect(text, contains('10/03/2026'));
    expect(text, contains('11/03/2026'));
    expect(text, contains('18 March 2026'));
  });
}
