import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

const double SaturationCoef = 1;
const double ValueCoef = 1.3;

Color mainColorFromBytes(List<int> values) {
  Map<Color, double> scoreByColor = Map<Color, double>();
  Color colorWithHighestScore;
  img.Image photo = img.decodeImage(values);

  for (int i = 0; i < photo.height * photo.width; i++) {
    int pixel32 = photo.getPixelSafe(i % photo.width, i ~/ photo.width);
    int hex = abgrToArgb(pixel32);
    Color color = Color(hex);
    if (!scoreByColor.containsKey(color)) {
      scoreByColor[color] = computeColorScore(color, SaturationCoef, ValueCoef);
    }
    if (colorWithHighestScore == null ||
        scoreByColor[colorWithHighestScore] < scoreByColor[color]) {
      colorWithHighestScore = color;
    }
  }
  scoreByColor.forEach((key, value) {
    if (value > 10) {
      print("$key => $value");
    }
  });
  if (colorWithHighestScore != null) {
    return colorWithHighestScore;
  }
  return Color(0xFFFFFF);
}

int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}

double computeColorScore(Color color, double saturationCoef, double valueCoef) {
  final hsvColor = HSVColor.fromColor(color);
  return hsvColor.saturation * saturationCoef + hsvColor.value * valueCoef;
}
