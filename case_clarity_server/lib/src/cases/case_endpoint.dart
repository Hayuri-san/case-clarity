import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/case_clarity_user_profile.dart';
import '../generated/case_stage.dart';
import '../generated/case_type.dart';
import '../generated/legal_case.dart';
import '../generated/user_role.dart';
import '../services/authorization.dart';

class CasesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<LegalCase> createCase(
    Session session,
    String title,
    CaseType caseType,
    String description,
  ) async {
    final signedIn = await Authorization.requireRole(session, UserRole.citizen);
    _validateCaseFields(title, description);

    UuidValue? assignedLawyerId;
    final demoAutoAssign =
        session.server.runMode == 'development' &&
        Platform.environment['DEMO_AUTO_ASSIGN']?.toLowerCase() != 'false';
    if (demoAutoAssign) {
      final lawyer = await CaseClarityUserProfile.db.findFirstRow(
        session,
        where: (t) => t.role.equals(UserRole.lawyer),
        orderByList: (t) => [t.createdAt.asc(), t.id.asc()],
      );
      assignedLawyerId = lawyer?.userId;
    }

    return LegalCase.db.insertRow(
      session,
      LegalCase(
        title: title.trim(),
        caseType: caseType,
        description: description.trim(),
        stage: CaseStage.underReview,
        creatorId: signedIn.userId,
        assignedLawyerId: assignedLawyerId,
      ),
    );
  }

  Future<List<LegalCase>> listMyCases(Session session) async {
    final signedIn = await Authorization.getSignedInUserAndProfile(session);
    return switch (signedIn.profile.role) {
      UserRole.citizen => LegalCase.db.find(
        session,
        where: (t) => t.creatorId.equals(signedIn.userId),
        orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
      ),
      UserRole.lawyer => LegalCase.db.find(
        session,
        where: (t) => t.assignedLawyerId.equals(signedIn.userId),
        orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
      ),
    };
  }

  Future<LegalCase> getCase(Session session, int id) async {
    return (await Authorization.requireCaseAccess(session, id)).legalCase;
  }

  Future<LegalCase> updateCaseInfo(
    Session session,
    int id,
    String title,
    String description,
  ) async {
    final signedIn = await Authorization.getSignedInUserAndProfile(session);
    final legalCase = await LegalCase.db.findById(session, id);
    if (legalCase == null ||
        signedIn.profile.role != UserRole.citizen ||
        legalCase.creatorId != signedIn.userId) {
      throw Exception(Authorization.caseUnavailableMessage);
    }
    _validateCaseFields(title, description);
    return LegalCase.db.updateRow(
      session,
      legalCase.copyWith(
        title: title.trim(),
        description: description.trim(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  void _validateCaseFields(String title, String description) {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty || normalizedTitle.length > 120) {
      throw ArgumentError('Title must be between 1 and 120 characters.');
    }
    if (description.length > 2000) {
      throw ArgumentError('Description must be at most 2000 characters.');
    }
  }
}
