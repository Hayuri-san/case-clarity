import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/app_components.dart';
import '../../providers/app_providers.dart';
import '../../widgets/async_content.dart';
import '../cases/case_screens.dart';

class LegalGuideListScreen extends ConsumerWidget {
  const LegalGuideListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guides = ref.watch(legalGuidesProvider);
    return _GuideBrowser(
      guides: guides,
      onRetry: () => ref.invalidate(legalGuidesProvider),
      onRefresh: () => ref.refresh(legalGuidesProvider.future),
    );
  }
}

class _GuideBrowser extends StatefulWidget {
  const _GuideBrowser({
    required this.guides,
    required this.onRetry,
    required this.onRefresh,
  });
  final AsyncValue<List<LegalGuide>> guides;
  final VoidCallback onRetry;
  final Future<List<LegalGuide>> Function() onRefresh;
  @override
  State<_GuideBrowser> createState() => _GuideBrowserState();
}

class _GuideBrowserState extends State<_GuideBrowser> {
  String _query = '';
  @override
  Widget build(BuildContext context) => widget.guides.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stack) => ErrorPanel(
      message: friendlyError(error),
      onRetry: widget.onRetry,
    ),
    data: (items) => RefreshIndicator(
      onRefresh: () async {
        await widget.onRefresh();
      },
      child: items.isEmpty
          ? ListView(
              children: const [EmptyPanel(message: 'Guides will appear here.')],
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SectionHeader(
                  title: 'Legal guides',
                  subtitle:
                      'Plain-language starting points for common concerns.',
                ),
                TextField(
                  onChanged: (value) =>
                      setState(() => _query = value.trim().toLowerCase()),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search legal guides',
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final visible = items
                        .where(
                          (item) =>
                              _query.isEmpty ||
                              item.title.toLowerCase().contains(_query) ||
                              item.summary.toLowerCase().contains(_query),
                        )
                        .toList();
                    if (visible.isEmpty)
                      return const EmptyState(
                        icon: Icons.search_off,
                        message: 'No guides match your search.',
                      );
                    final columns = constraints.maxWidth >= 760 ? 2 : 1;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 220,
                      ),
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        final guide = visible[index];
                        return AppCard(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  LegalGuideDetailScreen(slug: guide.slug),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                guide.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                  guide.summary,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.arrow_forward),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
    ),
  );
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
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(guide.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text(guide.summary, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 22),
          Text(
            'Steps to consider',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < guide.steps.length; i++)
            ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text(guide.steps[i]),
              contentPadding: EdgeInsets.zero,
            ),
          const SizedBox(height: 16),
          Text(
            'Relevant sections',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: guide.relevantSections
                .map((section) => Chip(label: Text(section)))
                .toList(),
          ),
          const SizedBox(height: 20),
          InfoBanner(message: guide.disclaimer),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    CreateCaseScreen(initialCaseType: guide.caseType),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Create a case from this guide'),
          ),
        ],
      ),
    ),
  );
}
