import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/case_clarity_user_profile.dart';
import '../generated/case_stage.dart';
import '../generated/case_type.dart';
import '../generated/case_update.dart';
import '../generated/case_update_kind.dart';
import '../generated/legal_case.dart';
import '../generated/user_role.dart';

class DevEndpoint extends Endpoint {
  Future<CaseClarityUserProfile> promoteToLawyer(
    Session session,
    String email,
  ) async {
    _requireDevelopment(session);
    final authProfile = await _findAuthProfile(session, email);
    final profile = await CaseClarityUserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(authProfile.authUserId),
    );
    if (profile == null) {
      return CaseClarityUserProfile.db.insertRow(
        session,
        CaseClarityUserProfile(
          userId: authProfile.authUserId,
          fullName: _displayName(authProfile.fullName, authProfile.email!),
          role: UserRole.lawyer,
        ),
      );
    }
    if (profile.role == UserRole.lawyer) return profile;
    return CaseClarityUserProfile.db.updateRow(
      session,
      profile.copyWith(role: UserRole.lawyer),
    );
  }

  Future<LegalCase> seedDemoData(
    Session session,
    String citizenEmail,
    String lawyerEmail,
  ) async {
    _requireDevelopment(session);
    final citizenAuth = await _findAuthProfile(session, citizenEmail);
    final lawyerAuth = await _findAuthProfile(session, lawyerEmail);
    if (citizenAuth.authUserId == lawyerAuth.authUserId) {
      throw ArgumentError('Citizen and lawyer must be different users.');
    }

    final citizen = await _getOrCreateProfile(
      session,
      citizenAuth,
      UserRole.citizen,
    );
    final lawyer = await CaseClarityUserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(lawyerAuth.authUserId),
    );
    if (lawyer == null || lawyer.role != UserRole.lawyer) {
      throw StateError('Promote the lawyer with promoteToLawyer first.');
    }

    const sampleTitle = 'Demo consumer complaint';
    final existingCase = await LegalCase.db.findFirstRow(
      session,
      where: (t) =>
          t.creatorId.equals(citizen.userId) & t.title.equals(sampleTitle),
    );
    if (existingCase != null) return existingCase;

    return session.db.transaction((transaction) async {
      final now = DateTime.now();
      final legalCase = await LegalCase.db.insertRow(
        session,
        LegalCase(
          title: sampleTitle,
          caseType: CaseType.consumerComplaint,
          description: 'Sample data for local development.',
          stage: CaseStage.inProgress,
          creatorId: citizen.userId,
          assignedLawyerId: lawyer.userId,
        ),
        transaction: transaction,
      );

      await CaseUpdate.db.insert(
        session,
        [
          CaseUpdate(
            caseId: legalCase.id!,
            authorId: lawyer.userId,
            kind: CaseUpdateKind.lawyerUpdate,
            title: 'Initial review completed',
            description: 'The lawyer reviewed the complaint.',
            createdAt: now,
          ),
          CaseUpdate(
            caseId: legalCase.id!,
            authorId: lawyer.userId,
            kind: CaseUpdateKind.stageChange,
            title: 'Stage changed to In Progress',
            description: 'The case moved from Under Review to In Progress.',
            createdAt: now.add(const Duration(milliseconds: 1)),
          ),
        ],
        transaction: transaction,
      );
      return legalCase;
    });
  }

  Future<CaseClarityUserProfile> _getOrCreateProfile(
    Session session,
    UserProfileModel authProfile,
    UserRole role,
  ) async {
    final profile = await CaseClarityUserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(authProfile.authUserId),
    );
    if (profile != null) {
      if (profile.role != role) {
        throw StateError(
          'The selected citizen already has a non-citizen role.',
        );
      }
      return profile;
    }

    return CaseClarityUserProfile.db.insertRow(
      session,
      CaseClarityUserProfile(
        userId: authProfile.authUserId,
        fullName: _displayName(authProfile.fullName, authProfile.email!),
        role: role,
      ),
    );
  }

  Future<UserProfileModel> _findAuthProfile(
    Session session,
    String email,
  ) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      throw ArgumentError('Email must not be empty.');
    }
    final profiles = await AuthServices.instance.userProfiles.admin
        .listUserProfiles(session, email: normalizedEmail, limit: 2);
    if (profiles.length != 1) {
      throw StateError('No unique signed-up user was found for that email.');
    }
    return profiles.single;
  }

  String _displayName(String? fullName, String email) {
    final name = fullName?.trim();
    return name == null || name.isEmpty ? email : name;
  }

  void _requireDevelopment(Session session) {
    if (session.server.runMode != 'development') {
      throw StateError('This endpoint is available only in development mode.');
    }
  }
}
