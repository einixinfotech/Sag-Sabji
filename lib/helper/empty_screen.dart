import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:saag_sabji/helper/strings.dart';
import 'package:saag_sabji/ui/add_address_ui.dart';
import 'package:saag_sabji/ui/container_ui.dart';

class EmptyUI extends StatefulWidget {
  final String emptyMsg, buttonText;

  EmptyUI(this.emptyMsg, this.buttonText);

  @override
  _EmptyUIState createState() => _EmptyUIState();
}

class _EmptyUIState extends State<EmptyUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset(Strings.emptyAnim, repeat: false),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              widget.emptyMsg,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800]),
            ),
            SizedBox(
              height: 40,
            ),
            widget.buttonText.contains("Add address")
                ? Text("")
                : Container(
                    height: 40,
                    width: 200,
                    child: RaisedButton(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        textColor: Colors.white,
                        onPressed: () {
                          print("LOLOL");
                          print(widget.buttonText);
                          if (widget.buttonText.contains("Shop Now")) {
                            print("KKK");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FragmentContainer()),
                                (route) => false);
                            /*   Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FragmentContainer()));*/
                          } else if (widget.buttonText
                              .contains("Add address")) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddAddressUI()));
                          }
                        },
                        child: Text(
                          widget.buttonText.toUpperCase(),
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w500),
                        )),
                  )
          ],
        ),
      ),
    );
  }
}
