import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/network/api.dart';

class AddAddressUI extends StatefulWidget {
  const AddAddressUI({Key? key}) : super(key: key);

  @override
  _AddAddressUIState createState() => _AddAddressUIState();
}

class _AddAddressUIState extends State<AddAddressUI> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _completeAddressController = TextEditingController();
  TextEditingController _areaPinCodeController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Address"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.grey[200],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  ),
                ),*/
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* Row(
                        children: [
                          Icon(
                            Icons.pin_drop_outlined,
                            size: 20,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "JPTL City",
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 0.6,
                                color: Color(0xff333333),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "address",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(
                        height: 30,
                      ),*/
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please provide a name')
                        ]),
                        style: Theme.of(context).textTheme.body1,
                        decoration: InputDecoration(
                            labelText: "Full Name",
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
                        controller: _phoneController,
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
                        maxLength: 6,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please provide area pin code'),
                          LengthRangeValidator(
                              min: 6,
                              max: 6,
                              errorText: 'Please enter a valid area pin code'),
                        ]),
                        keyboardType: TextInputType.phone,
                        controller: _areaPinCodeController,
                        style: Theme.of(context).textTheme.body1,
                        decoration: InputDecoration(
                            labelText: "Area pin code",
                            counterText: "",
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                            )),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _landmarkController,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please provide a landmark')
                        ]),
                        style: Theme.of(context).textTheme.body1,
                        decoration: InputDecoration(
                            labelText: "Landmark",
                            counterText: "",
                            prefixIcon: Icon(Icons.pin_drop),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                            )),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        controller: _completeAddressController,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please provide your complete address')
                        ]),
                        style: Theme.of(context).textTheme.body1,
                        decoration: InputDecoration(
                            labelText: "Complete address",
                            counterText: "",
                            prefixIcon: Icon(Icons.pin_drop),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 56,
                              child: TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    addAddress();
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
                                child: Text("Add / Save",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        letterSpacing: 0.3)),
                              ),
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addAddress() {
    _isLoading = true;
    setState(() {
      Map<String, String> formData = {
        "countryid": "101",
        "stateid": "13",
        "cityid": "1189",
        "pincode": _areaPinCodeController.text,
        "landmark": _landmarkController.text,
        "mobile": _phoneController.text,
        "address": _completeAddressController.text,
        "userid": Common.currentUser!.userid,
        "addresstype": "Home",
        "name": _nameController.text
      };
      print(formData);

      addAddressApi(formData).then((value) {
        var responseData = jsonDecode(value.body);
        setState(() {
          _isLoading = false;
          if (responseData['success']) {
            showSnackBar(context, responseData['response'], 1500);
            Future.delayed(Duration(milliseconds: 1500), () {
              Navigator.pop(context, true);
            });
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData['response'], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
          print("addAddressApiError: $onError");
        });
      });
    });
  }
}
