import 'package:serverpod/serverpod.dart';

import '../generated/case_stage.dart';
import '../generated/case_update.dart';
import '../generated/case_update_kind.dart';
import '../generated/legal_case.dart';
import '../generated/user_role.dart';
import '../services/authorization.dart';

class CaseUpdateEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<CaseUpdate> addUpdate(
    Session session,
    int caseId,
    String title,
    String description,
  ) async {
    final signedIn = await Authorization.getSignedInUserAndProfile(session);
    final access = await Authorization.requireCaseAccess(session, caseId);
    if (signedIn.profile.role != UserRole.lawyer) {
      throw Exception('Not authorized for this action.');
    }
    if (access.legalCase.assignedLawyerId != signedIn.userId) {
      throw Exception(Authorization.caseUnavailableMessage);
    }
    _validateFields(title, description);
    return CaseUpdate.db.insertRow(
      session,
      CaseUpdate(
        caseId: caseId,
        authorId: signedIn.userId,
        kind: CaseUpdateKind.lawyerUpdate,
        title: title.trim(),
        description: description.trim(),
      ),
    );
  }

  Future<LegalCase> changeStage(
    Session session,
    int caseId,
    CaseStage stage,
  ) async {
    final signedIn = await Authorization.getSignedInUserAndProfile(session);
    final access = await Authorization.requireCaseAccess(session, caseId);
    if (signedIn.profile.role != UserRole.lawyer) {
      throw Exception('Not authorized for this action.');
    }
    final legalCase = access.legalCase;
    if (legalCase.assignedLawyerId != signedIn.userId) {
      throw Exception(Authorization.caseUnavailableMessage);
    }

    final oldStageLabel = _stageLabel(legalCase.stage);
    final newStageLabel = _stageLabel(stage);
    return session.db.transaction((transaction) async {
      final updatedCase = await LegalCase.db.updateRow(
        session,
        legalCase.copyWith(stage: stage, updatedAt: DateTime.now()),
        transaction: transaction,
      );
      await CaseUpdate.db.insertRow(
        session,
        CaseUpdate(
          caseId: caseId,
          authorId: signedIn.userId,
          kind: CaseUpdateKind.stageChange,
          title: 'Stage changed to $newStageLabel',
          description: 'Stage changed from $oldStageLabel to $newStageLabel.',
        ),
        transaction: transaction,
      );
      return updatedCase;
    });
  }

  Future<List<CaseUpdate>> listUpdates(Session session, int caseId) async {
    await Authorization.requireCaseAccess(session, caseId);
    return CaseUpdate.db.find(
      session,
      where: (t) => t.caseId.equals(caseId),
      orderByList: (t) => [t.createdAt.asc(), t.id.asc()],
    );
  }

  void _validateFields(String title, String description) {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty || normalizedTitle.length > 120) {
      throw ArgumentError('Title must be between 1 and 120 characters.');
    }
    if (description.length > 2000) {
      throw ArgumentError('Description must be at most 2000 characters.');
    }
  }

  String _stageLabel(CaseStage stage) => switch (stage) {
    CaseStage.underReview => 'Under Review',
    CaseStage.inProgress => 'In Progress',
    CaseStage.awaitingDocuments => 'Awaiting Documents',
    CaseStage.resolved => 'Resolved',
  };
}
