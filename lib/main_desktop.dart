import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';

import 'pages/home-page.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(child: HomePage()),
    );
  }
}
