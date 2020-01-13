import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawCircle extends CustomPainter {
  Paint _paint;

  DrawCircle() {
    _paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    var radious = size.width/2;
    final Offset offsetCenter = Offset(0.0, 0.0);
     canvas.translate(size.width / 2, size.width / 2);

     canvas.drawCircle(offsetCenter,100, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}