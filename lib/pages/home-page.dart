import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      ],
      child: Consumer3<AFile, PlayStateController, Rpm>(
        builder: (BuildContext context, AFile file,
            PlayStateController playStateController, Rpm rpm, Widget child) {
          return Container(
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ButtonHover(
                        'get file',
                        onClick: () => loadImage(file),
                      ),
                      SizedBox(width: 15),
                      ButtonHover(
                        playStateController.currentState == PlayState.Pause
                            ? 'play'
                            : 'pause',
                        onClick: () => setPlayState(playStateController),
                      ),
                      SizedBox(width: 15),
                      // ButtonHover(
                      //   rpm.rpm == 45 ? '45 -> 33' : '33 -> 45',
                      //   onClick: () => rpm.setRpm(rpm.rpm == 45 ? 33 : 45),
                      // ),
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
                    ],
                  ),
                  if (file.file != null)
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: RotatingMacaron(
                          file: file.file,
                          // rpm: rpm.rpm,
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

  loadImage(AFile file) async {
    File localFile = await FilePicker.getFile(type: FileType.image);
    file.setFile(localFile);
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
