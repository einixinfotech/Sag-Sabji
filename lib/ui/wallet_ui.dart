import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/login_user_response.dart';
import 'package:saag_sabji/response/promo_codes_response.dart' as PromoCode;
import 'package:saag_sabji/response/transaction_history_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserWalletUI extends StatefulWidget {
  const UserWalletUI({Key? key}) : super(key: key);

  @override
  _UserWalletUIState createState() => _UserWalletUIState();
}

class _UserWalletUIState extends State<UserWalletUI> {
  bool _isLoading = false,
      _isAddingMoneyToWallet = false,
      _isUpdatingDetails = false;
  List<Response> listOfTransactions = [];
  List<PromoCode.Response> listOfPromoCodes = [];
  late Size _size;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _promoCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  static const platform = const MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;
  String orderId = "";

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            color: Colors.white,
            width: _size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add money to",
                        style: TextStyle(
                            fontSize: _size.width / 22,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        "My Wallet",
                        style: TextStyle(
                            fontSize: _size.width / 12,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      _isUpdatingDetails
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator())
                          : Text(
                              "Available balance ₹${Common.currentUser!.walletBalance}",
                              style: TextStyle(
                                fontSize: _size.width / 26,
                              ),
                            ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _amountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"^\d+\.?\d{0,2}")),
                        ],
                        validator: MultiValidator(
                            [RequiredValidator(errorText: 'Enter an amount')]),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: _size.width / 16,
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: new InputDecoration(
                          hintText: "Amount",
                          contentPadding: EdgeInsets.only(left: 8),
                          hintStyle: TextStyle(
                            fontSize: _size.width / 14,
                            fontWeight: FontWeight.w800,
                          ),
                          //prefixIcon: Icon(Icons.text_rotate_up),
                          prefixText: "₹",
                          enabled: true,
                          //prefix: Image.asset("assets/images/rupee.png",width: _size.width/18,height: _size.width/18,color: Colors.grey,)
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"[A-Z0-9]+")),
                        ],
                        controller: _promoCodeController,
                        cursorColor: Colors.black,
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: new InputDecoration(
                          hintText: "Enter a promo code",
                          contentPadding: EdgeInsets.only(left: 8),
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                          //prefixIcon: Icon(Icons.text_rotate_up),
                          enabled: true,
                          //prefix: Image.asset("assets/images/rupee.png",width: _size.width/18,height: _size.width/18,color: Colors.grey,)
                        ),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            getAvailablePromoCodes();
                          }
                          /*showPromoCodes();*/
                        },
                        child: Text(
                          "See available promo codes",
                          style: TextStyle(
                              fontSize: _size.width / 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.green),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _isAddingMoneyToWallet
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    addMoneyToWallet();
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
                                child: Text("Proceed to Add Money",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _size.width / 20,
                                        letterSpacing: 0.3)),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Recent History".toUpperCase(),
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: _size.width / 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1)),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : listOfTransactions.isEmpty
                        ? Center(child: Text("No transactions found!"))
                        : ListView.builder(
                            itemCount: listOfTransactions.length,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder:
                                (contextListViewBuilder, indexListViewBuilder) {
                              return Card(
                                elevation: 1.4,
                                shadowColor: Colors.black,
                                child: Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(bottom: 1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.blue,
                                          ),
                                          maxRadius: 28,
                                          backgroundColor: Colors.blue[100],
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          listOfTransactions[
                                                                  indexListViewBuilder]
                                                              .type
                                                              .toString()
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize:
                                                                  _size.width /
                                                                      24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  0.0,
                                                              wordSpacing: 1)),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        listOfTransactions[
                                                                        indexListViewBuilder]
                                                                    .transactionType ==
                                                                "positive"
                                                            ? "+ ₹${listOfTransactions[indexListViewBuilder].amount}"
                                                            : "- " +
                                                                "₹${listOfTransactions[indexListViewBuilder].amount}"
                                                                    .replaceAll(
                                                                        "-",
                                                                        ""),
                                                        style: TextStyle(
                                                            color: listOfTransactions[
                                                                            indexListViewBuilder]
                                                                        .transactionType ==
                                                                    "positive"
                                                                ? Colors.green
                                                                : Colors.red,
                                                            fontSize:
                                                                _size.width /
                                                                    20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 0.0,
                                                            wordSpacing: 1)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          listOfTransactions[
                                                                  indexListViewBuilder]
                                                              .createdAt,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize:
                                                                  _size.width /
                                                                      30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              letterSpacing:
                                                                  0.0,
                                                              wordSpacing: 1)),
                                                    ),
                                                    Text(
                                                        "Closing balance ₹${listOfTransactions[indexListViewBuilder].closingBalance}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize:
                                                                _size.width /
                                                                    28,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            letterSpacing: 0.0,
                                                            wordSpacing: 1)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )

                /*ListView.builder(
                            itemCount: listOfTransactions.length,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              return Container(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: _size.width,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      color: Colors.blueGrey[50],
                                      child: Text("June 10,2021 to be removed",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: _size.width / 26,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 0.3)),
                                    ),
                                    Container(
                                      color: Colors.blueGrey[50],
                                      child: ,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )*/
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
    getTransactionHistory();
    initializeRazorPay();
  }

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showLoaderDialog(context);
    updatePaymentStatus("success");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showLoaderDialog(context);
    updatePaymentStatus("failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // todo _handleExternalWallet
  }

  void getTransactionHistory() {
    setState(() {
      _isLoading = true;

      Map<String, String> formData = {"userid": Common.currentUser!.userid};

      fetchTransactionHistoryApi(formData).then((value) {
        setState(() {
          _isLoading = false;
          var responseData = jsonDecode(value.body);
          if (responseData["succsess"]) {
            TransactionHistoryResponse response =
                TransactionHistoryResponse.fromJson(jsonDecode(value.body));
            listOfTransactions = response.response;
          } else {
            showSnackBar(context, "Couldn't fetch transactions", 1500);
          }
        });
      });
    });
  }

  void showPromoCodes() {
    showModalBottomSheet(
        context: context,
        builder: (contextBottomSheet) {
          return StatefulBuilder(
            builder: (context, setBottomSheetState) {
              return SizedBox(
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Text(
                        "Apply Promo Code",
                        style: TextStyle(
                            fontSize: _size.width / 20,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: listOfPromoCodes.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: _size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 1.0,
                                        ),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          Colors.greenAccent),
                                                  color: Colors.green
                                                      .withOpacity(0.99)),
                                              width: 120,
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Text(
                                                    listOfPromoCodes[index]
                                                        .code
                                                        .toUpperCase(),
                                                    /*"SAAGSABJI50".toUpperCase(),*/
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 12,
                                                        letterSpacing: 1,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: true,
                                              child: TextButton(
                                                onPressed: () {
                                                  _promoCodeController.text =
                                                      listOfPromoCodes[index]
                                                          .code;

                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Apply".toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Expires on: " +
                                              listOfPromoCodes[index].enddate,
                                          style: TextStyle(
                                              fontSize: _size.width / 28,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Divider(),
                                        Text(
                                          listOfPromoCodes[index].msg,
                                          style: TextStyle(
                                              fontSize: _size.width / 28,
                                              color: Colors.grey[700],
                                              letterSpacing: 0.2,
                                              wordSpacing: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void getAvailablePromoCodes() {
    showLoaderDialog(context);
    Map<String, String> formData = {
      "uderid": Common.currentUser!.userid,
      "type": Common.cashback
    };
    fetchPromoCodesApi(formData).then((value) {
      Navigator.pop(context);

      var responseData = jsonDecode(value.body);
      if (responseData[Common.successKey]) {
        PromoCode.PromoCodesResponse response =
            PromoCode.PromoCodesResponse.fromJson(jsonDecode(value.body));
        listOfPromoCodes = response.response;
        showPromoCodes();
      } else {
        showSnackBar(context, "Couldn't fetch promo codes!", 1500);
      }
    }).catchError((onError) {
      Navigator.pop(context);
      print("fetchPromoCodesApiError: $onError");
    });
  }

  void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
          Container(
              child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text("Please wait..."),
          )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void addMoneyToWallet() {
    _isAddingMoneyToWallet = true;
    Map<String, String> formData = {
      "user_id": Common.currentUser!.userid,
      "amount": _amountController.text
    };
    if (_promoCodeController.text.isNotEmpty) {
      Map<String, String> appliedPromoCode = {
        "promocode": _promoCodeController.text
      };
      formData.addAll(appliedPromoCode);
    }
    print(formData);
    setState(() {
      _isAddingMoneyToWallet = true;
      addMoneyToWalletCreateOrderApi(formData).then((value) {
        setState(() {
          _isAddingMoneyToWallet = false;
          var responseData = jsonDecode(value.body);
          if (responseData[Common.successKey]) {
            // todo success
            placeRazorPayOrder(responseData);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isAddingMoneyToWallet = false;
          print("addMoneyToWalletCreateOrderApiError: $onError");
        });
      });
    });
  }

  void placeRazorPayOrder(responseData) {
    RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
    double money = double.parse(responseData["amount"].toString());
    double tMoney = money * 100;
    String stringMoney = tMoney.toString().replaceAll(regex, '');
    int totalMoney = int.parse(stringMoney);
    orderId = responseData["order_id"];
    var options = {
      'key': responseData["RAZORPAY_API_KEY"],
      'amount': totalMoney / 100,
      'name': 'Saag Sabji',
      'orderId': responseData["order_id"],
      'description': 'Add money to wallet',
      'prefill': {
        'contact': '${Common.currentUser!.mobile}',
        'email': '${Common.currentUser!.email}'
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    print(options);

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void updatePaymentStatus(String paymentStatus) {
    Map<String, String> formData = {
      "order_id": orderId,
      "user_id": Common.currentUser!.userid,
      "payment_status": paymentStatus
    };

    print("updatePaymentStatus ${formData}");

    addMoneyToWalletUpdatePaymentStatusApi(formData).then((value) {
      var responseData = jsonDecode(value.body);
      print("updatedPaymentStatus: ${responseData[Common.successKey]}");
      if (responseData[Common.successKey]) {
        updateUserDetails();
        Navigator.pop(context);
        showSnackBar(context, responseData[Common.responseKey], 1500);
      } else {
        updateUserDetails();
        Navigator.pop(context);
        showSnackBar(context, responseData[Common.responseKey], 1500);
      }
    }).catchError((onError) {
      updateUserDetails();
      print("addMoneyToWalletUpdatePaymentStatusApiError: $onError");
    });
  }

  Future<void> updateUserDetails() async {
    orderId = "";
    _amountController.clear();
    _promoCodeController.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? mobile = sharedPreferences.getString(Common.mobileKey);
    String? password = sharedPreferences.getString(Common.passwordKey);
    Map<String, String> formData = {
      "mobile": mobile.toString(),
      "otp": password.toString()
    };
    print(formData);
    setState(() {
      _isUpdatingDetails = true;
      loginUserApi(formData).then((value) {
        setState(() {
          _isUpdatingDetails = false;
          var responseData = jsonDecode(value.body);

          if (responseData[Common.successKey]) {
            getTransactionHistory();
            LoginUserResponse response =
                LoginUserResponse.fromJson(jsonDecode(value.body));
            setState(() {
              Common.currentUser = response;
            });
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showActionSnackBar(context, "Server error please try again later",
                "Logout", () {}, 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isUpdatingDetails = false;
        });
        print("updateUserDetailsError: $onError");
      });
    });
  }
}
