import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinyl_viewer/theme/main_theme.dart';
import 'package:vinyl_viewer/widgets/button_hover.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AFile()),
      ],
      child: Consumer<AFile>(
        builder: (BuildContext context, AFile file, Widget child) {
          return Container(
            child: Column(
              children: <Widget>[
                ButtonHover(
                  onClick: () => loadImage(file),
                ),
                if (file.file != null) Expanded(child: Image.file(file.file)),
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
