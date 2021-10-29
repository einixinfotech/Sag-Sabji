import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/db/cart_database.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/helper/page_transition_fade_animation.dart';
import 'package:saag_sabji/models/cart.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/get_categories_response.dart'
    as SelectedCategory;
import 'package:saag_sabji/response/get_products_by_category_response.dart'
    as Product;
import 'package:saag_sabji/response/get_products_by_category_response.dart';
import 'package:saag_sabji/ui/view_product_details.dart';
import 'package:saag_sabji/widgets/item_product.dart';

import 'cart_ui.dart';

class ShowProductsUI extends StatefulWidget {
  SelectedCategory.Response selectedCategory;

  ShowProductsUI(this.selectedCategory);

  @override
  _ShowProductsUIState createState() => _ShowProductsUIState();
}

class _ShowProductsUIState extends State<ShowProductsUI> {
  List<Product.Response> listOfProductsInTheSelectedCategory = [];
  bool _isLoading = true;

  Product.Varient selectedVarient = Product.Varient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedCategory.name),
        actions: [
          ValueListenableBuilder(
              valueListenable: Common.cartItems,
              builder: (context, value, child) {
                return InkWell(
                  onTap: () {
                    handleActions();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: listOfProductsInTheSelectedCategory.length,
                padding: EdgeInsets.all(8),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width / 460),
                itemBuilder: (BuildContext context, int index) {
                  return ItemProduct(index: index, varient: listOfProductsInTheSelectedCategory[index].varient![0], listOfProductsInTheSelectedCategory: listOfProductsInTheSelectedCategory[index]);
                },
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    getProductsForSelectedCategory();
  }

  void getProductsForSelectedCategory() {
    var formData = {"catid": widget.selectedCategory.categoryId};
    print(formData);

    getProductsForSelectedCategoryApi(formData).then((value) {
      setState(() {
        _isLoading = false;
        var responseData = jsonDecode(value.body);
        if (responseData[Common.successKey]) {
          Product.GetProductsByCategoryResponse response = Product.GetProductsByCategoryResponse.fromJson(jsonDecode(value.body));

          listOfProductsInTheSelectedCategory = response.response;

        } else if (value.statusCode >= 500 && value.statusCode <= 599) {
          showSnackBar(context, "Server error please try again later", 1500);
        } else {
          showSnackBar(context, responseData[Common.responseKey], 1500);
        }
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
        print("getProductsForSelectedCategoryApiError: $onError");
      });
    });
  }

  Widget addOrChangeQuantity(
      Product.Response item, int index, List<CartModel> value) {
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

  Future<void> _changeQuantity(CartModel itemCart, bool isIncrement, int index,
      Product.Response item) async {
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

  Future<void> removeItem(CartModel itemCart, Product.Response item) async {
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

  Future<void> addProductToCart(Product.Response selectedProduct) async {
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
