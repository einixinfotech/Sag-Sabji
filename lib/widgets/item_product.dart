import 'package:flutter/material.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/db/cart_database.dart';
import 'package:saag_sabji/helper/page_transition_fade_animation.dart';
import 'package:saag_sabji/models/cart.dart';
import 'package:saag_sabji/response/get_products_by_category_response.dart';
import 'package:saag_sabji/ui/view_product_details.dart';
import 'package:saag_sabji/response/get_products_by_category_response.dart'
as Product;


class ItemProduct extends StatefulWidget {
  final int index;
  final Varient varient;
  final Product.Response listOfProductsInTheSelectedCategory;
  const ItemProduct({required this.index, required this.varient, required this.listOfProductsInTheSelectedCategory});

  @override
  _ItemProductState createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {

  late Varient selectedVarient;
  int variantIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedVarient = widget.varient;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          FadeRoute(
            page: ViewProductDetails(widget.listOfProductsInTheSelectedCategory),
          ),
        );
      },
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
                    width: MediaQuery.of(context).size.width,
                    child: widget.listOfProductsInTheSelectedCategory.varient?[variantIndex].image ==
                        "http://sagsabji.einixworld.online/storage/product/"
                        ? ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      child: Image.asset(
                        "assets/images/logo_copy.png",
                        fit: BoxFit.fill,
                      ),
                    )
                        : ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        child: FadeInImage.assetNetwork(
                          image: widget.listOfProductsInTheSelectedCategory
                          .varient?[variantIndex].image??"",
                          fit: BoxFit.contain,
                          placeholder:
                          "assets/images/logo_copy.png",
                        ))),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Text(
                    widget.listOfProductsInTheSelectedCategory.varient?[variantIndex].name??"",
                    maxLines: 1,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      "₹${widget.listOfProductsInTheSelectedCategory.varient?[variantIndex].mrp == widget.listOfProductsInTheSelectedCategory.varient?[variantIndex].rate ? widget.listOfProductsInTheSelectedCategory.varient![variantIndex].rate : widget.listOfProductsInTheSelectedCategory.varient?[variantIndex].mrp}",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          letterSpacing: 0.3,
                          color: Colors.green,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                (widget.listOfProductsInTheSelectedCategory.varient?.length??0) > 1 ?
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1,color: Colors.black38),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.only(left: 8),
                  margin: const EdgeInsets.only(top: 0, left: 4, right: 4.0),
                  child: DropdownButton<Varient>(
                    style: TextStyle(fontSize: 12,color: Colors.black),
                      value: selectedVarient,
                      underline: Container(),
                      isExpanded: true,
                      isDense: true,
                      onChanged: (val){
                        // selectedCity = CityData();
                        // selectedCity?.id = val?.id??0;
                        setState(() {
                          variantIndex = widget.listOfProductsInTheSelectedCategory.varient?.indexOf(val!)??0;
                          selectedVarient = val!;
                        });
                        // getSimilarProducts(selectedVarient?.id.toString()??"");
                        // getProductDetails(selectedVarient?.id.toString()??"");
                      },
                      hint: Text("Varients"),
                      items: widget.listOfProductsInTheSelectedCategory.varient!.map((e) {
                        return DropdownMenuItem(child: Text(e.name??''),value: e);
                      }).toList()
                  ),
                ):Container(height: 25,),
                SizedBox(height: 4),
                ValueListenableBuilder(
                  valueListenable: Common.cartItems,
                  builder: (BuildContext context, value,
                      dynamic child) {
                    return addOrChangeQuantity(
                        widget.listOfProductsInTheSelectedCategory.varient![variantIndex],widget.index,
                        Common.cartItems.value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget addOrChangeQuantity(
      Varient item, int index, List<CartModel> value) {
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
      Varient item) async {
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
}
