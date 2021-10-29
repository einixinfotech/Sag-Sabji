import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/db/cart_database.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/helper/page_transition_fade_animation.dart';
import 'package:saag_sabji/models/cart.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/get_products_by_category_response.dart';

import 'cart_ui.dart';

class ViewProductDetails extends StatefulWidget {
  Response item;

  ViewProductDetails(this.item);

  /*const ViewProductDetails({Key? key}) : super(key: key);*/

  @override
  _ViewProductDetailsState createState() => _ViewProductDetailsState();
}

class _ViewProductDetailsState extends State<ViewProductDetails> {
  List<Response> listOfSimilarProducts = [];
  bool _isLoading = false;
  late Varient selectedVarient;
  int variantIndex = 0;
  int similarVariantIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("View Product"),
        actions: [
          ValueListenableBuilder(
              valueListenable: Common.cartItems,
              builder: (context, value, child) {
                return InkWell(
                  onTap: () {
                    handleActions();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 270,
                child: Image.network(
                  widget.item.varient?[variantIndex].image??"",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.varient?[variantIndex].name??"",
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.3,
                            wordSpacing: 1,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          widget.item.varient?[variantIndex].category??"",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            letterSpacing: 0.3,
                            wordSpacing: 1,
                            height: 1.5,
                          ),
                        ),
                        (widget.item.varient?.length??0) > 1 ?
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1,color: Colors.black38),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                          margin: const EdgeInsets.only(top: 16.0, left: 4, right: 4.0),
                          child: DropdownButton<Varient>(
                              style: TextStyle(fontSize: 14,color: Colors.black),
                              value: selectedVarient,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (val){
                                // selectedCity = CityData();
                                // selectedCity?.id = val?.id??0;
                                setState(() {
                                  variantIndex = widget.item.varient?.indexOf(val!)??0;
                                  selectedVarient = val!;
                                });
                                // getSimilarProducts(selectedVarient?.id.toString()??"");
                                // getProductDetails(selectedVarient?.id.toString()??"");
                              },
                              hint: Text("Varients"),
                              items: widget.item.varient!.map((e) {
                                return DropdownMenuItem(child: Text(e.name??''),value: e);
                              }).toList()
                          ),
                        ):Container(height: 65,),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "₹${widget.item.varient?[variantIndex].rate}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                wordSpacing: 1,
                                color: Colors.grey[900],
                                height: 1.5,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "₹${widget.item.varient?[variantIndex].wholesaleRate}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                letterSpacing: 0.3,
                                wordSpacing: 1,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  /* SizedBox(
                    height: 8,
                  ),*/
                  /* Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          height: 18,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.green),
                          child: Center(
                            child: Text(
                              "4.2",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "(245)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            letterSpacing: 0.3,
                            wordSpacing: 1,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
            /*SizedBox(
              height: 16,
            ),
            Divider(),
            SizedBox(
              height: 16,
            ),*/
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "About product",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    letterSpacing: 0.3,
                    wordSpacing: 1,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Product description",
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.3,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Divider(),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Similar Products",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                    wordSpacing: 1,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: listOfSimilarProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                FadeRoute(
                                  page: ViewProductDetails(listOfSimilarProducts[index]),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    elevation: 1.5,
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 100,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: listOfSimilarProducts[index].varient![similarVariantIndex].image ==
                                                    "http://sagsabji.einixworld.online/storage/product/"
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(8),
                                                            topRight:
                                                                Radius.circular(
                                                                    8)),
                                                    child: Image.asset(
                                                      "assets/images/logo_copy.png",
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(8),
                                                            topRight:
                                                                Radius.circular(
                                                                    8)),
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      image:
                                                          listOfSimilarProducts[index].varient![similarVariantIndex]
                                                              .image??"",
                                                      fit: BoxFit.contain,
                                                      placeholder:
                                                          "assets/images/logo_copy.png",
                                                    ))),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0),
                                          child: SizedBox(
                                            height: 30,
                                            child: Text(
                                              listOfSimilarProducts[index].varient![similarVariantIndex].name??"",
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  letterSpacing: 0.6,
                                                  color: Color(0xff3a3a3a),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Price: ",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  letterSpacing: 0.6,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "₹${listOfSimilarProducts[index].varient![similarVariantIndex].mrp == listOfSimilarProducts[index].varient![similarVariantIndex].rate ? listOfSimilarProducts[index].varient![similarVariantIndex].rate : listOfSimilarProducts[index].varient![similarVariantIndex].mrp}",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  letterSpacing: 0.3,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: Common.cartItems,
                                          builder: (BuildContext context, value,
                                              dynamic child) {
                                            return addOrChangeQuantity(
                                                listOfSimilarProducts[index].varient![similarVariantIndex],
                                                Common.cartItems.value);
                                          },
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
                  )
          ],
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: Common.cartItems,
        builder: (BuildContext context, value, dynamic child) {
          return addOrChangeQuantity(widget.item.varient![variantIndex], Common.cartItems.value);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getSimilarProducts();
    selectedVarient = widget.item.varient![0];
  }

  void getSimilarProducts() {
    Map<String, String> formData = {
      "catid": Common.selectedCategory,
      "productid": widget.item.productid
    };
    setState(() {
      _isLoading = true;

      getSimilarProductsApi(formData).then((value) {
        setState(() {
          _isLoading = false;
          var responseData = jsonDecode(value.body);
          if (responseData[Common.successKey]) {
            GetProductsByCategoryResponse response =
                GetProductsByCategoryResponse.fromJson(jsonDecode(value.body));
            listOfSimilarProducts = response.response;
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
          print("getSimilarProductsApiError: $onError");
        });
      });
    });
  }

  Widget addOrChangeQuantity(Varient item, List<CartModel> value) {
    print("CartSize Home " + value.length.toString());

    if (value.isNotEmpty) {
      CartModel? currentItemCart = null;
      for (CartModel currentCartItem in value) {
        if (int.parse(item.productid??"") ==
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
                        _changeQuantity(currentItemCart!, false, item);
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
                        _changeQuantity(currentItemCart!, true, item);
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
                    borderRadius: BorderRadius.zero,
                  )
                  )
              ),
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
      CartModel itemCart, bool isIncrement, Varient item) async {
    if (isIncrement) {
      int quantity = itemCart.quantity + 1;
      print(quantity);
      CartModel item = CartModel(
          itemCart.productId, quantity, itemCart.rate, itemCart.productname,itemCart.productImage);
      await CartDatabase.instance.update(item);
    } else if (itemCart.quantity > 1 && itemCart.quantity >= 1) {
      int quantity = itemCart.quantity - 1;
      print(quantity);
      CartModel item = CartModel(
          itemCart.productId, quantity, itemCart.rate, itemCart.productname,itemCart.productImage);
      await CartDatabase.instance.update(item);
    } else if (itemCart.quantity == 1) {
      removeItem(itemCart, item);
    }

    getCartItems();
  }

  Future<void> removeItem(CartModel itemCart, Varient item) async {
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

  Future<void> addProductToCart(Varient selectedProduct) async {
    setState(() {
      selectedProduct.hasInCart = true;
    });
    print(
        "addProductToCartFromHomeScreen ${selectedProduct.productid! + " selectedProductID"}");
    try {
      CartModel item = CartModel(selectedProduct.productid, 1,
          selectedProduct.rate, selectedProduct.name,selectedProduct.image);
      await CartDatabase.instance.create(item);
      getCartItems();
    } catch (error) {
      print("addProductToCartFromHomeScreenUI_Error $error");
    }
  }

  void handleActions() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CartUI()));
    /* if (Common.isSignedIn) {

    } else {
      showActionSnackBar(
          context, "You must be logged in first!", "Proceed to login", () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeUI()));
      }, 1500);
    }*/
  }
}
