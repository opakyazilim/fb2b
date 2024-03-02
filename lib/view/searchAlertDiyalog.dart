import 'package:b2b/const/siteSabit.dart';
import 'package:flutter/material.dart';
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
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.8,
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
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.04),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "ŞİMDİ ARAYIN",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * .04,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        top: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: Text(
                        "Dilersenin aşağıdaki arama alanını kullanarak ürün, kategori veya marka arayabilirsiniz. Ya da yandaki simge yardımı ile barkod okutabilirsiniz.",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * .02,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        top: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.065,
                            child: TextFormField(
                              controller: _textController,
                              autofocus: true,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                hintText: "Ürün, kategori veya marka arayın",
                                hintStyle: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * .025,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * .03,
                              ),
                            ),
                          ),
                          Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  onPressed: () {
                                    var yeniUrl = Uri.parse("https://" +
                                        SiteSabit.Link! +
                                        "/arama/arama?q=" +
                                        _textController.text);
                                    widget.controller.loadRequest(yeniUrl);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "ARA",
                                    style: TextStyle(fontSize: 12),
                                  )))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * .008,
            child: Container(
              width: MediaQuery.of(context).size.width * .15,
              height: MediaQuery.of(context).size.width * .15,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple], // İstenilen renkler
                ), // Koyu turuncu arka plan rengi
                // Altıgen şekil
                borderRadius: BorderRadius.circular(100.0), // Köşe yuvarlama
              ),
              child: IconButton(
                icon:  Image.asset("assets/barcode.png"),
                color: Colors.white,
                iconSize: MediaQuery.of(context).size.width * .1,
                onPressed: () async {
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(),
                      ));

                  var yeniUrl = Uri.parse(
                      "https://" + SiteSabit.Link! + "/arama/arama?q=" + res);
                  widget.controller.loadRequest(yeniUrl);
                  Navigator.pop(context);
                },
              ),

              //Image.asset("assets/arama.gif",),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.001,
            left: MediaQuery.of(context).size.width * .85,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .05,
                height: MediaQuery.of(context).size.width * .05,
                decoration: BoxDecoration(
                  color: Colors.white,
            
                  borderRadius: BorderRadius.circular(100.0), // Köşe yuvarlama
                ),
                child: Center(
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: MediaQuery.of(context).size.width * .03,
                  ),
                ),
            
                //Image.asset("assets/arama.gif",),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
