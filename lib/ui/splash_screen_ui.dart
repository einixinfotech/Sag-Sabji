import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/login_user_response.dart';
import 'package:saag_sabji/ui/welcome_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'container_ui.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({Key? key}) : super(key: key);

  @override
  _SplashScreenUIState createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: size.width / 1,
                height: size.height / 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(Common.imagePath + "logo.png"),
                ),
              ),
              CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCredentials().catchError((onError) {
      print("getCredentials: $onError");
    });
  }

  Future<void> getCredentials() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey(Common.isLoggedInKey)) {
      print("isLoggedInKeyPresent");
      if (sharedPreferences.getBool(Common.isLoggedInKey) != null) {
        print("keyIsNotNull");
        bool? isLoggedIn = sharedPreferences.getBool(Common.isLoggedInKey);
        if (isLoggedIn!) {
          print("isLogged in $isLoggedIn" + "login();");
          login();
        } else {
          print("isLogged in $isLoggedIn" + "handleNewUser();");
          handleNewUser();
        }
      } else {
        handleNewUser();
      }
    } else {
      print("KeyNotFound");
      handleNewUser();
    }
  }

  Future<void> login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? mobile = sharedPreferences.getString(Common.mobileKey);
    String? password = sharedPreferences.getString(Common.passwordKey);
    Map<String, String> formData = {
      "mobile": mobile.toString(),
      "otp": password.toString()
    };
    print(formData);
    loginUserApi(formData).then((value) {
      var responseData = jsonDecode(value.body);

      if (responseData[Common.successKey]) {
        LoginUserResponse response =
            LoginUserResponse.fromJson(jsonDecode(value.body));
        Common.isSignedIn = true;
        Common.currentUser = response;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => FragmentContainer()));
      } else if (value.statusCode >= 500 && value.statusCode <= 599) {
        showActionSnackBar(
            context, "Server error please try again later", "Logout", () {
          logout();
        }, 1500);
        Future.delayed(Duration(milliseconds: 1500), () {
          SystemNavigator.pop(animated: true);
        });
      } else {
        showSnackBar(context, responseData[Common.responseKey], 1500);
        Future.delayed(Duration(milliseconds: 1500), () {
          SystemNavigator.pop(animated: true);
        });
      }
    }).catchError((onError) {
      print("SplashScreenLoginError $onError");
      setState(() {
        showActionSnackBar(
            context, "Parsing error, please try again or login again", "Logout",
            () {
          logout();
        }, 1500);
        Future.delayed(Duration(milliseconds: 1500), () {
          SystemNavigator.pop(animated: true);
        });
      });
    });
  }

  void handleNewUser() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => FragmentContainer()));
    });
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(Common.isLoggedInKey, false);
    sharedPreferences.setString(Common.emailKey, "");
    sharedPreferences.setString(Common.passwordKey, "");
    sharedPreferences.setString(Common.mobileKey, "");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => WelcomeUI()), (route) => false);
  }
}
