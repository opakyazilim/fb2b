import 'dart:async';
import 'dart:math';

import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/servis/servis.dart';
import 'package:b2b/servis/sharedPrefsHelper.dart';
import 'package:b2b/view/altKullaniciList.dart';
import 'package:b2b/view/cariRehberList.dart';
import 'package:b2b/view/drawer.dart';
import 'package:b2b/view/pdf.dart';
import 'package:b2b/view/searchAlertDiyalog.dart';
import 'package:b2b/view/webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'dart:io';

//import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; //IOS İÇİN

import '../main.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, super.key});

  final WebViewController controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  Servis servis = Servis();
  int selected = 1;
  var heart = false;
  PageController controller = PageController();
  Future<bool> iosLocationPerm() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      //await Geolocator.openAppSettings(); //! Lokasyon ayarlarına yönlendirme
      return false;
    } else if (permission == LocationPermission.denied) {
      return false;
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(milliseconds: 100), () {
      completer.complete();
    });

    return completer.future.then<void>((_) {
      widget.controller.loadRequest(Uri.https(SiteSabit.Link!));
    });
  }

  Future<List<double>> getLocationIos() async {
    final value = await iosLocationPerm();
    if (value) {
      final currentLocation = await Geolocator.getCurrentPosition();
      lat = currentLocation.latitude;
      long = currentLocation.longitude;
      acc = currentLocation.accuracy;
      return [lat!, long!, acc!];
    } else {
      print("gönderilmedi");
      return [32, 32, 10];
    }
  }

  Future<void> checkLocationPermission() async {
    loc.PermissionStatus permissionStatus;

    try {
      permissionStatus = await loc.Location().hasPermission();
    } catch (e) {
      permissionStatus = loc.PermissionStatus.denied;
    }

    if (permissionStatus == loc.PermissionStatus.denied) {
      permissionStatus = await loc.Location().requestPermission();
      if (permissionStatus != loc.PermissionStatus.granted) {
        //izin vermedi
      }
    }
  }

  loc.LocationData? currentLocation;
  double? lat;
  double? long;
  double? acc;

  Future<void> getCurrentLocation() async {
    try {
      loc.Location location = loc.Location();
      currentLocation = await location.getLocation();
      long = currentLocation?.longitude;
      lat = currentLocation?.latitude;
      acc = currentLocation?.accuracy;
    } catch (e) {
      print("Konum bilgisi alınamadı: $e");
    }
  }

  Future<void> yanMenuGetir() async {
    await servis.getYanMenu(
        cariGuid: Ctanim.cari!.guid!,
        plasiyerGuid: Ctanim.PlasiyerGuid == null || Ctanim.PlasiyerGuid == ""
            ? ""
            : Ctanim.PlasiyerGuid!);
  }

  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    yanMenuGetir();
    widget.controller
      ..addJavaScriptChannel(
        "MobilMesaj",
        onMessageReceived: (p0) async {
          if (p0.message == "MiniSepetGetir") {
            await servis.getSepetAdet(
                plasiyerGuid: Ctanim.PlasiyerGuid!,
                cariGuid: Ctanim.cari!.guid!);
            setState(() {});
          } else if (p0.message.contains("CariSec")) {
            String cariGuid = p0.message.split(":")[1];
            Ctanim.cari!.guid = cariGuid;

            servis.postCari(
                plasiyerGuid: Ctanim.PlasiyerGuid ?? "",
                cariGuid: Ctanim.cari!.guid ?? "");

            var url = Uri.https(
              SiteSabit.Link!,
              '/Login/MobilGiris',
              {
                'Guid': Ctanim.cari!.guid,
                'PlasiyerGuid': Ctanim.PlasiyerGuid,
              },
            );
            await SharedPrefsHelper.saveUser(Ctanim.cari!);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return WebViewApp(
                    url: url,
                  );
                },
              ),
              (Route<dynamic> route) => false,
            );
          }
        },
      )
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
            renkDegistir(url);
          },
          onUrlChange: (change) async {
            if (change.url!.toString().toLowerCase().contains("carirehber")) {
              await servis.getCariRehber(
                  plasiyerGuid: Ctanim.PlasiyerGuid!, arama: "");
              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => CariRehberList(),
                ),
                (route) => false,
              );
            }
          },
          onNavigationRequest: (navigation) async {
            String url = Uri.parse(navigation.url).toString();
            Ctanim.currentUrl = url;
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
            } else if ((url.toLowerCase().contains('login') ||
                    url.toLowerCase().contains('/giris')) &&
                !url.toLowerCase().contains('mobilgiris')) {
              await SharedPrefsHelper.clearUser();
              widget.controller.clearLocalStorage();
              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(title: '', viewDanMi: true),
                ),
                (route) => false,
              );

              return NavigationDecision.prevent;
            } else if (url.toLowerCase().contains('carirehber')) {
              await servis.getCariRehber(
                  plasiyerGuid: Ctanim.PlasiyerGuid!, arama: "");

              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => CariRehberList(),
                ),
                (route) => false,
              );

              return NavigationDecision.prevent;
            } else if (url.toLowerCase().contains('wa.me')) {
              final Uri wp = Uri.parse(url);
              launchUrl(wp);
              return NavigationDecision.prevent;
            } else if (url.toLowerCase().contains('hesabim/altkullanici')) {
              await servis.getAltKullanici(
                  plasiyerGuid: Ctanim.PlasiyerGuid!,
                  cariGuid: Ctanim.cari!.guid!);
              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => AltKullaniciList(),
                ),
                (route) => false,
              );

              return NavigationDecision.prevent;
            } else if (url.toLowerCase().contains('exportpdf') ||
                url.toLowerCase().contains('/yazdir?')) {
              var a = await widget.controller
                  .runJavaScriptReturningResult("document.cookie.toString()");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PDF(title: "PDF", url: url, cookie: a.toString()),
                  )).then((value) => widget.controller.canGoBack());

              return NavigationDecision.prevent;
            } else if (url.toLowerCase().contains('ziyaret') &&
                !url.toLowerCase().contains("latitude") &&
                !url.toLowerCase().contains("longitude") &&
                !url.toLowerCase().contains("accuracy")) {
              if (Platform.isIOS) {
                List<double> gelen = [];
                var sonUrl;
                gelen = await getLocationIos();
                lat = gelen[0];
                long = gelen[1];
                acc = gelen[2];
                var baseUri = Uri.parse(navigation.url);
                var yeniUrl = baseUri.replace(queryParameters: {
                  'latitude': lat.toString(),
                  'longitude': long.toString(),
                  'accuracy': acc.toString(),
                });

                String a = yeniUrl.toString();
                a = a + "?";
                sonUrl = Uri.parse(a);

                print(a);
/*
                getLocationIos().then((value) {
                  gelen = value;
                  lat = gelen[0];
                  long = gelen[1];
                  acc = gelen[2];
                  var baseUri = Uri.parse(navigation.url);
                  var yeniUrl = baseUri.replace(queryParameters: {
                    'latitude': lat.toString(),
                    'longitude': long.toString(),
                    'accuracy': acc.toString(),
                  });

                  String a = yeniUrl.toString();
                  a = a + "?";
                  sonUrl = Uri.parse(a);

                  print(a);
                });
                */
                widget.controller.loadRequest(sonUrl);

                return NavigationDecision.prevent;
              } else {
                await checkLocationPermission();
                if (loc.PermissionStatus.granted ==
                    await loc.Location().hasPermission()) {
                  await getCurrentLocation();
                  var yeniUrl = Uri.parse(navigation.url +
                      "?latitude=$lat&longitude=$long&accuracy=$acc");
                  widget.controller.loadRequest(yeniUrl);
                  return NavigationDecision.prevent;
                }
                //turan ekledi
              }
            }

            //ExportPdf
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  List<Color> bottomColorList = [
    Colors.grey,
    Colors.amber,
    Colors.grey,
    Colors.transparent,
    Colors.transparent,
    Colors.grey,
    const Color.fromARGB(255, 199, 166, 166),
    Colors.grey
  ];
// number that changes when refreshed
  bool geri = false;
  bool ileri = false;
  @override
  Widget build(BuildContext context) {
    widget.controller.canGoBack().then((value) {
      if (value != geri) {
        geri = value;
        setState(() {});
      }
    });
    widget.controller.canGoForward().then((value) {
      if (value != ileri) {
        ileri = value;
        setState(() {});
      }
    });

    return SafeArea(
      bottom: false,
      child: Scaffold(
        bottomNavigationBar: StylishBottomBar(
          option: AnimatedBarOptions(
            barAnimation: BarAnimation.blink,
          ),
          items: [
            BottomBarItem(
                icon: Opacity(
                  opacity: geri == true ? 1 : 0.3,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                  ),
                ),
                backgroundColor: bottomColorList[0],
                title: Opacity(
                  opacity: geri == true ? 1 : 0.3,
                  child: Text(
                    Ctanim.translate('Geri'),
                    style: TextStyle(
                        fontSize:    MediaQuery.of(context).size.width >800? MediaQuery.of(context).size.width * .01:
                    MediaQuery.of(context).size.width * .02),
                  ),
                )),
            BottomBarItem(
              icon: const Icon(
                Icons.house_outlined,
              ),
              backgroundColor: bottomColorList[1],
              title: Text(
                Ctanim.translate('Anasayfa'),
                style: TextStyle(
                    fontSize:    MediaQuery.of(context).size.width >800? MediaQuery.of(context).size.width * .01:
                    MediaQuery.of(context).size.width * .02),
              ),
            ),
            BottomBarItem(
              icon: const Icon(Icons.category),
              backgroundColor: bottomColorList[2],
              title: Text(
                Ctanim.translate("Kategoriler"),
                style: TextStyle(
                    fontSize:    MediaQuery.of(context).size.width >800? MediaQuery.of(context).size.width * .01:
                    MediaQuery.of(context).size.width * .02),
              ),
            ),
            BottomBarItem(
              icon: Icon(
                Icons.access_time_filled_outlined,
                size: 5,
              ),
              backgroundColor: bottomColorList[3],
              title: Text(
                '',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * .02),
              ),
            ),
            BottomBarItem(
              icon: Icon(
                Icons.access_time_filled_outlined,
                size: 5,
              ),
              backgroundColor: bottomColorList[4],
              title: Text(
                '',
                style: TextStyle(
                    fontSize: 
                    
                    MediaQuery.of(context).size.width * .02),
              ),
            ),
            BottomBarItem(
                icon: const Icon(
                  Icons.shopping_cart,
                ),
                backgroundColor: bottomColorList[5],
                showBadge: Ctanim.sepetGozuksunMu,
                badge: Text(Ctanim.sepetAdet.toString()),
                title: Text(
                 Ctanim.translate('Sepetim'),
                  style: TextStyle(
                      fontSize:    MediaQuery.of(context).size.width >800? MediaQuery.of(context).size.width * .01:
                    MediaQuery.of(context).size.width * .02),
                )),
            BottomBarItem(
                icon: const Icon(
                  Icons.person,
                ),
                backgroundColor: bottomColorList[6],
                title: Text(
                 Ctanim.translate( 'Bilgilerim'),
                  style: TextStyle(
                      fontSize:     MediaQuery.of(context).size.width >800? MediaQuery.of(context).size.width * .01:
                    MediaQuery.of(context).size.width * .02),
                )),
            BottomBarItem(
                icon: Opacity(
                  opacity: ileri == true ? 1 : 0.3,
                  child: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
                backgroundColor: bottomColorList[7],
                title: Opacity(
                  opacity: ileri == true ? 1 : 0.3,
                  child: Text(
                    Ctanim.translate('İleri'),
                    style: TextStyle(
                        fontSize:    MediaQuery.of(context).size.width >800? MediaQuery.of(context).size.width * .01:
                    MediaQuery.of(context).size.width * .02),
                  ),
                )),
          ],
          hasNotch: false,
          fabLocation: StylishBarFabLocation.center,
          currentIndex: selected,
          onTap: (index) async {
            //controller.jumpToPage(index);
            setState(() {
              selected = index;
            });

            if (selected == 0) {
              await widget.controller.goBack();
            } else if (selected == 1) {
              widget.controller.loadRequest(Uri.https(SiteSabit.Link!));
            } else if (selected == 2) {
              Ctanim.yanMenu(context);
              scaffoldKey.currentState!.openDrawer();
            } else if (selected == 5) {
              String link = "https://" + SiteSabit.Link! + "\/Sepet\/Sepet";
              widget.controller.loadRequest(Uri.parse(link));
            } else if (selected == 6) {
              String link =
                  "https://" + SiteSabit.Link! + "/Hesabim/Bilgilerim";
              widget.controller.loadRequest(Uri.parse(link));
            } else if (selected == 7) {
              await widget.controller.goForward();
            }
          },
        ),
        floatingActionButton: Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * .05),
          child: FloatingActionButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return Stack(
                    children: [
                      SearchAlertDialog(
                        controller: widget.controller,
                      ),
                    ],
                  );
                },
              );
            },

            backgroundColor:
                Colors.transparent, // Arka plan rengini şeffaf yapın
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple], // İstenilen renkler
                ),
                shape: BoxShape.circle, // Dairesel bir şekil verir
              ),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
              padding:
                  EdgeInsets.all(16.0), // İkonu ortalamak için iç boşluk ekler
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: deneme(
          controller: widget.controller,
        ),
        key: scaffoldKey,
        body: Stack(
          children: [
            WebViewWidget(
              controller: widget.controller,
            ),
            if (loadingPercentage < 100)
              Center(child: CircularProgressIndicator())
            /*
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
              */
          ],
        ),
        /*RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,

            child: Container(
          height:  MediaQuery.of(context).size.height,
          width:  MediaQuery.of(context).size.width,
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
            ),
          ),
        ),
        */

        /*LiquidPullToRefresh(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          showChildOpacityTransition: false,
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
        ),
        */
      ),
    );
  }

  Future<void> renkDegistir(String url) async {
    bottomColorList[1] = Colors.grey; //Anasayfa
    bottomColorList[2] = Colors.grey; //Kategori
    bottomColorList[5] = Colors.grey; //Sepet
    bottomColorList[6] = Colors.grey; //Bilgilerim
    if (url!.toLowerCase().contains("sepet")) {
      bottomColorList[5] = Colors.amber; //Sepet
    } else if (url!.toLowerCase().contains("hesabim")) {
      bottomColorList[6] = Colors.amber; //Sepet
    } else {
      bottomColorList[1] = Colors.amber; //Sepet
    }
    setState(() {});
  }
}
