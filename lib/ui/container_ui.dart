import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:saag_sabji/db/cart_database.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/helper/page_transition_fade_animation.dart';
import 'package:saag_sabji/models/cart.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/get_products_by_category_response.dart';
import 'package:saag_sabji/ui/account_ui.dart';
import 'package:saag_sabji/ui/address_ui.dart';
import 'package:saag_sabji/ui/cart_ui.dart';
import 'package:saag_sabji/ui/home_sreeen_ui.dart';
import 'package:saag_sabji/ui/orders_ui.dart';
import 'package:saag_sabji/ui/refer_and_earn.dart';
import 'package:saag_sabji/ui/supprt_and_help_ui.dart';
import 'package:saag_sabji/ui/view_product_details.dart';
import 'package:saag_sabji/ui/wallet_ui.dart';
import 'package:saag_sabji/ui/welcome_ui.dart';
import 'package:saag_sabji/widgets/item_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/common.dart';
import 'about_us_ui.dart';

class FragmentContainer extends StatefulWidget {
  @override
  _FragmentContainerState createState() => _FragmentContainerState();
}

class _FragmentContainerState extends State<FragmentContainer> {
  int _state = 0;

  TextEditingController _searchController = TextEditingController();
  List<Response> listOfSearchedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: [
            ValueListenableBuilder(
                valueListenable: Common.cartItems,
                builder: (context, value, child) {
                  return InkWell(
                    onTap: () {
                      handleActions();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Badge(
                        toAnimate: true,
                        animationType: BadgeAnimationType.slide,
                        showBadge: Common.cartItems.value.isNotEmpty,
                        animationDuration: Duration(milliseconds: 300),
                        badgeColor: Colors.green.shade300,
                        alignment: Alignment.center,
                        position: BadgePosition.topEnd(),
                        badgeContent: ValueListenableBuilder(
                          valueListenable: Common.cartItems,
                          builder: (context, value, child) {
                            return Text(
                              Common.cartItems.value.length.toString(),
                              style: TextStyle(color: Colors.black),
                            );
                          },
                        ),
                        child: Icon(Icons.shopping_cart),
                      ),
                    ),
                  );
                })
          ],
          bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.text,
                    controller: _searchController,
                    onChanged: searchQuery,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      suffixIcon: Visibility(
                        visible: _state == 1
                            ? true
                            : _state == 2
                                ? true
                                : _state == 3
                                    ? true
                                    : false,
                        child: IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                            ),
                            onPressed: () {
                              print("CLICK");
                              setState(() {
                                if (_state != 0) {
                                  setState(() {
                                    _searchController.clear();
                                    _state = 0;
                                  });
                                }
                              });
                            }),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Search for fruits and vegetables",
                      counterText: "",
                      prefixIcon: Icon(Icons.search, color: Colors.black87),
                    ),
                  ),
                ),
              ),
              preferredSize: Size.fromHeight(60.0)),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: UserAccountsDrawerHeader(
                    accountName: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Visibility(
                        visible: Common.currentUser == null ? false : true,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton.icon(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero),
                                onPressed: () {},
                                icon: Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  Common.currentUser != null
                                      ? "Wallet balance: ₹${Common.currentUser!.walletBalance}"
                                      : "",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      ),
                    ),
                    accountEmail: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                            style: TextButton.styleFrom(padding: EdgeInsets.zero),
                            onPressed: () {},
                            icon: Icon(
                              Icons.person_outline_rounded,
                              color: Colors.white,
                            ),
                            label: Text(
                              Common.currentUser == null
                                  ? "Guest user"
                                  : Common.currentUser!.mobile,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )),
                      ],
                    )),
              ),
              ListTile(
                leading: Icon(Icons.home_rounded),
                title: Text("Home"),
                onTap: () {
                  handleNavigation("Home");
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart_rounded),
                title: Text("Cart"),
                onTap: () {
                  handleNavigation("Cart");
                },
              ),
              Visibility(
                visible: Common.isSignedIn,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.account_box_rounded),
                      title: Text("Account"),
                      onTap: () {
                        handleNavigation("Account");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.account_balance_wallet_rounded),
                      title: Text("Wallet"),
                      onTap: () {
                        handleNavigation("Wallet");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on_rounded),
                      title: Text("My Addresses"),
                      onTap: () {
                        handleNavigation("My Addresses");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.bookmark_border_rounded),
                      title: Text("My Orders"),
                      onTap: () {
                        // handleNavigation("My Orders");
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> OrdersUI()));
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 0.1,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8),
                child: Text(
                  "Communicate",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info_rounded),
                title: Text("About Us"),
                onTap: () {
                  handleNavigation("About Us");
                },
              ),
              Visibility(
                visible: Common.isSignedIn,
                child: ListTile(
                  leading: Icon(Icons.offline_share),
                  title: Text("Refer & earn"),
                  onTap: () {
                    handleNavigation("Refer & earn");
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.help_outline_rounded),
                title: Text("Support"),
                onTap: () {
                  handleNavigation("Support");
                },
              ),
              ListTile(
                leading: Common.isSignedIn
                    ? Icon(Icons.exit_to_app_rounded)
                    : Icon(Icons.login),
                title: Text(Common.isSignedIn ? "Log out" : "Log in"),
                onTap: () {
                  if (Common.isSignedIn) {
                    logout();
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WelcomeUI()));
                  }
                },
              ),
            ],
          ),
        ),

        body: _state == 0 // initial home screen products
            ? HomeFragment()
            : _state == 1
                ? Center(child: CircularProgressIndicator())
                : _state == 2 // results found
                    ? Container(
                        color: Colors.white,
                        child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: listOfSearchedProducts.length,
                          padding: EdgeInsets.all(8),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: MediaQuery.of(context).size.width / 460),
                          itemBuilder: (BuildContext context, int index) {
                            return ItemProduct(index: index, varient: listOfSearchedProducts[index].varient![0], listOfProductsInTheSelectedCategory: listOfSearchedProducts[index]);
                          },
                        ),
                      )
                    : _state == 3 // no results found
                        ? Center(
                            child: Text("No results found!", style: TextStyle(color: Colors.green)))
                        : Center(
                            child: Text("Not defined $_state"))); // not defined
  }

  @override
  void initState() {
    super.initState();
    enableNormalUI();
  }

  void handleNavigation(String nameOfNewRoute) {
    print(nameOfNewRoute);
    if (nameOfNewRoute == "Account") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen()));
    } else if (nameOfNewRoute == "Cart") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CartUI()));
    } else if (nameOfNewRoute == "My Addresses") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddressUI(false, "My Addresses", false)));
    } else if (nameOfNewRoute == "My Orders") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OrdersUI()));
    } else if (nameOfNewRoute == "Refer & earn") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ReferAndEarnUI()));
    } else if (nameOfNewRoute == "Support") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SupportAndHelpUI()));
    } else if (nameOfNewRoute == "Home") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => FragmentContainer()));
    } else if (nameOfNewRoute == "About Us") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AboutUsUi()));
    } else if (nameOfNewRoute == "Wallet") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UserWalletUI()));
    }
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

  void handleActions() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CartUI()));
  }

  void searchQuery(String query) {
    if (query.trim().isNotEmpty) {
      setState(() {
        listOfSearchedProducts.clear();
        _state = 1;
        print("searchQuery: $_state");
        Map<String, String> formData = {
          "keyword": query.trim(),
          "vendorid": "1"
        };
        print("formData: $formData");
        searchProductsApi(formData).then((value) {
          print(value.request);
          setState(() {
            var responseData = jsonDecode(value.body);
            if (responseData[Common.successKey]) {
              GetProductsByCategoryResponse response = GetProductsByCategoryResponse.fromJson(jsonDecode(value.body));
              listOfSearchedProducts.clear();
              _state = 2;
              print("searchQuery: $_state");
              listOfSearchedProducts = response.response;
            } else if (value.statusCode >= 500 && value.statusCode <= 599) {
              listOfSearchedProducts.clear();
              _state = 0;
              print("searchQuery: $_state");
              showSnackBar(
                  context, "Server error please try again later", 1500);
            } else {
              showSnackBar(context, responseData[Common.responseKey], 1500);
              listOfSearchedProducts.clear();
              _state = 3;
              print("searchQuery: $_state");
            }
          });
        }).catchError((onError) {
          setState(() {
            _state = 0;
            listOfSearchedProducts.clear();
            print("searchQuery: $_state");
            print("searchProductsApiError: $onError");
          });
        });
      });
    } else {
      setState(() {
        _state = 0;
      });
    }
  }

  Future<void> addProductToCart(Response selectedProduct) async {
    setState(() {
      selectedProduct.hasInCart = true;
    });
    print(
        "addProductToCartFromHomeScreen ${selectedProduct.productid + " selectedProductID"}");
    try {
      CartModel item = CartModel(selectedProduct.productid, 1,
          selectedProduct.rate, selectedProduct.name,selectedProduct.image);
      await CartDatabase.instance.create(item);
      getCartItems();
    } catch (error) {
      print("addProductToCartFromHomeScreenUI_Error $error");
    }
  }

  Widget addOrChangeQuantity(Response item, int index, List<CartModel> value) {
    print("CartSize Home " + value.length.toString());

    if (value.isNotEmpty) {
      CartModel? currentItemCart = null;
      for (CartModel currentCartItem in value) {
        if (int.parse(item.productid) ==
            int.parse(currentCartItem.productId.toString())) {
          //alreadyInCart = true;
          item.hasInCart = true;
          currentItemCart = currentCartItem;
          break;
        } else {
          item.hasInCart = false;
        }
      }
      if (item.hasInCart) {
        return SizedBox(
          height: 40,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                side: BorderSide(color: Colors.blueGrey, width: 1)),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: FlatButton(
                      padding: EdgeInsets.only(right: 2),
                      onPressed: () {
                        _changeQuantity(currentItemCart!, false, index, item);
                      },
                      child: Icon(
                        Icons.remove,
                        color: Colors.green,
                        size: 15,
                      )),
                ),
                Text(
                  currentItemCart == null
                      ? ""
                      : currentItemCart.quantity.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                      padding: EdgeInsets.only(right: 2),
                      onPressed: () {
                        _changeQuantity(currentItemCart!, true, index, item);
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
        );
      } else {
        return SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () {
                addProductToCart(item);
              },
              child: Text(
                "+ Add to Cart ",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    wordSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Color(0xff237f52);
                      return Color(0xff237f52); // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                  ))),
            ));
      }
    } else {
      return SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            onPressed: () {
              addProductToCart(item);
            },
            child: Text(
              "+ Add to Cart ",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  wordSpacing: 1.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Color(0xff237f52);
                    return Color(0xff237f52); // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                ))),
          ));
    }
  }

  Future<void> _changeQuantity(
      CartModel itemCart, bool isIncrement, int index, Response item) async {
    if (isIncrement) {
      int quantity = itemCart.quantity + 1;
      print(quantity);
      CartModel item = CartModel(itemCart.productId, quantity, itemCart.rate, itemCart.productname,itemCart.productImage);
      await CartDatabase.instance.update(item);
    } else if (itemCart.quantity > 1 && itemCart.quantity >= 1) {
      int quantity = itemCart.quantity - 1;
      print(quantity);
      CartModel item = CartModel(itemCart.productId, quantity, itemCart.rate, itemCart.productname,itemCart.productImage);
      await CartDatabase.instance.update(item);
    } else if (itemCart.quantity == 1) {
      removeItem(itemCart, item);
    }

    getCartItems();
  }

  Future<void> removeItem(CartModel itemCart, Response item) async {
    await CartDatabase.instance.delete(itemCart.productId);
    item.hasInCart = false;
  }

  Future<List<CartModel>> getCartItems() async {
    await CartDatabase.instance.getListOfItemsInCart().then((value) {
      Common.cartItems.value = value;

      return value;
    });
    return [];
  }

/*Widget addAndChangeQuantity(Response item, int index) {
    // bool alreadyInCart = false;
    CartModel? currentItemCart = null;
    for (CartModel currentCartItem in Common.cartItems.value) {
      if (item.name == currentCartItem.name) {
        //alreadyInCart = true;
        item.hasInCart = true;
        currentItemCart = currentCartItem;
        break;
      } else {
        item.hasInCart = false;
        //alreadyInCart = false;
      }
    }
    //print(alreadyInCart);
    if (item.hasInCart) {
      return SizedBox(
        height: 40,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: BorderSide(color: Colors.blueGrey, width: 1)),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: FlatButton(
                    padding: EdgeInsets.only(right: 2),
                    onPressed: () {
                      _changeQuantity(currentItemCart!, false, index, item);
                    },
                    child: Icon(
                      Icons.remove,
                      color: Colors.green,
                      size: 15,
                    )),
              ),
              Text(
                */ /* currentItemCart == null
                    ? ""
                    : currentItemCart.quantity.toString()*/ /*
                currentItemCart!.quantity.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                    padding: EdgeInsets.only(right: 2),
                    onPressed: () {
                      _changeQuantity(currentItemCart!, true, index, item);
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
      );
    } else {
      return SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            onPressed: () {
              addProductToCart(item);
            },
            child: Text(
              "+ Add to Cart ",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  wordSpacing: 1.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Color(0xff237f52);
                    return Color(0xff237f52); // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                ))),
          ));
    }
  }*/
/*
  void _changeQuantity(
      CartModel itemCart, bool isIncrement, int index, Response item) {
    setState(() {
      if (isIncrement) {
        itemCart.quantity++;
      } else if (itemCart.quantity > 1 && itemCart.quantity >= 1) {
        itemCart.quantity--;
      } else if (itemCart.quantity == 1) {
        setState(() {
          // Common.cartItems.value.removeAt(index);
          item.hasInCart = false;
          Common.cartItems.value.remove(itemCart);
          // itemCart.removeAt(index);
        });
      }
    });
  }*/
}
