import 'dart:convert';

import 'package:http/http.dart' as http;

String url = "sagsabji.einixworld.online";

Future<http.Response> getCategoriesApi(Map<String, String> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/apiCategories.php"), body: formData);
  return response;
}

Future<http.Response> getFirmDetailsApi() async {
  final response = await http.post(Uri.http(url, "/adminapi/apiGetFirmDetail.php"));
  return response;
}

Future<http.Response> getProductsForSelectedCategoryApi(
    Map<String, String> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/apiCategoryProduct.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> getSimilarProductsApi(
    Map<String, String> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/apiSimilarProduct.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> getUserProfileApi(Map<String, int> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/apiUserInfo.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> updateUserProfileApi(
    Map<String, dynamic> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/apiUpdateUser.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> getOrdersApi(Map<String, dynamic> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/apiOrders.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> getOrderDetailsApi(Map<String, dynamic> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/apiOrderDetails.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> verifyReferralCodeApi(
    Map<String, dynamic> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/apiVerifySponsar.php"), body: formData);
  return response;
}

Future<http.Response> sendOTPApi(Map<String, dynamic> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/apiSendOtp.php"), body: formData);
  return response;
}

Future<http.Response> registerUserApi(Map<String, dynamic> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/apiRegisterUser.php"), body: formData);
  return response;
}

Future<http.Response> loginUserApi(Map<String, String> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/apiVerifyOtp.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> updateProfileApi(Map<String, String> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/apiUpdateUser.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> verifyOTPForgotPasswordApi(
    Map<String, String> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/apiSendPwd.php"), body: formData);
  return response;
}

Future<http.Response> updateOrderStatusApi(
    Map<String, dynamic> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/apiUpdatePayment.php"), body: formData);
  return response;
}

Future<http.Response> getSavedAddressApi(Map<String, String> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/apiCustomerAddress.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> addAddressApi(Map<String, String> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/apiAddCustomerAddress.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> getCarouselImagesApi() async {
  final response = await http.post(Uri.http(url, "/adminapi/apiGallery.php"));
  return response;
}

Future<http.Response> getPopularProductsApi() async {
  final response = await http.get(Uri.http(url, "/adminapi/apiLastProduct.php"));
  return response;
}

Future<http.Response>  searchProductsApi(Map<String, String> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/apiSearchProduct.php"), body: formData);
  return response;
}

Future<http.Response> sendEnquiryApi(Map<String, String> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/apiSendEnquiry.php"), body: formData);
  return response;
}

Future<http.Response> deleteAddressApi(Map<String, String> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/apiDeleteAddress.php"), body: formData);
  return response;
}

Future<http.Response> cancelOrderApi(Map<String, String> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/apiCancelOrder.php"), body: formData);
  return response;
}

Future<http.Response> deleteOrderApi(Map<String, String> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/apiDeletOrder.php"), body: formData);
  return response;
}

Future<http.Response> getDeliveryChargesApi(
    Map<String, dynamic> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/apiUpdateCartPrice.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> placeCashOnDeliveryOrderApi(
    Map<String, dynamic> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/apiCheckout.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> fetchWalletBalanceApi(
    Map<String, String> formData) async {
  final response = await http.post(Uri.http(url, "/adminapi/fetch_wallet_balance.php"),
      body: formData);
  return response;
}

Future<http.Response> fetchTransactionHistoryApi(
    Map<String, String> formData) async {
  final response = await http
      .post(Uri.http(url, "/adminapi/fetch_transaction_history.php"), body: formData);
  return response;
}

Future<http.Response> fetchPromoCodesApi(Map<String, String> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/fetchPromoCodes.php"), body: formData);
  return response;
}

Future<http.Response> addMoneyToWalletCreateOrderApi(
    Map<String, String> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/createOrderApi.php"), body: formData);
  return response;
}

Future<http.Response> addMoneyToWalletUpdatePaymentStatusApi(
    Map<String, String> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/updatepaymentstatus.php"), body: formData);
  return response;
}

Future<http.Response> applyPromoCodeApi(Map<String, String> formData) async {
  final response =
      await http.post(Uri.http(url, "/adminapi/apiCheckPromoCode.php"), body: formData);
  return response;
}
