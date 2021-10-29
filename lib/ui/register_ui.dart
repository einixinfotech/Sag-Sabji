import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/get_otp_response.dart';
import 'package:saag_sabji/ui/verify_otp_ui.dart';

class RegisterUI extends StatefulWidget {
  bool isForgotPassword = false;

  RegisterUI(this.isForgotPassword);

  @override
  _RegisterUIState createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordSecure = true,
      _isConfirmPasswordSecure = true,
      _isLoading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _referralCodeController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Saag Sabji",style: TextStyle(color: Colors.black),),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green),
        backgroundColor: Colors.white,
      ),
      body: widget.isForgotPassword
          ? SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Forgot Password",
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Provide your mobile number to continue",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              maxLength: 10,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'Please provide a phone number'),
                                LengthRangeValidator(
                                    min: 10,
                                    max: 10,
                                    errorText:
                                        'Please enter a valid phone number'),
                              ]),
                              keyboardType: TextInputType.phone,
                              controller: _mobileController,
                              style: Theme.of(context).textTheme.body1,
                              decoration: InputDecoration(
                                  labelText: "Phone number",
                                  counterText: "",
                                  prefixIcon: Icon(Icons.phone_android),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 5.0),
                                  )),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _isLoading
                                ? CircularProgressIndicator()
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 56,
                                    child: TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          sendOTP();
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Colors.green;
                                            return Colors
                                                .green; // Use the component's default.
                                          },
                                        ),
                                      ),
                                      child: Text("Continue",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              letterSpacing: 0.3)),
                                    ),
                                  ),
                            SizedBox(
                              height: 18,
                            ),
                            SizedBox(height: 8)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "SignUp",
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Fill up the details to get going",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.name,
                              controller: _nameController,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'Please provide a name')
                              ]),
                              style: Theme.of(context).textTheme.body1,
                              decoration: InputDecoration(
                                  labelText: "Name",
                                  counterText: "",
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 5.0),
                                  )),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText:
                                        'Please provide a email address'),
                                EmailValidator(
                                    errorText:
                                        'Please enter a valid Email-Address'),
                              ]),
                              style: Theme.of(context).textTheme.body1,
                              decoration: InputDecoration(
                                  labelText: "Email",
                                  counterText: "",
                                  prefixIcon: Icon(Icons.mail),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 5.0),
                                  )),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              maxLength: 10,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'Please provide a phone number'),
                                LengthRangeValidator(
                                    min: 10,
                                    max: 10,
                                    errorText:
                                        'Please enter a valid phone number'),
                              ]),
                              keyboardType: TextInputType.phone,
                              controller: _mobileController,
                              style: Theme.of(context).textTheme.body1,
                              decoration: InputDecoration(
                                  labelText: "Phone number",
                                  counterText: "",
                                  prefixIcon: Icon(Icons.phone_android),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 5.0),
                                  )),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              enabled: true,
                              keyboardType: TextInputType.text,
                              controller: _referralCodeController,
                              style: Theme.of(context).textTheme.body1,
                              decoration: InputDecoration(
                                  labelText: "Referral code",
                                  counterText: "",
                                  prefixIcon: Icon(Icons.local_offer),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 5.0),
                                  )),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              maxLength: 16,
                              obscureText: _isPasswordSecure,
                              style: TextStyle(fontSize: 16),
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'Please provide a password'),
                                LengthRangeValidator(
                                    min: 8,
                                    max: 16,
                                    errorText:
                                        'Your password must have at least 8 characters'),
                              ]),
                              keyboardType: TextInputType.visiblePassword,
                              controller: _currentPasswordController,
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
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 5.0),
                                  )),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                                maxLength: 16,
                                obscureText: _isConfirmPasswordSecure,
                                keyboardType: TextInputType.visiblePassword,
                                controller: _confirmPasswordController,
                                validator: (val) => MatchValidator(
                                        errorText:
                                            'Password and confirm password do not match')
                                    .validateMatch(
                                        _currentPasswordController.text,
                                        _confirmPasswordController.text),
                                decoration: InputDecoration(
                                  counterText: "",
                                  labelText: 'Confirm your password',
                                  prefixIcon: Icon(
                                    Icons.lock_open_outlined,
                                    size: 24,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 5.0),
                                  ),
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        _isConfirmPasswordSecure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: _isConfirmPasswordSecure
                                            ? Color(0xff949494)
                                            : Colors.green,
                                      ),
                                      onPressed: () {
                                        print("CLICK");
                                        setState(() {
                                          if (_isConfirmPasswordSecure) {
                                            _isConfirmPasswordSecure = false;
                                          } else {
                                            _isConfirmPasswordSecure = true;
                                          }
                                        });
                                      }),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            _isLoading
                                ? CircularProgressIndicator()
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 56,
                                    child: TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          checkReferralCode();
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Colors.green;
                                            return Colors
                                                .green; // Use the component's default.
                                          },
                                        ),
                                      ),
                                      child: Text("Register",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              letterSpacing: 0.3)),
                                    ),
                                  ),
                            SizedBox(
                              height: 18,
                            ),
                            SizedBox(height: 8)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void checkReferralCode() {
    if (_referralCodeController.text.trim().isEmpty) {
      _referralCodeController.clear();
      print("Empty referral Code");
      sendOTP();
    } else {
      validateReferralCode();
    }
  }

  void validateReferralCode() {
    setState(() {
      _isLoading = true;
      Map<String, String> formData = {"sponsar": Common.referralCode};
      print(formData);

      verifyReferralCodeApi(formData).then((value) {
        _isLoading = false;
        var responseData = jsonDecode(value.body);

        if (responseData[Common.successKey]) {
          sendOTP();
        } else if (value.statusCode >= 500 && value.statusCode <= 599) {
          showSnackBar(context, "Server error please try again later", 1500);
        } else {
          showSnackBar(context, responseData[Common.responseKey], 1500);
        }
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
          print("verifyReferralCodeApi: $onError");
        });
      });
    });
  }

  void sendOTP() {
    Map<String, String> formData = {"mobile": _mobileController.text.trim()};
    setState(() {
      _isLoading = true;

      print(formData);

      sendOTPApi(formData).then((value) {
        setState(() {
          _isLoading = false;
          var responseData = jsonDecode(value.body);

          if (responseData[Common.successKey]) {
            Common.mobile = _mobileController.text;
            GetOTPResponse response =
                GetOTPResponse.fromJson(jsonDecode(value.body));
            // showSnackBar(context, response.response.otp.toString(),
            //     1500); // todo remove after testing
            Common.formData = {
              "name": _nameController.text,
              "mobile": _mobileController.text,
              "email": _emailController.text,
              "password": _confirmPasswordController.text,
              "sponsar": Common.referralCode // todo remove after testing
            };
            Future.delayed(const Duration(milliseconds: 1500), () {
              showSnackBar(
                  context,
                  "OTP Sent on your number: ${_mobileController.text.trim()}",
                  1500);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyOtpUI(
                          _mobileController.text.trim(),
                          widget.isForgotPassword)));
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
}
