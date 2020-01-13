import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawCircleMinutes extends CustomPainter {
  /*Paint _paint;

  DrawCircleMinutes() {
    _paint = Paint()
      ..color = Color(0xFF4285F4)
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    */ /*final double center = size.width * 0.5;
    var radious = size.width/2;*/ /*
    final Offset offsetCenter = Offset(0.0, 0.0);
    canvas.translate(size.width / 2, size.width / 2);
    canvas.drawCircle(offsetCenter,85, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }*/

  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  double totalProgress;

  DrawCircleMinutes(
      {this.lineColor,
      this.completeColor,
      this.completePercent,
      this.width,
      this.totalProgress});

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
    double radius = min(size.width / 2.2, size.height / 2.2);
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * (completePercent / totalProgress);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
