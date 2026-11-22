import 'package:case_clarity_server/src/generated/case_clarity_user_profile.dart';
import 'package:case_clarity_server/src/generated/case_stage.dart';
import 'package:case_clarity_server/src/generated/case_type.dart';
import 'package:case_clarity_server/src/generated/case_document.dart';
import 'package:case_clarity_server/src/generated/document_ocr_status.dart';
import 'package:case_clarity_server/src/generated/legal_case.dart';
import 'package:case_clarity_server/src/generated/user_role.dart';
import 'package:case_clarity_server/src/services/legal_guide_seed.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

TestSessionBuilder _user(TestSessionBuilder builder, String id) =>
    builder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(id, {}),
    );

Future<void> _expectUnauthenticated(Future<dynamic> call) async {
  await expectLater(call, throwsA(anything));
}

Future<void> _expectCaseDenied(Future<dynamic> call) async {
  await expectLater(
    call,
    throwsA(
      predicate(
        (error) => error.toString().contains(
          'Case not found or access denied.',
        ),
      ),
    ),
  );
}

Future<void> _expectNotAuthorized(Future<dynamic> call) async {
  await expectLater(
    call,
    throwsA(
      predicate(
        (error) => error.toString().contains('Not authorized for this action.'),
      ),
    ),
  );
}

void main() {
  withServerpod(
    'Given endpoint authorization matrix',
    (sessionBuilder, endpoints) {
      test(
        'when five caller roles use each feature then access follows ownership',
        () async {
          final citizen = _user(
            sessionBuilder,
            '71000000-0000-4000-8000-000000000001',
          );
          final unrelatedCitizen = _user(
            sessionBuilder,
            '71000000-0000-4000-8000-000000000002',
          );
          final assignedLawyer = _user(
            sessionBuilder,
            '71000000-0000-4000-8000-000000000003',
          );
          final unrelatedLawyer = _user(
            sessionBuilder,
            '71000000-0000-4000-8000-000000000004',
          );
          final anonymous = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.unauthenticated(),
          );

          final citizenProfile = await endpoints.profile
              .createOrUpdateMyProfile(citizen, 'Matrix Citizen');
          await endpoints.profile.createOrUpdateMyProfile(
            unrelatedCitizen,
            'Unrelated Citizen',
          );
          final assignedProfile = await endpoints.profile
              .createOrUpdateMyProfile(assignedLawyer, 'Assigned Lawyer');
          final unrelatedLawyerProfile = await endpoints.profile
              .createOrUpdateMyProfile(unrelatedLawyer, 'Unrelated Lawyer');
          final setup = sessionBuilder.build();
          await CaseClarityUserProfile.db.updateRow(
            setup,
            assignedProfile.copyWith(role: UserRole.lawyer),
          );
          await CaseClarityUserProfile.db.updateRow(
            setup,
            unrelatedLawyerProfile.copyWith(role: UserRole.lawyer),
          );
          await seedLegalGuides(setup);

          // Profiles have no user-supplied ID: every signed-in caller reads
          // and changes only their own profile.
          for (final user in [
            citizen,
            unrelatedCitizen,
            assignedLawyer,
            unrelatedLawyer,
          ]) {
            expect(await endpoints.profile.getMyProfile(user), isNotNull);
            expect(
              (await endpoints.profile.createOrUpdateMyProfile(
                user,
                'Updated matrix profile',
              )).userId,
              isNotNull,
            );
          }
          await _expectUnauthenticated(endpoints.profile.getMyProfile(anonymous));
          await _expectUnauthenticated(
            endpoints.profile.createOrUpdateMyProfile(anonymous, 'Anonymous'),
          );

          final legalCase = await endpoints.cases.createCase(
            citizen,
            'Authorization matrix case',
            CaseType.chequeBounce,
            'A case for endpoint access checks.',
          );
          await LegalCase.db.updateRow(
            setup,
            legalCase.copyWith(assignedLawyerId: assignedProfile.userId),
          );

          expect((await endpoints.cases.getCase(citizen, legalCase.id!)).id,
              legalCase.id);
          expect((await endpoints.cases.getCase(assignedLawyer, legalCase.id!)).id,
              legalCase.id);
          await _expectCaseDenied(
            endpoints.cases.getCase(unrelatedCitizen, legalCase.id!),
          );
          await _expectCaseDenied(
            endpoints.cases.getCase(unrelatedLawyer, legalCase.id!),
          );
          await _expectCaseDenied(
            endpoints.cases.getCase(citizen, -999),
          );
          await _expectUnauthenticated(endpoints.cases.listMyCases(anonymous));
          for (final user in [
            citizen,
            unrelatedCitizen,
            assignedLawyer,
            unrelatedLawyer,
          ]) {
            await endpoints.cases.listMyCases(user);
          }
          await _expectUnauthenticated(
            endpoints.cases.createCase(
              anonymous,
              'Anonymous case',
              CaseType.other,
              '',
            ),
          );
          await _expectUnauthenticated(
            endpoints.cases.updateCaseInfo(anonymous, legalCase.id!, 'Title', ''),
          );
          final changedCase = await endpoints.cases.updateCaseInfo(
            citizen,
            legalCase.id!,
            'Updated matrix case',
            'Updated description.',
          );
          expect(changedCase.stage, CaseStage.underReview);
          expect(changedCase.assignedLawyerId, assignedProfile.userId);
          await _expectCaseDenied(
            endpoints.cases.updateCaseInfo(
              unrelatedCitizen,
              legalCase.id!,
              'Intrusion',
              'Unauthorized edit attempt.',
            ),
          );
          await _expectCaseDenied(
            endpoints.cases.updateCaseInfo(
              assignedLawyer,
              legalCase.id!,
              'Intrusion',
              'Unauthorized edit attempt.',
            ),
          );

          // Guides and deadline calculations are available to every signed-in
          // role; anonymous access is rejected.
          for (final user in [
            citizen,
            unrelatedCitizen,
            assignedLawyer,
            unrelatedLawyer,
          ]) {
            expect(await endpoints.legalGuide.listGuides(user), isNotEmpty);
            expect(
              await endpoints.legalGuide.getGuide(user, 'cheque-bounce'),
              isNotNull,
            );
            final result = await endpoints.deadline.calculateSection138(
              user,
              chequeDate: DateTime.utc(2026, 1, 1),
              chequePresentedDate: DateTime.utc(2026, 1, 2),
              dishonourIntimationDate: DateTime.utc(2026, 1, 3),
              noticeSentDate: DateTime.utc(2026, 1, 4),
              noticeReceivedDate: DateTime.utc(2026, 1, 4),
            );
            expect(result.items, isNotEmpty);
          }
          await _expectUnauthenticated(endpoints.legalGuide.listGuides(anonymous));
          await _expectUnauthenticated(
            endpoints.legalGuide.getGuide(anonymous, 'cheque-bounce'),
          );
          await _expectUnauthenticated(
            endpoints.deadline.calculateSection138(
              anonymous,
              chequeDate: DateTime.utc(2026, 1, 1),
              chequePresentedDate: DateTime.utc(2026, 1, 2),
              dishonourIntimationDate: DateTime.utc(2026, 1, 3),
            ),
          );

          // Only the assigned lawyer can write updates or change the stage;
          // both case members can read the timeline.
          final posted = await endpoints.caseUpdate.addUpdate(
            assignedLawyer,
            legalCase.id!,
            'Matrix update',
            'Visible to the case citizen.',
          );
          expect(posted.authorId, assignedProfile.userId);
          final stageChanged = await endpoints.caseUpdate.changeStage(
            assignedLawyer,
            legalCase.id!,
            CaseStage.inProgress,
          );
          expect(stageChanged.stage, CaseStage.inProgress);
          expect(
            (await endpoints.caseUpdate.listUpdates(citizen, legalCase.id!)),
            isNotEmpty,
          );
          expect(
            (await endpoints.caseUpdate.listUpdates(assignedLawyer, legalCase.id!)),
            isNotEmpty,
          );
          await _expectNotAuthorized(
            endpoints.caseUpdate.addUpdate(
              citizen,
              legalCase.id!,
              'Forbidden',
              'Forbidden update attempt.',
            ),
          );
          await _expectNotAuthorized(
            endpoints.caseUpdate.changeStage(
              citizen,
              legalCase.id!,
              CaseStage.resolved,
            ),
          );
          for (final user in [unrelatedCitizen, unrelatedLawyer]) {
            await _expectCaseDenied(
              endpoints.caseUpdate.addUpdate(
                user,
                legalCase.id!,
                'Forbidden',
                'Forbidden update attempt.',
              ),
            );
            await _expectCaseDenied(
              endpoints.caseUpdate.changeStage(
                user,
                legalCase.id!,
                CaseStage.resolved,
              ),
            );
          }
          for (final user in [unrelatedCitizen, unrelatedLawyer]) {
            await _expectCaseDenied(
              endpoints.caseUpdate.listUpdates(user, legalCase.id!),
            );
          }
          await _expectUnauthenticated(
            endpoints.caseUpdate.listUpdates(anonymous, legalCase.id!),
          );
          await _expectUnauthenticated(
            endpoints.caseUpdate.addUpdate(anonymous, legalCase.id!, 'x', 'y'),
          );
          await _expectUnauthenticated(
            endpoints.caseUpdate.changeStage(
              anonymous,
              legalCase.id!,
              CaseStage.resolved,
            ),
          );

          final document = await CaseDocument.db.insertRow(
            setup,
            CaseDocument(
              caseId: legalCase.id!,
              uploaderId: citizenProfile.userId,
              fileName: 'matrix-notice.pdf',
              mimeType: 'application/pdf',
              sizeBytes: 128,
              storagePath: null,
              ocrStatus: DocumentOcrStatus.pending,
            ),
          );
          expect(
            (await endpoints.document.getDocument(citizen, document.id!)).id,
            document.id,
          );
          expect(
            (await endpoints.document.getDocument(assignedLawyer, document.id!)).id,
            document.id,
          );
          expect(await endpoints.document.listDocuments(citizen, legalCase.id!),
              hasLength(1));
          expect(
            await endpoints.document.listDocuments(assignedLawyer, legalCase.id!),
            hasLength(1),
          );
          await _expectCaseDenied(
            endpoints.document.getDocument(unrelatedCitizen, document.id!),
          );
          await _expectCaseDenied(
            endpoints.document.getDocument(unrelatedLawyer, document.id!),
          );
          await _expectCaseDenied(
            endpoints.document.getDocument(citizen, -999),
          );
          await _expectCaseDenied(
            endpoints.document.listDocuments(unrelatedCitizen, legalCase.id!),
          );
          await _expectCaseDenied(
            endpoints.document.listDocuments(unrelatedLawyer, legalCase.id!),
          );
          await _expectUnauthenticated(
            endpoints.document.listDocuments(anonymous, legalCase.id!),
          );
          await _expectUnauthenticated(
            endpoints.document.getDocument(anonymous, document.id!),
          );
          await _expectUnauthenticated(
            endpoints.document.finishUpload(anonymous, document.id!),
          );
          await _expectUnauthenticated(
            endpoints.document.startUpload(
              anonymous,
              legalCase.id!,
              'anonymous.pdf',
              'application/pdf',
              128,
            ),
          );
          await _expectCaseDenied(
            endpoints.document.startUpload(
              unrelatedCitizen,
              legalCase.id!,
              'other.pdf',
              'application/pdf',
              128,
            ),
          );
          await _expectCaseDenied(
            endpoints.document.startUpload(
              assignedLawyer,
              legalCase.id!,
              'lawyer.pdf',
              'application/pdf',
              128,
            ),
          );
          await _expectCaseDenied(
            endpoints.document.startUpload(
              unrelatedLawyer,
              legalCase.id!,
              'other-lawyer.pdf',
              'application/pdf',
              128,
            ),
          );
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
