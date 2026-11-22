import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:case_clarity_server/src/generated/case_clarity_user_profile.dart';
import 'package:case_clarity_server/src/generated/case_document.dart';
import 'package:case_clarity_server/src/generated/case_stage.dart';
import 'package:case_clarity_server/src/generated/case_type.dart';
import 'package:case_clarity_server/src/generated/case_update_kind.dart';
import 'package:case_clarity_server/src/generated/document_ocr_status.dart';
import 'package:case_clarity_server/src/generated/legal_case.dart';
import 'package:case_clarity_server/src/generated/user_role.dart';
import 'package:case_clarity_server/src/documents/document_endpoint.dart';
import 'package:case_clarity_server/src/services/ocr_service.dart';
import 'package:case_clarity_server/src/services/legal_guide_seed.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _pdfBytes = <int>[37, 80, 68, 70, 45, 49, 46, 55, 10];
const _pngBytes = <int>[137, 80, 78, 71, 13, 10, 26, 10, 0];

TestSessionBuilder _asUser(TestSessionBuilder builder, String userId) =>
    builder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(userId, {}),
    );

Future<void> _createProfile(
  TestEndpoints endpoints,
  TestSessionBuilder user,
  String name,
) async {
  await endpoints.profile.createOrUpdateMyProfile(user, name);
}

Future<LegalCase> _createCase(
  TestEndpoints endpoints,
  TestSessionBuilder citizen,
) async {
  return endpoints.cases.createCase(
    citizen,
    'Upload test case',
    CaseType.chequeBounce,
    'Test case for private document upload.',
  );
}

Future<int> _uploadBinary(String description, List<int> bytes) async {
  final url = Uri.parse((jsonDecode(description) as Map)['url'] as String);
  final client = HttpClient();
  try {
    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.binary;
    request.contentLength = bytes.length;
    request.add(bytes);
    final response = await request.close();
    await response.drain<void>();
    return response.statusCode;
  } finally {
    client.close(force: true);
  }
}

Future<void> _expectCaseUnavailable(Future<dynamic> call) async {
  await expectLater(
    call,
    throwsA(
      predicate(
        (error) => error.toString().contains('Case not found or access denied.'),
      ),
    ),
  );
}

Future<CaseDocument> _waitForOcr(
  TestEndpoints endpoints,
  TestSessionBuilder user,
  int documentId,
) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    final document = await endpoints.document.getDocument(user, documentId);
    if (document.ocrStatus == DocumentOcrStatus.completed ||
        document.ocrStatus == DocumentOcrStatus.failed) {
      return document;
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
  throw TimeoutException('OCR did not finish within the test wait period.');
}

class _FailingOcrProvider implements OcrProvider {
  @override
  Future<String> extractText({
    required Uint8List documentBytes,
    required String mimeType,
  }) async {
    throw StateError('Private provider diagnostic that must not be returned.');
  }
}

void main() {
  withServerpod(
    'Given Case Clarity document uploads',
    (sessionBuilder, endpoints) {
      test('citizen uploads a valid PDF and gets a processing document', () async {
        final citizen = _asUser(
          sessionBuilder,
          '70000000-0000-4000-8000-000000000001',
        );
        await _createProfile(endpoints, citizen, 'Upload Citizen');
        final legalCase = await _createCase(endpoints, citizen);

        final ticket = await endpoints.document.startUpload(
          citizen,
          legalCase.id!,
          'notice.pdf',
          'application/pdf',
          _pdfBytes.length,
        );
        expect(await _uploadBinary(ticket.uploadDescription, _pdfBytes), anyOf(200, 204));

        final document = await endpoints.document.finishUpload(
          citizen,
          ticket.documentId,
        );
        expect(document.ocrStatus, DocumentOcrStatus.processing);
        expect(document.sizeBytes, _pdfBytes.length);
        expect((await endpoints.document.getDocument(citizen, document.id!)).id,
            document.id);

        final completed = await _waitForOcr(
          endpoints,
          citizen,
          document.id!,
        );
        expect(completed.ocrStatus, DocumentOcrStatus.completed);
        expect(completed.extractedText, isNotEmpty);
        expect(completed.candidateDates, isNotEmpty);
      });

      test('runs the cheque notice demo flow across citizen and lawyer access', () async {
        final citizen = _asUser(
          sessionBuilder,
          '70000000-0000-4000-8000-000000000020',
        );
        final lawyer = _asUser(
          sessionBuilder,
          '70000000-0000-4000-8000-000000000021',
        );
        await _createProfile(endpoints, citizen, 'Demo Citizen');
        final lawyerProfile = await endpoints.profile.createOrUpdateMyProfile(
          lawyer,
          'Demo Lawyer',
        );
        final setup = sessionBuilder.build();
        await CaseClarityUserProfile.db.updateRow(
          setup,
          lawyerProfile.copyWith(role: UserRole.lawyer),
        );
        await seedLegalGuides(setup);

        final guide = await endpoints.legalGuide.getGuide(
          citizen,
          'cheque-bounce',
        );
        expect(guide.title, isNotEmpty);
        final createdCase = await endpoints.cases.createCase(
          citizen,
          'Cheque return notice',
          CaseType.chequeBounce,
          'The bank returned the cheque unpaid.',
        );
        await LegalCase.db.updateRow(
          setup,
          createdCase.copyWith(assignedLawyerId: lawyerProfile.userId),
        );

        final ticket = await endpoints.document.startUpload(
          citizen,
          createdCase.id!,
          'cheque-return-notice.pdf',
          'application/pdf',
          _pdfBytes.length,
        );
        expect(await _uploadBinary(ticket.uploadDescription, _pdfBytes), anyOf(200, 204));
        await endpoints.document.finishUpload(citizen, ticket.documentId);
        final document = await _waitForOcr(
          endpoints,
          citizen,
          ticket.documentId,
        );
        expect(document.ocrStatus, DocumentOcrStatus.completed);
        expect(document.extractedText, isNotEmpty);
        expect(document.candidateDates, hasLength(greaterThanOrEqualTo(4)));

        DateTime confirmedDate(String value) {
          final parts = value.split(RegExp(r'[/\-]'));
          if (parts.length == 3) {
            return DateTime.utc(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );
          }

          final namedDate = RegExp(
            r'^(\d{1,2})\s+([A-Za-z]+)\s+(\d{4})$',
          ).firstMatch(value.trim());
          if (namedDate != null) {
            const months = {
              'january': 1,
              'february': 2,
              'march': 3,
              'april': 4,
              'may': 5,
              'june': 6,
              'july': 7,
              'august': 8,
              'september': 9,
              'october': 10,
              'november': 11,
              'december': 12,
            };
            final month = months[namedDate.group(2)!.toLowerCase()];
            if (month != null) {
              return DateTime.utc(
                int.parse(namedDate.group(3)!),
                month,
                int.parse(namedDate.group(1)!),
              );
            }
          }
          throw FormatException('Unsupported OCR date suggestion.', value);
        }

        final suggestions = document.candidateDates!;
        final deadlines = await endpoints.deadline.calculateSection138(
          citizen,
          chequeDate: confirmedDate(suggestions[0]),
          chequePresentedDate: confirmedDate(suggestions[1]),
          dishonourIntimationDate: confirmedDate(suggestions[2]),
          noticeSentDate: confirmedDate(suggestions[3]),
          noticeReceivedDate: confirmedDate(suggestions[3]),
        );
        expect(deadlines.items, isNotEmpty);
        expect(deadlines.disclaimer, contains('not legal advice'));

        expect(
          (await endpoints.cases.getCase(lawyer, createdCase.id!)).id,
          createdCase.id,
        );
        final changedCase = await endpoints.caseUpdate.changeStage(
          lawyer,
          createdCase.id!,
          CaseStage.inProgress,
        );
        expect(changedCase.stage, CaseStage.inProgress);
        await endpoints.caseUpdate.addUpdate(
          lawyer,
          createdCase.id!,
          'Notice reviewed',
          'The confirmed notice dates were reviewed.',
        );
        final timeline = await endpoints.caseUpdate.listUpdates(
          citizen,
          createdCase.id!,
        );
        expect(timeline.map((update) => update.kind), contains(CaseUpdateKind.stageChange));
        expect(timeline.last.title, 'Notice reviewed');
        expect(
          timeline.map((update) => update.createdAt),
          orderedEquals(
            timeline.map((update) => update.createdAt).toList()..sort(),
          ),
        );
      });

      test('rejects uploaded bytes whose signature differs from PDF metadata', () async {
        final citizen = _asUser(
          sessionBuilder,
          '70000000-0000-4000-8000-000000000002',
        );
        await _createProfile(endpoints, citizen, 'Signature Citizen');
        final legalCase = await _createCase(endpoints, citizen);
        final ticket = await endpoints.document.startUpload(
          citizen,
          legalCase.id!,
          'notice.pdf',
          'application/pdf',
          _pngBytes.length,
        );
        expect(await _uploadBinary(ticket.uploadDescription, _pngBytes), anyOf(200, 204));

        await expectLater(
          endpoints.document.finishUpload(citizen, ticket.documentId),
          throwsA(anything),
        );
      });

      test('rejects uploads larger than the configured 5 MiB limit', () async {
        final citizen = _asUser(
          sessionBuilder,
          '70000000-0000-4000-8000-000000000003',
        );
        await _createProfile(endpoints, citizen, 'Size Citizen');
        final legalCase = await _createCase(endpoints, citizen);

        await expectLater(
          endpoints.document.startUpload(
            citizen,
            legalCase.id!,
            'large.pdf',
            'application/pdf',
            maxDocumentSizeBytes + 1,
          ),
          throwsA(anything),
        );
        expect(await endpoints.document.listDocuments(citizen, legalCase.id!), isEmpty);
      });

      test('only the case citizen uploads and case members view documents', () async {
        final citizen = _asUser(
          sessionBuilder,
          '70000000-0000-4000-8000-000000000004',
        );
        final lawyer = _asUser(
          sessionBuilder,
          '70000000-0000-4000-8000-000000000005',
        );
        final unrelated = _asUser(
          sessionBuilder,
          '70000000-0000-4000-8000-000000000006',
        );
        await _createProfile(endpoints, citizen, 'Owner Citizen');
        final lawyerProfile = await endpoints.profile.createOrUpdateMyProfile(
          lawyer,
          'Assigned Lawyer',
        );
        await _createProfile(endpoints, unrelated, 'Unrelated Citizen');
        await CaseClarityUserProfile.db.updateRow(
          sessionBuilder.build(),
          lawyerProfile.copyWith(role: UserRole.lawyer),
        );
        final created = await _createCase(endpoints, citizen);
        await LegalCase.db.updateRow(
          sessionBuilder.build(),
          created.copyWith(assignedLawyerId: lawyerProfile.userId),
        );

        final ticket = await endpoints.document.startUpload(
          citizen,
          created.id!,
          'notice.pdf',
          'application/pdf',
          _pdfBytes.length,
        );
        final pending = await endpoints.document.getDocument(
          citizen,
          ticket.documentId,
        );

        await _expectCaseUnavailable(
          endpoints.document.startUpload(
            lawyer,
            created.id!,
            'lawyer.pdf',
            'application/pdf',
            _pdfBytes.length,
          ),
        );
        await _expectCaseUnavailable(
          endpoints.document.getDocument(unrelated, pending.id!),
        );
        await _expectCaseUnavailable(
          endpoints.document.listDocuments(unrelated, created.id!),
        );
        final anonymous = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.unauthenticated(),
        );
        await expectLater(
          endpoints.document.getDocument(anonymous, pending.id!),
          throwsA(anything),
        );
        await expectLater(
          endpoints.document.finishUpload(anonymous, pending.id!),
          throwsA(anything),
        );
        expect(await endpoints.document.getDocument(lawyer, pending.id!), isNotNull);
        expect(await endpoints.document.listDocuments(lawyer, created.id!), hasLength(1));
      });

      test('records only a safe failure message when OCR provider fails', () async {
        final citizen = _asUser(
          sessionBuilder,
          '70000000-0000-4000-8000-000000000007',
        );
        await _createProfile(endpoints, citizen, 'OCR Failure Citizen');
        final legalCase = await _createCase(endpoints, citizen);
        const storagePath = 'case-documents/ocr-failure-test.pdf';
        final session = citizen.build();
        await session.storage.storeFile(
          storageId: 'private',
          path: storagePath,
          byteData: ByteData.sublistView(Uint8List.fromList(_pdfBytes)),
        );
        final inserted = await CaseDocument.db.insertRow(
          session,
          CaseDocument(
            caseId: legalCase.id!,
            uploaderId: UuidValue.fromString(
              session.authenticated!.userIdentifier,
            ),
            fileName: 'notice.pdf',
            mimeType: 'application/pdf',
            sizeBytes: _pdfBytes.length,
            storagePath: storagePath,
            ocrStatus: DocumentOcrStatus.processing,
          ),
        );

        await OcrService(_FailingOcrProvider()).processDocument(
          session,
          inserted.id!,
        );
        final failed = await endpoints.document.getDocument(citizen, inserted.id!);
        expect(failed.ocrStatus, DocumentOcrStatus.failed);
        expect(failed.extractedText, isNull);
        expect(failed.errorMessage, 'OCR processing failed. Please try again later.');
        expect(failed.errorMessage, isNot(contains('Private provider diagnostic')));
      });

      test('detects PDF, JPG, and PNG by file signature', () {
        expect(
          documentMimeTypeFromMagicBytes(
            ByteData.sublistView(Uint8List.fromList(_pdfBytes)),
          ),
          'application/pdf',
        );
        expect(
          documentMimeTypeFromMagicBytes(
            ByteData.sublistView(Uint8List.fromList([0xff, 0xd8, 0xff, 0xd9])),
          ),
          'image/jpeg',
        );
        expect(
          documentMimeTypeFromMagicBytes(
            ByteData.sublistView(Uint8List.fromList(_pngBytes)),
          ),
          'image/png',
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
