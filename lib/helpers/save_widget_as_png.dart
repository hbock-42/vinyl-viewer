import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

Future<Uint8List> saveWidgetAsPng(GlobalKey key,
    {double pixelRatio = 1.0}) async {
  try {
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    List<int> pngBytes = byteData.buffer.asUint8List();
    print("width: ${image.width}");
    print("height: ${image.height}");
    print("lengthInBytes: ${byteData.lengthInBytes}");
    print("elementSizeInBytes: ${byteData.elementSizeInBytes}");
    print("buffer length: ${byteData.buffer.asUint8List().length}");
    print(
        "buffer lengthInBytes: ${byteData.buffer.asUint8List().lengthInBytes}");
    // var bs64 = base64Encode(pngBytes);
    // print(pngBytes);
    // print(bs64);

    return pngBytes;
  } catch (e) {
    print(e);
    return Future<Uint8List>.value();
  }
}
