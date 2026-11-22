import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/date_format.dart';
import '../../providers/app_providers.dart';

class DeadlineScreen extends ConsumerStatefulWidget {
  const DeadlineScreen({super.key, this.initialDates});
  final List<DateTime?>? initialDates;

  @override
  ConsumerState<DeadlineScreen> createState() => _DeadlineScreenState();
}

class _DeadlineScreenState extends ConsumerState<DeadlineScreen> {
  static const _labels = [
    'Cheque date',
    'Cheque presented date',
    'Dishonour intimation date',
    'Notice sent date (optional)',
    'Notice received date (optional)',
  ];
  late final List<DateTime?> _dates = List<DateTime?>.generate(
    5,
    (index) => widget.initialDates != null && index < widget.initialDates!.length
        ? widget.initialDates![index]
        : null,
  );
  Section138DeadlineResult? _result;
  bool _busy = false;
  String? _error;

  Future<void> _pickDate(int index) async {
    final current = _dates[index];
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: current == null ? now : DateTime(current.year, current.month, current.day),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (selected != null) {
      setState(() => _dates[index] = DateTime.utc(selected.year, selected.month, selected.day));
    }
  }

  Future<void> _calculate() async {
    if (_dates.take(3).any((date) => date == null)) {
      setState(() => _error = 'Choose the cheque, presentation, and dishonour dates.');
      return;
    }
    setState(() { _busy = true; _error = null; _result = null; });
    try {
      final dates = _dates;
      _result = await ref.read(clientProvider).deadline.calculateSection138(
        chequeDate: dates[0]!,
        chequePresentedDate: dates[1]!,
        dishonourIntimationDate: dates[2]!,
        noticeSentDate: dates[3],
        noticeReceivedDate: dates[4],
      );
    } catch (error) {
      _error = friendlyError(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Deadline calculator')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Confirm the dates', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('These dates are used to estimate the Section 138 deadlines.'),
        const SizedBox(height: 16),
        for (var i = 0; i < _labels.length; i++)
          Card(
            child: ListTile(
              title: Text(_labels[i]),
              subtitle: Text(formatDate(_dates[i])),
              trailing: IconButton(
                tooltip: 'Pick ${_labels[i]}',
                onPressed: () => _pickDate(i),
                icon: const Icon(Icons.calendar_month_outlined),
              ),
              onTap: () => _pickDate(i),
            ),
          ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _busy ? null : _calculate,
          icon: _busy
              ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.calculate_outlined),
          label: const Text('Calculate deadlines'),
        ),
        if (_result case final result?) ...[
          const SizedBox(height: 24),
          DeadlineResults(result: result),
        ],
      ],
    ),
  );
}

class DeadlineResults extends StatelessWidget {
  const DeadlineResults({super.key, required this.result});
  final Section138DeadlineResult result;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Your deadline checklist', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 10),
      for (final item in result.items)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Text(item.label, style: Theme.of(context).textTheme.titleMedium)),
                _StatusBadge(status: item.status),
              ]),
              const SizedBox(height: 8),
              Text(item.dueDate == null ? 'Due date not yet available' : 'Due ${formatDate(item.dueDate)}'),
              const SizedBox(height: 4),
              Text(item.basis, style: Theme.of(context).textTheme.bodyMedium),
            ]),
          ),
        ),
      if (result.assumptions.isNotEmpty) ...[
        const SizedBox(height: 12),
        Text('Assumptions', style: Theme.of(context).textTheme.titleLarge),
        for (final assumption in result.assumptions)
          ListTile(leading: const Icon(Icons.info_outline), title: Text(assumption), contentPadding: EdgeInsets.zero),
      ],
      const SizedBox(height: 12),
      Card(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(result.disclaimer, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    ],
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final DeadlineStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (label, color, foreground) = switch (status) {
      DeadlineStatus.upcoming => ('Upcoming', colors.primaryContainer, colors.onPrimaryContainer),
      DeadlineStatus.dueSoon => ('Due soon', colors.tertiaryContainer, colors.onTertiaryContainer),
      DeadlineStatus.passed => ('Passed', colors.errorContainer, colors.onErrorContainer),
      DeadlineStatus.notYetComputable => ('Not yet computable', colors.surfaceContainerHighest, colors.onSurfaceVariant),
    };
    return DecoratedBox(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(label, style: TextStyle(color: foreground, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
