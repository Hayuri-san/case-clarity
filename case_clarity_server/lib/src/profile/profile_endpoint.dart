import 'package:serverpod/serverpod.dart';

import '../generated/case_clarity_user_profile.dart';
import '../generated/user_role.dart';
import '../services/authorization.dart';

class ProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<CaseClarityUserProfile?> getMyProfile(Session session) async {
    final userId = Authorization.requireSignedInUserId(session);
    return CaseClarityUserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }

  Future<CaseClarityUserProfile> createOrUpdateMyProfile(
    Session session,
    String fullName,
  ) async {
    final userId = Authorization.requireSignedInUserId(session);
    final normalizedName = fullName.trim();
    if (normalizedName.isEmpty || normalizedName.length > 120) {
      throw ArgumentError('Full name must be between 1 and 120 characters.');
    }

    final existing = await CaseClarityUserProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
    if (existing == null) {
      return CaseClarityUserProfile.db.insertRow(
        session,
        CaseClarityUserProfile(
          userId: userId,
          fullName: normalizedName,
          role: UserRole.citizen,
        ),
      );
    }

    final updated = existing.copyWith(fullName: normalizedName);
    return CaseClarityUserProfile.db.updateRow(session, updated);
  }
}
