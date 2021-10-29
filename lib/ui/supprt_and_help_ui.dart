import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/network/api.dart';

class SupportAndHelpUI extends StatefulWidget {
  @override
  _SupportAndHelpUIState createState() => _SupportAndHelpUIState();
}

class _SupportAndHelpUIState extends State<SupportAndHelpUI> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _subjectController = TextEditingController();

  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Get assistance",
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Please type your message",
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
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please provide a email address'),
                          EmailValidator(
                              errorText: 'Please enter a valid Email-Address'),
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
                        maxLines: 1,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please provide a subject'),
                        ]),
                        keyboardType: TextInputType.name,
                        controller: _subjectController,
                        style: Theme.of(context).textTheme.body1,
                        decoration: InputDecoration(
                            labelText: "Subject",
                            counterText: "",
                            prefixIcon: Icon(Icons.title),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                            )),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please type your message'),
                        ]),
                        textAlign: TextAlign.start,
                        maxLines: 12,
                        enabled: true,
                        keyboardType: TextInputType.multiline,
                        controller: _messageController,
                        style: Theme.of(context).textTheme.body1,
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: "Message",
                            counterText: "",
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                            )),
                      ),
                      SizedBox(
                        height: 16,
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
                                    sendMessage();
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.green;
                                      return Colors
                                          .green; // Use the component's default.
                                    },
                                  ),
                                ),
                                child: Text("Send your message",
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

  void sendMessage() {
    Map<String, String> formData = {
      "email": _emailController.text,
      "subject": _subjectController.text,
      "message": _messageController.text
    };
    setState(() {
      _isLoading = true;

      print(formData);
      sendEnquiryApi(formData).then((value) {
        setState(() {
          _isLoading = false;

          var responseData = jsonDecode(value.body);

          if (responseData[Common.successKey]) {
            _emailController.clear();
            _subjectController.clear();
            _messageController.clear();
            showSnackBar(context, responseData[Common.responseKey], 1500);
            Future.delayed(const Duration(milliseconds: 1500), () {
              Navigator.pop(context);
            });
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          print("sendEnquiryApiError: $onError");
          _isLoading = false;
        });
      });
    });
  }
}
