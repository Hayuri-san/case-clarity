import 'package:case_clarity_server/src/generated/case_clarity_user_profile.dart';
import 'package:case_clarity_server/src/generated/case_stage.dart';
import 'package:case_clarity_server/src/generated/case_type.dart';
import 'package:case_clarity_server/src/generated/case_update.dart';
import 'package:case_clarity_server/src/generated/case_update_kind.dart';
import 'package:case_clarity_server/src/generated/legal_case.dart';
import 'package:case_clarity_server/src/generated/user_role.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

TestSessionBuilder asUser(TestSessionBuilder builder, String userId) {
  return builder.copyWith(
    authentication: AuthenticationOverride.authenticationInfo(userId, {}),
  );
}

Future<CaseClarityUserProfile> createProfile(
  TestEndpoints endpoints,
  TestSessionBuilder sessionBuilder,
  String name,
) {
  return endpoints.profile.createOrUpdateMyProfile(sessionBuilder, name);
}

Future<CaseClarityUserProfile> createLawyerProfile(
  TestEndpoints endpoints,
  TestSessionBuilder sessionBuilder,
  String name,
) async {
  final profile = await createProfile(endpoints, sessionBuilder, name);
  return CaseClarityUserProfile.db.updateRow(
    sessionBuilder.build(),
    profile.copyWith(role: UserRole.lawyer),
  );
}

Future<void> expectRejected(Future<dynamic> call) async {
  await expectLater(call, throwsA(anything));
}

void main() {
  withServerpod('Given Case Clarity endpoints', (sessionBuilder, endpoints) {
    test('when anonymous then profile access is rejected', () async {
      final anonymous = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );

      final protectedCalls = <Future<dynamic> Function()>[
        () => endpoints.profile.getMyProfile(anonymous),
        () => endpoints.profile.createOrUpdateMyProfile(anonymous, 'Anonymous'),
        () => endpoints.cases.createCase(
          anonymous,
          'Anonymous case',
          CaseType.other,
          '',
        ),
        () => endpoints.cases.listMyCases(anonymous),
        () => endpoints.cases.getCase(anonymous, 1),
        () => endpoints.cases.updateCaseInfo(anonymous, 1, 'Title', ''),
        () => endpoints.caseUpdate.addUpdate(anonymous, 1, 'Title', ''),
        () => endpoints.caseUpdate.changeStage(
          anonymous,
          1,
          CaseStage.inProgress,
        ),
        () => endpoints.caseUpdate.listUpdates(anonymous, 1),
      ];

      for (final call in protectedCalls) {
        await expectLater(
          call(),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      }
    });

    test('when development endpoints run outside development then all calls are rejected', () async {
      final anonymous = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );
      await expectRejected(
        endpoints.dev.promoteToLawyer(anonymous, 'lawyer@example.com'),
      );
      await expectRejected(
        endpoints.dev.seedDemoData(
          anonymous,
          'citizen@example.com',
          'lawyer@example.com',
        ),
      );
    });

    test('when users read and update profiles then each can change only their own', () async {
      final alice = asUser(
        sessionBuilder,
        '10000000-0000-4000-8000-000000000001',
      );
      final bob = asUser(
        sessionBuilder,
        '10000000-0000-4000-8000-000000000002',
      );

      final aliceProfile = await createProfile(endpoints, alice, 'Alice');
      final bobProfile = await createProfile(endpoints, bob, 'Bob');
      expect(aliceProfile.role, UserRole.citizen);
      expect(bobProfile.role, UserRole.citizen);

      final updatedAlice = await endpoints.profile.createOrUpdateMyProfile(
        alice,
        'Alice Updated',
      );
      final aliceReadBack = await endpoints.profile.getMyProfile(alice);
      final bobReadBack = await endpoints.profile.getMyProfile(bob);

      expect(updatedAlice.fullName, 'Alice Updated');
      expect(aliceReadBack?.fullName, 'Alice Updated');
      expect(aliceReadBack?.role, UserRole.citizen);
      expect(bobReadBack?.fullName, 'Bob');
      expect(bobReadBack?.role, UserRole.citizen);
    });

    test('when a citizen creates cases then listing returns only their cases', () async {
      final alice = asUser(
        sessionBuilder,
        '20000000-0000-4000-8000-000000000001',
      );
      final bob = asUser(
        sessionBuilder,
        '20000000-0000-4000-8000-000000000002',
      );
      await createProfile(endpoints, alice, 'Alice');
      await createProfile(endpoints, bob, 'Bob');

      final created = await endpoints.cases.createCase(
        alice,
        'Cheque case',
        CaseType.chequeBounce,
        'A description',
      );
      await endpoints.cases.createCase(
        bob,
        'Consumer case',
        CaseType.consumerComplaint,
        'Another description',
      );

      final aliceCases = await endpoints.cases.listMyCases(alice);
      expect(created.stage, CaseStage.underReview);
      expect(aliceCases, hasLength(1));
      expect(aliceCases.single.id, created.id);
    });

    test('when unrelated citizens and lawyers or the case citizen post then case access is rejected', () async {
      final citizen = asUser(
        sessionBuilder,
        '30000000-0000-4000-8000-000000000001',
      );
      final assignedLawyer = asUser(
        sessionBuilder,
        '30000000-0000-4000-8000-000000000002',
      );
      final otherCitizen = asUser(
        sessionBuilder,
        '30000000-0000-4000-8000-000000000003',
      );
      final otherLawyer = asUser(
        sessionBuilder,
        '30000000-0000-4000-8000-000000000004',
      );
      await createProfile(endpoints, citizen, 'Citizen');
      final assignedProfile = await createLawyerProfile(
        endpoints,
        assignedLawyer,
        'Assigned Lawyer',
      );
      await createProfile(endpoints, otherCitizen, 'Other Citizen');
      await createLawyerProfile(endpoints, otherLawyer, 'Other Lawyer');

      final created = await endpoints.cases.createCase(
        citizen,
        'Assigned matter',
        CaseType.other,
        'Description',
      );
      final legalCase = await LegalCase.db.updateRow(
        sessionBuilder.build(),
        created.copyWith(assignedLawyerId: assignedProfile.userId),
      );
      final deniedUsers = [otherCitizen, otherLawyer];

      for (final deniedUser in deniedUsers) {
        await expectRejected(endpoints.cases.getCase(deniedUser, legalCase.id!));
        await expectRejected(
          endpoints.caseUpdate.listUpdates(deniedUser, legalCase.id!),
        );
        await expectRejected(
          endpoints.caseUpdate.addUpdate(
            deniedUser,
            legalCase.id!,
            'Blocked update',
            'Description',
          ),
        );
        await expectRejected(
          endpoints.caseUpdate.changeStage(
            deniedUser,
            legalCase.id!,
            CaseStage.inProgress,
          ),
        );
      }

      await expectRejected(
        endpoints.caseUpdate.addUpdate(
          citizen,
          legalCase.id!,
          'Citizen update',
          'Description',
        ),
      );
      await expectRejected(
        endpoints.caseUpdate.changeStage(
          citizen,
          legalCase.id!,
          CaseStage.inProgress,
        ),
      );
    });

    test('when the assigned lawyer posts and changes stage then updates are oldest first', () async {
      final citizen = asUser(
        sessionBuilder,
        '40000000-0000-4000-8000-000000000001',
      );
      final lawyer = asUser(
        sessionBuilder,
        '40000000-0000-4000-8000-000000000002',
      );
      await createProfile(endpoints, citizen, 'Citizen');
      final lawyerProfile = await createLawyerProfile(endpoints, lawyer, 'Lawyer');

      final created = await endpoints.cases.createCase(
        citizen,
        'Timeline matter',
        CaseType.cyberFraud,
        'Description',
      );
      final legalCase = await LegalCase.db.updateRow(
        sessionBuilder.build(),
        created.copyWith(assignedLawyerId: lawyerProfile.userId),
      );

      for (final entry in [
        (title: 'Late seeded update', date: DateTime.utc(2025, 1, 3)),
        (title: 'Early seeded update', date: DateTime.utc(2025, 1, 1)),
        (title: 'Middle seeded update', date: DateTime.utc(2025, 1, 2)),
      ]) {
        await CaseUpdate.db.insertRow(
          sessionBuilder.build(),
          CaseUpdate(
            caseId: legalCase.id!,
            authorId: lawyerProfile.userId,
            kind: CaseUpdateKind.lawyerUpdate,
            title: entry.title,
            description: 'Seeded for ordering check',
            createdAt: entry.date,
          ),
        );
      }

      await endpoints.caseUpdate.addUpdate(
        lawyer,
        legalCase.id!,
        'Lawyer update',
        'A progress update',
      );
      final changed = await endpoints.caseUpdate.changeStage(
        lawyer,
        legalCase.id!,
        CaseStage.inProgress,
      );
      final updates = await endpoints.caseUpdate.listUpdates(
        citizen,
        legalCase.id!,
      );

      expect(changed.stage, CaseStage.inProgress);
      expect(updates.map((update) => update.title).toList(), [
        'Early seeded update',
        'Middle seeded update',
        'Late seeded update',
        'Lawyer update',
        'Stage changed to In Progress',
      ]);
      expect(updates.last.kind, CaseUpdateKind.stageChange);
      expect(updates.last.authorId, lawyerProfile.userId);
      expect(updates.map((update) => update.createdAt), orderedEquals(
        updates.map((update) => update.createdAt).toList()..sort(),
      ));
    });

    test('when the creating citizen updates case info then stage and assignment stay unchanged', () async {
      final citizen = asUser(
        sessionBuilder,
        '50000000-0000-4000-8000-000000000001',
      );
      final lawyer = asUser(
        sessionBuilder,
        '50000000-0000-4000-8000-000000000002',
      );
      final otherCitizen = asUser(
        sessionBuilder,
        '50000000-0000-4000-8000-000000000003',
      );
      await createProfile(endpoints, citizen, 'Creating Citizen');
      final lawyerProfile = await createLawyerProfile(endpoints, lawyer, 'Lawyer');
      await createProfile(endpoints, otherCitizen, 'Other Citizen');

      final created = await endpoints.cases.createCase(
        citizen,
        'Original title',
        CaseType.other,
        'Original description',
      );
      await LegalCase.db.updateRow(
        sessionBuilder.build(),
        created.copyWith(
          assignedLawyerId: lawyerProfile.userId,
          stage: CaseStage.awaitingDocuments,
        ),
      );

      final updated = await endpoints.cases.updateCaseInfo(
        citizen,
        created.id!,
        'Revised title',
        'Revised description',
      );
      expect(updated.title, 'Revised title');
      expect(updated.description, 'Revised description');
      expect(updated.stage, CaseStage.awaitingDocuments);
      expect(updated.assignedLawyerId, lawyerProfile.userId);

      await expectRejected(
        endpoints.cases.updateCaseInfo(
          lawyer,
          created.id!,
          'Lawyer title',
          'Description',
        ),
      );
      await expectRejected(
        endpoints.cases.updateCaseInfo(
          otherCitizen,
          created.id!,
          'Other title',
          'Description',
        ),
      );
    });
  });
}
