import 'package:flutter/material.dart';
import 'dart:ui';

class NavCustomPainter extends CustomPainter {
  late double loc;
  late double s;
  Color color;
  TextDirection textDirection;
  bool stroke;

  NavCustomPainter(double startingLoc, int itemsLength, this.color,
      this.textDirection, this.stroke) {
    final span = 1.0 / itemsLength;
    s = 0.2;
    double l = startingLoc + (span - s) / 2;
    loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = stroke ? PaintingStyle.stroke : PaintingStyle.fill
      ..isAntiAlias = false
      ..strokeWidth = 1;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo((loc - 0.1) * size.width, 0)
      ..cubicTo(
        (loc + s * 0.20) * size.width,
        size.height * 0.05,
        loc * size.width,
        size.height * 0.85,
        (loc + s * 0.50) * size.width,
        size.height * 0.85,
      )
      ..cubicTo(
        (loc + s) * size.width,
        size.height * 0.85,
        (loc + s - s * 0.20) * size.width,
        size.height * 0.05,
        (loc + s + 0.05) * size.width,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawShadow(
        path.shift(Offset(0, -2)), Colors.black.withOpacity(0.1), 0.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
