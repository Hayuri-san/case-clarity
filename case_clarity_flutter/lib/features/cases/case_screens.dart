import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/date_format.dart';
import '../../providers/app_providers.dart';
import '../../widgets/async_content.dart';
import '../documents/document_screens.dart';
import '../legal_guides/legal_guide_screens.dart';
import '../deadlines/deadline_screen.dart';

final recentLawyerUpdatesProvider = FutureProvider.autoDispose<List<CaseUpdate>>((ref) async {
  final client = ref.watch(clientProvider);
  final cases = await client.cases.listMyCases();
  final updates = <CaseUpdate>[];
  for (final legalCase in cases.take(8)) {
    updates.addAll(await client.caseUpdate.listUpdates(legalCase.id!));
  }
  final recent = updates
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
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Welcome back,', style: Theme.of(context).textTheme.titleMedium),
        profile.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LinearProgressIndicator(),
          ),
          error: (error, stack) => Text(friendlyError(error)),
          data: (item) => Text(
            item?.fullName ?? 'there',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 20),
        cases.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stack) => ErrorPanel(
            message: friendlyError(error),
            onRetry: () => ref.invalidate(myCasesProvider),
          ),
          data: (items) {
            final active = items.where((item) => item.stage != CaseStage.resolved).length;
            return Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListTile(
                title: Text('$active active cases', style: Theme.of(context).textTheme.titleLarge),
                subtitle: const Text('Your cases in progress'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => _openCases(context),
              ),
            );
          },
        ),
        const SizedBox(height: 22),
        Text('Quick actions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _QuickAction(
              label: 'Read a guide',
              icon: Icons.menu_book,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const Scaffold(
                  appBar: _SimpleBackBar(title: 'Legal guides'),
                  body: LegalGuideListScreen(),
                )),
              ),
            ),
            _QuickAction(
              label: 'Create a case',
              icon: Icons.add_circle_outline,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const CreateCaseScreen()),
              ),
            ),
            _QuickAction(
              label: 'Scan a notice',
              icon: Icons.document_scanner_outlined,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SelectCaseForUploadScreen()),
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
        Text('Recent lawyer updates', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        recentUpdates.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stack) => Text(friendlyError(error)),
          data: (items) => items.isEmpty
              ? const Text('Updates from your lawyer will appear here.')
              : Column(
                  children: items.map((update) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: Text(update.title),
                      subtitle: Text('${update.description}\n${formatDate(update.createdAt)}'),
                      isThreeLine: true,
                    ),
                  )).toList(),
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
  const _QuickAction({required this.label, required this.icon, required this.onTap});
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
        data: (items) => items.isEmpty
            ? const EmptyPanel(message: 'Create a case before uploading a notice.')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final legalCase = items[index];
                  return Card(child: ListTile(
                    title: Text(legalCase.title),
                    subtitle: Text(stageLabel(legalCase.stage.name)),
                    trailing: const Icon(Icons.upload_file),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => CaseDetailScreen(legalCase: legalCase, initialTab: 1),
                    )),
                  ));
                },
              ),
      ),
    );
  }
}

class _CaseListScreenState extends ConsumerState<CaseListScreen> {
  CaseStage? _filter;

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
        final visible = items.where((item) => _filter == null || item.stage == _filter).toList();
        return RefreshIndicator(
          onRefresh: () => ref.refresh(myCasesProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DropdownButtonFormField<CaseStage?>(
                initialValue: _filter,
                decoration: const InputDecoration(labelText: 'Filter by stage'),
                items: [
                  const DropdownMenuItem<CaseStage?>(value: null, child: Text('All stages')),
                  ...CaseStage.values.map((stage) => DropdownMenuItem(
                    value: stage,
                    child: Text(stageLabel(stage.name)),
                  )),
                ],
                onChanged: (stage) => setState(() => _filter = stage),
              ),
              const SizedBox(height: 12),
              if (visible.isEmpty)
                const EmptyPanel(message: 'No cases match this view yet.')
              else
                ...visible.map((legalCase) => Card(
                  child: ListTile(
                    title: Text(legalCase.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(caseTypeLabel(legalCase.caseType.name)),
                        const SizedBox(height: 4),
                        Chip(label: Text(stageLabel(legalCase.stage.name))),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CaseDetailScreen(legalCase: legalCase),
                      ),
                    ),
                  ),
                )),
            ],
          ),
        );
      },
    );
  }
}

class CreateCaseScreen extends ConsumerStatefulWidget {
  const CreateCaseScreen({super.key, this.initialCaseType});
  final CaseType? initialCaseType;

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

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _busy = true; _error = null; });
    try {
      final created = await ref.read(clientProvider).cases.createCase(
        _title.text.trim(), _type, _description.text.trim(),
      );
      ref.invalidate(myCasesProvider);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
        builder: (_) => CaseDetailScreen(legalCase: created),
      ));
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
              Text('Tell us what happened', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 18),
              TextFormField(
                controller: _title,
                maxLength: 120,
                decoration: const InputDecoration(labelText: 'Case title', border: OutlineInputBorder()),
                validator: (value) => (value?.trim().isEmpty ?? true) ? 'Enter a title.' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<CaseType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Case type', border: OutlineInputBorder()),
                items: CaseType.values.map((type) => DropdownMenuItem(value: type, child: Text(caseTypeLabel(type.name)))).toList(),
                onChanged: (type) { if (type != null) setState(() => _type = type); },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _description,
                maxLength: 2000,
                minLines: 4,
                maxLines: 8,
                decoration: const InputDecoration(labelText: 'Describe the issue', alignLabelWithHint: true, border: OutlineInputBorder()),
                validator: (value) => (value?.length ?? 0) > 2000 ? 'Use 2000 characters or fewer.' : null,
              ),
              if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _busy ? null : _submit,
                icon: _busy ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.arrow_forward),
                label: const Text('Create case'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class CaseDetailScreen extends ConsumerWidget {
  const CaseDetailScreen({super.key, required this.legalCase, this.initialTab = 0});
  final LegalCase legalCase;
  final int initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseAsync = ref.watch(legalCaseProvider(legalCase.id!));
    final profile = ref.watch(myProfileProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: Text(legalCase.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (profile?.role == UserRole.citizen)
            IconButton(
              tooltip: 'Edit case details',
              onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => EditCaseScreen(legalCase: legalCase),
              )),
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
          length: 2,
          child: Column(
            children: [
              _CaseSummary(legalCase: item),
              const TabBar(tabs: [Tab(text: 'Timeline'), Tab(text: 'Documents')]),
              Expanded(
                child: TabBarView(children: [
                  TimelinePanel(caseId: item.id!),
                  DocumentListScreen(caseId: item.id!),
                ]),
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
        Wrap(spacing: 8, children: [
          Chip(label: Text(stageLabel(legalCase.stage.name))),
          Chip(label: Text(caseTypeLabel(legalCase.caseType.name))),
        ]),
        Text(legalCase.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 6),
        Text(legalCase.assignedLawyerId == null ? 'Waiting for a lawyer assignment' : 'A lawyer is assigned'),
        Text('Created ${formatDate(legalCase.createdAt)}', style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
  );
}

class TimelinePanel extends ConsumerWidget {
  const TimelinePanel({super.key, required this.caseId});
  final int caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updates = ref.watch(caseUpdatesProvider(caseId));
    return updates.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorPanel(
        message: friendlyError(error),
        onRetry: () => ref.invalidate(caseUpdatesProvider(caseId)),
      ),
      data: (items) => items.isEmpty
          ? const EmptyPanel(message: 'Case updates will appear here.')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final update = items[index];
                final stageChange = update.kind == CaseUpdateKind.stageChange;
                return Card(
                  color: stageChange ? Theme.of(context).colorScheme.secondaryContainer : null,
                  child: ListTile(
                    leading: Icon(stageChange ? Icons.sync_alt : Icons.chat_bubble_outline),
                    title: Text(update.title),
                    subtitle: Text('${update.description}\n${formatDate(update.createdAt)}'),
                    isThreeLine: true,
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
    setState(() { _busy = true; _error = null; });
    try {
      await ref.read(clientProvider).caseUpdate.changeStage(widget.legalCase.id!, stage);
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
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(controller: title, maxLength: 120, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => (v?.trim().isEmpty ?? true) ? 'Enter a title.' : null),
            TextFormField(controller: description, maxLength: 2000, minLines: 2, maxLines: 5, decoration: const InputDecoration(labelText: 'Description'), validator: (v) => (v?.length ?? 0) > 2000 ? 'Use 2000 characters or fewer.' : null),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(onPressed: () { if (form.currentState!.validate()) Navigator.pop(dialogContext, true); }, child: const Text('Post')),
        ],
      ),
    );
    if (save != true) { title.dispose(); description.dispose(); return; }
    setState(() { _busy = true; _error = null; });
    try {
      await ref.read(clientProvider).caseUpdate.addUpdate(
        widget.legalCase.id!, title.text.trim(), description.text.trim(),
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
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
      Row(children: [
        Expanded(child: DropdownButtonFormField<CaseStage>(
          initialValue: widget.legalCase.stage,
          decoration: const InputDecoration(labelText: 'Change stage', isDense: true),
          items: CaseStage.values.map((stage) => DropdownMenuItem(value: stage, child: Text(stageLabel(stage.name)))).toList(),
          onChanged: _busy ? null : _changeStage,
        )),
        const SizedBox(width: 12),
        FilledButton.tonalIcon(onPressed: _busy ? null : _postUpdate, icon: const Icon(Icons.add_comment_outlined), label: const Text('Post update')),
      ]),
    ]),
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
  late final _description = TextEditingController(text: widget.legalCase.description);
  final _form = GlobalKey<FormState>();
  bool _busy = false;
  String? _error;
  @override
  void dispose() { _title.dispose(); _description.dispose(); super.dispose(); }
  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _busy = true; _error = null; });
    try {
      await ref.read(clientProvider).cases.updateCaseInfo(widget.legalCase.id!, _title.text.trim(), _description.text.trim());
      ref.invalidate(legalCaseProvider(widget.legalCase.id!));
      if (mounted) Navigator.pop(context);
    } catch (error) {
      setState(() => _error = friendlyError(error));
    } finally { if (mounted) setState(() => _busy = false); }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Edit case details')),
    body: Form(key: _form, child: ListView(padding: const EdgeInsets.all(20), children: [
      TextFormField(controller: _title, maxLength: 120, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()), validator: (v) => (v?.trim().isEmpty ?? true) ? 'Enter a title.' : null),
      const SizedBox(height: 12),
      TextFormField(controller: _description, minLines: 4, maxLines: 8, maxLength: 2000, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), validator: (v) => (v?.length ?? 0) > 2000 ? 'Use 2000 characters or fewer.' : null),
      if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
      FilledButton(onPressed: _busy ? null : _save, child: _busy ? const CircularProgressIndicator() : const Text('Save changes')),
    ])),
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
  void dispose() { _name.dispose(); super.dispose(); }
  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _name.text.trim().length > 120) {
      setState(() => _error = 'Enter a name using 1 to 120 characters.');
      return;
    }
    setState(() { _busy = true; _error = null; });
    try {
      await ref.read(clientProvider).profile.createOrUpdateMyProfile(_name.text.trim());
      ref.invalidate(myProfileProvider);
      setState(() => _editing = false);
    } catch (error) { setState(() => _error = friendlyError(error)); }
    finally { if (mounted) setState(() => _busy = false); }
  }
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(myProfileProvider);
    return profile.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorPanel(message: friendlyError(error), onRetry: () => ref.invalidate(myProfileProvider)),
      data: (user) {
        if (user == null) return const EmptyPanel(message: 'Profile not found.');
        if (!_editing) _name.text = user.fullName;
        return ListView(padding: const EdgeInsets.all(20), children: [
          Text('Your profile', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          if (_editing) ...[
            TextField(controller: _name, maxLength: 120, decoration: const InputDecoration(labelText: 'Your name', border: OutlineInputBorder())),
            if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 8),
            Row(children: [
              FilledButton(onPressed: _busy ? null : _save, child: const Text('Save name')),
              const SizedBox(width: 8),
              TextButton(onPressed: () => setState(() { _editing = false; _error = null; }), child: const Text('Cancel')),
            ]),
          ] else ...[
            ListTile(leading: const Icon(Icons.person_outline), title: Text(user.fullName), subtitle: Text(user.role.name == 'lawyer' ? 'Lawyer' : 'Citizen')),
            OutlinedButton.icon(onPressed: () => setState(() => _editing = true), icon: const Icon(Icons.edit_outlined), label: const Text('Edit name')),
          ],
        ]);
      },
    );
  }
}
