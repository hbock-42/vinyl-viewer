import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinyl_viewer/helpers/image_main_color.dart';
import 'package:vinyl_viewer/widgets/button_hover.dart';
import 'package:vinyl_viewer/widgets/rotating_macaron.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AFile()),
        ChangeNotifierProvider(create: (_) => PlayStateController()),
        ChangeNotifierProvider(create: (_) => Rpm()),
        ChangeNotifierProvider(create: (_) => BgColor()),
        ChangeNotifierProvider(create: (_) => RecordNotifier()),
        ChangeNotifierProvider(create: (_) => TakePictureNotifier()),
      ],
      child: Consumer6<AFile, PlayStateController, Rpm, BgColor, RecordNotifier,
          TakePictureNotifier>(
        builder: (BuildContext context,
            AFile file,
            PlayStateController playStateController,
            Rpm rpm,
            BgColor bgColor,
            RecordNotifier recordNotifier,
            TakePictureNotifier takePictureNotifier,
            Widget child) {
          return Container(
            color: bgColor.color,
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ButtonHover(
                        'get file',
                        onClick: () => loadImage(file, bgColor),
                      ),
                      SizedBox(width: 15),
                      ButtonHover(
                        playStateController.currentState == PlayState.Pause
                            ? 'play'
                            : 'pause',
                        onClick: () => setPlayState(playStateController),
                      ),
                      SizedBox(width: 15),
                      ButtonHover(
                        '33',
                        onClick: () => rpm.setRpm(33),
                      ),
                      SizedBox(width: 15),
                      ButtonHover(
                        '45',
                        onClick: () => rpm.setRpm(45),
                      ),
                      SizedBox(width: 15),
                      ButtonHover(
                        '90',
                        onClick: () => rpm.setRpm(90),
                      ),
                      SizedBox(width: 15),
                      if (file.file != null)
                        ButtonHover(
                          recordNotifier.recordState == RecordState.Start ||
                                  recordNotifier.recordState ==
                                      RecordState.Recording
                              ? 'stop record'
                              : 'start record',
                          onClick: () => recordNotifier.setRecordState(
                            recordNotifier.recordState == RecordState.Start ||
                                    recordNotifier.recordState ==
                                        RecordState.Recording
                                ? RecordState.Stop
                                : RecordState.Start,
                          ),
                        ),
                      SizedBox(width: 15),
                      if (file.file != null)
                        ButtonHover(
                          "Take snapshot",
                          onClick: () => takePictureNotifier.takePicture(),
                        ),
                    ],
                  ),
                  if (file.file != null)
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: RepaintBoundary(
                          child: RotatingMacaron(
                            file: file.file,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  loadImage(AFile file, BgColor bgColor) async {
    File localFile = await FilePicker.getFile(type: FileType.image);
    file.setFile(localFile);
    if (localFile != null) {
      var color = mainColorFromBytes(await file.file.readAsBytes());
      bgColor.setColor(color);
    }
  }

  setPlayState(PlayStateController playController) {
    if (playController.currentState == PlayState.Play) {
      playController.setPlayState(PlayState.Pause);
    } else {
      playController.setPlayState(PlayState.Play);
    }
  }
}

class AFile with ChangeNotifier {
  File _file;
  File get file => _file;
  void setFile(File newFile) {
    _file = newFile;
    notifyListeners();
  }
}

enum PlayState {
  Play,
  Pause,
}

class PlayStateController with ChangeNotifier {
  PlayState _currentState = PlayState.Pause;
  PlayState get currentState => _currentState;
  void setPlayState(PlayState state) {
    _currentState = state;
    notifyListeners();
  }
}

class Rpm with ChangeNotifier {
  int _currentRpm = 45;
  int get rpm => _currentRpm;
  void setRpm(int rpm) {
    _currentRpm = rpm;
    notifyListeners();
  }
}

class BgColor with ChangeNotifier {
  Color _color = Colors.red;
  Color get color => _color;
  void setColor(Color color) {
    _color = color;
    notifyListeners();
  }
}

enum RecordState {
  Start,
  Recording,
  Converting,
  Stop,
}

class RecordNotifier with ChangeNotifier {
  RecordState _currentState = RecordState.Stop;
  RecordState get recordState => _currentState;
  void setRecordState(RecordState recordState) {
    print(recordState);
    _currentState = recordState;
    notifyListeners();
  }
}

class TakePictureNotifier with ChangeNotifier {
  int _pictureId = 0;
  int get pictureId => _pictureId;
  void takePicture() {
    _pictureId++;
    notifyListeners();
  }
}
