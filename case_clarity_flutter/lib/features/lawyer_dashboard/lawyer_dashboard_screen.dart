import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/date_format.dart';
import '../../providers/app_providers.dart';
import '../../widgets/app_components.dart';
import '../../widgets/async_content.dart';
import '../cases/case_screens.dart';

final lawyerRecentActivityProvider =
    FutureProvider.autoDispose<
      List<({LegalCase legalCase, CaseUpdate update})>
    >((ref) async {
      final client = ref.watch(clientProvider);
      final cases = await client.cases.listMyCases();
      final entries = <({LegalCase legalCase, CaseUpdate update})>[];
      for (final legalCase in cases.take(12)) {
        final updates = await client.caseUpdate.listUpdates(legalCase.id!);
        for (final update in updates) {
          entries.add((legalCase: legalCase, update: update));
        }
      }
      entries.sort((a, b) => b.update.createdAt.compareTo(a.update.createdAt));
      return entries.take(5).toList();
    });

class LawyerDashboardScreen extends ConsumerWidget {
  const LawyerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cases = ref.watch(myCasesProvider);
    final activity = ref.watch(lawyerRecentActivityProvider);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SectionHeader(
          title: 'Your practice',
          subtitle: 'A quick view of your assigned cases.',
        ),
        const SizedBox(height: 18),
        cases.when(
          loading: () => const SkeletonLoader(rows: 2),
          error: (error, stack) => ErrorPanel(
            message: friendlyError(error),
            onRetry: () => ref.invalidate(myCasesProvider),
          ),
          data: (items) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: CaseStage.values.map((stage) {
              final count = items.where((item) => item.stage == stage).length;
              return SizedBox(
                width: 170,
                child: AppCard(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$count',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      StatusChip.forStage(stage),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            const Expanded(child: SectionHeader(title: 'Recent activity')),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const Scaffold(
                    appBar: _CasesAppBar(),
                    body: CaseListScreen(),
                  ),
                ),
              ),
              child: const Text('All cases'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        activity.when(
          loading: () => const SkeletonLoader(rows: 2),
          error: (error, stack) => Text(friendlyError(error)),
          data: (items) {
            if (items.isEmpty) {
              return const EmptyPanel(
                message: 'Activity will appear as your cases are updated.',
              );
            }
            return Column(
              children: items.map((entry) {
                return Card(
                  child: ListTile(
                    leading: Icon(
                      entry.update.kind == CaseUpdateKind.stageChange
                          ? Icons.sync_alt
                          : Icons.chat_bubble_outline,
                    ),
                    title: Text(entry.update.title),
                    subtitle: Text(
                      '${entry.legalCase.title} · '
                      '${formatDate(entry.update.createdAt)}',
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CaseDetailScreen(
                          legalCase: entry.legalCase,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _CasesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CasesAppBar();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) =>
      AppBar(title: const Text('Assigned cases'));
}
