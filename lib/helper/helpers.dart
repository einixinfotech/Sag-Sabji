import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showSnackBar(
    BuildContext context, String message, int durationInMilliseconds) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(milliseconds: durationInMilliseconds),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showActionSnackBar(BuildContext context, String message, String action,
    Function functionToPerform, int durationInMilliseconds) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(milliseconds: durationInMilliseconds),
    action: SnackBarAction(
        label: action,
        textColor: Colors.green,
        onPressed: () {
          functionToPerform();
        }),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void enableFullScreenUI() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  ));
}

void enableNormalUI() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    // navigation bar color
    statusBarColor: Colors.transparent,
    // status bar color
    statusBarBrightness: Brightness.dark,
    //status bar brightness
    statusBarIconBrightness: Brightness.dark,
    //status barIcon Brightness
    //systemNavigationBarDividerColor: Colors.greenAccent,
    //Navigation bar divider color
    systemNavigationBarIconBrightness: Brightness.light,
    //navigation bar icon
  ));
}
