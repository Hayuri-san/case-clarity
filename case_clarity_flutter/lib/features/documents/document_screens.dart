import 'dart:typed_data';

import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serverpod_client/serverpod_client.dart';

import '../../core/date_format.dart';
import '../../providers/app_providers.dart';
import '../../widgets/app_components.dart';
import '../../widgets/async_content.dart';
import '../deadlines/deadline_screen.dart';
import 'date_suggestion_parser.dart';

const _maxUploadBytes = 5 * 1024 * 1024;

class DocumentListScreen extends ConsumerStatefulWidget {
  const DocumentListScreen({
    super.key,
    required this.caseId,
    this.startCameraScan = false,
  });
  final int caseId;
  final bool startCameraScan;

  @override
  ConsumerState<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends ConsumerState<DocumentListScreen> {
  bool _uploading = false;
  bool _cameraUnavailable = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.startCameraScan) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _captureAndUpload();
      });
    }
  }

  Future<void> _chooseAndUpload() async {
    setState(() {
      _uploading = true;
      _error = null;
    });
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (file == null) return;
      final name = file.name;
      final extension = name.contains('.')
          ? name.split('.').last.toLowerCase()
          : '';
      final mimeType = switch (extension) {
        'pdf' => 'application/pdf',
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        _ => null,
      };
      final size = await file.length();
      if (mimeType == null)
        throw const FormatException('Choose a PDF, JPG, or PNG file.');
      if (size == null)
        throw const FormatException('Could not read the file size.');
      if (size <= 0 || size > _maxUploadBytes) {
        throw const FormatException(
          'Choose a file that is no larger than 5 MB.',
        );
      }

      final bytes = await file.readAsBytes();
      if (bytes.lengthInBytes != size) {
        throw const FormatException(
          'The selected file could not be read. Please choose it again.',
        );
      }
      await _uploadBytes(name, mimeType, bytes);
    } catch (error) {
      if (mounted)
        setState(
          () => _error = error is FormatException
              ? error.message
              : friendlyError(error),
        );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _captureAndUpload() async {
    setState(() {
      _uploading = true;
      _cameraUnavailable = false;
      _error = null;
    });
    try {
      final picker = ImagePicker();
      XFile? photo;
      var approved = false;
      while (!approved) {
        photo = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 2000,
          maxHeight: 2000,
          imageQuality: 82,
        );
        if (photo == null) return;
        final bytes = await photo.readAsBytes();
        if (bytes.lengthInBytes > _maxUploadBytes) {
          throw const FormatException(
            'This photo is still larger than 5 MB. Retake it closer or use a smaller image.',
          );
        }
        if (!mounted) return;
        final usePhoto = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Review your scan'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 420),
              child: Image.memory(bytes, fit: BoxFit.contain),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Retake'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Use photo'),
              ),
            ],
          ),
        );
        if (usePhoto == null) return;
        approved = usePhoto;
      }
      final capturedPhoto = photo;
      if (capturedPhoto == null) return;
      final bytes = await capturedPhoto.readAsBytes();
      await _uploadBytes('notice-scan.jpg', 'image/jpeg', bytes);
    } catch (error) {
      if (mounted) {
        if (error is PlatformException ||
            error is MissingPluginException ||
            error is UnsupportedError) {
          setState(() {
            _cameraUnavailable = true;
            _error =
                'Camera access is unavailable. You can choose a notice file instead.';
          });
        } else {
          setState(
            () => _error = error is FormatException
                ? error.message
                : friendlyError(error),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _uploadBytes(
    String name,
    String mimeType,
    Uint8List bytes,
  ) async {
    if (bytes.isEmpty || bytes.lengthInBytes > _maxUploadBytes) {
      throw const FormatException('Choose an image smaller than 5 MB.');
    }
    final client = ref.read(clientProvider);
    final ticket = await client.document.startUpload(
      widget.caseId,
      name,
      mimeType,
      bytes.lengthInBytes,
    );
    final uploaded = await FileUploader(
      ticket.uploadDescription,
    ).uploadByteData(ByteData.sublistView(bytes));
    if (!uploaded) {
      throw const FormatException(
        'The upload did not finish. Please try again.',
      );
    }
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
      setState(
        () => _error =
            'This document is taking longer than expected. You can check it again in the documents list.',
      );
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OcrReviewScreen(document: finalDocument!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(caseDocumentsProvider(widget.caseId));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryButton(
                onPressed: _uploading ? null : _chooseAndUpload,
                loading: _uploading,
                icon: Icons.upload_file,
                label: _uploading
                    ? 'Uploading and reading notice…'
                    : 'Upload a notice',
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _uploading ? null : _captureAndUpload,
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Scan with camera'),
              ),
              if (_uploading) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
                const SizedBox(height: 4),
                const Text(
                  'Step 2 of 3 · Reading text. This can take up to one minute.',
                  textAlign: TextAlign.center,
                ),
              ],
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              if (_cameraUnavailable)
                TextButton.icon(
                  onPressed: _uploading ? null : _chooseAndUpload,
                  icon: const Icon(Icons.folder_open_outlined),
                  label: const Text('Choose a file instead'),
                ),
            ],
          ),
        ),
        Expanded(
          child: documents.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => ErrorPanel(
              message: friendlyError(error),
              onRetry: () =>
                  ref.invalidate(caseDocumentsProvider(widget.caseId)),
            ),
            data: (items) => RefreshIndicator(
              onRefresh: () =>
                  ref.refresh(caseDocumentsProvider(widget.caseId).future),
              child: items.isEmpty
                  ? ListView(
                      children: const [
                        EmptyPanel(
                          message:
                              'No documents yet. Upload a notice to get started.',
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return AppCard(
                          onTap: () async {
                            try {
                              final full = await ref
                                  .read(clientProvider)
                                  .document
                                  .getDocument(item.id!);
                              if (!context.mounted) return;
                              await Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      OcrReviewScreen(document: full),
                                ),
                              );
                            } catch (error) {
                              if (context.mounted)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(friendlyError(error))),
                                );
                            }
                          },
                          child: ListTile(
                            leading: const Icon(Icons.description_outlined),
                            title: Text(item.fileName),
                            subtitle: Text(formatBytes(item.sizeBytes)),
                            trailing: StatusChip.forOcr(item.ocrStatus),
                          ),
                        );
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
  late final List<DateSuggestion> _suggestions = parseDateSuggestions(
    widget.document.candidateDates ?? const [],
  );
  final List<DateTime?> _dates = List<DateTime?>.filled(5, null);
  int _selectedDateIndex = 0;

  Future<void> _pickDate(int index) async {
    final today = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _dates[index] ?? today,
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

  Future<void> _chooseSuggestion(int index) async {
    final usable = _suggestions
        .where((suggestion) => suggestion.date != null)
        .toList();
    final selected = await showModalBottomSheet<DateSuggestion>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: [
            Text(
              'Choose a date suggestion',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            for (final suggestion in usable)
              ListTile(
                title: Text(suggestion.text),
                subtitle: Text(formatDate(suggestion.date)),
                onTap: () => Navigator.pop(context, suggestion),
              ),
          ],
        ),
      ),
    );
    if (selected != null) setState(() => _dates[index] = selected.date);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Review extracted dates')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SectionHeader(
          title: 'Check the notice',
          subtitle:
              'OCR suggestions are not confirmed dates. Review each before calculating.',
        ),
        const SizedBox(height: 8),
        InfoBanner(
          message:
              'Step 3 of 3 · Review the extracted dates and confirm the ones you can verify. OCR can make mistakes.',
        ),
        const SizedBox(height: 18),
        Text('Suggested dates', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (_suggestions.isEmpty)
          const Text('No dates were recognized. You can enter them below.')
        else ...[
          DropdownButtonFormField<int>(
            initialValue: _selectedDateIndex,
            decoration: const InputDecoration(labelText: 'Fill date field'),
            items: List.generate(
              _labels.length,
              (i) => DropdownMenuItem(value: i, child: Text(_labels[i])),
            ),
            onChanged: (value) {
              if (value != null) setState(() => _selectedDateIndex = value);
            },
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _suggestions
                .map(
                  (item) => ActionChip(
                    label: Text(
                      item.date == null
                          ? item.text
                          : '${item.text} · ${formatDate(item.date)}',
                    ),
                    onPressed: item.date == null
                        ? null
                        : () => setState(
                            () => _dates[_selectedDateIndex] = item.date,
                          ),
                  ),
                )
                .toList(),
          ),
        ],
        const SizedBox(height: 16),
        for (var i = 0; i < _labels.length; i++)
          Card(
            child: ListTile(
              title: Text(_labels[i]),
              subtitle: Text(formatDate(_dates[i])),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Choose OCR suggestion',
                    onPressed: _suggestions.any((item) => item.date != null)
                        ? () => _chooseSuggestion(i)
                        : null,
                    icon: const Icon(Icons.auto_awesome_outlined),
                  ),
                  IconButton(
                    tooltip: 'Pick date',
                    onPressed: () => _pickDate(i),
                    icon: const Icon(Icons.calendar_month_outlined),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: _dates.take(3).every((date) => date != null)
              ? () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => DeadlineScreen(initialDates: _dates),
                  ),
                )
              : null,
          child: const Text('Calculate deadlines'),
        ),
        const SizedBox(height: 22),
        const SectionHeader(title: 'Extracted text'),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: widget.document.extractedText == null
                ? null
                : () async {
                    await Clipboard.setData(
                      ClipboardData(text: widget.document.extractedText!),
                    );
                    if (context.mounted)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Extracted text copied.')),
                      );
                  },
            icon: const Icon(Icons.copy_outlined),
            label: const Text('Copy text'),
          ),
        ),
        Card(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                widget.document.extractedText ?? 'No text was extracted.',
              ),
            ),
          ),
        ),
        if (widget.document.ocrStatus == DocumentOcrStatus.failed)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              widget.document.errorMessage ??
                  'OCR could not read this document.',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    ),
  );
}
