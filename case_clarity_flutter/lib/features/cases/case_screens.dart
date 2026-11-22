import 'dart:async';

import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../core/date_format.dart';
import '../../core/theme.dart';
import '../../core/relative_time.dart';
import '../../providers/app_providers.dart';
import '../../widgets/app_components.dart';
import '../../widgets/visual_components.dart';
import '../../widgets/async_content.dart';
import '../documents/document_screens.dart';
import '../legal_guides/legal_guide_screens.dart';
import '../deadlines/deadline_screen.dart';

final recentLawyerUpdatesProvider =
    FutureProvider.autoDispose<List<CaseUpdate>>((ref) async {
      final client = ref.watch(clientProvider);
      final cases = await client.cases.listMyCases();
      final updates = <CaseUpdate>[];
      for (final legalCase in cases.take(8)) {
        updates.addAll(await client.caseUpdate.listUpdates(legalCase.id!));
      }
      final recent =
          updates
              .where((update) => update.kind == CaseUpdateKind.lawyerUpdate)
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return recent.take(4).toList();
    });

class CitizenHomeScreen extends ConsumerWidget {
  const CitizenHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(myProfileProvider);
    final cases = ref.watch(myCasesProvider);
    final recentUpdates = ref.watch(recentLawyerUpdatesProvider);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(greeting, style: Theme.of(context).textTheme.titleMedium),
        profile.when(
          loading: () => const SkeletonLoader(rows: 1),
          error: (error, stack) => ErrorState(message: friendlyError(error)),
          data: (item) => Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: CaseClarityColors.heroGradient),
              borderRadius: BorderRadius.circular(26),
              boxShadow: CaseClarityDecor.cardShadow(context),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.white70),
                      ),
                      Text(
                        item?.fullName ?? 'there',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your legal journey, clearly organized.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.wb_sunny_rounded,
                  color: Color(0xFFFFD36E),
                  size: 42,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const InfoBanner(
          message:
              'Have a legal notice? Confirm its dates to see your next steps and estimated deadlines.',
        ),
        const SizedBox(height: 16),
        cases.when(
          loading: () => const SkeletonLoader(rows: 1),
          error: (error, stack) => ErrorPanel(
            message: friendlyError(error),
            onRetry: () => ref.invalidate(myCasesProvider),
          ),
          data: (items) {
            final active = items
                .where((item) => item.stage != CaseStage.resolved)
                .length;
            final resolved = items
                .where((item) => item.stage == CaseStage.resolved)
                .length;
            return AppCard(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListTile(
                title: Text(
                  '$active active cases',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$resolved resolved · ${items.length} total'),
                    if (items.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      CaseStageDonut(
                        counts: {
                          for (final stage in CaseStage.values)
                            stage: items
                                .where((item) => item.stage == stage)
                                .length,
                        },
                      ),
                      CaseTypeStack(
                        counts: {
                          for (final type in CaseType.values)
                            type.name: items
                                .where((item) => item.caseType == type)
                                .length,
                        },
                      ),
                    ],
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => _openCases(context),
              ),
            );
          },
        ),
        const SizedBox(height: 22),
        const SectionHeader(
          title: 'Quick actions',
          subtitle: 'Pick up where you need help.',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _QuickAction(
              label: 'Read a guide',
              icon: Icons.menu_book,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const Scaffold(
                    appBar: _SimpleBackBar(title: 'Legal guides'),
                    body: LegalGuideListScreen(),
                  ),
                ),
              ),
            ),
            _QuickAction(
              label: 'Create a case',
              icon: Icons.add_circle_outline,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CreateCaseScreen(),
                ),
              ),
            ),
            _QuickAction(
              label: 'Scan a notice',
              icon: Icons.document_scanner_outlined,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SelectCaseForUploadScreen(),
                ),
              ),
            ),
            _QuickAction(
              label: 'Deadline calculator',
              icon: Icons.event_outlined,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const DeadlineScreen()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'Recent lawyer updates'),
        recentUpdates.when(
          loading: () => const SkeletonLoader(rows: 2),
          error: (error, stack) => Text(friendlyError(error)),
          data: (items) => items.isEmpty
              ? const Text('Updates from your lawyer will appear here.')
              : Column(
                  children: items
                      .map(
                        (update) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.chat_bubble_outline),
                            title: Text(update.title),
                            subtitle: Text(
                              '${update.description}\n${relativeTime(update.createdAt)}',
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }

  void _openCases(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const Scaffold(
        appBar: _SimpleBackBar(title: 'My cases'),
        body: CaseListScreen(),
      ),
    ),
  );
}

class _SimpleBackBar extends StatelessWidget implements PreferredSizeWidget {
  const _SimpleBackBar({required this.title});
  final String title;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) => AppBar(title: Text(title));
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 160,
    child: OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
    ),
  );
}

class CaseListScreen extends ConsumerStatefulWidget {
  const CaseListScreen({super.key});

  @override
  ConsumerState<CaseListScreen> createState() => _CaseListScreenState();
}

class SelectCaseForUploadScreen extends ConsumerWidget {
  const SelectCaseForUploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cases = ref.watch(myCasesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a case')),
      body: cases.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorPanel(
          message: friendlyError(error),
          onRetry: () => ref.invalidate(myCasesProvider),
        ),
        data: (items) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (items.isEmpty)
              const EmptyPanel(
                message: 'Create a case before scanning a notice.',
              )
            else
              for (final legalCase in items)
                Card(
                  child: ListTile(
                    title: Text(legalCase.title),
                    subtitle: Text(stageLabel(legalCase.stage.name)),
                    trailing: const Icon(Icons.document_scanner_outlined),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CaseDetailScreen(
                          legalCase: legalCase,
                          initialTab: 2,
                          startCameraScan: true,
                        ),
                      ),
                    ),
                  ),
                ),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CreateCaseScreen(
                    startCameraScanAfterCreate: true,
                  ),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Create a case first'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaseListScreenState extends ConsumerState<CaseListScreen> {
  CaseStage? _filter;
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cases = ref.watch(myCasesProvider);
    return cases.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorPanel(
        message: friendlyError(error),
        onRetry: () => ref.invalidate(myCasesProvider),
      ),
      data: (items) {
        final query = _search.text.trim().toLowerCase();
        final visible =
            items
                .where(
                  (item) =>
                      (_filter == null || item.stage == _filter) &&
                      (query.isEmpty ||
                          item.title.toLowerCase().contains(query) ||
                          caseTypeLabel(
                            item.caseType.name,
                          ).toLowerCase().contains(query)),
                )
                .toList()
              ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        return RefreshIndicator(
          onRefresh: () => ref.refresh(myCasesProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SectionHeader(
                title: 'Your cases',
                subtitle: 'Search, filter and follow progress.',
              ),
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search cases',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<CaseStage?>(
                initialValue: _filter,
                decoration: const InputDecoration(labelText: 'Filter by stage'),
                items: [
                  const DropdownMenuItem<CaseStage?>(
                    value: null,
                    child: Text('All stages'),
                  ),
                  ...CaseStage.values.map(
                    (stage) => DropdownMenuItem(
                      value: stage,
                      child: Text(stageLabel(stage.name)),
                    ),
                  ),
                ],
                onChanged: (stage) => setState(() => _filter = stage),
              ),
              const SizedBox(height: 12),
              if (visible.isEmpty)
                const EmptyPanel(message: 'No cases match this view yet.')
              else
                ...visible.map(
                  (legalCase) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              CaseDetailScreen(legalCase: legalCase),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  legalCase.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              StatusChip.forStage(legalCase.stage),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(caseTypeLabel(legalCase.caseType.name)),
                          const SizedBox(height: 12),
                          StageProgress(stage: legalCase.stage, compact: true),
                          const SizedBox(height: 8),
                          Text(
                            'Updated ${relativeTime(legalCase.updatedAt)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class CreateCaseScreen extends ConsumerStatefulWidget {
  const CreateCaseScreen({
    super.key,
    this.initialCaseType,
    this.startCameraScanAfterCreate = false,
  });
  final CaseType? initialCaseType;
  final bool startCameraScanAfterCreate;

  @override
  ConsumerState<CreateCaseScreen> createState() => _CreateCaseScreenState();
}

class _CreateCaseScreenState extends ConsumerState<CreateCaseScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  late CaseType _type = widget.initialCaseType ?? CaseType.chequeBounce;
  bool _busy = false;
  String? _error;
  int _step = 0;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final created = await ref
          .read(clientProvider)
          .cases
          .createCase(
            _title.text.trim(),
            _type,
            _description.text.trim(),
          );
      ref.invalidate(myCasesProvider);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => CaseDetailScreen(
            legalCase: created,
            initialTab: widget.startCameraScanAfterCreate ? 2 : 0,
            startCameraScan: widget.startCameraScanAfterCreate,
          ),
        ),
      );
    } catch (error) {
      setState(() => _error = friendlyError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Create a case')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Create your case',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Step ${_step + 1} of 3 · ${['Case type', 'Your story', 'Review'][_step]}',
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: (_step + 1) / 3),
              const SizedBox(height: 18),
              if (_step == 0) ...[
                const Text(
                  'Start with a clear title and choose the kind of issue.',
                ),
                TextFormField(
                  controller: _title,
                  maxLength: 120,
                  decoration: const InputDecoration(
                    labelText: 'Case title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value?.trim().isEmpty ?? true) ? 'Enter a title.' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<CaseType>(
                  initialValue: _type,
                  decoration: const InputDecoration(
                    labelText: 'Case type',
                    border: OutlineInputBorder(),
                  ),
                  items: CaseType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(caseTypeLabel(type.name)),
                        ),
                      )
                      .toList(),
                  onChanged: (type) {
                    if (type != null) setState(() => _type = type);
                  },
                ),
              ],
              if (_step == 1) ...[
                const Text(
                  'Share the key facts. You can add documents after creating the case.',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _description,
                  maxLength: 2000,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Describe the issue',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value?.length ?? 0) > 2000
                      ? 'Use 2000 characters or fewer.'
                      : null,
                ),
              ],
              if (_step == 2)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title.text.trim().isEmpty
                            ? 'Untitled case'
                            : _title.text.trim(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      StatusChip(label: caseTypeLabel(_type.name)),
                      const SizedBox(height: 12),
                      Text(
                        _description.text.trim().isEmpty
                            ? 'No description added.'
                            : _description.text.trim(),
                      ),
                      const SizedBox(height: 12),
                      const InfoBanner(
                        message:
                            'Your case starts in Under review. You can upload a notice after it is created.',
                      ),
                    ],
                  ),
                ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (_step > 0)
                    TextButton(
                      onPressed: _busy ? null : () => setState(() => _step--),
                      child: const Text('Back'),
                    ),
                  const Spacer(),
                  PrimaryButton(
                    onPressed: () {
                      if (_step == 0 &&
                          !(_form.currentState?.validate() ?? false))
                        return;
                      if (_step == 1 && (_description.text.length > 2000)) {
                        setState(
                          () => _error = 'Use 2000 characters or fewer.',
                        );
                        return;
                      }
                      if (_step < 2) {
                        setState(() => _step++);
                        return;
                      }
                      _submit();
                    },
                    loading: _busy,
                    label: _step == 2 ? 'Create case' : 'Continue',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class CaseDetailScreen extends ConsumerWidget {
  const CaseDetailScreen({
    super.key,
    required this.legalCase,
    this.initialTab = 0,
    this.startCameraScan = false,
  });
  final LegalCase legalCase;
  final int initialTab;
  final bool startCameraScan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseAsync = ref.watch(legalCaseProvider(legalCase.id!));
    final profile = ref.watch(myProfileProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          legalCase.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (profile?.role == UserRole.citizen)
            IconButton(
              tooltip: 'Edit case details',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => EditCaseScreen(legalCase: legalCase),
                ),
              ),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: caseAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorPanel(
          message: friendlyError(error),
          onRetry: () => ref.invalidate(legalCaseProvider(legalCase.id!)),
        ),
        data: (item) => DefaultTabController(
          initialIndex: initialTab,
          length: 3,
          child: Column(
            children: [
              _CaseSummary(legalCase: item),
              const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Timeline'),
                  Tab(text: 'Documents'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _CaseOverview(legalCase: item),
                    TimelinePanel(caseId: item.id!),
                    DocumentListScreen(
                      caseId: item.id!,
                      startCameraScan: startCameraScan,
                    ),
                  ],
                ),
              ),
              if (profile?.role == UserRole.lawyer)
                _LawyerActions(legalCase: item),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaseSummary extends StatelessWidget {
  const _CaseSummary({required this.legalCase});
  final LegalCase legalCase;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StatusChip.forStage(legalCase.stage),
            const SizedBox(width: 8),
            Flexible(child: Text(caseTypeLabel(legalCase.caseType.name))),
          ],
        ),
        const SizedBox(height: 8),
        StageProgress(stage: legalCase.stage, compact: true),
        const SizedBox(height: 6),
        Text(
          'Created ${formatDate(legalCase.createdAt)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}

class _CaseOverview extends StatelessWidget {
  const _CaseOverview({required this.legalCase});
  final LegalCase legalCase;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const SectionHeader(title: 'Case overview'),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              legalCase.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text('Case type', style: Theme.of(context).textTheme.labelLarge),
            Text(caseTypeLabel(legalCase.caseType.name)),
            const SizedBox(height: 12),
            Text('Created', style: Theme.of(context).textTheme.labelLarge),
            Text(formatDate(legalCase.createdAt)),
            const SizedBox(height: 12),
            Text(
              legalCase.assignedLawyerId == null
                  ? 'A lawyer has not been assigned yet.'
                  : 'A lawyer is assigned to your case.',
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const InfoBanner(
        message:
            'Your next deadline appears after you confirm the relevant notice dates.',
      ),
    ],
  );
}

class TimelinePanel extends ConsumerStatefulWidget {
  const TimelinePanel({super.key, required this.caseId});
  final int caseId;

  @override
  ConsumerState<TimelinePanel> createState() => _TimelinePanelState();
}

class _TimelinePanelState extends ConsumerState<TimelinePanel> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      ref.invalidate(caseUpdatesProvider(widget.caseId));
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updates = ref.watch(caseUpdatesProvider(widget.caseId));
    return updates.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorPanel(
        message: friendlyError(error),
        onRetry: () => ref.invalidate(caseUpdatesProvider(widget.caseId)),
      ),
      data: (items) => items.isEmpty
          ? const EmptyPanel(message: 'Case updates will appear here.')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final update = items[index];
                final stageChange = update.kind == CaseUpdateKind.stageChange;
                return FadeSlideIn(
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      color: stageChange
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : null,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            stageChange
                                ? Icons.sync_alt
                                : Icons.chat_bubble_outline,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  update.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(update.description),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      stageChange
                                          ? 'Stage change'
                                          : 'Lawyer update',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                    const Text(' · '),
                                    Tooltip(
                                      message: '${update.createdAt}',
                                      child: Text(
                                        relativeTime(update.createdAt),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _LawyerActions extends ConsumerStatefulWidget {
  const _LawyerActions({required this.legalCase});
  final LegalCase legalCase;
  @override
  ConsumerState<_LawyerActions> createState() => _LawyerActionsState();
}

class _LawyerActionsState extends ConsumerState<_LawyerActions> {
  bool _busy = false;
  String? _error;
  Future<void> _changeStage(CaseStage? stage) async {
    if (stage == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change case stage?'),
        content: Text(
          'Move this case to ${stageLabel(stage.name)}? The change will appear in the case timeline.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Change stage'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(clientProvider)
          .caseUpdate
          .changeStage(widget.legalCase.id!, stage);
      ref.invalidate(legalCaseProvider(widget.legalCase.id!));
      ref.invalidate(caseUpdatesProvider(widget.legalCase.id!));
      ref.invalidate(myCasesProvider);
    } catch (error) {
      setState(() => _error = friendlyError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _postUpdate() async {
    final form = GlobalKey<FormState>();
    final title = TextEditingController();
    final description = TextEditingController();
    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Post an update'),
        content: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: title,
                maxLength: 120,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Enter a title.' : null,
              ),
              TextFormField(
                controller: description,
                maxLength: 2000,
                minLines: 2,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => (v?.length ?? 0) > 2000
                    ? 'Use 2000 characters or fewer.'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (form.currentState!.validate())
                Navigator.pop(dialogContext, true);
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
    if (save != true) {
      title.dispose();
      description.dispose();
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(clientProvider)
          .caseUpdate
          .addUpdate(
            widget.legalCase.id!,
            title.text.trim(),
            description.text.trim(),
          );
      ref.invalidate(caseUpdatesProvider(widget.legalCase.id!));
    } catch (error) {
      setState(() => _error = friendlyError(error));
    } finally {
      title.dispose();
      description.dispose();
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_error != null)
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<CaseStage>(
                initialValue: widget.legalCase.stage,
                decoration: const InputDecoration(
                  labelText: 'Change stage',
                  isDense: true,
                ),
                items: CaseStage.values
                    .map(
                      (stage) => DropdownMenuItem(
                        value: stage,
                        child: Text(stageLabel(stage.name)),
                      ),
                    )
                    .toList(),
                onChanged: _busy ? null : _changeStage,
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.tonalIcon(
              onPressed: _busy ? null : _postUpdate,
              icon: const Icon(Icons.add_comment_outlined),
              label: const Text('Post update'),
            ),
          ],
        ),
      ],
    ),
  );
}

class EditCaseScreen extends ConsumerStatefulWidget {
  const EditCaseScreen({super.key, required this.legalCase});
  final LegalCase legalCase;
  @override
  ConsumerState<EditCaseScreen> createState() => _EditCaseScreenState();
}

class _EditCaseScreenState extends ConsumerState<EditCaseScreen> {
  late final _title = TextEditingController(text: widget.legalCase.title);
  late final _description = TextEditingController(
    text: widget.legalCase.description,
  );
  final _form = GlobalKey<FormState>();
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(clientProvider)
          .cases
          .updateCaseInfo(
            widget.legalCase.id!,
            _title.text.trim(),
            _description.text.trim(),
          );
      ref.invalidate(legalCaseProvider(widget.legalCase.id!));
      if (mounted) Navigator.pop(context);
    } catch (error) {
      setState(() => _error = friendlyError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Edit case details')),
    body: Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: _title,
            maxLength: 120,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                (v?.trim().isEmpty ?? true) ? 'Enter a title.' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _description,
            minLines: 4,
            maxLines: 8,
            maxLength: 2000,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v?.length ?? 0) > 2000
                ? 'Use 2000 characters or fewer.'
                : null,
          ),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: _busy
                ? const CircularProgressIndicator()
                : const Text('Save changes'),
          ),
        ],
      ),
    ),
  );
}

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _name = TextEditingController();
  bool _editing = false;
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _name.text.trim().length > 120) {
      setState(() => _error = 'Enter a name using 1 to 120 characters.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(clientProvider)
          .profile
          .createOrUpdateMyProfile(_name.text.trim());
      ref.invalidate(myProfileProvider);
      setState(() => _editing = false);
    } catch (error) {
      setState(() => _error = friendlyError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(myProfileProvider);
    return profile.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorPanel(
        message: friendlyError(error),
        onRetry: () => ref.invalidate(myProfileProvider),
      ),
      data: (user) {
        if (user == null)
          return const EmptyPanel(message: 'Profile not found.');
        if (!_editing) _name.text = user.fullName;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SectionHeader(
              title: 'Your profile',
              subtitle: 'Manage your Case Clarity account.',
            ),
            if (!_editing)
              AppCard(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.secondaryContainer,
                      child: Text(
                        user.fullName.trim().isEmpty
                            ? '?'
                            : user.fullName.trim()[0].toUpperCase(),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.fullName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    StatusChip(
                      label: user.role == UserRole.lawyer
                          ? 'Lawyer'
                          : 'Citizen',
                      tone: StatusTone.active,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            if (_editing) ...[
              TextField(
                controller: _name,
                maxLength: 120,
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  FilledButton(
                    onPressed: _busy ? null : _save,
                    child: const Text('Save name'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => setState(() {
                      _editing = false;
                      _error = null;
                    }),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ] else ...[
              OutlinedButton.icon(
                onPressed: () => setState(() => _editing = true),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit name'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Sign out?'),
                      content: const Text('You can sign back in at any time.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: const Text('Sign out'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true)
                    await ref.read(clientProvider).auth.signOutDevice();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
              ),
              const SizedBox(height: 16),
              Text(
                'Case Clarity · Version 1.0.0',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        );
      },
    );
  }
}
