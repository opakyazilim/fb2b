import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class PDF extends StatefulWidget {
  PDF({Key? key, required this.title, required this.url}) : super(key: key);

  final String title;
  final String url;

  @override
  _PDFState createState() => _PDFState();
}

class _PDFState extends State<PDF> {
  String urlPDFPath = "";
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController? _pdfViewController;
  bool loaded = false;

  Future<File> getFileFromUrl(String url, {String? name}) async {
    var fileName = 'B2B';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      await file.writeAsBytes(bytes, flush: true);
      return file;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  void requestPermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Storage permission granted
    } else {
      // Storage permission denied
    }
  }

  void sharePDF(String pdfPath) {
    Share.shareFiles([pdfPath], text: 'Paylaşmak için PDF dosyası:');
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    getFileFromUrl(widget.url).then(
      (value) {
        setState(() {
          if (value != null) {
            urlPDFPath = value.path;
            loaded = true;
            exists = true;
          } else {
            exists = false;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
  
    if (loaded) {
      return Scaffold(
        appBar: AppBar(
            title: Text("Rapor"),
            backgroundColor: Color.fromARGB(255, 30, 38, 45),
            actions: []),
        body: PDFView(
          filePath: urlPDFPath,
          autoSpacing: true,
          enableSwipe: true,
          //    pageSnap: true, // ios da destek yok!
          swipeHorizontal: true,
          onError: (e) {
          
          },
          onRender: (_pages) {
            setState(() {
              _totalPages = _pages!;
              pdfReady = true;
            });
          },
          onViewCreated: (PDFViewController vc) {
            setState(() {
              _pdfViewController = vc;
            });
          },
          onPageChanged: (int? page, int? total) {
            setState(() {
              if (page != null) {
                _currentPage = page;
              }
            });
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * .05),
              child: IconButton(
                  onPressed: () {
                    sharePDF(urlPDFPath);
                  },
                  icon: Icon(
                    Icons.share,
                    color: Colors.green,
                    size: 30,
                  )),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.chevron_left),
              iconSize: 50,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (_currentPage > 0) {
                    _currentPage--;
                    _pdfViewController?.setPage(_currentPage);
                  }
                });
              },
            ),
            Text(
              "${_currentPage + 1}/$_totalPages",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              iconSize: 50,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (_currentPage < _totalPages - 1) {
                    _currentPage++;
                    _pdfViewController?.setPage(_currentPage);
                  }
                });
              },
            ),
          ],
        ),
      );
    } else {
      if (exists) {
       
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
  
        return Scaffold(
          appBar: AppBar(
            title: Text("Rapor"),
          ),
          body: Text(
            "PDF Açılamadı",
            style: TextStyle(fontSize: 20),
          ),
        );
      }
    }
  }
}
