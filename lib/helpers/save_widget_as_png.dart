import 'dart:async';
import 'dart:typed_data';

import 'package:image/image.dart' as imageEncode;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

Future<Uint8List> saveWidgetAsPng(GlobalKey key,
// Future<Uint32List> saveWidgetAsPng(GlobalKey key,
    {double pixelRatio = 1.0}) async {
  try {
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    List<int> pngBytes = byteData.buffer.asUint8List();
    // List<int> pngBytes = byteData.buffer.asUint32List();
    // imageEncode.Image decodedImage = imageEncode.decodeImage(pngBytes);
    // List<int> encodedPng = imageEncode.encodePng(decodedImage);
    // return encodedPng;
    return pngBytes;
  } catch (e) {
    print(e);
    return Future<Uint8List>.value();
    // return Future<Uint32List>.value();
  }
}
