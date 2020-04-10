import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;
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
  img.Animation _animation;
  List<Future> captureFutures = List<Future>();
  int _pictureId = 0;
  List<List<int>> _frameReturned = List<List<int>>();
  static const FrameDurations = [
    Duration(milliseconds: 16),
    Duration(milliseconds: 17),
    Duration(milliseconds: 17),
  ];
  int _currentFrameDurationIndex;
  int _totalFrameRecorded;
  List<img.Image> _frameImages;
  Duration get currentFrameDuration =>
      FrameDurations[_currentFrameDurationIndex % 3];

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
              // if (recordNotifier.recordState != _currentRecordState) {
              //   _currentRecordState = recordNotifier.recordState;
              //   if (_currentRecordState == RecordState.Stop) {
              //     saveLocaly(widget.file.path);
              //   }
              //   if (_currentRecordState == RecordState.Start) {
              //     _animation = imageEncode.Animation();
              //   }
              // }
              // if (_currentRecordState == RecordState.Start) {
              //   addFrameToAnimation();
              // }

              if (recordNotifier.recordState == RecordState.Start) {
                _currentFrameDurationIndex = 0;
                _totalFrameRecorded = 0;
                _frameImages = List<img.Image>();
                _controller.reset();
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  recordNotifier.setRecordState(RecordState.Recording);
                });
              } else if (recordNotifier.recordState == RecordState.Recording) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  _saveFrameImage(currentFrameDuration).then(
                    (value) => {
                      _currentFrameDurationIndex++,
                      _totalFrameRecorded++,
                      if (_totalFrameRecorded >= 60)
                        {
                          _convertFramesToAnimation(widget.file.path)
                              .then((value) => {
                                    recordNotifier
                                        .setRecordState(RecordState.Converting),
                                    if (playStateController.currentState ==
                                        PlayState.Play)
                                      {_controller.repeat()},
                                  })
                        }
                      else
                        {
                          _controller.value += currentFrameDuration
                                  .inMilliseconds
                                  .roundToDouble() /
                              1000.0
                        }
                    },
                  );
                });
              } else if (recordNotifier.recordState == RecordState.Stop) {}

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
    print("recording");
    var retFuture =
        capturePngToAnimation(_widgetKey, _animation, pixelRatio: 0.3);
    captureFutures.add(retFuture);
    var retAwaited = await retFuture;
    _frameReturned.add(retAwaited);
  }

  void saveLocaly(String loadedPath) async {
    await Future.wait(captureFutures);
    for (int i = 0; i < _frameReturned.length; i++) {
      img.Image decodedFrame = img.decodeImage(_frameReturned[i])
        ..duration = 16;
      _animation.addFrame(decodedFrame);
    }
    List<int> encodedAnimation = img.encodePngAnimation(_animation);
    File(loadedPath + "_anim.png")..writeAsBytesSync(encodedAnimation);
    print("Localy save");
    _animation = null;
  }

  void saveWidget(String loadedPath) async {
    List<int> encodedPng = await saveWidgetAsPng(_widgetKey);
    File(loadedPath + "_picture.png")..writeAsBytesSync(encodedPng);
    print("png saved");
  }

  Future _saveFrameImage(Duration frameDuration) async {
    List<int> encodedPng = await saveWidgetAsPng(_widgetKey, pixelRatio: 0.5);
    img.Image decodedImage = img.decodeImage(encodedPng)
      ..duration = frameDuration.inMilliseconds;
    // ..duration = 16;
    _frameImages.add(decodedImage);
  }

  Future _convertFramesToAnimation(String loadedPath) async {
    _animation = img.Animation();
    int maxWidth = 0;
    int maxHeight = 0;
    _frameImages.forEach((image) => {
          _animation.addFrame(image),
          if (image.width > maxWidth) {maxWidth = image.width},
          if (image.height > maxHeight) {maxHeight = image.height},
        });
    _animation.width = maxWidth;
    _animation.height = maxHeight;
    List<int> encodedAnimation = img.encodePngAnimation(_animation);
    File(loadedPath + "_anim.png")..writeAsBytesSync(encodedAnimation);
    print("Localy save");
    _animation = null;
  }
}
