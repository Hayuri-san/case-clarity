import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart' as app_client;
import '../screens/sign_in_screen.dart';

final clientProvider = Provider<Client>((ref) => app_client.client);

final signedInProvider = NotifierProvider<SignedInController, bool>(
  SignedInController.new,
);

class SignedInController extends Notifier<bool> {
  @override
  bool build() {
    final auth = ref.read(clientProvider).auth;
    void update() {
      state = auth.isAuthenticated;
      ref.invalidate(myProfileProvider);
      ref.invalidate(myCasesProvider);
      ref.invalidate(legalGuidesProvider);
      ref.invalidate(caseUpdatesProvider);
      ref.invalidate(caseDocumentsProvider);
    }

    auth.authInfoListenable.addListener(update);
    ref.onDispose(() => auth.authInfoListenable.removeListener(update));
    return auth.isAuthenticated;
  }
}

final signInScreenProvider = Provider<Widget>(
  (ref) => const SignInScreen(child: SizedBox.shrink()),
);

final myProfileProvider = FutureProvider.autoDispose<CaseClarityUserProfile?>(
  (ref) => ref.watch(clientProvider).profile.getMyProfile(),
);

final myCasesProvider = FutureProvider.autoDispose<List<LegalCase>>(
  (ref) => ref.watch(clientProvider).cases.listMyCases(),
);

final legalGuidesProvider = FutureProvider.autoDispose<List<LegalGuide>>(
  (ref) => ref.watch(clientProvider).legalGuide.listGuides(),
);

final legalGuideProvider = FutureProvider.autoDispose
    .family<LegalGuide, String>(
      (ref, slug) => ref.watch(clientProvider).legalGuide.getGuide(slug),
    );

final legalCaseProvider = FutureProvider.autoDispose.family<LegalCase, int>(
  (ref, id) => ref.watch(clientProvider).cases.getCase(id),
);

final caseUpdatesProvider = FutureProvider.autoDispose
    .family<List<CaseUpdate>, int>(
      (ref, caseId) => ref.watch(clientProvider).caseUpdate.listUpdates(caseId),
    );

final caseDocumentsProvider = FutureProvider.autoDispose
    .family<List<CaseDocument>, int>(
      (ref, caseId) => ref.watch(clientProvider).document.listDocuments(caseId),
    );

String friendlyError(Object error) {
  final text = error.toString().toLowerCase();
  if (text.contains('case not found') || text.contains('access denied')) {
    return "We couldn't find that case, or you don't have access to it.";
  }
  if (text.contains('not authorized')) {
    return 'Only the lawyer assigned to this case can do that.';
  }
  if (text.contains('unauthenticated') || text.contains('authentication')) {
    return 'Your sign-in has expired. Please sign in again.';
  }
  if (text.contains('out of order') || text.contains('date')) {
    return 'Check that the dates are valid and in the right order.';
  }
  if (text.contains('file') || text.contains('upload')) {
    return 'The document could not be uploaded. Check the file type and size, then try again.';
  }
  return 'Something went wrong. Please try again.';
}
