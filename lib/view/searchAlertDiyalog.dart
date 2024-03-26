import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchAlertDialog extends StatefulWidget {
  const SearchAlertDialog({super.key, required this.controller});
  final WebViewController controller;

  @override
  State<SearchAlertDialog> createState() => _SearchAlertDialogState();
}

class _SearchAlertDialogState extends State<SearchAlertDialog> {
  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
  backgroundColor: Colors.transparent,
  insetPadding: EdgeInsets.all(0),
  child: OrientationBuilder(
    
    builder: (context, orientation) {
      return Stack(
        children: [
          SizedBox(
                   height: orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.3
                  : MediaQuery.of(context).size.width * 0.2,
                   width: orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width * 0.8
                  : MediaQuery.of(context).size.height,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.width * 0.8
                    : MediaQuery.of(context).size.height * 0.8,
                height: orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height * 0.22
                    : MediaQuery.of(context).size.width * 0.6,
                alignment: Alignment.topRight,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Color(0xFFBBDCDF), Color(0xFFCAE4C3)],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Ctanim.translate("ŞİMDİ ARA"),
                        style: TextStyle(
                          fontSize: orientation == Orientation.portrait
                              ? MediaQuery.of(context).size.width * .04
                              : MediaQuery.of(context).size.height * .04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.01 : MediaQuery.of(context).size.width * 0.01),
                    Text(
                      Ctanim.translate("Dilersenin aşağıdaki arama alanını kullanarak ürün, kategori veya marka arayabilirsiniz. Ya da yandaki simge yardımı ile barkod okutabilirsiniz."),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.width * .02
                            : MediaQuery.of(context).size.height * .02,
                      ),
                    ),
                    SizedBox(height: orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.01 : MediaQuery.of(context).size.width * 0.01),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            height: orientation == Orientation.portrait
                                ? MediaQuery.of(context).size.height * 0.065
                                : MediaQuery.of(context).size.width * 0.065,
                            child: TextFormField(
                              controller: _textController,
                              autofocus: true,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                hintText: Ctanim.translate("Ürün, kategori veya marka arayın"),
                                hintStyle: TextStyle(
                                  fontSize: orientation == Orientation.portrait
                                      ? MediaQuery.of(context).size.width * .025
                                      : MediaQuery.of(context).size.height * .025,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: orientation == Orientation.portrait
                                    ? MediaQuery.of(context).size.width * .03
                                    : MediaQuery.of(context).size.height * .03,
                              ),
                            ),
                          ),
                        ),
                        Container(
                           height: orientation == Orientation.portrait
                                ? MediaQuery.of(context).size.height * 0.065
                                : MediaQuery.of(context).size.width * 0.065,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            onPressed: () {
                              var yeniUrl = Uri.parse("https://" + SiteSabit.Link! + "/arama/arama?q=" + _textController.text);
                              widget.controller.loadRequest(yeniUrl);
                              Navigator.pop(context);
                            },
                            child: Text(
                              Ctanim.translate("ARA"),
                              style: TextStyle(fontSize: orientation == Orientation.portrait
                                  ? MediaQuery.of(context).size.width * .03
                                  : MediaQuery.of(context).size.height * .03,)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.17 : MediaQuery.of(context).size.width * 0.05,
            left: orientation == Orientation.portrait ? MediaQuery.of(context).size.width * .3 : -MediaQuery.of(context).size.height * .01,
            child: Container(
              width: orientation == Orientation.portrait ? MediaQuery.of(context).size.width * .175 : MediaQuery.of(context).size.height * .175,
              height: orientation == Orientation.portrait ? MediaQuery.of(context).size.width * .175 : MediaQuery.of(context).size.height * .175,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 1.0,)
                ,borderRadius: BorderRadius.circular(100.0),
                color: Colors.white
                /*
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Color(0xFFBBDCDF), Color(0xFFCAE4C3)],
                  ),
                  */
               
              ),
              child: IconButton(
                icon: Lottie.asset("assets/barcod3.json"),
                color: Colors.white,
                iconSize: orientation == Orientation.portrait ? MediaQuery.of(context).size.width * .1 : MediaQuery.of(context).size.height * .1,
                onPressed: () async {
                  var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ),
                  );

                  var yeniUrl = Uri.parse("https://" + SiteSabit.Link! + "/arama/arama?q=" + res);
                  widget.controller.loadRequest(yeniUrl);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Positioned(
            top: orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.001 : MediaQuery.of(context).size.width * 0.001,
            left: orientation == Orientation.portrait ? MediaQuery.of(context).size.width * .85 : MediaQuery.of(context).size.height * .85,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: orientation == Orientation.portrait ? MediaQuery.of(context).size.width * .05 : MediaQuery.of(context).size.height * .05,
                height: orientation == Orientation.portrait ? MediaQuery.of(context).size.width * .05 : MediaQuery.of(context).size.height * .05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Center(
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: orientation == Orientation.portrait ? MediaQuery.of(context).size.width * .03 : MediaQuery.of(context).size.height * .03,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  ),
);
}
}
