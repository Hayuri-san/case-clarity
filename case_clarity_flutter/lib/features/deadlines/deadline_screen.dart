import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../core/date_format.dart';
import '../../providers/app_providers.dart';
import '../../widgets/app_components.dart';

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
    (index) =>
        widget.initialDates != null && index < widget.initialDates!.length
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
      initialDate: current == null
          ? now
          : DateTime(current.year, current.month, current.day),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (selected != null) {
      setState(
        () => _dates[index] = DateTime.utc(
          selected.year,
          selected.month,
          selected.day,
        ),
      );
    }
  }

  Future<void> _calculate() async {
    if (_dates.take(3).any((date) => date == null)) {
      setState(
        () => _error = 'Choose the cheque, presentation, and dishonour dates.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _result = null;
    });
    try {
      final dates = _dates;
      _result = await ref
          .read(clientProvider)
          .deadline
          .calculateSection138(
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
        const SectionHeader(
          title: 'Section 138 deadline calculator',
          subtitle: 'Confirm the dates shown on your cheque and notice.',
        ),
        const SizedBox(height: 8),
        const InfoBanner(
          message:
              'Dates read from a document are suggestions. Check each one against the original notice before calculating.',
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < _labels.length; i++)
          AppCard(
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
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 12),
        PrimaryButton(
          onPressed: _busy ? null : _calculate,
          loading: _busy,
          icon: Icons.calculate_outlined,
          label: 'Calculate deadlines',
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
      Row(
        children: [
          Expanded(
            child: Text(
              'Your deadline checklist',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          IconButton(
            tooltip: 'Copy deadline summary',
            icon: const Icon(Icons.copy_outlined),
            onPressed: () async {
              final summary = result.items
                  .map(
                    (item) =>
                        '${item.label}: ${item.dueDate == null ? 'Not yet computable' : formatDate(item.dueDate)}',
                  )
                  .join('\n');
              await Clipboard.setData(
                ClipboardData(text: '$summary\n${result.disclaimer}'),
              );
              if (context.mounted)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Deadline summary copied.')),
                );
            },
          ),
        ],
      ),
      const SizedBox(height: 10),
      for (final item in result.items)
        AppCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    StatusChip.forDeadline(item.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.dueDate == null
                      ? 'Due date not yet available'
                      : 'Due ${formatDate(item.dueDate)}',
                ),
                const SizedBox(height: 4),
                Text(item.basis, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      if (result.assumptions.isNotEmpty) ...[
        const SizedBox(height: 12),
        ExpansionTile(
          title: const Text('Assumptions and counting rules'),
          children: result.assumptions
              .map(
                (assumption) => ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(assumption),
                ),
              )
              .toList(),
        ),
      ],
      const SizedBox(height: 12),
      InfoBanner(message: result.disclaimer),
    ],
  );
}
