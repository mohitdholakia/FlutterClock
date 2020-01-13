import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlinkingText extends StatefulWidget {
  final Color _color;

  BlinkingText(this._color);

  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _animationController,
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(":",
              style: TextStyle(
                  color: widget._color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ));
  }

  @override
  void didUpdateWidget(BlinkingText oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
