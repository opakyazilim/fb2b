import 'package:b2b/view/webviewStack.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; //IOS İÇİN

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key, required this.url});
  final Uri url;

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.url.toString()),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewStack(controller: controller),
    );
  }
}
