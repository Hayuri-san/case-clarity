import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/case_clarity_user_profile.dart';
import '../generated/case_type.dart';
import '../generated/legal_case.dart';
import '../generated/user_role.dart';

/// Applies only explicitly configured production demo roles and sample case.
/// Missing or unregistered email addresses are ignored so startup stays safe.
Future<void> provisionProductionDemoData(Session session) async {
  if (session.server.runMode != 'production') return;

  final passwords = session.serverpod;
  final lawyerEmails = productionLawyerEmails(
    session.server.runMode,
    passwords.getPassword('demoLawyerEmails'),
  );
  final citizenEmail = _normalizeEmail(
    passwords.getPassword('demoCitizenEmail'),
  );
  final lawyers = <CaseClarityUserProfile>[];

  for (final email in lawyerEmails) {
    final authProfiles = await AuthServices.instance.userProfiles.admin
        .listUserProfiles(session, email: email, limit: 2);
    if (authProfiles.length != 1) continue;

    final authProfile = authProfiles.single;
    final profile = await CaseClarityUserProfile.db.findFirstRow(
      session,
      where: (table) => table.userId.equals(authProfile.authUserId),
    );
    final displayName = authProfile.fullName?.trim();
    final lawyer = profile == null
        ? await CaseClarityUserProfile.db.insertRow(
            session,
            CaseClarityUserProfile(
              userId: authProfile.authUserId,
              fullName: displayName == null || displayName.isEmpty
                  ? email
                  : displayName,
              role: UserRole.lawyer,
            ),
          )
        : profile.role == UserRole.lawyer
        ? profile
        : await CaseClarityUserProfile.db.updateRow(
            session,
            profile.copyWith(role: UserRole.lawyer),
          );
    lawyers.add(lawyer);
  }

  if (citizenEmail == null) return;
  final citizenAuthProfiles = await AuthServices.instance.userProfiles.admin
      .listUserProfiles(session, email: citizenEmail, limit: 2);
  if (citizenAuthProfiles.length != 1) return;

  final citizenAuthProfile = citizenAuthProfiles.single;
  if (lawyers.any((lawyer) => lawyer.userId == citizenAuthProfile.authUserId)) {
    return;
  }
  final existingProfile = await CaseClarityUserProfile.db.findFirstRow(
    session,
    where: (table) => table.userId.equals(citizenAuthProfile.authUserId),
  );
  if (existingProfile != null && existingProfile.role != UserRole.citizen) {
    return;
  }

  final displayName = citizenAuthProfile.fullName?.trim();
  final citizen =
      existingProfile ??
      await CaseClarityUserProfile.db.insertRow(
        session,
        CaseClarityUserProfile(
          userId: citizenAuthProfile.authUserId,
          fullName: displayName == null || displayName.isEmpty
              ? citizenEmail
              : displayName,
          role: UserRole.citizen,
        ),
      );

  const sampleTitle = 'Demo cheque bounce case';
  final existingCase = await LegalCase.db.findFirstRow(
    session,
    where: (table) =>
        table.creatorId.equals(citizen.userId) &
        table.title.equals(sampleTitle),
  );
  if (existingCase != null) return;

  await LegalCase.db.insertRow(
    session,
    LegalCase(
      title: sampleTitle,
      caseType: CaseType.chequeBounce,
      description: 'Sample production demo case for the configured citizen.',
      creatorId: citizen.userId,
      assignedLawyerId: lawyers.isEmpty ? null : lawyers.first.userId,
    ),
  );
}

List<String> productionLawyerEmails(String runMode, String? value) {
  if (runMode != 'production') return const [];
  if (value == null || value.trim().isEmpty) return const [];
  return value
      .split(RegExp(r'[,;\s]+'))
      .map((email) => email.trim().toLowerCase())
      .where((email) => email.isNotEmpty)
      .toSet()
      .toList();
}

String? _normalizeEmail(String? value) {
  final email = value?.trim().toLowerCase();
  return email == null || email.isEmpty ? null : email;
}
