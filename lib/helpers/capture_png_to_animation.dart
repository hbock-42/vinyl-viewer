import 'dart:async';
import 'dart:typed_data';

import 'package:image/image.dart' as imageEncode;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

Future<Uint8List> capturePngToAnimation(
    GlobalKey key, imageEncode.Animation animation,
    {double pixelRatio = 1.0}) async {
  try {
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    List<int> pngBytes = byteData.buffer.asUint8List();

    if (animation.width == null || animation.height == null) {
      animation.width = image.width;
      animation.height = image.height;
    }
    return pngBytes;
  } catch (e) {
    print(e);
    return Future<Uint8List>.value();
  }
}
