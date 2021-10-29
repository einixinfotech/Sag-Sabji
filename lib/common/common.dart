import 'package:flutter/material.dart';
import 'package:saag_sabji/models/cart.dart';
import 'package:saag_sabji/response/login_user_response.dart';

class Common {
  static final String selectedCategory = "3";
  static final String cashback = "cashback";
  static final String discount = "discount";
  static final String orderIdForDetails = "1149";
  static final String referralCode = "SS0000";

  /*static final int userId = 1175;*/
  static final String imagePath = "assets/images/";
  static final String successKey = "success";
  static final String responseKey = "response";
  static final String isLoggedInKey = "isLoggedIn";
  static final String emailKey = "email";
  static final String passwordKey = "password";
  static final String mobileKey = "mobile";
  static Map<String, String> formData = {};
  static String emailAddress = "";
  static String mobile = "";
  static String password = "";

  static ValueNotifier<List<CartModel>> cartItems = ValueNotifier<List<CartModel>>([]);

  static LoginUserResponse? currentUser

      /* = LoginUserResponse(
      success: false,
      error: false,
      userid: "",
      mobile: "",
      ismember: "",
      status: "status",
      response: "")*/
      ;

  static bool isSignedIn = false;

  static Map<String, dynamic> placeOrderData = {};

  static String selectedAddressId = "";
}
