import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/helper/empty_screen.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/helper/page_transition_fade_animation.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/get_order_response.dart';
import 'package:saag_sabji/ui/order_details_ui.dart';

import 'container_ui.dart';

class OrdersUI extends StatefulWidget {
  const OrdersUI({Key? key}) : super(key: key);

  @override
  _OrdersUIState createState() => _OrdersUIState();
}

class _OrdersUIState extends State<OrdersUI> {
  bool _isLoading = true;
  List<Response> listOfOrders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FragmentContainer()));
                },
                child: Icon(Icons.arrow_back_rounded)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text("My Orders"),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : listOfOrders.isEmpty
              ? EmptyUI("You don't have any orders yet", "Shop Now")
              : ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: listOfOrders.length,
                  itemBuilder:
                      (BuildContext contextListViewBuilder, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: OrderDetailsUI(listOfOrders[index].id),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "ORDER ID : " +
                                            listOfOrders[index].orderid,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            letterSpacing: 0.3,
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    orderStatus(index),
                                  ],
                                ),
                                Text(
                                  listOfOrders[index].date,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      letterSpacing: 0.6,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w400),
                                ),
                                Divider(),
                                /* Text(
                                  listOfOrders[index].paymentstatus,
                                  style: Theme.of(context).textTheme.subtitle,
                                ),*/
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "₹ ${listOfOrders[index].total}",
                                  style: Theme.of(context).textTheme.title,
                                ),
                                Divider(),
                                Text(
                                  "Payment : " +
                                      listOfOrders[index].paymentstatus,
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                                Visibility(
                                  visible: false,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: TextButton(
                                        onPressed: () {
                                          showConfirmationDialog(
                                              listOfOrders[index]);
                                        },
                                        child: Text(
                                          "CANCEL",
                                          style: TextStyle(
                                              color: Color(0xffff0303)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserOrders();
  }

  void getUserOrders() {
    print(Common.currentUser!.userid.toString());
    Map<String, int> formData = {
      "userid": int.parse(Common.currentUser!.userid)
    };
    print(formData);

    getOrdersApi(formData).then((value) {
      setState(() {
        _isLoading = false;
        var responseData = jsonDecode(value.body);

        if (responseData[Common.successKey]) {
          GetOrdersResponse response =
              GetOrdersResponse.fromJson(jsonDecode(value.body));
          listOfOrders = response.response;
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
        print("getUserDetailsApiError: $onError");
      });
    });
  }

  Widget orderStatus(int index) {
    /*
      -1 = pending
      0 = Accepted
      1 = dispatched
      2 = delivered
      3 = canceled

     */
    if (int.parse(listOfOrders[index].status) == -1) {
      return Row(
        children: [
          Text(
            "Pending".toUpperCase(),
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                letterSpacing: 0.3,
                color: Color(0xff333333),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.watch_later_outlined,
            size: 15,
            color: Colors.orange,
          )
        ],
      );
    } else if (int.parse(listOfOrders[index].status) == 0) {
      return Row(
        children: [
          Text(
            "Accepted".toUpperCase(),
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                letterSpacing: 0.3,
                color: Color(0xff333333),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.check_circle_outline,
            size: 15,
            color: Colors.blue,
          )
        ],
      );
    } else if (int.parse(listOfOrders[index].status) == 1) {
      return Row(
        children: [
          Text(
            "Dispatched".toUpperCase(),
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                letterSpacing: 0.3,
                color: Color(0xff333333),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.directions_bike_outlined,
            size: 15,
            color: Colors.blue,
          )
        ],
      );
    } else if (int.parse(listOfOrders[index].status) == 2) {
      return Row(
        children: [
          Text(
            "Delivered".toUpperCase(),
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                letterSpacing: 0.3,
                color: Color(0xff333333),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.check_circle,
            size: 15,
            color: Colors.green,
          )
        ],
      );
    } else if (int.parse(listOfOrders[index].status) == 3) {
      return Row(
        children: [
          Text(
            "Canceled".toUpperCase(),
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                letterSpacing: 0.3,
                color: Colors.red,
                fontWeight: FontWeight.w600),
          ),
        ],
      );
    }
    return Container();
  }

  void showConfirmationDialog(Response selectedOrder) {
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
                    Text("You will need to place this order again if you need")
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
                  child: const Text('Confirm cancel order',
                      style: TextStyle(color: Color(0xffff0303))),
                  onPressed: () {
                    cancelOrder(selectedOrder);
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

  void cancelOrder(Response selectedOrder) {
    setState(() {
      _isLoading = true;
      Map<String, String> formData = {"orderid": selectedOrder.orderid};
      cancelOrderApi(formData).then((value) {
        setState(() {
          _isLoading = false;
          var responseData = jsonDecode(value.body);
          if (responseData['success']) {
            showSnackBar(context, responseData['response'], 1500);
            listOfOrders.clear();
            getUserOrders();
          } else {
            getUserOrders();
            showSnackBar(context, responseData['response'], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
          getUserOrders();
          print("cancelOrderApiError: $onError");
        });
      });
    });
  }
}
