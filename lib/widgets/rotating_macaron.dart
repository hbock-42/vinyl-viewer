import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../pages/home-page.dart';

class RotatingMacaron extends StatefulWidget {
  final File file;

  const RotatingMacaron({Key key, this.file}) : super(key: key);

  @override
  _RotatingMacaronState createState() => _RotatingMacaronState();
}

class _RotatingMacaronState extends State<RotatingMacaron>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int _currentRpm = 45;
  PlayState _currentPlayState;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: (60 / _currentRpm * 1000).round()));
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<Rpm, PlayStateController>(
      builder: (BuildContext context, Rpm value,
          PlayStateController playStateController, Widget child) {
        if (value.rpm != _currentRpm) {
          _currentRpm = Provider.of<Rpm>(context).rpm;
          _setAnimationDurationFromRpm(_currentRpm);
        }

        if (playStateController.currentState != _currentPlayState) {
          if (playStateController.currentState == PlayState.Pause) {
            _controller.stop(canceled: false);
          } else if (playStateController.currentState == PlayState.Play) {
            _controller.repeat();
          }
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) {
            return Transform.rotate(
              angle: 2.0 * math.pi * _controller.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: FileImage(widget.file), fit: BoxFit.fill),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _setAnimationDurationFromRpm(int rpm) {
    _controller.duration =
        Duration(milliseconds: (60 / _currentRpm * 1000).round());
  }
}
