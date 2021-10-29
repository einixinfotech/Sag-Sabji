import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/user_profile_response.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_share/social_share.dart';

class ReferAndEarnUI extends StatefulWidget {
  const ReferAndEarnUI({Key? key}) : super(key: key);

  @override
  _ReferAndEarnUIState createState() => _ReferAndEarnUIState();
}

class _ReferAndEarnUIState extends State<ReferAndEarnUI> {
  bool _isLoading = false;
  late UserProfileResponse response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refer & Earn"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    Image.asset("assets/images/refer.png"),
                    SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Total Earned: ₹${response.response.points}",
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Good news! get instant credit of ₹50 as your friend's first order through your referral link",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Share your referral link using: ",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    SocialShare.shareWhatsapp("${response.response.refmsg}");
                                  },
                                  icon: Image.asset(
                                    "assets/images/whatsapp.png",
                                    width: 32,
                                    height: 32,
                                  )),
                              Text("WhatsApp", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 32,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    checkStoragePermission(1);
                                  },
                                  icon: Image.asset(
                                    "assets/images/facebook.png",
                                    width: 32,
                                    height: 32,
                                  )),
                              Text(
                                "Facebook",
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 28,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    checkStoragePermission(2);
                                  },
                                  icon: Image.asset(
                                    "assets/images/instagram.png",
                                    width: 32,
                                    height: 32,
                                  )),
                              Text(
                                "Instagram",
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 28,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    checkStoragePermission(3);
                                  },
                                  icon: Image.asset(
                                    "assets/images/more.png",
                                    width: 32,
                                    height: 32,
                                  )),
                              Text(
                                "More",
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() {
    setState(() {
      _isLoading = true;
    });
    Map<String, int> formData = {
      "userid": int.parse(Common.currentUser!.userid)
    };
    print(formData);

    getUserProfileApi(formData).then((value) {
      setState(() {
        _isLoading = false;
        var responseData = jsonDecode(value.body);

        if (responseData[Common.successKey]) {
          print(responseData[Common.successKey]);
          print(responseData[Common.responseKey]);
          response = UserProfileResponse.fromJson(jsonDecode(value.body));
        } else if (value.statusCode >= 500 && value.statusCode <= 599) {
          showSnackBar(context, "Server error please try again later", 1500);
        } else {
          showSnackBar(context, responseData[Common.responseKey], 1500);
        }
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
        print("getUserProfileApiError: $onError");
      });
    });
  }

/*Future<void> _onShare() async {
    await Share.share(response.response.refmsg + "${response.response.refercode}");
  }*/

  void _onShare(BuildContext context, File file, int i) async {
    final box = context.findRenderObject() as RenderBox?;
    if (i == 1) {
      print("sharetofacebook");
      SocialShare.shareFacebookStory(
          file.path, "#ffffff", "#000000", "https://deep-link-url",
          appId: "4222572564442546");
    } else if (i == 3) {
      await Share.shareFiles([file.path],
          text: "${response.response.refmsg}",
          subject: "Test subject",
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else if (i == 2) {}

    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
  }

  _shareImage(int i) async {
    try {
      final ByteData bytes = await rootBundle.load("assets/images/logo.png");
      final Uint8List list = bytes.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.jpg').create();
      file.writeAsBytesSync(list);
      _onShare(context, file, i);
    } catch (e) {
      print('Share error: $e');
    }
  }

/*  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path */ /*'assets/$path'*/ /*);

    final file = File('${(await getApplicationSupportDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }*/

  Future<void> checkStoragePermission(int i) async {
    if (await Permission.storage.request().isGranted) {
      if (i == 3) {
        _shareImage(i);
      } else if (i == 2) {
        _shareImage(2);
      } else if (i == 1) {
        _shareImage(1);
      }
    } else if (await Permission.storage.isPermanentlyDenied) {
      showSnackBarForPermissionError(true);
    } else {
      showSnackBarForPermissionError(false);
    }
  }

  void showSnackBarForPermissionError(bool isPermissionPermanentlyDenied) {
    final snackBar = SnackBar(
      content: Text(isPermissionPermanentlyDenied
          ? "Storage permission is permanently denied"
          : "Storage permission is required for sharing Logo"),
      action: SnackBarAction(
          label: isPermissionPermanentlyDenied ? "Open App Settings" : "Retry!",
          onPressed: () {
            if (isPermissionPermanentlyDenied) {
              openAppSettings();
            } else {
              checkStoragePermission(-1);
            }
          }),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
