import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as imageEncode;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:vinyl_viewer/helpers/capture_png_to_animation.dart';
import 'package:vinyl_viewer/helpers/save_widget_as_png.dart';
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
  RecordState _currentRecordState = RecordState.Stop;
  final GlobalKey _widgetKey = GlobalKey();
  imageEncode.Animation _animation;
  List<Future> captureFutures = List<Future>();
  int _pictureId = 0;

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
    return Consumer4<Rpm, PlayStateController, RecordNotifier,
        TakePictureNotifier>(
      builder: (
        BuildContext context,
        Rpm value,
        PlayStateController playStateController,
        RecordNotifier recordNotifier,
        TakePictureNotifier takePictureNotifier,
        Widget child,
      ) {
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

        return RepaintBoundary(
          key: _widgetKey,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              if (recordNotifier.recordState != _currentRecordState) {
                _currentRecordState = recordNotifier.recordState;
                if (_currentRecordState == RecordState.Stop) {
                  saveLocaly(widget.file.path);
                }
                if (_currentRecordState == RecordState.Start) {
                  _animation = imageEncode.Animation();
                }
              }
              if (_currentRecordState == RecordState.Start) {
                addFrameToAnimation();
              }

              if (_pictureId != takePictureNotifier.pictureId) {
                _pictureId = takePictureNotifier.pictureId;
                saveWidget(widget.file.path);
              }
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
          ),
        );
      },
    );
  }

  void _setAnimationDurationFromRpm(int rpm) {
    _controller.duration =
        Duration(milliseconds: (60 / _currentRpm * 1000).round());
  }

  void addFrameToAnimation() async {
    captureFutures
        .add(capturePngToAnimation(_widgetKey, _animation, pixelRatio: 1.0));
    print("recording");
  }

  void saveLocaly(String loadedPath) async {
    await Future.wait(captureFutures);
    print("Save Done !!!");
    print("anim width: ${_animation.width}");
    print("anim height: ${_animation.height}");
    List<int> encodedAnimation = imageEncode.encodePngAnimation(_animation);
    File(loadedPath + "_anim.png")..writeAsBytesSync(encodedAnimation);
    print("Localy save");
    _animation = null;
  }

  void saveWidget(String loadedPath) async {
    Uint8List encodedPng = await saveWidgetAsPng(_widgetKey);
    File(loadedPath + "_picture.png")..writeAsBytesSync(encodedPng);
    print("png saved");
  }
}
