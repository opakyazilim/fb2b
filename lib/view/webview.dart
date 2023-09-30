import 'package:b2b/view/webviewStack.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

//import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; //IOS İÇİN

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key, required this.url});
  final Uri url;
  

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}
 WebViewController? controller;
Future<bool> _exitApp(BuildContext context) async {
  if (await controller!.canGoBack()) {
    print("onwill goback");
    controller!.goBack();
  } else {
    
    
    return Future.value(false);
  }
  return Future.value(false);
}


class _WebViewAppState extends State<WebViewApp> {
  
  

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

    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        
        
        body: WebViewStack(controller: controller!),
      ),
    );
  }
}


 
  /*
              if (await controller.canGoBack()) {
       
        print("web geri");
        controller.goBack();
        return false;
        
      } else {
        print("uygulama geri");
        Navigator.canPop(context);
        return true;
        
      }
      */