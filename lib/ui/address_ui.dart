import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/db/cart_database.dart';
import 'package:saag_sabji/helper/empty_screen.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/helper/strings.dart';
import 'package:saag_sabji/models/cart.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/get_address_response.dart';
import 'package:saag_sabji/response/place_order_response.dart' as PlaceOrder;
import 'package:saag_sabji/ui/purchased_order_details_screen.dart';

import 'add_address_ui.dart';
import 'cart_ui.dart';
import 'orders_ui.dart';

class AddressUI extends StatefulWidget {
  bool isSelectingAddress = false, isOnlinePayment = false;
  String titleText = "My Addresses";

  String orderID,itemTotal,deliveryCharges;

  AddressUI(this.isSelectingAddress, this.titleText, this.isOnlinePayment,{this.orderID = "",this.itemTotal = "",this.deliveryCharges = ""});

  @override
  _AddressUIState createState() => _AddressUIState();
}

class _AddressUIState extends State<AddressUI> {
  bool _isLoading = true;
  List<Response> listOfSavedAddresses = [];
  String currentOrderId = "";
  static const platform = const MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.titleText,
        ),
        actions: [
          Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.add_location_alt,
                    size: 18,
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddAddressUI()),
                    );
                    print(result);
                    if (result == null || result == true) {
                      getUsersAddress();
                    }
                  }),
            ],
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : listOfSavedAddresses.isEmpty
              ? EmptyUI("You don't have any saved address", "Add address")
              : ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listOfSavedAddresses.length,
                      padding: EdgeInsets.only(top: 12.0),
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            print("isOnline: ${widget.isOnlinePayment}");
                            setState(() {
                              if (listOfSavedAddresses[index].addressid ==
                                  Common.selectedAddressId) {
                                Common.selectedAddressId = "";
                              } else {
                                Common.selectedAddressId =
                                    listOfSavedAddresses[index].addressid;
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 3.0,
                                offset: Offset(0, 0),
                                spreadRadius: 3.0,
                              ),
                            ]
                            ),
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listOfSavedAddresses[index].name,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              letterSpacing: 0.6,
                                              color: Color(0xff3c3c3c),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          listOfSavedAddresses[index].address,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            widget.isSelectingAddress
                                                ? TextButton(
                                                    onPressed: () {
                                                      print(
                                                          "isOnline: ${widget.isOnlinePayment}");
                                                      setState(() {
                                                        if (listOfSavedAddresses[
                                                                    index]
                                                                .addressid ==
                                                            Common
                                                                .selectedAddressId) {
                                                          Common.selectedAddressId =
                                                              "";
                                                        } else {
                                                          Common.selectedAddressId =
                                                              listOfSavedAddresses[
                                                                      index]
                                                                  .addressid;
                                                        }
                                                      });
                                                    },
                                                    child: Text(
                                                      Common.selectedAddressId ==
                                                              listOfSavedAddresses[
                                                                      index]
                                                                  .addressid
                                                          ? "SELECTED"
                                                          : "SELECT",
                                                      style: TextStyle(
                                                          color: Common
                                                                      .selectedAddressId ==
                                                                  listOfSavedAddresses[
                                                                          index]
                                                                      .addressid
                                                              ? Colors.green
                                                              : Color(
                                                                  0xffff0303)),
                                                    ),
                                                  )
                                                : TextButton(
                                                    onPressed: () {
                                                      showConfirmationDialog(
                                                          listOfSavedAddresses[
                                                              index]);
                                                    },
                                                    child: Text(
                                                      "DELETE",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xffff0303)),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: widget.isSelectingAddress
          ? Common.selectedAddressId == ""
              ? Text("")
              : SizedBox(
                  child: TextButton.icon(
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _openLoadingDialog(context, true, false).then((value) {
                        placeOrder();
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Colors.green;
                          return Colors.green; // Use the component's default.
                        },
                      ),
                    ),
                    label: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                          widget.isOnlinePayment
                              ? "Proceed to payment"
                              : "Place your order",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 0.3)),
                    ),
                  ),
                )
          : null,
    );
  }

  @override
  void initState() {
    super.initState();
    getUsersAddress();
    initializeRazorPay();
    print(widget.isSelectingAddress);
  }

  void getUsersAddress() {
    print("getUsersAddress");
    print(Common.currentUser!.userid);
    setState(() {
      _isLoading = true;
      Map<String, String> formData = {"userid": Common.currentUser!.userid};
      getSavedAddressApi(formData).then((value) {
        setState(() {
          _isLoading = false;
          var responseData = jsonDecode(value.body);
          print(responseData[Common.responseKey]);
          if (responseData[Common.successKey]) {
            AddressResponse response =
                AddressResponse.fromJson(jsonDecode(value.body));
            listOfSavedAddresses = response.response;
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else if (responseData[Common.responseKey].toString() !=
              "No record found !") {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  void showConfirmationDialog(Response selectedAddress) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setPopupState) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text("You wouldn't be able to revert this change")
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Confirm delete',
                      style: TextStyle(color: Color(0xffff0303))),
                  onPressed: () {
                    deleteAddress(selectedAddress);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void deleteAddress(Response selectedAddress) {
    setState(() {
      _isLoading = true;
      Map<String, String> formData = {"addressid": selectedAddress.addressid};
      deleteAddressApi(formData).then((value) {
        setState(() {
          _isLoading = false;
          var responseData = jsonDecode(value.body);
          if (responseData['success']) {
            showSnackBar(context, responseData['response'], 1500);
            listOfSavedAddresses.clear();
            getUsersAddress();
          } else {
            getUsersAddress();
            showSnackBar(context, responseData['response'], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          print("deleteAddressApiError: $onError");
          _isLoading = false;
          getUsersAddress();
        });
      });
    });
  }

  Future<void> _openLoadingDialog(
      BuildContext context, bool isPlacingOrder, bool isFailed) async {
    /*  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light));*/
    showDialog(
      context: context,
      barrierColor: Colors.white,
      // Background color
      barrierDismissible: isFailed
          ? true
          : isPlacingOrder
              ? false
              : true,
      barrierLabel: 'Dialog',
      // How long it takes to popup dialog after button click
      builder: (context) {
        // Makes widget fullscreen
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return SizedBox.expand(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Center(
                        child: isPlacingOrder
                            ? Lottie.asset(Strings.loadinCircularAnim,
                                repeat: true)
                            : isFailed
                                ? Lottie.asset(Strings.failedAnim,
                                    repeat: false)
                                : Lottie.asset(Strings.placedAnim,
                                    repeat: false)),
                  ),
                  Visibility(
                    visible: !isPlacingOrder,
                    child: Expanded(
                      flex: 1,
                      child: SizedBox.expand(
                        child: ElevatedButton(
                          onPressed: () {
                            enableNormalUI();
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor: isFailed
                                  ? MaterialStateProperty.all(Colors.red)
                                  : MaterialStateProperty.all(Colors.green)),
                          child: Text(
                            'Dismiss',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> placeOrder() async {
    print("isOnline: ${widget.isOnlinePayment}");
    if (!widget.isOnlinePayment) {
      Map<String, dynamic> data = {"addressid": Common.selectedAddressId};
      Common.placeOrderData.addAll(data);
      print("codFormData: ${jsonEncode(Common.placeOrderData)}");
    } else {
      Map<String, dynamic> data = {"addressid": Common.selectedAddressId};
      Common.placeOrderData.addAll(data);
      Common.placeOrderData
          .update("type", (value) => "online", ifAbsent: () => "online");
      print("onlineFormData: ${jsonEncode(Common.placeOrderData)}");
    }

    placeCashOnDeliveryOrderApi(Common.placeOrderData).then((value) {
      var responseData = jsonDecode(value.body);
      print("Success? ${responseData[Common.successKey]}");
      print("Success? ${responseData["response"]["orderid"]}");
      if (responseData[Common.successKey]) {
        if (widget.isOnlinePayment) {
          Navigator.pop(context);
        }
        if (!widget.isOnlinePayment) {
          clearCart();
          _openLoadingDialog(context, false, false);
          setState(() {
            widget.isSelectingAddress = false;
            Common.selectedAddressId = "";
          });

          Future.delayed(Duration(milliseconds: 2000), () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => PurchasedOrderDetailsScreen(itemTotal: widget.itemTotal,deliveryCharges: widget.deliveryCharges,orderId: responseData["response"]["orderid"].toString(),)),
                (route) => false);
          });
        } else {
          print("razorPay");
          PlaceOrder.PlaceOrderResponse response =
              PlaceOrder.PlaceOrderResponse.fromJson(jsonDecode(value.body));
          placeRazorPayOrder(response.response);
          currentOrderId = response.response.orderid.toString();
        }
      } else if (value.statusCode >= 500 && value.statusCode <= 599) {
        print("serverError");
        Navigator.pop(context);
        _openLoadingDialog(context, false, false);
        showSnackBar(context, "Server error please try again later", 1500);
      } else {
        Navigator.pop(context);
        _openLoadingDialog(context, false, true);
        showSnackBar(context, responseData[Common.responseKey], 1500);
      }
    }).catchError((onError) {
      setState(() {
        Navigator.pop(context);
        _openLoadingDialog(context, false, true);
        print("placeCashOnDeliveryOrderApiError: $onError" +
            "isOnlineOrder: ${widget.isOnlinePayment}");
      });
    });
  }

  void placeRazorPayOrder(PlaceOrder.Response response) {
    print("placeRazorPayOrder");
    RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
    double money = double.parse(response.total.toString());
    double tMoney = money * 100;
    String stringMoney = tMoney.toString().replaceAll(regex, '');
    int totalMoney = int.parse(stringMoney);
    print(response.rAZORPAYAPIKEY);
    var options = {
      'key': response.rAZORPAYAPIKEY,
      'amount': totalMoney,
      'name': 'Saag Sabji',
      'orderId': response.orderid,
      'description': 'Your order of Saag Sabji',
      'prefill': {
        'contact':
            '${Common.currentUser!.mobile}' /*, 'email': 'test@razorpay.com'*/
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

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("_handlePaymentSuccess");
    Map<String, dynamic> formData = {"orderid": response.orderId.toString()};
    print("orderID: $formData");
    updateOrderStatusApi(formData).then((value) {
      setState(() async {
        var responseData = jsonDecode(value.body);
        print("registerUserApi: $responseData");
        if (responseData[Common.successKey]) {
          showSuccess();
        } else if (value.statusCode >= 500 && value.statusCode <= 599) {
          showSnackBar(context, "Server error please try again later", 1500);
        } else {
          showSnackBar(context, responseData[Common.responseKey], 1500);
        }
      });
    }).catchError((onError) {
      setState(() {
        print("updateOrderStatusApiError: $onError");
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("_handlePaymentError");
    _openLoadingDialog(context, false, true);

    deleteOrder();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // todo _handleExternalWallet
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> clearCart() async {
    print("clearCart");
    CartDatabase.instance.getListOfItemsInCart().then((value) {
      for (CartModel currentItem in value) {
        CartDatabase.instance.delete(currentItem.productId);
      }
    });
  }

  void updatePaymentStatus(String orderId) {
    setState(() {
      Map<String, String> otp = {"orderid": orderId};
      print(otp);
    });
  }

  void showSuccess() {
    print("showSuccess");
    clearCart();
    _openLoadingDialog(context, false, false);
    setState(() {
      widget.isSelectingAddress = false;
      Common.selectedAddressId = "";
    });

    Future.delayed(Duration(milliseconds: 2000), () async {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OrdersUI()),
          (route) => false);
    });
  }

  void deleteOrder() {
    Map<String, String> formData = {"orderid": currentOrderId};
    deleteOrderApi(formData).then((value) {
      setState(() async {
        var responseData = jsonDecode(value.body);
        print("registerUserApi: $responseData");
        if (responseData[Common.successKey]) {
          widget.isSelectingAddress = false;
          Common.selectedAddressId = "";
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartUI()));
        } else if (value.statusCode >= 500 && value.statusCode <= 599) {
          showSnackBar(context, "Server error please try again later", 1500);
        } else {
          showSnackBar(context, responseData[Common.responseKey], 1500);
        }
      });
    }).catchError((onError) {
      setState(() {
        print("deleteOrderApiError: $onError");
      });
    });
  }
}
