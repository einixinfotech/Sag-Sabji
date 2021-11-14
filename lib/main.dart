import 'package:flutter/material.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/ui/splash_screen_ui.dart';

import 'helper/resources.dart';

void main() {
  enableFullScreenUI();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, primaryColor: accentColor),
      home: SplashScreenUI(),
      // test commit
    );
  }
}
