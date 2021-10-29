import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String manageAddress = "Manage Address";
const String offers = "Offers";
const String payModes = "Payment Modes";
const String Help = "Help";
const String logout = "Logout";

const String delMan = "delivery_man_bike.json";
const String reviewAnim = "review_animation.json";

const String likeMost = "Tell us what you liked most...";
const String submitFb = "submit your feedback";

const String rateDelivery = "Rate your Delivery";

const String saveAddress = "Saved Addresses";
const String address = "JPTL City, Mohali, Sector-115";

const String setLocation = "set location";

const String villageMsg =
    "When you eat food with your family and friends, it always tastes better!";
const String twoMsg = "Everything tastes good when you're hungry";
const String threeMsg =
    "The most essential part of a well-balanced diet is—food";

const String haveAnAccount = "Have an account? ";
const String enterMobileNo = "Enter your phone number to proceed";
const String category = "Eat what makes you happy";
const String restaurants = "18 restaurants around you";
const String search = "Search for restaurants and food";

const String catDesc =
    "From Cheesy delights to drool-worthy toppings, choose from a range of pizzas from around you.";
const String nearByRest = "8 Restaurants nearby you";
const String cusReq =
    "Any restaurant request? We will try our best to convey it";
const String avlCoupon = "available coupon";
const String enterCoupon = "Enter Coupon Code";
const String delivered = "Order delivered on February 21, 9:23 PM by Vaibhav";
const String billDetail = "bill details";
const String userName = "Vaibhav Pandey";
const String userContact = "94534526421 • abc@gmail.com";

const String showResBy = "show restaurant by";

const String editAccount = "Edit Account";
const String phoneNo = "Phone number";
const String emailAddr = "Email Address";

const String pickupBy = "Vikas Kumar picked your order";
const String trackOrder = "Track your order";
const String orderPickup = "Order PickedUp";
const String card = "Credit, Debit & ATM Cards";
const String paytm = "Paytm UPI";
const String gpay = "Google Pay";
const String rel = "Relevance";
const String costForTwo = "Cost For Two";
const String deliveryTime = "Delivery Time";
const String rating = "Rating";
const String confirmNdPay = "Confirm Order and Pay";

const String restaurantName = "Savera Restaurant";
const String restaurantLocation = "City, Ambala";
const String dishes = "Paneer Butter Masala x 1, Butter Missi Roti x 12";
const String deliveryDate = "Feb 21, 08:45 PM";
const String getDiscount = "Get 15% discount using HSBC Credit Cards";
const String discountMsg =
    "Use Code COMIDA50 & get 20% discount up to INR 100/- on orders above INR 600/-";

const String rentalImg = "assets/images/rental.jpg";
const String pgImg = "assets/images/pg.jpg";
const String flatImg = "assets/images/flat.jpg";

const Color accentColor = Color(0xff237f52);
const Color primaryColor = Color(0xffFFF3E0);
const Color buttonColor = Color(0xff4C3349);
const Color midNightColor = Color(0xff2c3e50);

const TextStyle appbar = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18,
    letterSpacing: 0.6,
    color: Colors.black87,
    fontWeight: FontWeight.w700);

const TextStyle titleTxt = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    letterSpacing: 0.6,
    color: Color(0xff3c3c3c),
    fontWeight: FontWeight.w400);
const TextStyle titleBold = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    letterSpacing: 0.6,
    color: Color(0xff3c3c3c),
    fontWeight: FontWeight.w600);

const TextStyle boldTitleTxt = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    letterSpacing: 0.6,
    color: Color(0xff3a3a3a),
    fontWeight: FontWeight.w600);

const TextStyle subtitleTxt = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 13,
    letterSpacing: 0.6,
    color: Colors.grey,
    fontWeight: FontWeight.w400);

const TextStyle buttonTxt = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    letterSpacing: 0.6,
    wordSpacing: 1.5,
    color: Colors.white,
    fontWeight: FontWeight.w600);

const TextStyle txtButton = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    letterSpacing: 0.6,
    color: accentColor,
    fontWeight: FontWeight.w500);

final BoxDecoration cornRadius =
    BoxDecoration(borderRadius: allRadius, color: Colors.grey);

final BoxDecoration topCornerRadius = BoxDecoration(
  borderRadius: topRadius,
  image: DecorationImage(
      image: NetworkImage(
          "https://cdn.wallpaper.com/main/styles/fp_922x565/s3/galleries/15/12/131028_p103_035.jpg"),
      fit: BoxFit.cover),
);
final BorderRadius allRadius = BorderRadius.circular(8);
final BorderRadius topRadius = BorderRadius.only(
    topLeft: Radius.circular(8), topRight: Radius.circular(8));

const TextStyle extraBoldTitleTxt = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 17,
    letterSpacing: 0.6,
    color: Color(0xff333333),
    fontWeight: FontWeight.w700);

Widget veg() {
  return Container(
    height: 15,
    width: 15,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(width: 1, color: Colors.green)),
    alignment: Alignment.center,
    child: Icon(Icons.brightness_1, size: 9, color: Colors.green),
  );
}

const kTileHeight = 50.0;

ButtonStyle addTextButton = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  ),
);

ButtonStyle accentButton = ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) return accentColor;
      return accentColor; // Use the component's default.
    },
  ),
);

ButtonStyle outLineBtn = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(side: BorderSide(width: 0.5, color: accentColor)),
  ),
);

ButtonStyle rateOrderBtn = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      side: BorderSide(
        width: 1,
        color: Colors.grey,
      ),
    ),
  ),
);

ButtonStyle offerButton = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
  ),
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) return Colors.indigoAccent;
      return Colors.indigoAccent; // Use the component's default.
    },
  ),
);

ButtonStyle addToCartButton = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: allRadius,
    ),
  ),
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) return accentColor;
      return accentColor; // Use the component's default.
    },
  ),
);

ButtonStyle menuButton = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) return Colors.grey;
      return Colors.grey; // Use the component's default.
    },
  ),
);

/*ButtonStyle addButton = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  ),
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) return Colors.grey;
      return null; // Use the component's default.
    },
  ),
);*/

ButtonStyle eleButton = ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) return accentColor;
      return accentColor; // Use the component's default.
    },
  ),
);

/*
ButtonStyle enDsBtnStyle(bool isEnable){
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) return isEnable ? accentColor : Colors.red[100];
        return isEnable ? accentColor : Colors.red[100]; // Use the component's default.
      },
    ),
  );
}*/
