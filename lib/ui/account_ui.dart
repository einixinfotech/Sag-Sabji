import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/user_profile_response.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _referralCodeController = TextEditingController();
  TextEditingController _pointsController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  var _groupValue;
  bool _isLoading = true,
      _isSaving = false,
      _isPasswordSecure = true,
      _isConfirmPasswordSecure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                borderSide:
                                    BorderSide(color: Colors.red, width: 5.0),
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
                                errorText: 'Please provide a email address'),
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
                                borderSide:
                                    BorderSide(color: Colors.red, width: 5.0),
                              )),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          enabled: false,
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
                          style: Theme.of(context).textTheme.body1,
                          decoration: InputDecoration(
                              labelText: "Phone number",
                              counterText: "",
                              prefixIcon: Icon(Icons.phone_android),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 5.0),
                              )),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _referralCodeController,
                          style: Theme.of(context).textTheme.body1,
                          decoration: InputDecoration(
                              labelText: "Referral code",
                              counterText: "",
                              prefixIcon: Icon(Icons.local_offer),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 5.0),
                              )),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _pointsController,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          style: Theme.of(context).textTheme.body1,
                          decoration: InputDecoration(
                              labelText: "Points",
                              counterText: "",
                              prefixIcon: Icon(Icons.point_of_sale),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 5.0),
                              )),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          obscureText: _isPasswordSecure,
                          maxLength: 16,
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
                          style: Theme.of(context).textTheme.body1,
                          decoration: InputDecoration(
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
                              labelText: "New Password",
                              counterText: "",
                              prefixIcon: Icon(Icons.lock_open_outlined),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 5.0),
                              )),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                            obscureText: _isConfirmPasswordSecure,
                            maxLength: 16,
                            keyboardType: TextInputType.visiblePassword,
                            controller: _confirmPasswordController,
                            validator: (val) => MatchValidator(
                                    errorText:
                                        'New password and confirm password do not match')
                                .validateMatch(_currentPasswordController.text,
                                    _confirmPasswordController.text),
                            style: Theme.of(context).textTheme.body1,
                            decoration: InputDecoration(
                              counterText: "",
                              labelText: 'Confirm your new password',
                              prefixIcon: Icon(
                                Icons.lock_open_outlined,
                                size: 24,
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
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 5.0),
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Gender"),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                  value: 0,
                                  groupValue: _groupValue,
                                  onChanged: (newValue) =>
                                      setState(() => _groupValue = newValue)),
                              Text(
                                'Male',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                              Radio(
                                value: 1,
                                groupValue: _groupValue,
                                onChanged: (newValue) =>
                                    setState(() => _groupValue = newValue),
                              ),
                              Text(
                                'Female',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                      updateProfile();
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
                                  child: Text("Save / Update",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          letterSpacing: 0.3)),
                                ),
                              ),
                        SizedBox(
                          height: 18,
                        ),
                        /*_isLoading
                            ? CircularProgressIndicator()
                            : Container(
                          height: 44,
                          width: 256,
                          child: MaterialButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  checkReferralCode();
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Colors.green,
                              child: Text(
                                "Register".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                    wordSpacing: 2,
                                    fontWeight: FontWeight.w800),
                              )),
                        ),*/
                        SizedBox(height: 8),
                      ],
                    ),
                  )),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() {
    setState(() {
      _isLoading = true;
    });
    Map<String, int> formData = {
      "userid": int.parse(Common.currentUser!.userid)
    };
    print(formData);

    getUserProfileApi(formData).then((value) {
      setState(() {
        _isLoading = false;
        var responseData = jsonDecode(value.body);

        if (responseData[Common.successKey]) {
          print(responseData[Common.successKey]);
          print(responseData[Common.responseKey]);
          UserProfileResponse response =
              UserProfileResponse.fromJson(jsonDecode(value.body));
          setData(response.response);
        } else if (value.statusCode >= 500 && value.statusCode <= 599) {
          showSnackBar(context, "Server error please try again later", 1500);
        } else {
          showSnackBar(context, responseData[Common.responseKey], 1500);
        }
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
        print("getUserProfileApiError: $onError");
      });
    });
  }

  void setData(Response response) {
    setState(() {
      _nameController.text = response.name;
      _mobileController.text = response.mobile;
      _referralCodeController.text = response.refercode;
      _pointsController.text = response.points.toString();
      _emailController.text = response.email;
      if (response.gender != null) {
        if (response.gender.toString() == "Male") {
          _groupValue = 0;
        }
      }
    });
  }

  void updateProfile() {
    Map<String, String> formData = {
      "userid": Common.currentUser!.userid,
      "name": _nameController.text,
      "email": _emailController.text,
      "gender": _groupValue == 0 ? "Male" : "Female",
      "password": _confirmPasswordController.text
    };
    setState(() {
      _isSaving = true;

      updateProfileApi(formData).then((value) {
        _isSaving = false;
        var responseData = jsonDecode(value.body);

        if (responseData[Common.successKey]) {
          showSnackBar(context, responseData[Common.responseKey], 1500);
          _getUserDetails();
        } else if (value.statusCode >= 500 && value.statusCode <= 599) {
          showSnackBar(context, "Server error please try again later", 1500);
        } else {
          showSnackBar(context, responseData[Common.responseKey], 1500);
        }
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
          print("updateProfileApiError: $onError");
        });
      });
    });
  }
}
