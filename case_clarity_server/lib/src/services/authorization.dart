import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/case_clarity_user_profile.dart';
import '../generated/legal_case.dart';
import '../generated/user_role.dart';

class Authorization {
  static const caseUnavailableMessage = 'Case not found or access denied.';

  static UuidValue requireSignedInUserId(Session session) {
    final userId = session.authenticated?.authUserId;
    if (userId == null) {
      throw Exception('Authentication required.');
    }
    return userId;
  }

  static Future<({UuidValue userId, CaseClarityUserProfile profile})>
  getSignedInUserAndProfile(Session session) async {
    final userId = requireSignedInUserId(session);
    final profile = await CaseClarityUserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
    if (profile == null) {
      throw Exception('Profile not found.');
    }
    return (userId: userId, profile: profile);
  }

  static Future<CaseClarityUserProfile> requireRole(
    Session session,
    UserRole role,
  ) async {
    final signedIn = await getSignedInUserAndProfile(session);
    if (signedIn.profile.role != role) {
      throw Exception('Not authorized for this action.');
    }
    return signedIn.profile;
  }

  static bool canAccessCase(
    CaseClarityUserProfile profile,
    LegalCase legalCase,
  ) {
    return switch (profile.role) {
      UserRole.citizen => legalCase.creatorId == profile.userId,
      UserRole.lawyer => legalCase.assignedLawyerId == profile.userId,
    };
  }

  static Future<({UuidValue userId, CaseClarityUserProfile profile, LegalCase legalCase})>
  requireCaseAccess(Session session, int caseId) async {
    final signedIn = await getSignedInUserAndProfile(session);
    final legalCase = await LegalCase.db.findById(session, caseId);
    if (legalCase == null || !canAccessCase(signedIn.profile, legalCase)) {
      throw Exception(caseUnavailableMessage);
    }
    return (
      userId: signedIn.userId,
      profile: signedIn.profile,
      legalCase: legalCase,
    );
  }
}
