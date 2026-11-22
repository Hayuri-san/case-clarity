import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

class AsyncContent<T> extends StatelessWidget {
  const AsyncContent({
    super.key,
    required this.value,
    required this.data,
    required this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (value.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (value.hasError) {
      return ErrorPanel(message: friendlyError(value.error!), onRetry: onRetry);
    }
    if (!value.hasValue) {
      return ErrorPanel(message: 'No information was returned.', onRetry: onRetry);
    }
    final result = value.value;
    if (result == null) {
      return ErrorPanel(message: 'No information was returned.', onRetry: onRetry);
    }
    return data(result);
  }
}

class ErrorPanel extends StatelessWidget {
  const ErrorPanel({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline, color: colors.error, size: 36),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyPanel extends StatelessWidget {
  const EmptyPanel({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}

String stageLabel(String stage) => switch (stage) {
  'underReview' => 'Under review',
  'inProgress' => 'In progress',
  'awaitingDocuments' => 'Awaiting documents',
  'resolved' => 'Resolved',
  _ => stage,
};

String caseTypeLabel(String type) => switch (type) {
  'chequeBounce' => 'Cheque bounce',
  'consumerComplaint' => 'Consumer complaint',
  'cyberFraud' => 'Cyber fraud',
  'other' => 'Other',
  _ => type,
};
