import 'dart:typed_data';

import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_client/serverpod_client.dart';

import '../../core/date_format.dart';
import '../../providers/app_providers.dart';
import '../../widgets/async_content.dart';
import '../deadlines/deadline_screen.dart';
import 'date_suggestion_parser.dart';

const _maxUploadBytes = 5 * 1024 * 1024;

class DocumentListScreen extends ConsumerStatefulWidget {
  const DocumentListScreen({super.key, required this.caseId});
  final int caseId;

  @override
  ConsumerState<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends ConsumerState<DocumentListScreen> {
  bool _uploading = false;
  String? _error;

  Future<void> _chooseAndUpload() async {
    setState(() { _uploading = true; _error = null; });
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (file == null) return;
      final name = file.name;
      final extension = name.contains('.') ? name.split('.').last.toLowerCase() : '';
      final mimeType = switch (extension) {
        'pdf' => 'application/pdf',
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        _ => null,
      };
      final size = await file.length();
      if (mimeType == null) throw const FormatException('Choose a PDF, JPG, or PNG file.');
      if (size == null) throw const FormatException('Could not read the file size.');
      if (size <= 0 || size > _maxUploadBytes) {
        throw const FormatException('Choose a file that is no larger than 5 MB.');
      }

      final bytes = await file.readAsBytes();
      if (bytes.lengthInBytes != size) {
        throw const FormatException('The selected file could not be read. Please choose it again.');
      }
      final client = ref.read(clientProvider);
      final ticket = await client.document.startUpload(
        widget.caseId,
        name,
        mimeType,
        size,
      );
      final uploaded = await FileUploader(ticket.uploadDescription).uploadByteData(
        ByteData.sublistView(bytes),
      );
      if (!uploaded) throw const FormatException('The upload did not finish. Please try again.');

      await client.document.finishUpload(ticket.documentId);
      CaseDocument? finalDocument;
      for (var attempt = 0; attempt < 30; attempt++) {
        await Future<void>.delayed(const Duration(seconds: 2));
        finalDocument = await client.document.getDocument(ticket.documentId);
        if (finalDocument.ocrStatus == DocumentOcrStatus.completed ||
            finalDocument.ocrStatus == DocumentOcrStatus.failed) {
          break;
        }
      }
      ref.invalidate(caseDocumentsProvider(widget.caseId));
      if (!mounted) return;
      if (finalDocument == null ||
          finalDocument.ocrStatus == DocumentOcrStatus.processing ||
          finalDocument.ocrStatus == DocumentOcrStatus.pending) {
        setState(() => _error = 'This document is taking longer than expected. You can check it again in the documents list.');
        return;
      }
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => OcrReviewScreen(document: finalDocument!),
      ));
    } catch (error) {
      if (mounted) setState(() => _error = error is FormatException ? error.message : friendlyError(error));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(caseDocumentsProvider(widget.caseId));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            FilledButton.icon(
              onPressed: _uploading ? null : _chooseAndUpload,
              icon: _uploading
                  ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.upload_file),
              label: Text(_uploading ? 'Uploading and reading notice…' : 'Upload a notice'),
            ),
            if (_uploading) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
              const SizedBox(height: 4),
              const Text('OCR can take up to one minute.', textAlign: TextAlign.center),
            ],
            if (_error != null) Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ]),
        ),
        Expanded(
          child: documents.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => ErrorPanel(
              message: friendlyError(error),
              onRetry: () => ref.invalidate(caseDocumentsProvider(widget.caseId)),
            ),
            data: (items) => RefreshIndicator(
              onRefresh: () => ref.refresh(caseDocumentsProvider(widget.caseId).future),
              child: items.isEmpty
                  ? ListView(children: const [EmptyPanel(message: 'No documents yet. Upload a notice to get started.')])
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(child: ListTile(
                          leading: const Icon(Icons.description_outlined),
                          title: Text(item.fileName),
                          subtitle: Text('${item.ocrStatus.name} · ${formatBytes(item.sizeBytes)}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            try {
                              final full = await ref.read(clientProvider).document.getDocument(item.id!);
                              if (!context.mounted) return;
                              await Navigator.of(context).push(MaterialPageRoute<void>(
                                builder: (_) => OcrReviewScreen(document: full),
                              ));
                            } catch (error) {
                              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(friendlyError(error))),
                              );
                            }
                          },
                        ));
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

String formatBytes(int bytes) => bytes < 1024 * 1024
    ? '${(bytes / 1024).ceil()} KB'
    : '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';

class OcrReviewScreen extends StatefulWidget {
  const OcrReviewScreen({super.key, required this.document});
  final CaseDocument document;

  @override
  State<OcrReviewScreen> createState() => _OcrReviewScreenState();
}

class _OcrReviewScreenState extends State<OcrReviewScreen> {
  static const _labels = [
    'Cheque date',
    'Cheque presented date',
    'Dishonour intimation date',
    'Notice sent date',
    'Notice received date',
  ];
  late final List<DateSuggestion> _suggestions =
      parseDateSuggestions(widget.document.candidateDates ?? const []);
  final List<DateTime?> _dates = List<DateTime?>.filled(5, null);

  Future<void> _pickDate(int index) async {
    final today = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _dates[index] ?? today,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (selected != null) {
      setState(() => _dates[index] = DateTime.utc(selected.year, selected.month, selected.day));
    }
  }

  Future<void> _chooseSuggestion(int index) async {
    final usable = _suggestions.where((suggestion) => suggestion.date != null).toList();
    final selected = await showModalBottomSheet<DateSuggestion>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(padding: const EdgeInsets.all(16), shrinkWrap: true, children: [
          Text('Choose a date suggestion', style: Theme.of(context).textTheme.titleLarge),
          for (final suggestion in usable)
            ListTile(
              title: Text(suggestion.text),
              subtitle: Text(formatDate(suggestion.date)),
              onTap: () => Navigator.pop(context, suggestion),
            ),
        ]),
      ),
    );
    if (selected != null) setState(() => _dates[index] = selected.date);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Review extracted dates')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Text('Check the notice', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 8),
      const Text('These dates were read automatically and may be wrong. Please confirm them.'),
      const SizedBox(height: 18),
      Text('Suggested dates', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      if (_suggestions.isEmpty)
        const Text('No dates were recognized. You can enter them below.')
      else
        Wrap(spacing: 8, runSpacing: 4, children: _suggestions.map((item) => Chip(
          label: Text(item.date == null ? item.text : '${item.text} · ${formatDate(item.date)}'),
        )).toList()),
      const SizedBox(height: 16),
      for (var i = 0; i < _labels.length; i++)
        Card(child: ListTile(
          title: Text(_labels[i]),
          subtitle: Text(formatDate(_dates[i])),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(tooltip: 'Choose OCR suggestion', onPressed: _suggestions.any((item) => item.date != null) ? () => _chooseSuggestion(i) : null, icon: const Icon(Icons.auto_awesome_outlined)),
            IconButton(tooltip: 'Pick date', onPressed: () => _pickDate(i), icon: const Icon(Icons.calendar_month_outlined)),
          ]),
        )),
      const SizedBox(height: 18),
      FilledButton(
        onPressed: _dates.take(3).every((date) => date != null)
            ? () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => DeadlineScreen(initialDates: _dates),
              ))
            : null,
        child: const Text('Calculate deadlines'),
      ),
      const SizedBox(height: 22),
      Text('Extracted text', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Card(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(widget.document.extractedText ?? 'No text was extracted.'),
          ),
        ),
      ),
      if (widget.document.ocrStatus == DocumentOcrStatus.failed)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(widget.document.errorMessage ?? 'OCR could not read this document.', style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
    ]),
  );
}
