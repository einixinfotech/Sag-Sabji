import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/db/cart_database.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/helper/page_transition_fade_animation.dart';
import 'package:saag_sabji/helper/resources.dart';
import 'package:saag_sabji/items/category_item.dart';
import 'package:saag_sabji/models/cart.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/carousel_images_response.dart'
    as carouselResponse;
import 'package:saag_sabji/response/get_categories_response.dart';
import 'package:saag_sabji/response/get_products_by_category_response.dart'
    as Product;
import 'package:saag_sabji/ui/view_product_details.dart';
import 'package:saag_sabji/widgets/item_product.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true, _isCarouselLoading = true;

  List<Response> listOfCategories = [];
  List<Product.Response> listOfPopularProducts = [];
  List<carouselResponse.Response> listOfCarouselImages = [];

  final CarouselController controller = CarouselController();

  @override
  void initState() {
    super.initState();
    loadCategories().then((value) {
      getTrendingProducts();
    });
    getSliderImages();
    getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _isCarouselLoading
                              ? Center(
                                  child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: CircularProgressIndicator(),
                                ))
                              : Visibility(
                                  visible: listOfCarouselImages.isNotEmpty,
                                  child: CarouselSlider.builder(
                                    itemCount: listOfCarouselImages.length,
                                    options: CarouselOptions(
                                      aspectRatio: 2.6,
                                      viewportFraction: 1.0,
                                      enlargeCenterPage: false,
                                      autoPlay: true,
                                    ),
                                    itemBuilder: (BuildContext context,
                                        int index, int realIndex) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                listOfCarouselImages[index].image,
                                              ),
                                              fit: BoxFit.contain,
                                            )),
                                      );
                                    },
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 12),
                  child: Text("Shop By Categories", style: boldTitleTxt),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: _isLoading
                    ? Container(
                        height: 120,
                        child: Center(child: CircularProgressIndicator()))
                    : Container(
                        color: Colors.white,
                        child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: listOfCategories.length,
                          padding: EdgeInsets.all(16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: size.width / 450),
                          itemBuilder: (BuildContext context, int index) {
                            return Category(listOfCategories[index]);
                          },
                        ),
                      ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green[50]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 12,
                                    color: Colors.green[300],
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text("Popular".toUpperCase(),
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          letterSpacing: 0.6,
                                          color: Color(0xff333333),
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listOfPopularProducts.length,
                  padding: EdgeInsets.all(8),
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: size.width / 460),
                  itemBuilder: (BuildContext context, int index) {
                    return ItemProduct(index: index, varient: listOfPopularProducts[index].varient![0], listOfProductsInTheSelectedCategory: listOfPopularProducts[index]);
                  },
                ),
              ),
            ),
          ],
        ));
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

  Future<void> loadCategories() async {
    Map<String, String> formData = {"vendorid": "1"};
    print(formData);

    getCategoriesApi(formData).then((value) {
      setState(() {
        _isLoading = false;
        var responseData = jsonDecode(value.body);

        if (responseData[Common.successKey]) {
          CategoriesResponse response =
              CategoriesResponse.fromJson(jsonDecode(value.body));
          listOfCategories = response.response;
        } else if (value.statusCode >= 500 && value.statusCode <= 599) {
          showSnackBar(context, "Server error please try again later", 1500);
        } else {
          showSnackBar(context, responseData[Common.responseKey], 1500);
        }
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
        print("shopByCategoriesApiError: $onError");
      });
    });
  }

  void getSliderImages() {
    getCarouselImagesApi().then((value) {
      setState(() {
        _isCarouselLoading = false;
        var responseData = jsonDecode(value.body);

        if (responseData[Common.successKey]) {
          carouselResponse.CarouselImagesResponse response =
              carouselResponse.CarouselImagesResponse.fromJson(
                  jsonDecode(value.body));
          listOfCarouselImages = response.response;
        } else if (value.statusCode >= 500 && value.statusCode <= 599) {
          showSnackBar(context, "Server error please try again later", 1500);
        } else {
          showSnackBar(context, responseData[Common.responseKey], 1500);
        }
      });
    }).catchError((onError) {
      setState(() {
        _isCarouselLoading = false;
        print("getCarouselImagesApiError: $onError");
      });
    });
  }

  void getTrendingProducts() {
    getPopularProductsApi().then((value) {
      try{
        setState(() {
          _isLoading = false;
          var responseData = jsonDecode(value.body);

          if (responseData[Common.successKey]) {
            Product.GetProductsByCategoryResponse response = Product.GetProductsByCategoryResponse.fromJson(jsonDecode(value.body));
            listOfPopularProducts = response.response;
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }catch(e){
        print(e);
      }
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
        print("getPopularProductsApiError: $onError");
      });
    });
  }

  Future<void> addProductToCart(Product.Response selectedProduct) async {
    setState(() {
      selectedProduct.hasInCart = true;
    });
    print("addProductToCartFromHomeScreen ${selectedProduct.productid + " selectedProductID"}");
    try {
      CartModel item = CartModel(selectedProduct.productid, 1,
          selectedProduct.rate, selectedProduct.name,selectedProduct.image);
      await CartDatabase.instance.create(item);
      getCartItems();
    } catch (error) {
      print("addProductToCartFromHomeScreenUI_Error $error");
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
}
