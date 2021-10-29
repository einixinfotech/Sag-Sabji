import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saag_sabji/common/common.dart';
import 'package:saag_sabji/helper/helpers.dart';
import 'package:saag_sabji/network/api.dart';
import 'package:saag_sabji/response/get_firm_details_response.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUsUi extends StatefulWidget {
  const AboutUsUi({Key? key}) : super(key: key);

  @override
  _AboutUsUiState createState() => _AboutUsUiState();
}

class _AboutUsUiState extends State<AboutUsUi> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String url = ""; // https://saagsabjiindia.com/contact
  bool isInProgress = true, isHalfLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: url == ""
          ? Center(child: CircularProgressIndicator())
          : WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                setState(() {
                  isInProgress = true;
                });
                // showSnackBar(context, "Please wait... (progress : $progress%)", 3000);
                print("WebView is loading (progress : $progress%)");
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                setState(() {
                  isHalfLoaded = true;
                });
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                setState(() {
                  isInProgress = false;
                });
                print('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
            ),
      bottomNavigationBar: Visibility(
          visible: isInProgress,
          child: LinearProgressIndicator(
            backgroundColor: isHalfLoaded ? Colors.yellow : Colors.transparent,
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _getFirmDetails();
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  void _getFirmDetails() {
    getFirmDetailsApi().then((value) {
      var responseData = jsonDecode(value.body);
      setState(() {
        if (responseData[Common.successKey]) {
          FirmDetailsResponse response =
              FirmDetailsResponse.fromJson(jsonDecode(value.body));
          url = response.response.url;
        } else if (value.statusCode >= 500 && value.statusCode <= 599) {
          showSnackBar(context, "Server error please try again later", 1500);
        } else {
          showSnackBar(context, responseData[Common.responseKey], 1500);
        }
      });
    }).catchError((onError) {
      print("getFirmDetailsApiError: $onError");
    });
  }
}
