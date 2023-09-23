import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/servis/sharedPrefsHelper.dart';
import 'package:b2b/view/anasayfa.dart';
import 'package:b2b/view/girisYap.dart';
import 'package:b2b/view/pdf.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; //IOS İÇİN


import '../main.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, super.key});

  final WebViewController controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  final Uri wp = Uri.parse("https://wa.me/${SiteSabit.whatsappTel}");

  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onNavigationRequest: (navigation) async {
            String url = Uri.parse(navigation.url).toString();

            if (url.toLowerCase().contains('mobilbarkod')) {
              var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ));
              var yeniUrl = Uri.parse(
                  "https://" + SiteSabit.Link! + "/arama/arama?q=" + res);
              widget.controller.loadRequest(yeniUrl);
              return NavigationDecision.prevent;
            } else if (url.toLowerCase().contains('login')) {
              await SharedPrefsHelper.clearUser();
              widget.controller.clearLocalStorage();

              var res = await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(title: '', viewDanMi: true),
                ),
                (route) => false,
              );

              return NavigationDecision.prevent;
            } else if (url.toLowerCase().contains('whatsapp')) {
              launchUrl(wp);

              return NavigationDecision.prevent;
            } else if (url.toLowerCase().contains('exportpdf') ) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDF(title: "PDF", url: url),
                  ));

              return NavigationDecision.prevent;
            }
            //ExportPdf
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          WebViewWidget(
            controller: widget.controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
