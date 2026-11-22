import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import 'app_components.dart';

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
      return const SkeletonLoader();
    }
    if (value.hasError) {
      return ErrorState(message: friendlyError(value.error!), onRetry: onRetry);
    }
    if (!value.hasValue) {
      return const EmptyState(
        icon: Icons.inbox_outlined,
        message: 'No information was returned.',
      );
    }
    final result = value.value;
    if (result == null) {
      return const EmptyState(
        icon: Icons.inbox_outlined,
        message: 'No information was returned.',
      );
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
  Widget build(BuildContext context) =>
      ErrorState(message: message, onRetry: onRetry);
}

class EmptyPanel extends StatelessWidget {
  const EmptyPanel({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => EmptyState(
    icon: Icons.folder_open_outlined,
    message: message,
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
