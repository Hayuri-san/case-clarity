import 'package:case_clarity_server/src/generated/legal_guide.dart';
import 'package:case_clarity_server/src/services/legal_guide_seed.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the legal guide endpoint', (sessionBuilder, endpoints) {
    test('signed-in users can list and read guides', () async {
      final signedIn = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          '60000000-0000-4000-8000-000000000001',
          {},
        ),
      );
      await seedLegalGuides(sessionBuilder.build());

      final guides = await endpoints.legalGuide.listGuides(signedIn);
      expect(guides.map((guide) => guide.slug), [
        'cheque-bounce',
        'consumer-complaint',
        'cyber-fraud',
      ]);
      expect(guides.every((guide) => guide.disclaimer.endsWith(
        'General information, not legal advice.',
      )), isTrue);

      final guide = await endpoints.legalGuide.getGuide(
        signedIn,
        'cheque-bounce',
      );
      expect(guide, isA<LegalGuide>());
      expect(guide.title, 'Cheque bounce');

      final deadlines = await endpoints.deadline.calculateSection138(
        signedIn,
        chequeDate: DateTime.utc(2025, 1, 1),
        chequePresentedDate: DateTime.utc(2025, 1, 2),
        dishonourIntimationDate: DateTime.utc(2025, 1, 3),
        noticeSentDate: DateTime.utc(2025, 1, 10),
        noticeReceivedDate: DateTime.utc(2025, 1, 11),
      );
      expect(deadlines.items, hasLength(4));
      expect(deadlines.items[0].dueDate, DateTime.utc(2025, 4, 1));
      expect(deadlines.items[2].dueDate, DateTime.utc(2025, 1, 26));
    });

    test('anonymous users cannot read guides', () async {
      final anonymous = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );
      await expectLater(
        endpoints.legalGuide.listGuides(anonymous),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
      await expectLater(
        endpoints.legalGuide.getGuide(anonymous, 'cheque-bounce'),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
      await expectLater(
        endpoints.deadline.calculateSection138(
          anonymous,
          chequeDate: DateTime.utc(2025, 1, 1),
          chequePresentedDate: DateTime.utc(2025, 1, 2),
          dishonourIntimationDate: DateTime.utc(2025, 1, 3),
        ),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('seeding twice updates existing rows without adding duplicates', () async {
      final session = sessionBuilder.build();
      await seedLegalGuides(session);
      await seedLegalGuides(session);

      final guides = await LegalGuide.db.find(session);
      expect(guides, hasLength(3));
      expect(guides.map((guide) => guide.slug).toSet(), {
        'cheque-bounce',
        'consumer-complaint',
        'cyber-fraud',
      });
    });
  });
}
