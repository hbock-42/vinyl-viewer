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

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1818));
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
    if (Provider.of<PlayStateController>(context).currentState ==
        PlayState.Pause) {
      _controller.stop(canceled: false);
    } else if (Provider.of<PlayStateController>(context).currentState ==
        PlayState.Play) {
      _controller.repeat();
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
                    image: FileImage(widget.file), fit: BoxFit.fill)),
          ),
        );
      },
    );
  }
}
