import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/get_otp_response.dart';
import 'package:saag_sabji/response/register_user_response.dart';
import 'package:saag_sabji/ui/container_ui.dart';
import 'package:saag_sabji/ui/welcome_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOtpUI extends StatefulWidget {
  String enteredPhoneNumber;
  bool isForgotPassword = false;

  VerifyOtpUI(this.enteredPhoneNumber, this.isForgotPassword);

  @override
  _VerifyOtpUIState createState() => _VerifyOtpUIState();
}

class _VerifyOtpUIState extends State<VerifyOtpUI>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController controller;
  late Animation<double> animation;
  late Timer _timer;
  int _countDownTimer = 30;
  bool _isLoading = false, _isVerifying = false;

  TextEditingController _edtController1 = new TextEditingController();
  TextEditingController _edtController2 = new TextEditingController();
  TextEditingController _edtController3 = new TextEditingController();
  TextEditingController _edtController4 = new TextEditingController();
  TextEditingController _edtController5 = new TextEditingController();
  TextEditingController _edtController6 = new TextEditingController();

  bool isTaped = false;

  bool isButtonEnabled = false;

  bool isEmpty() {
    setState(() {
      if ((_edtController1.text.length == 1) &&
          (_edtController2.text.length == 1) &&
          (_edtController3.text.length == 1) &&
          (_edtController4.text.length == 1) &&
          (_edtController5.text.length == 1) &&
          (_edtController6.text.length == 1)) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
    return isButtonEnabled;
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 4000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {});
    controller.repeat();
    startTimer();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //howInSnackBar(Common.OTP);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[100],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 120,
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Verify your OTP".toUpperCase(),
                        style: Theme.of(context).textTheme.headline,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "OTP sent to ${widget.enteredPhoneNumber}",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter OTP".toUpperCase(),
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, right: 16),
                            child: TextField(
                                controller: _edtController1,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                controller: _edtController2,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: TextField(
                                controller: _edtController3,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 0),
                            child: TextField(
                                controller: _edtController4,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 0),
                            child: TextField(
                                controller: _edtController5,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 0),
                            child: TextField(
                                controller: _edtController6,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _countDownTimer.toString() + " ".toUpperCase(),
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        _countDownTimer == 0
                            ? InkWell(
                                onTap: () {
                                  if (_countDownTimer == 0) {
                                    resendOTP();
                                  } else {
                                    showSnackBar(
                                        context, "Please wait...", 1500);
                                  }
                                },
                                child: Text(
                                  "resend".toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      letterSpacing: 0.6,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500),
                                ))
                            : Text("")
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    isTaped
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              LinearProgressIndicator(
                                minHeight: 45,
                                value: animation.value,
                                backgroundColor: Colors.red[100],
                                semanticsLabel: "Loading...",
                                semanticsValue: "Loading...",
                              ),
                              Text(
                                "Wait a movement",
                                style: Theme.of(context).textTheme.button,
                              ),
                            ],
                          )
                        : _isVerifying
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                child: RaisedButton(
                                  elevation: 0,
                                  onPressed: isButtonEnabled
                                      ? () {
                                          setState(() {
                                            String enteredOTP =
                                                _edtController1.text +
                                                    _edtController2.text +
                                                    _edtController3.text +
                                                    _edtController4.text +
                                                    _edtController5.text +
                                                    _edtController6.text;
                                            print(enteredOTP);
                                            if (!widget.isForgotPassword) {
                                              registerUser(enteredOTP);
                                            } else {
                                              verifyForgotPasswordOTP(
                                                  enteredOTP);
                                            }
                                          });
                                        }
                                      : null,
                                  child: Text(
                                    isButtonEnabled
                                        ? "continue".toUpperCase()
                                        : "Enter OTP",
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                  disabledColor: Colors.lightGreen,
                                  color: isButtonEnabled
                                      ? Colors.green
                                      : Colors.lightGreenAccent,
                                ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_countDownTimer == 0) {
          setState(() {
            timer.cancel();
            _countDownTimer = 0;
          });
        } else {
          setState(() {
            _countDownTimer--;
            print(_countDownTimer);
          });
        }
      },
    );
  }

  void resendOTP() {
    setState(() {
      _isLoading = true;
      Map<String, String> formData = {"mobile": widget.enteredPhoneNumber};
      print(formData);

      sendOTPApi(formData).then((value) {
        setState(() {
          _isLoading = false;
          var responseData = jsonDecode(value.body);
          if (responseData[Common.successKey]) {
            GetOTPResponse response =
                GetOTPResponse.fromJson(jsonDecode(value.body));
            _countDownTimer = 30;
            startTimer();
            showSnackBar(context, response.response.otp.toString(), 1500);
            Future.delayed(const Duration(milliseconds: 1500), () {
              showSnackBar(
                  context,
                  "Please check your phone again for the OTP: ${widget.enteredPhoneNumber}",
                  1500);
            });
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
          print("sendOTPApiError: $onError");
        });
      });
    });
  }

  void registerUser(String enteredOTP) {
    setState(() {
      _isVerifying = true;

      Map<String, String> otp = {"otp": enteredOTP};
      Common.formData.addAll(otp);
      print(Common.formData);

      registerUserApi(Common.formData).then((value) {
        setState(() async {
          _isVerifying = false;

          var responseData = jsonDecode(value.body);
          print("registerUserApi: $responseData");
          if (responseData[Common.successKey]) {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            RegisterUserResponse response =
                RegisterUserResponse.fromJson(jsonDecode(value.body));
            sharedPreferences.setBool(Common.isLoggedInKey, true);
            sharedPreferences.setString(Common.emailKey, Common.emailAddress);
            sharedPreferences.setString(Common.passwordKey, Common.password);
            sharedPreferences.setString(Common.mobileKey, Common.mobile);
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
          _isVerifying = false;
          print("registerUserApi: $onError");
        });
      });
    });
  }

  void verifyForgotPasswordOTP(String enteredOTP) {
    setState(() {
      _isVerifying = true;

      Map<String, String> otp = {"mobile": Common.mobile, "otp": enteredOTP};
      print(otp);
      verifyOTPForgotPasswordApi(otp).then((value) {
        setState(() async {
          _isVerifying = false;

          var responseData = jsonDecode(value.body);
          print("registerUserApi: $responseData");
          if (responseData[Common.successKey]) {
            showSnackBar(context, responseData[Common.responseKey], 1500);
            Future.delayed(Duration(milliseconds: 1500), () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WelcomeUI()));
            });
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isVerifying = false;
          print("registerUserApi: $onError");
        });
      });
    });
  }
}
