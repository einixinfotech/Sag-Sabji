import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saag_sabji/ui/container_ui.dart';

class PurchasedOrderDetailsScreen extends StatefulWidget {
  final String itemTotal,deliveryCharges,orderId;
  const PurchasedOrderDetailsScreen({Key? key, this.itemTotal="", this.deliveryCharges="", this.orderId=""}) : super(key: key);

  @override
  _PurchasedOrderDetailsScreenState createState() => _PurchasedOrderDetailsScreenState();
}

class _PurchasedOrderDetailsScreenState extends State<PurchasedOrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summary"),
      ),
      bottomNavigationBar: ElevatedButton(style: ElevatedButton.styleFrom(
        fixedSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),onPressed: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>FragmentContainer()), (route) => false);
      }, child: Text("Continue Shopping")),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey,width: 1),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: Icon(Icons.check_rounded,color: Colors.white,size: 50,),
              ),
              Text("Order Placed Successfully",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
              Divider(color: Colors.grey.shade800,thickness: 1),
              SizedBox(height: 20),
              tiles("Order ID: ",widget.orderId),
              Divider(color: Colors.grey.shade800,thickness: 1),
              SizedBox(height: 10),
              tiles("Delivery Charges: ",widget.deliveryCharges),
              Divider(color: Colors.grey.shade800,thickness: 1),
              SizedBox(height: 10),
              tiles("Item Total : ",widget.itemTotal),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
  Widget tiles(String title,String subTitle){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,style: TextStyle(fontWeight: FontWeight.bold)),
        Text("₹"+subTitle),
      ],
    );
  }
}
