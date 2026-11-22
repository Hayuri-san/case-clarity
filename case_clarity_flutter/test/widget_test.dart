import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:case_clarity/features/authentication/auth_gate.dart';
import 'package:case_clarity/features/cases/case_screens.dart';
import 'package:case_clarity/core/app_frame.dart';
import 'package:case_clarity/features/deadlines/deadline_screen.dart';
import 'package:case_clarity/features/documents/date_suggestion_parser.dart';
import 'package:case_clarity/features/lawyer_dashboard/lawyer_dashboard_screen.dart';
import 'package:case_clarity/core/relative_time.dart';
import 'package:case_clarity/providers/app_providers.dart';
import 'package:case_clarity/widgets/app_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _SignedOutController extends SignedInController {
  @override
  bool build() => false;
}

class _EmptySignedInController extends SignedInController {
  @override
  bool build() => true;
}

void main() {
  testWidgets('AppFrame constrains a wide browser to phone width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => AppFrame(
          child: child ?? const SizedBox.shrink(),
        ),
        home: Builder(
          builder: (context) => SizedBox(
            key: const ValueKey('frame-width'),
            width: MediaQuery.sizeOf(context).width,
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const ValueKey('frame-width'))).width,
      430,
    );

    tester.view.physicalSize = const Size(360, 800);
    await tester.pump();
    expect(
      tester.getSize(find.byKey(const ValueKey('frame-width'))).width,
      360,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'citizen navigation stays in phone layout at wide and narrow widths',
    (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final overrides = [
        myCasesProvider.overrideWith((ref) async => <LegalCase>[]),
        myProfileProvider.overrideWith((ref) async => null),
        legalGuidesProvider.overrideWith((ref) async => <LegalGuide>[]),
        recentLawyerUpdatesProvider.overrideWith((ref) async => <CaseUpdate>[]),
      ];
      await tester.pumpWidget(
        ProviderScope(
          overrides: overrides,
          child: MaterialApp(
            builder: (context, child) => AppFrame(
              child: child ?? const SizedBox.shrink(),
            ),
            home: const MainShell(role: UserRole.citizen),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(NavigationRail), findsNothing);
      expect(tester.takeException(), isNull);

      tester.view.physicalSize = const Size(360, 800);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  test('relative time uses the supplied clock deterministically', () {
    final now = DateTime(2026, 4, 20, 12);
    expect(
      relativeTime(now.subtract(const Duration(minutes: 5)), now: now),
      '5 minutes ago',
    );
    expect(relativeTime(now, now: now), 'just now');
  });

  testWidgets('status chip renders a resolved case state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: StatusChip.forStage(CaseStage.resolved)),
      ),
    );
    expect(find.text('Resolved'), findsOneWidget);
  });

  testWidgets('stage progress labels current case stages', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StageProgress(stage: CaseStage.inProgress)),
      ),
    );
    expect(find.text('Review'), findsOneWidget);
    expect(find.text('In progress'), findsOneWidget);
    expect(find.text('Documents'), findsOneWidget);
    expect(find.text('Resolved'), findsOneWidget);
  });

  testWidgets('signed-out auth gate renders the existing sign-in surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signedInProvider.overrideWith(_SignedOutController.new),
          signInScreenProvider.overrideWith(
            (ref) => const Text('Sign in here'),
          ),
        ],
        child: const MaterialApp(home: AuthGate()),
      ),
    );

    expect(find.text('Sign in here'), findsOneWidget);
  });

  testWidgets(
    'role router shows the citizen and lawyer navigation with faked data',
    (tester) async {
      final sharedOverrides = [
        signedInProvider.overrideWith(_EmptySignedInController.new),
        myCasesProvider.overrideWith((ref) async => <LegalCase>[]),
        myProfileProvider.overrideWith((ref) async => null),
        legalGuidesProvider.overrideWith((ref) async => <LegalGuide>[]),
        recentLawyerUpdatesProvider.overrideWith((ref) async => <CaseUpdate>[]),
        lawyerRecentActivityProvider.overrideWith(
          (ref) async => <({LegalCase legalCase, CaseUpdate update})>[],
        ),
        caseUpdatesProvider.overrideWith((ref, caseId) async => <CaseUpdate>[]),
        caseDocumentsProvider.overrideWith(
          (ref, caseId) async => <CaseDocument>[],
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: sharedOverrides,
          child: const MaterialApp(home: RoleRouter(role: UserRole.citizen)),
        ),
      );
      expect(find.text('Home'), findsOneWidget);
      await tester.pumpWidget(
        ProviderScope(
          overrides: sharedOverrides,
          child: const MaterialApp(home: RoleRouter(role: UserRole.lawyer)),
        ),
      );
      expect(find.text('Dashboard'), findsOneWidget);
    },
  );

  testWidgets('date suggestion parser reads numeric and named dates', (
    tester,
  ) async {
    final parsed = parseDateSuggestions([
      '18/03/2026',
      '19-03-2026',
      '20 March 2026',
      'date unclear',
    ]);
    expect(parsed[0].date, DateTime.utc(2026, 3, 18));
    expect(parsed[1].date, DateTime.utc(2026, 3, 19));
    expect(parsed[2].date, DateTime.utc(2026, 3, 20));
    expect(parsed[3].date, isNull);
    expect(parsed[3].text, 'date unclear');
  });

  testWidgets(
    'deadline results render due dates, badges, assumptions and disclaimer',
    (tester) async {
      final result = Section138DeadlineResult(
        items: [
          DeadlineItem(
            label: 'Send demand notice',
            dueDate: DateTime.utc(2026, 4, 18),
            basis: 'Within 30 days after dishonour information.',
            status: DeadlineStatus.upcoming,
          ),
          DeadlineItem(
            label: 'Complaint filing',
            basis: 'Notice receipt date is missing.',
            status: DeadlineStatus.notYetComputable,
          ),
        ],
        assumptions: const ['Dates are treated as confirmed.'],
        disclaimer: 'Calculated from confirmed dates; not legal advice.',
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(children: [DeadlineResults(result: result)]),
          ),
        ),
      );

      expect(find.text('Send demand notice'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('Not yet computable'), findsOneWidget);
      await tester.tap(find.text('Assumptions and counting rules'));
      await tester.pumpAndSettle();
      expect(find.text('Dates are treated as confirmed.'), findsOneWidget);
      expect(
        find.text('Calculated from confirmed dates; not legal advice.'),
        findsOneWidget,
      );
    },
  );
}
