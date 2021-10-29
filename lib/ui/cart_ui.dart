import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/db/cart_database.dart';
import 'package:saag_sabji/helper/empty_screen.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/models/cart.dart';
import 'package:saag_sabji/models/item_model.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/promo_codes_response.dart';
import 'package:saag_sabji/ui/welcome_ui.dart';

import 'address_ui.dart';

class CartUI extends StatefulWidget {
  @override
  _CartUIState createState() => _CartUIState();
}

class _CartUIState extends State<CartUI> {
  late Size _size;
  double totalPrice = 0.00;
  int discount = 0;
  bool _isCouponApplied = false,
      _useCouponCode = false,
      _isApplyingPromoCode = false;
  double finalPrice = 0.00;
  double finalPriceToBePaid = 0.00;
  double walletAmountUsed = 0.00;
  List<Response> listOfPromoCodes = [];
  TextEditingController _promoCodeController = TextEditingController();
  int deliveryCharges = 0;
  var _selectedMethod = -1;
  bool _isLoading = false, _usingWallet = false;
  double amountUsedFromWallet = 0.00;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text("Cart"),
        elevation: 1,
      ),
      body: ValueListenableBuilder(
        key: scaffoldKey,
        valueListenable: Common.cartItems,
        builder: (BuildContext context, value, dynamic child) {
          if (Common.cartItems.value.isEmpty) {
            return EmptyUI("Your cart is empty", "Shop Now");
          } else {
            return ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: Common.cartItems.value.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // todo forShowing item Image
                              /* SizedBox(
                                width: 60,
                                height: 60,
                                child: Image.network(
                                  Common.cartItems.value[index].image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),*/
                              Container(
                                  height: 100,
                                  width: 100,
                                  child: Common.cartItems.value[index].productImage ==
                                      "http://sagsabji.einixworld.online/storage/product/"
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                    child: Image.asset(
                                      "assets/images/logo_copy.png",
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                      : ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8)),
                                      child: FadeInImage.assetNetwork(
                                        image: Common.cartItems.value[index].productImage,
                                        fit: BoxFit.contain,
                                        placeholder:
                                        "assets/images/logo_copy.png",
                                      ))),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Text(
                                        Common.cartItems.value[index].productname,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "₹${Common.cartItems.value[index].rate}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  child: Card(
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(0),
                                                        side: BorderSide(
                                                            color: Colors.blueGrey,
                                                            width: 1)),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: FlatButton(
                                                              padding:
                                                              EdgeInsets.only(right: 2),
                                                              onPressed: () {
                                                                _changeQuantity(
                                                                    Common.cartItems
                                                                        .value[index],
                                                                    false);
                                                              },
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: Colors.green,
                                                                size: 15,
                                                              )),
                                                        ),
                                                        Text(
                                                          Common.cartItems.value[index]
                                                              .quantity
                                                              .toString(),
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 14),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: FlatButton(
                                                              padding:
                                                              EdgeInsets.only(right: 2),
                                                              onPressed: () {
                                                                _changeQuantity(
                                                                    Common.cartItems
                                                                        .value[index],
                                                                    true);
                                                              },
                                                              child: Icon(
                                                                Icons.add,
                                                                color: Colors.green,
                                                                size: 15,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                removeItem(Common.cartItems.value[index]);
                                                // Common.cartItems.value.removeAt(index);
                                              },
                                              icon: Icon(
                                                Icons.delete_rounded,
                                                color: Colors.red,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Bill Detail".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    "",
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Sub Total",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "₹$totalPrice",
                                    style: TextStyle(fontSize: 14),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delivery charges",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  _isLoading
                                      ? Center(
                                          child: SizedBox(
                                              height: 14,
                                              width: 14,
                                              child:
                                                  CircularProgressIndicator()))
                                      : Text(
                                          "+ ₹$deliveryCharges",
                                          style: TextStyle(fontSize: 14),
                                        )
                                ],
                              ),
                              Divider(color: Colors.grey,),
                              Visibility(
                                visible: Common.isSignedIn,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 24.0,
                                            height: 24.0,
                                            child: Checkbox(
                                              value: _useCouponCode,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _useCouponCode = newValue!;
                                                  if (!_useCouponCode) {
                                                    discount = 0;
                                                    getFinalAmountToPaid();
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text(
                                              "Use a promo code",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        _useCouponCode
                                            ? discount == 0
                                                ? "Enter a promo code"
                                                : "- ₹$discount"
                                            : "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              SizedBox(
                                height: 4,
                              ),
                              Visibility(
                                visible: Common.isSignedIn,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 24.0,
                                            height: 24.0,
                                            child: Checkbox(
                                              value: _usingWallet,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _usingWallet = newValue!;
                                                  getFinalAmountToPaid();
                                                  getCartPrice();
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text(
                                              Common.isSignedIn
                                                  ? "Use my wallet balance \ntotal available: ₹${double.parse(Common.currentUser!.walletBalance)}"
                                                  : "",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // _usingWallet
                                      //     ? Text(
                                      //         "- ₹${walletAmountUsed.abs()}",
                                      //         style: TextStyle(
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.bold),
                                      //       )
                                      //     : Text("")
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Visibility(
                                visible: _useCouponCode,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: InkWell(
                                        onTap: () {
                                          getAvailablePromoCodes();
                                        },
                                        child: Text(
                                          "Show available coupons",
                                          style: TextStyle(
                                              fontSize: _size.width / 24,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r"[A-Z0-9]+")),
                                      ],
                                      controller: _promoCodeController,
                                      cursorColor: Colors.black,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      decoration: new InputDecoration(
                                        hintText: "Enter a promo code",
                                        contentPadding:
                                            EdgeInsets.only(left: 8),
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        //prefixIcon: Icon(Icons.text_rotate_up),
                                        enabled: true,
                                        //prefix: Image.asset("assets/images/rupee.png",width: _size.width/18,height: _size.width/18,color: Colors.grey,)
                                      ),
                                    ),
                                    _isApplyingPromoCode
                                        ? Center(
                                            child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator()),
                                          ))
                                        : SizedBox(
                                            width: _size.width,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
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
                                              onPressed: () {
                                                applyPromoCode();
                                              },
                                              child: Text("Apply".toUpperCase(),
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      letterSpacing: 0.6,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ))
                                  ],
                                ),
                              ),
                              /* SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "To Pay",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "₹",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),*/
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: Common.cartItems.value.isNotEmpty
          ? Container(
              color: Colors.grey[50],
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "total".toUpperCase(),
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                letterSpacing: 1,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "₹$finalPriceToBePaid".toUpperCase(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.green;
                                return Colors
                                    .green; // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            if (finalPriceToBePaid <= 0.00) {
                              print("Free!");
                              selectDeliveryAddress(false);
                            } else {
                              selectPaymentMethod();
                            }
                          },
                          child: Text("place order".toUpperCase(),
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  letterSpacing: 0.6,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  @override
  void initState() {
    super.initState();
    getCartItems();
  }

  void getCartPrice() {
    setState(() {
      _isLoading = true;
    });

    List<ItemModel> listOfItems = [];
    Common.cartItems.value.forEach((element) {
      ItemModel item =
          ItemModel(element.productId.toString(), element.quantity);
      listOfItems.add(item);
    });
    Map<String, dynamic> formData = {
      "userid": Common.isSignedIn ? Common.currentUser!.userid : "120",
      "products": listOfItems
    };

    Map<String, dynamic> placeOrderData = {
      "userid": Common.isSignedIn ? Common.currentUser!.userid : "120",
      "cartdata": listOfItems,
      "vendorid": "27",
      "type": "cod",
      "usepoints": _usingWallet ? walletAmountUsed.abs() : false,
      "discount": _useCouponCode ? discount : 0
    };
    print(walletAmountUsed);
    print("useWallet? $_usingWallet");

    Common.placeOrderData = placeOrderData;

    print(jsonEncode(formData));

    getDeliveryChargesApi(formData).then((value) {
      setState(() {
        _isLoading = false;
        var responseData = jsonDecode(value.body);
        if (responseData['success']) {
          deliveryCharges = responseData['dlcharge'];

          getTotalAmount(responseData['dlcharge']);
        } else {
          showSnackBar(context, responseData['response'], 1500);
        }
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      print("getDeliveryChargesApiError: $onError");
    });
  }

  void _changeQuantity(CartModel item, bool isIncrement) {
    if (isIncrement) {
      increaseQuantity(item, isIncrement);
    } else {
      increaseQuantity(item, isIncrement);
    }
  }

  Future<List<CartModel>> getCartItems() async {
    await CartDatabase.instance.getListOfItemsInCart().then((value) {
      Common.cartItems.value = value;
      print("Cart " + value.length.toString());
      getCartPrice();
      return value;
    });

    return [];
  }

  void removeItem(CartModel cartModel) async {
    await CartDatabase.instance.delete(cartModel.productId);

    getCartItems();
  }

  Future<void> increaseQuantity(CartModel cartItem, bool isIncrement) async {
    print(isIncrement);
    if (isIncrement) {
      int quantity = cartItem.quantity + 1;
      print(quantity);
      CartModel item = CartModel(
          cartItem.productId, quantity, cartItem.rate, cartItem.productname,cartItem.productImage);
      // print(item.quantity);
      await CartDatabase.instance.update(item);
    } else if (cartItem.quantity > 1 && cartItem.quantity >= 1) {
      int quantity = cartItem.quantity - 1;
      print(quantity);
      CartModel item = CartModel(
          cartItem.productId, quantity, cartItem.rate, cartItem.productname,cartItem.productImage);
      // print(item.quantity);
      await CartDatabase.instance.update(item);
    } else if (cartItem.quantity == 1) {
      await CartDatabase.instance.delete(cartItem.productId);
    }

    getCartItems();
  }

  void getTotalAmount(deliveryCharges) {
    totalPrice = 0.00;
    for (CartModel cart in Common.cartItems.value) {
      setState(() {
        totalPrice += cart.quantity * cart.rate;
        finalPrice = totalPrice + deliveryCharges;
      });
    }

    getFinalAmountToPaid();
  }

  void selectPaymentMethod() {
    showModalBottomSheet(
        backgroundColor: Common.isSignedIn ? Colors.white : Colors.transparent,
        context: context,
        builder: (contextBottomSheet) {
          return StatefulBuilder(
            builder: (context, setBottomState) {
              return Common.isSignedIn
                  ? Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: new Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Text(
                                  "Payment Modes",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Expanded(
                                  child: Text(""),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey[500],
                          ),
                          new Center(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: 0,
                                      groupValue: _selectedMethod,
                                      onChanged: (value) {
                                        setState(() {
                                          changePaymentMethod(
                                              value, setBottomState);
                                        });
                                      },
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          changePaymentMethod(
                                              0, setBottomState);
                                        });
                                      },
                                      child: Text(
                                        "COD (Cash On Delivery)",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: _selectedMethod,
                                      onChanged: (v) {
                                        setState(() {
                                          changePaymentMethod(
                                              v, setBottomState);
                                        });
                                      },
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          changePaymentMethod(
                                              1, setBottomState);
                                        });
                                      },
                                      child: Text(
                                        "Credit/Debit Cards, Net banking and Wallets",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 12, right: 12),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          side:
                                              BorderSide(color: Colors.green)),
                                      onPressed: () {
                                        if (_selectedMethod == 0) {
                                          selectDeliveryAddress(false);
                                        } else if (_selectedMethod == 1) {
                                          selectDeliveryAddress(true);
                                        } else {
                                          Navigator.pop(context);
                                          showSnackBar(
                                              context,
                                              "Please select a payment mode!",
                                              1500);
                                        }
                                      },
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      child: amount(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 70,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color(0xff333333).withOpacity(0.5),
                                width: 0.1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Please login to continue",
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'OpenSans'),
                                  )),
                              Container(
                                  height: 30,
                                  width: 90,
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "Cancel".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: 10,
                                          fontFamily: 'Ubuntu',
                                          fontWeight: FontWeight.w800),
                                    ),
                                  )),
                              Container(
                                  height: 30,
                                  width: 80,
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WelcomeUI()));
                                    },
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Color(0xff333333), width: 1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "Login".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 10,
                                          fontFamily: 'Ubuntu',
                                          fontWeight: FontWeight.w800),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
            },
          );
        });
  }

  void changePaymentMethod(v, StateSetter setBottomState) {
    setBottomState(() {
      print(v);
      _selectedMethod = v;
      print(_selectedMethod);
    });
  }

  Widget amount() {
    print(_selectedMethod);
    if (_selectedMethod == 0) {
      return Text(
          "Place order and pay ".toUpperCase() +
              "₹$finalPriceToBePaid" +
              " /- " +
              "On delivery",
          style: TextStyle(fontSize: 14));
    } else if (_selectedMethod == 1) {
      return Text(
          "Proceed To Pay ".toUpperCase() + "₹$finalPriceToBePaid" + " /-",
          style: TextStyle(fontSize: 14));
    } else {
      return Text("Select your payment mode", style: TextStyle(fontSize: 14));
    }
  }

  void selectDeliveryAddress(bool isOnlinePaymentMethod) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddressUI(
                true, "Select a delivery Address", isOnlinePaymentMethod,itemTotal: totalPrice.toString(),deliveryCharges: deliveryCharges.toString())));
  }

  void getFinalAmountToPaid() {
    walletAmountUsed = 0.0;
    if (_usingWallet) {
      finalPriceToBePaid = finalPrice -
          discount -
          double.parse(Common.currentUser!.walletBalance);

      print("final ${finalPriceToBePaid.abs()}");
      print("wallet " +
          (double.parse(Common.currentUser!.walletBalance) -
                  double.parse(Common.currentUser!.walletBalance) -
                  finalPrice -
                  discount)
              .toString());

      walletAmountUsed = finalPriceToBePaid.abs() -
          double.parse(Common.currentUser!.walletBalance);

      if (finalPriceToBePaid <= 0) {
        finalPriceToBePaid = 0.00;
      }
    } else {
      finalPriceToBePaid = finalPrice - discount;
    }

    setState(() {});
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
                        "Apply coupon code",
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
                                            TextButton(
                                              onPressed: () {
                                                _promoCodeController.text =
                                                    listOfPromoCodes[index]
                                                        .code;
                                                Navigator.pop(context);
                                                setState(() {
                                                  _isCouponApplied = true;
                                                });
                                              },
                                              child: Text(
                                                "Apply".toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green,
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
      "type": Common.discount
    };
    fetchPromoCodesApi(formData).then((value) {
      Navigator.pop(context);

      var responseData = jsonDecode(value.body);
      if (responseData[Common.successKey]) {
        PromoCodesResponse response =
            PromoCodesResponse.fromJson(jsonDecode(value.body));
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

  void applyPromoCode() {
    setState(() {
      _isApplyingPromoCode = true;
      Map<String, String> formData = {
        "promocode": _promoCodeController.text,
        "amount": finalPriceToBePaid.toString(),
        "type": Common.discount
      };
      print(formData);

      applyPromoCodeApi(formData).then((value) {
        print("apply");
        setState(() {
          _isApplyingPromoCode = false;
          var responseData = jsonDecode(value.body);
          print(responseData);
          print(responseData[Common.successKey]);
          if (responseData[Common.successKey]) {
            print("if");
            print(responseData["discount"]);
            discount = int.parse(responseData["discount"]);
            print(finalPrice);
            showSnackBar(context, responseData[Common.responseKey], 1500);
          } else {
            print(responseData);
            print("else: ${responseData[Common.responseKey]}");
            discount = 0;
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }

          getFinalAmountToPaid();
        });
      }).catchError((onError) {
        print("applyPromoCodeApiError: $onError");
        setState(() {
          discount = 0;
          getFinalAmountToPaid();
          _isApplyingPromoCode = false;
        });
      });
    });
  }
}
