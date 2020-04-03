import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;

class ColorPickerWidget extends StatefulWidget {
  final String imagePath;
  final File imageFile;

  ColorPickerWidget({Key key, this.imagePath, this.imageFile})
      : super(key: key);
  @override
  _ColorPickerWidgetState createState() =>
      _ColorPickerWidgetState(imagePath: imagePath);
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  final String imagePath;

  _ColorPickerWidgetState({this.imagePath});
  // String imagePath = 'assets/images/santorini.jpg';
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();

  // CHANGE THIS FLAG TO TEST BASIC IMAGE, AND SNAPSHOT.
  bool useSnapshot = true;

  // based on useSnapshot=true ? paintKey : imageKey ;
  // this key is used in this example to keep the code shorter.
  GlobalKey currentKey;

  final StreamController<Color> _stateController = StreamController<Color>();
  img.Image photo;

  @override
  void initState() {
    currentKey = useSnapshot ? paintKey : imageKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String title = useSnapshot ? "snapshot" : "basic";
    return StreamBuilder(
        initialData: Colors.green[500],
        stream: _stateController.stream,
        builder: (buildContext, snapshot) {
          Color selectedColor = snapshot.data ?? Colors.green;
          return Stack(
            children: <Widget>[
              RepaintBoundary(
                key: paintKey,
                child: Listener(
                  onPointerUp: (event) => searchPixel(event.position),
                  child: Center(
                    child: Image.file(
                      widget.imageFile,
                      key: imageKey,
                      fit: BoxFit.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(70),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedColor,
                    border: Border.all(width: 2.0, color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2))
                    ]),
              ),
              Positioned(
                child: Text('${selectedColor}',
                    style: TextStyle(
                        color: Colors.white, backgroundColor: Colors.black54)),
                left: 114,
                top: 95,
              ),
            ],
          );
        });
  }

  void searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await (useSnapshot ? loadSnapshotBytes() : loadImageBundleBytes());
    }
    _calculatePixel(globalPosition);
  }

  void _calculatePixel(Offset globalPosition) {
    RenderBox box = currentKey.currentContext.findRenderObject();
    Offset localPosition = box.globalToLocal(globalPosition);

    double px = localPosition.dx;
    double py = localPosition.dy;

    if (!useSnapshot) {
      double widgetScale = box.size.width / photo.width;
      print(py);
      px = (px / widgetScale);
      py = (py / widgetScale);
    }

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);

    _stateController.add(Color(hex));
  }

  Future<void> loadImageBundleBytes() async {
    return;
    ByteData imageBytes = await rootBundle.load(imagePath);
    setImageBytes(imageBytes);
  }

  Future<void> loadSnapshotBytes() async {
    RenderRepaintBoundary boxPaint = paintKey.currentContext.findRenderObject();
    ui.Image capture = await boxPaint.toImage();
    ByteData imageBytes =
        await capture.toByteData(format: ui.ImageByteFormat.png);
    setImageBytes(imageBytes);
    capture.dispose();
  }

  void setImageBytes(ByteData imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }
}

// image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}
