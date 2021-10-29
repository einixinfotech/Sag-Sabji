import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/order_details_response.dart';

class OrderDetailsUI extends StatefulWidget {
  String orderId;

  OrderDetailsUI(this.orderId);

  @override
  _OrderDetailsUIState createState() => _OrderDetailsUIState();
}

class _OrderDetailsUIState extends State<OrderDetailsUI> {
  List<Response> listOfItemsInTheOrder = [];
  OrderDetailsResponse response = OrderDetailsResponse();
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of order ID: ${widget.orderId}"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10),
                      physics: BouncingScrollPhysics(),
                      itemCount: listOfItemsInTheOrder.length,
                      itemBuilder:
                          (BuildContext contextListViewBuilder, int index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Product Name",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700)),
                                      SizedBox(height: 5),
                                      Text(listOfItemsInTheOrder[index].name,style: TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Rate",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700)),
                                    SizedBox(height: 5),
                                    Text(listOfItemsInTheOrder[index].rate.toString(),style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                SizedBox(width: 40),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Quantity",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700)),
                                    SizedBox(height: 5),
                                    Text(listOfItemsInTheOrder[index].quantity,style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                SizedBox(width: 40),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Total",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700)),
                                    SizedBox(height: 5),
                                    Text(listOfItemsInTheOrder[index].totalrate.toString(),style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                            Divider(color: Colors.grey,thickness: 1,)
                          ],
                        );
                      }),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 3.0,
                            offset: Offset(0, 0),
                            spreadRadius: 3.0,
                          ),
                        ]
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Item Total"),
                            Text("₹"+response.subtotal.toString()),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Delivery Charges"),
                            Text("₹"+response.dlcharge.toString()),
                          ],
                        ),
                        Divider(color: Colors.grey.shade800),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Amount Payable"),
                            Text("₹"+response.total.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
    );
  }

  @override
  void initState() {
    super.initState();

    getOrderDetails();
  }

  void getOrderDetails() {
    print(Common.orderIdForDetails.toString());
    Map<String, int> formData = {
      "orderid": int.parse(widget.orderId)
    };
    print(formData);

    setState(() {
      _isLoading = true;
      getOrderDetailsApi(formData).then((value) {
        setState(() {
          _isLoading = false;
          var responseData = jsonDecode(value.body);
          if (responseData[Common.successKey]) {
            response = OrderDetailsResponse.fromJson(jsonDecode(value.body));
            listOfItemsInTheOrder = response.response!;
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
          print("getOrderDetailsAPI: $onError");
        });
      });
    });
  }
}
