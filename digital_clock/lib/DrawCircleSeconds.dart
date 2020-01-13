import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawCircleSeconds extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  double totalProgress;
  double fraction;

  DrawCircleSeconds(
      {this.lineColor,
      this.completeColor,
      this.completePercent,
      this.width,
      this.totalProgress,
      this.fraction});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2.4, size.height / 2.4);
    canvas.drawCircle(center, radius, line);

    double arcAngle = 2 * pi * (completePercent / totalProgress);
    double arcAnim = 2 * pi * (fraction / totalProgress);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        fraction, false, complete);
  }

  @override
  bool shouldRepaint(DrawCircleSeconds oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
