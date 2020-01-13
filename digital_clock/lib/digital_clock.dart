// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:digital_clock/BlinkingText.dart';
import 'package:digital_clock/DrawCircleMinutes.dart';
import 'package:digital_clock/DrawCircleOuterMain.dart';
import 'package:digital_clock/DrawCircleSeconds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
  progressHour,
  progressHourInActive,
  progressMinutes,
  progressMinutesInActive,
  progressSeconds,
  progressSecondsInActive
}

final _lightTheme = {
  _Element.background: Colors.black87,
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
  _Element.progressHour: Color(0xFFbae8e8),
  _Element.progressHourInActive: Color(0x50bae8e8),
  _Element.progressMinutes: Color(0xFFe3f6f5),
  _Element.progressMinutesInActive: Color(0x50e3f6f5),
  _Element.progressSeconds: Color(0xFFd6e5fa),
  _Element.progressSecondsInActive: Color(0x50d6e5fa),
};

final _darkTheme = {
  _Element.background: Colors.black87,
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
  _Element.progressHour: Color(0xFFce2e6c),
  _Element.progressHourInActive: Color(0x50ce2e6c),
  _Element.progressMinutes: Color(0xFFffb5b5),
  _Element.progressMinutesInActive: Color(0x50ffb5b5),
  _Element.progressSeconds: Color(0xFFf0decb),
  _Element.progressSecondsInActive: Color(0x50f0decb),
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  var _temperature = '';
  var _condition = '';

  double _fraction = 0.0;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();

    var controller = AnimationController(
        duration: Duration(milliseconds: 60000), vsync: this);

    animation = Tween(
            begin: double.parse(DateFormat('ss').format(_dateTime)), end: 60.0)
        .animate(controller)
          ..addListener(() {
            setState(() {
              var temp = double.parse(DateFormat('ss').format(_dateTime));
              _fraction = 2 * pi * (temp / 60);
              ;
              //  _fraction =  ((animation.value)/60)*2*pi+0.100;
              if (animation.value == 60.0) {
                controller.repeat();
              }
            });
          });
    controller.forward();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _condition = widget.model.weatherString;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      /* _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );*/
      //Update once per second, but make sure to do it at the beginning of each
      //new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final _hour = DateFormat('hh').format(_dateTime);
    final _second = DateFormat('ss').format(_dateTime);
    final _dayName = DateFormat('EEEE').format(_dateTime);
    final _minute = DateFormat('mm').format(_dateTime);
    final _date = DateFormat("dd MMM yy").format(_dateTime);

    return Container(
        color: colors[_Element.background],
        child: Center(
          child: Center(
              child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                    child: Stack(
                  children: <Widget>[
                    Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                  spreadRadius: 1)
                            ]),
                        child: CustomPaint(
                            painter: DrawCircleOuterMain(
                                lineColor:
                                    colors[_Element.progressHourInActive],
                                completeColor: colors[_Element.progressHour],
                                completePercent: double.parse(_hour),
                                width: 5.0,
                                totalProgress: 12),
                            child: Container(
                              child: CustomPaint(
                                painter: DrawCircleMinutes(
                                    lineColor: colors[
                                        _Element.progressMinutesInActive],
                                    completeColor:
                                        colors[_Element.progressMinutes],
                                    completePercent: double.parse(_minute),
                                    width: 5.0,
                                    totalProgress: 60),
                                child: Container(
                                  child: CustomPaint(
                                      painter: DrawCircleSeconds(
                                          lineColor: colors[
                                              _Element.progressSecondsInActive],
                                          completeColor:
                                              colors[_Element.progressSeconds],
                                          completePercent:
                                              double.parse(_second),
                                          width: 5.0,
                                          totalProgress: 60,
                                          fraction: _fraction)),
                                ),
                              ),
                            ))),
                  ],
                )),
              ),
              Stack(
                children: <Widget>[
                  Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text(_date,
                                style: TextStyle(
                                    color: colors[_Element.progressHour],
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'pressStart',
                                    fontSize: 12)),
                            Text(_dayName,
                                style: TextStyle(
                                    color: colors[_Element.progressHour],
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'pressStart',
                                    fontSize: 15)),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_hour,
                              style: TextStyle(
                                  color: colors[_Element.progressHour],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'rubika',
                                  fontSize: 40)),
                          BlinkingText(colors[_Element.progressHour]),
                          Text(_minute,
                              style: TextStyle(
                                  color: colors[_Element.progressHour],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'rubika',
                                  fontSize: 40))
                        ],
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(_condition,
                                style: TextStyle(
                                    color: colors[_Element.progressHour],
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'pressStart',
                                    fontSize: 12)),
                            Container(width: 5),
                            Text(_temperature,
                                style: TextStyle(
                                    color: colors[_Element.progressHour],
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'pressStart',
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ))
                ],
              )
            ],
          )),
        ));
  }
}

/*child: Image.asset(
                  'assets/images/' + imageName,
                ),*/
/**/
