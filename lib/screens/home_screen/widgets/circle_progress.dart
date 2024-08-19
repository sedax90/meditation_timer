import 'dart:math';

import 'package:flutter/widgets.dart';

class CircleProgress extends CustomPainter {
  final double value;
  final Color color;
  final double strokeWidth;
  final double width;

  CircleProgress({
    super.repaint,
    required this.value,
    required this.color,
    required this.strokeWidth,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final circle = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final arcRect = Rect.fromCircle(center: size.center(Offset.zero), radius: width / 2);
    canvas.drawArc(arcRect, 3 * pi / 2, value, false, circle);
  }

  @override
  bool shouldRepaint(CircleProgress oldDelegate) => false;
}
