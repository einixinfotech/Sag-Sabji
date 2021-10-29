import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/helper/page_transition_fade_animation.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/login_user_response.dart';
import 'package:saag_sabji/ui/register_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'container_ui.dart';

class WelcomeUI extends StatefulWidget {
  const WelcomeUI({Key? key}) : super(key: key);

  @override
  _WelcomeUIState createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI> {
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordSecure = true, _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.asset("assets/images/logo.png"),
                ),
                SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Proceed with your login",
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  maxLength: 10,
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: 'Please provide a phone number'),
                    LengthRangeValidator(
                        min: 10,
                        max: 10,
                        errorText: 'Please enter a valid phone number'),
                  ]),
                  keyboardType: TextInputType.phone,
                  controller: _mobileController,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      labelText: "Mobile number",
                      counterText: "",
                      prefixIcon: Icon(Icons.phone_android),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5.0),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLength: 16,
                  obscureText: _isPasswordSecure,
                  style: TextStyle(fontSize: 16),
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Please provide a password'),
                    LengthRangeValidator(
                        min: 8,
                        max: 16,
                        errorText:
                            'Your password must have at least 8 characters'),
                  ]),
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: "Password",
                      counterText: "",
                      suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordSecure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: _isPasswordSecure
                                ? Color(0xff949494)
                                : Colors.green,
                          ),
                          onPressed: () {
                            print("CLICK");
                            setState(() {
                              if (_isPasswordSecure) {
                                _isPasswordSecure = false;
                              } else {
                                _isPasswordSecure = true;
                              }
                            });
                          }),
                      prefixIcon: Icon(Icons.lock_open_outlined),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5.0),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 56,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 50,
                                child: TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      login();
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed))
                                          return Colors.green;
                                        return Colors
                                            .green; // Use the component's default.
                                      },
                                    ),
                                  ),
                                  child: Text("Login to continue",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          letterSpacing: 0.3)),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: SizedBox(
                                    height: 50,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FragmentContainer()));
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all(Color(0xFFCDCDCD)),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              8))))),
                                      icon: Icon(
                                        Icons.home_rounded,
                                        color: Colors.black,
                                      ),
                                      label: Text(
                                        "Skip login",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            letterSpacing: 0.3),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, FadeRoute(page: RegisterUI(true)))
                        .then((value) {
                      enableNormalUI();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(""),
                        ),
                        Text(
                          "Forgot password?",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.push(context, FadeRoute(page: RegisterUI(false)))
              .then((value) {
            enableNormalUI();
          });
        },
        child: Container(
          color: Color(0xffb3d685),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      letterSpacing: 0.6,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    "Register",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        letterSpacing: 0.6,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void login() async {
    setState(() {
      _isLoading = true;
      Map<String, String> formData = {
        "mobile": _mobileController.text,
        "otp": _passwordController.text
      };
      print(jsonEncode(formData));
      loginUserApi(formData).then((value) async {
        setState(() async {
          _isLoading = false;

          var responseData = jsonDecode(value.body);
          if (responseData[Common.successKey]) {
            LoginUserResponse response =
                LoginUserResponse.fromJson(jsonDecode(value.body));
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.setBool(Common.isLoggedInKey, true);
            sharedPreferences.setString(
                Common.mobileKey, _mobileController.text);
            sharedPreferences.setString(
                Common.passwordKey, _passwordController.text);
            Common.currentUser = response;
            Common.isSignedIn = true;
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => FragmentContainer()));
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
          print("loginUserApiError $onError");
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    enableNormalUI();
  }
}
