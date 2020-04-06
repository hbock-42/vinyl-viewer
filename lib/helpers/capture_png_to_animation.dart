import 'dart:async';
import 'dart:typed_data';

import 'package:image/image.dart' as imageEncode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

Future<Uint8List> capturePngToAnimation(
// Future<Uint32List> capturePngToAnimation(
    GlobalKey key,
    imageEncode.Animation animation,
    {double pixelRatio = 1.0}) async {
  try {
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    print("boundary width: ${boundary.size.width}");
    print("boundary height: ${boundary.size.height}");
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // List<int> pngBytes = byteData.buffer.asUint32List();
    // Uint32List pngBytes = byteData.buffer.asUint32List();
    List<int> pngBytes = byteData.buffer.asUint8List();

    if (animation.width == null || animation.height == null) {
      animation.width = image.width;
      animation.height = image.height;
    }
    animation.addFrame(imageEncode.Image.fromBytes(
        (image.width).floor(), (image.height).floor(), pngBytes)
      ..duration = 16);
    // animation.addFrame(imageEncode.Image.fromBytes(
    //     (image.width / 4).floor(), (image.height / 4).floor(), pngBytes)
    //   ..duration = 16);
    print("width: ${image.width}");
    // print("width: ${image.width / 4}");
    print("height: ${image.height}");
    // print("height: ${image.height / 4}");
    print("pngBytes length: ${pngBytes.length}");

    return pngBytes;
  } catch (e) {
    print(e);
    return Future<Uint8List>.value();
    // return Future<Uint32List>.value();
  }
}
