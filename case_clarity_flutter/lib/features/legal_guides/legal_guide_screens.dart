import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../widgets/async_content.dart';
import '../cases/case_screens.dart';

class LegalGuideListScreen extends ConsumerWidget {
  const LegalGuideListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guides = ref.watch(legalGuidesProvider);
    return guides.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorPanel(
        message: friendlyError(error),
        onRetry: () => ref.invalidate(legalGuidesProvider),
      ),
      data: (items) => RefreshIndicator(
        onRefresh: () => ref.refresh(legalGuidesProvider.future),
        child: items.isEmpty
            ? ListView(children: const [EmptyPanel(message: 'Guides will appear here.')])
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final guide = items[index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const Icon(Icons.menu_book_outlined),
                      title: Text(guide.title, style: Theme.of(context).textTheme.titleLarge),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(guide.summary, maxLines: 3, overflow: TextOverflow.ellipsis),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => LegalGuideDetailScreen(slug: guide.slug),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class LegalGuideDetailScreen extends ConsumerWidget {
  const LegalGuideDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guide = ref.watch(legalGuideProvider(slug));
    return Scaffold(
      appBar: AppBar(title: const Text('Legal guide')),
      body: guide.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorPanel(
          message: friendlyError(error),
          onRetry: () => ref.invalidate(legalGuideProvider(slug)),
        ),
        data: (item) => _GuideContent(guide: item),
      ),
    );
  }
}

class _GuideContent extends StatelessWidget {
  const _GuideContent({required this.guide});

  final LegalGuide guide;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Text(guide.title, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 10),
      Text(guide.summary, style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 22),
      Text('Steps to consider', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      for (var i = 0; i < guide.steps.length; i++)
        ListTile(
          leading: CircleAvatar(child: Text('${i + 1}')),
          title: Text(guide.steps[i]),
          contentPadding: EdgeInsets.zero,
        ),
      const SizedBox(height: 16),
      Text('Relevant sections', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: guide.relevantSections.map((section) => Chip(label: Text(section))).toList(),
      ),
      const SizedBox(height: 20),
      Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(guide.disclaimer, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
      const SizedBox(height: 16),
      FilledButton.icon(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CreateCaseScreen(initialCaseType: guide.caseType),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Create a case from this guide'),
      ),
    ],
  );
}
