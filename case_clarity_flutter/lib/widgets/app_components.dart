import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:flutter/material.dart';

import '../core/theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      color: color,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.x2),
        child: child,
      ),
    );
    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: card,
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.x1),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (action != null) action!,
      ],
    ),
  );
}

enum StatusTone { neutral, active, dueSoon, passed, resolved, processing }

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
  });

  factory StatusChip.forStage(CaseStage stage) => StatusChip(
    label: switch (stage) {
      CaseStage.underReview => 'Under review',
      CaseStage.inProgress => 'In progress',
      CaseStage.awaitingDocuments => 'Awaiting documents',
      CaseStage.resolved => 'Resolved',
    },
    tone: stage == CaseStage.resolved ? StatusTone.resolved : StatusTone.active,
  );

  factory StatusChip.forOcr(DocumentOcrStatus status) => StatusChip(
    label: switch (status) {
      DocumentOcrStatus.pending => 'Uploaded',
      DocumentOcrStatus.processing => 'Reading text',
      DocumentOcrStatus.completed => 'Dates found',
      DocumentOcrStatus.failed => 'Could not read',
    },
    tone: switch (status) {
      DocumentOcrStatus.pending => StatusTone.neutral,
      DocumentOcrStatus.processing => StatusTone.processing,
      DocumentOcrStatus.completed => StatusTone.resolved,
      DocumentOcrStatus.failed => StatusTone.passed,
    },
  );

  factory StatusChip.forDeadline(DeadlineStatus status) => StatusChip(
    label: switch (status) {
      DeadlineStatus.upcoming => 'Upcoming',
      DeadlineStatus.dueSoon => 'Due soon',
      DeadlineStatus.passed => 'Passed',
      DeadlineStatus.notYetComputable => 'Not yet computable',
    },
    tone: switch (status) {
      DeadlineStatus.upcoming => StatusTone.neutral,
      DeadlineStatus.dueSoon => StatusTone.dueSoon,
      DeadlineStatus.passed => StatusTone.passed,
      DeadlineStatus.notYetComputable => StatusTone.neutral,
    },
  );

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (background, foreground) = switch (tone) {
      StatusTone.neutral => (
        colors.surfaceContainerHighest,
        colors.onSurfaceVariant,
      ),
      StatusTone.active => (
        colors.secondaryContainer,
        colors.onSecondaryContainer,
      ),
      StatusTone.dueSoon => (const Color(0xFFFFE5B4), const Color(0xFF714000)),
      StatusTone.passed => (colors.errorContainer, colors.onErrorContainer),
      StatusTone.resolved => (const Color(0xFFDCEFE3), const Color(0xFF174A2D)),
      StatusTone.processing => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
      ),
    };
    return Semantics(
      label: label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 42, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: AppSpacing.x1),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.x2),
            action!,
          ],
        ],
      ),
    ),
  );
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => EmptyState(
    icon: Icons.cloud_off_outlined,
    message: message,
    action: onRetry == null
        ? null
        : OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
  );
}

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({super.key, this.rows = 3});
  final int rows;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      final base = Theme.of(context).colorScheme.surfaceContainerHighest;
      final shimmer = Theme.of(context).colorScheme.surface;
      return ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          colors: [base, shimmer, base],
          stops: [
            (_controller.value - .35).clamp(0.0, 1.0).toDouble(),
            _controller.value,
            (_controller.value + .35).clamp(0.0, 1.0).toDouble(),
          ],
        ).createShader(bounds),
        child: Column(
          children: List.generate(
            widget.rows,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x1),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 18,
                      width: index.isEven ? 220 : 160,
                      decoration: BoxDecoration(
                        color: base,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: base,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 14,
                      width: 180,
                      decoration: BoxDecoration(
                        color: base,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: loading ? null : onPressed,
    icon: loading
        ? const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(icon ?? Icons.arrow_forward),
    label: Text(label),
  );
}

class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x2),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.onSecondaryContainer),
          const SizedBox(width: AppSpacing.x1),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colors.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class StageProgress extends StatelessWidget {
  const StageProgress({super.key, required this.stage, this.compact = false});
  final CaseStage stage;
  final bool compact;

  static const stages = CaseStage.values;

  @override
  Widget build(BuildContext context) {
    final activeIndex = stages.indexOf(stage);
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        for (var index = 0; index < stages.length; index++) ...[
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 3,
                        color: index == 0
                            ? Colors.transparent
                            : (index <= activeIndex
                                  ? colors.secondary
                                  : colors.outlineVariant),
                      ),
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index <= activeIndex
                            ? colors.secondary
                            : colors.surfaceContainerHighest,
                        border: Border.all(
                          color: index <= activeIndex
                              ? colors.secondary
                              : colors.outlineVariant,
                        ),
                      ),
                      child: index < activeIndex
                          ? Icon(
                              Icons.check,
                              size: 12,
                              color: colors.onSecondary,
                            )
                          : null,
                    ),
                    Expanded(
                      child: Container(
                        height: 3,
                        color: index == stages.length - 1
                            ? Colors.transparent
                            : (index < activeIndex
                                  ? colors.secondary
                                  : colors.outlineVariant),
                      ),
                    ),
                  ],
                ),
                if (!compact) ...[
                  const SizedBox(height: 6),
                  Text(
                    _label(stages[index]),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  static String _label(CaseStage stage) => switch (stage) {
    CaseStage.underReview => 'Review',
    CaseStage.inProgress => 'In progress',
    CaseStage.awaitingDocuments => 'Documents',
    CaseStage.resolved => 'Resolved',
  };
}
