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
      ],
      child: Consumer2<AFile, PlayStateController>(
        builder: (BuildContext context, AFile file,
            PlayStateController playStateController, Widget child) {
          return Container(
            child: Column(
              children: <Widget>[
                ButtonHover(
                  'get file',
                  onClick: () => loadImage(file),
                ),
                ButtonHover(
                  'play',
                  onClick: () =>
                      playStateController.setPlayState(PlayState.Play),
                ),
                ButtonHover(
                  'pause',
                  onClick: () =>
                      playStateController.setPlayState(PlayState.Pause),
                ),
                if (file.file != null)
                  Expanded(
                      child: AspectRatio(
                    aspectRatio: 1,
                    child: RotatingMacaron(file: file.file),
                  )),
              ],
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
