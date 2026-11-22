import 'dart:math' as math;

import 'package:case_clarity_client/case_clarity_client.dart';
import 'package:flutter/material.dart';

import '../core/theme.dart';

class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({super.key, required this.child, this.index = 0});
  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: CaseClarityMotion.entrance + Duration(milliseconds: index * 45),
      curve: CaseClarityMotion.curve,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({super.key, required this.value, this.style});
  final int value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context))
      return Text('$value', style: style);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: CaseClarityMotion.counter,
      curve: Curves.easeOutCubic,
      builder: (context, current, _) =>
          Text('${current.round()}', style: style),
    );
  }
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: (dark ? const Color(0xFF202733) : Colors.white).withValues(
          alpha: .82,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: dark ? .1 : .65),
        ),
        boxShadow: CaseClarityDecor.cardShadow(context),
      ),
      child: child,
    );
  }
}

class AnimatedLegalBackdrop extends StatefulWidget {
  const AnimatedLegalBackdrop({super.key, required this.child});
  final Widget child;
  @override
  State<AnimatedLegalBackdrop> createState() => _AnimatedLegalBackdropState();
}

class _AnimatedLegalBackdropState extends State<AnimatedLegalBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) => CustomPaint(
      painter: _LegalBackdropPainter(
        _controller.value,
        Theme.of(context).brightness == Brightness.dark,
      ),
      child: widget.child,
    ),
  );
}

class _LegalBackdropPainter extends CustomPainter {
  const _LegalBackdropPainter(this.phase, this.dark);
  final double phase;
  final bool dark;
  @override
  void paint(Canvas canvas, Size size) {
    final colors = dark
        ? CaseClarityColors.darkGradient
        : CaseClarityColors.heroGradient;
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ).createShader(Offset.zero & size),
    );
    final pale = Paint()..color = Colors.white.withValues(alpha: .07);
    for (var i = 0; i < 5; i++) {
      final x = (i * .23 + phase * .12) % 1;
      final y = .16 + .68 * ((i * .31 + phase * .08) % 1);
      canvas.drawCircle(
        Offset(size.width * x, size.height * y),
        32 + i * 18,
        pale,
      );
    }
    final center = Offset(size.width * .5, size.height * .28);
    final motif = Paint()
      ..color = Colors.white.withValues(alpha: .08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawLine(center.translate(-64, 34), center.translate(64, 34), motif);
    canvas.drawLine(center.translate(0, -30), center.translate(0, 54), motif);
    canvas.drawCircle(center.translate(0, -35), 8, motif);
    for (final side in [-1.0, 1.0]) {
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + side * 50, center.dy + 26);
      canvas.drawPath(path, motif);
      canvas.drawLine(
        center.translate(side * 50, 26),
        center.translate(side * 76, 26),
        motif,
      );
      canvas.drawLine(
        center.translate(side * 50, 26),
        center.translate(side * 62, 52),
        motif,
      );
      canvas.drawLine(
        center.translate(side * 76, 26),
        center.translate(side * 62, 52),
        motif,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LegalBackdropPainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.dark != dark;
}

class CaseStageDonut extends StatelessWidget {
  const CaseStageDonut({super.key, required this.counts});
  final Map<CaseStage, int> counts;
  @override
  Widget build(BuildContext context) {
    final total = counts.values.fold<int>(0, (sum, value) => sum + value);
    if (total == 0) return const SizedBox.shrink();
    final colors = [
      Theme.of(context).colorScheme.secondary,
      const Color(0xFF5177A8),
      const Color(0xFFD49A43),
      CaseClarityColors.green,
    ];
    return Row(
      children: [
        SizedBox(
          width: 108,
          height: 108,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: CaseClarityMotion.counter,
            builder: (context, progress, _) => CustomPaint(
              painter: _DonutPainter(
                CaseStage.values.map((stage) => counts[stage] ?? 0).toList(),
                colors,
                progress,
              ),
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              for (var i = 0; i < CaseStage.values.length; i++)
                _LegendDot(
                  color: colors[i],
                  label:
                      '${_stageName(CaseStage.values[i])} ${counts[CaseStage.values[i]] ?? 0}',
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.values, this.colors, this.progress);
  final List<int> values;
  final List<Color> colors;
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<int>(0, (sum, value) => sum + value);
    if (total == 0) return;
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = math.pi * 2 * values[i] / total * progress;
      canvas.drawArc(
        rect.deflate(5),
        start,
        sweep,
        false,
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14
          ..strokeCap = StrokeCap.round,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.values != values;
}

class CaseTypeStack extends StatelessWidget {
  const CaseTypeStack({super.key, required this.counts});
  final Map<String, int> counts;
  @override
  Widget build(BuildContext context) {
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) return const SizedBox.shrink();
    final colors = [
      Theme.of(context).colorScheme.secondary,
      const Color(0xFF5177A8),
      const Color(0xFFD49A43),
      const Color(0xFF9272B3),
    ];
    final entries = counts.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 14,
            child: Row(
              children: [
                for (var i = 0; i < entries.length; i++)
                  Expanded(
                    flex: entries[i].value < 1 ? 1 : entries[i].value,
                    child: ColoredBox(color: colors[i % colors.length]),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            for (var i = 0; i < entries.length; i++)
              _LegendDot(
                color: colors[i % colors.length],
                label: '${_caseTypeName(entries[i].key)} ${entries[i].value}',
              ),
          ],
        ),
      ],
    );
  }
}

class CaseStageBars extends StatelessWidget {
  const CaseStageBars({super.key, required this.counts});
  final Map<CaseStage, int> counts;
  @override
  Widget build(BuildContext context) {
    final colors = [
      Theme.of(context).colorScheme.secondary,
      const Color(0xFF5177A8),
      CaseClarityColors.dueSoon,
      CaseClarityColors.resolved,
    ];
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: CaseClarityMotion.counter,
      builder: (context, progress, _) => SizedBox(
        height: 164,
        width: double.infinity,
        child: CustomPaint(
          painter: _StageBarPainter(
            CaseStage.values.map((stage) => counts[stage] ?? 0).toList(),
            colors,
            progress,
          ),
        ),
      ),
    );
  }
}

class _StageBarPainter extends CustomPainter {
  const _StageBarPainter(this.values, this.colors, this.progress);
  final List<int> values;
  final List<Color> colors;
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = values.fold<int>(
      1,
      (maximum, value) => value > maximum ? value : maximum,
    );
    const labels = ['Review', 'In progress', 'Documents', 'Resolved'];
    final slot = size.width / values.length;
    for (var i = 0; i < values.length; i++) {
      final barHeight = (size.height - 38) * values[i] / maxValue * progress;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          i * slot + slot * .24,
          size.height - 27 - barHeight,
          slot * .52,
          barHeight,
        ),
        const Radius.circular(8),
      );
      canvas.drawRRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [colors[i].withValues(alpha: .65), colors[i]],
          ).createShader(rect.outerRect),
      );
      final text = TextPainter(
        text: TextSpan(
          text: '${values[i]}',
          style: TextStyle(
            color: colors[i],
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(
        canvas,
        Offset(
          i * slot + (slot - text.width) / 2,
          size.height - 32 - barHeight - text.height,
        ),
      );
      final label = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: colors[i].withValues(alpha: .92),
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: slot - 4);
      label.paint(
        canvas,
        Offset(i * slot + (slot - label.width) / 2, size.height - 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StageBarPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.values != values;
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(label, style: Theme.of(context).textTheme.labelMedium),
    ],
  );
}

class DeadlineRing extends StatelessWidget {
  const DeadlineRing({super.key, required this.daysRemaining, this.size = 60});
  final int? daysRemaining;
  final double size;
  @override
  Widget build(BuildContext context) {
    final days = daysRemaining;
    final color = days == null
        ? Theme.of(context).colorScheme.outline
        : days < 0
        ? CaseClarityColors.passed
        : days <= 7
        ? CaseClarityColors.dueSoon
        : CaseClarityColors.resolved;
    final progress = days == null
        ? 0.0
        : days < 0
        ? 1.0
        : (1 - days / 30).clamp(0.06, 1.0).toDouble();
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(progress, color),
        child: Center(
          child: Text(
            days == null
                ? '—'
                : days < 0
                ? 'Past'
                : '$days',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter(this.progress, this.color);
  final double progress;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final track = Paint()
      ..color = color.withValues(alpha: .16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final active = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect.deflate(4), 0, math.pi * 2, false, track);
    canvas.drawArc(
      rect.deflate(4),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      active,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _HoverScale extends StatefulWidget {
  const _HoverScale({required this.child});
  final Widget child;
  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hovered = false;
  bool _pressed = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() {
      _hovered = false;
      _pressed = false;
    }),
    child: GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed
            ? .97
            : _hovered
            ? 1.025
            : 1,
        duration: CaseClarityMotion.micro,
        child: widget.child,
      ),
    ),
  );
}

Widget hoverScale(Widget child) => _HoverScale(child: child);

String _stageName(CaseStage stage) => switch (stage) {
  CaseStage.underReview => 'Review',
  CaseStage.inProgress => 'In progress',
  CaseStage.awaitingDocuments => 'Documents',
  CaseStage.resolved => 'Resolved',
};
String _caseTypeName(String key) => switch (key) {
  'chequeBounce' => 'Cheque bounce',
  'consumerComplaint' => 'Consumer',
  'cyberFraud' => 'Cyber fraud',
  _ => key,
};
