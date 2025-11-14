import 'dart:math';
import 'package:flutter/material.dart';

class DashedBorder extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final Radius radius;
  final List<double> dashArray;
  final Color color;
  final EdgeInsets padding;

  const DashedBorder({
    super.key,
    required this.child,
    this.strokeWidth = 1.5,
    this.radius = const Radius.circular(12),
    this.dashArray = const [6, 4],
    this.color = Colors.white38,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(
        color: color,
        strokeWidth: strokeWidth,
        radius: radius,
        dashArray: dashArray,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final double strokeWidth;
  final Radius radius;
  final List<double> dashArray;
  final Color color;

  _DashedRectPainter({
    this.strokeWidth = 1.5,
    this.radius = const Radius.circular(12),
    this.dashArray = const [6, 4],
    this.color = Colors.white38,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, radius);
    final path = Path()..addRRect(rrect);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    // compute metrics and draw dashes
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      final len = metric.length;
      int i = 0;
      while (distance < len) {
        final double drawLen = min(dashArray[i % dashArray.length], len - distance);
        final Path extractPath = metric.extractPath(distance, distance + drawLen);
        canvas.drawPath(extractPath, paint);
        distance += drawLen;
        // skip the gap
        final double gapLen = dashArray[(i + 1) % dashArray.length];
        distance += gapLen;
        i += 2;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        oldDelegate.dashArray != dashArray;
  }
}
