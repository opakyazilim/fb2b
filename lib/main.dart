import 'dart:io';

import 'package:b2b/model/cariModel.dart';
import 'package:b2b/view/alertDiyalog.dart';
import 'package:b2b/servis/servis.dart';
import 'package:b2b/servis/sharedPrefsHelper.dart';
import 'package:b2b/view/anasayfa.dart';
import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/view/smsDogrulama.dart';
import 'package:b2b/view/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'model/menuModel.dart';
import 'view/girisYap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Ctanim.internet = await Servis.internetDene();

  if (Ctanim.internet) {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(SiteSabit.oneSignalKey);
    OneSignal.Notifications.requestPermission(true);
  } else {
    //exit(0);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        '/anasayfa': (context) => anasayfa(),
        '/girisYap': (context) => girisYap(
              kulAdi: "",
              sifre: "",
              beniHatirla: false,
            ),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF00b8a6)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, this.viewDanMi = false});
  final bool viewDanMi;

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Servis s = Servis();
  String kulAdi = "";
  String sifre = "";
  bool beniHatirla = false;
  bool smsVarMi = false;

  Future<void> getKulAndSifreAndSmsFromShared() async {
    kulAdi =
        (await SharedPrefsHelper.getStringFromSharedPreferences("kulAdi"))!;
    sifre = (await SharedPrefsHelper.getStringFromSharedPreferences("sifre"))!;
    beniHatirla =
        (await SharedPrefsHelper.getSBoolFromSharedPreferences("beniHatirla"))!;
    smsVarMi = (await SharedPrefsHelper.getSBoolFromSharedPreferences("sms"))!;    

  }

  Future<void> oneSignalKeyAl() async {
    Servis ss = Servis();
    String? temp =
        await SharedPrefsHelper.getStringFromSharedPreferences("oneSignalID");
    if (temp == null || temp == "") {
      MethodChannel _channel =
          const MethodChannel('OneSignal#pushsubscription');
      var _id = await _channel.invokeMethod("OneSignal#pushSubscriptionId");
      SharedPrefsHelper.saveStringToSharedPreferences("oneSignalID", _id);
      Ctanim.oneSignalKey = _id;
      if (Ctanim.cari != null) {
        ss.postCari(
            plasiyerGuid: Ctanim.PlasiyerGuid ?? "",
            cariGuid: Ctanim.cari!.guid ?? "");
      }
    } else {
      Ctanim.oneSignalKey = temp;
      if (Ctanim.cari != null) {
        ss.postCari(
            plasiyerGuid: Ctanim.PlasiyerGuid ?? "",
            cariGuid: Ctanim.cari!.guid ?? "");
      }
    }
  }

  Future<void> test() async {
    OneSignal.Notifications.addClickListener((event) {
      if (event.notification.additionalData!["ReturnUrl"] != "" &&
          event.notification.additionalData!["ReturnUrl"] != null) {
        Ctanim.bildirimUrlVarMi =
            event.notification.additionalData!["ReturnUrl"].toString();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WebViewApp(url: Uri.parse(Ctanim.bildirimUrlVarMi)),
          ),
        );
        Ctanim.bildirimvar = true;
      } else {
        Ctanim.bildirimvar = false;
      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Ctanim.tabController =
        TabController(vsync: this, length: 2, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Future.wait([
          getKulAndSifreAndSmsFromShared(),
          SharedPrefsHelper.getStringFromSharedPreferences("plasiyerGuid"),
          SharedPrefsHelper.getUser(),
          s.getMenu(cariGuid: "", plasiyerGuid: ""),
        
          //   test()
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset('assets/ee1.gif')),
              ),
            );
          } else if (snapshot.hasError || Ctanim.internet == false) {
            print("Bitti");
            return Scaffold(
              body: AlertDialog(
                title: Text(Ctanim.translate("İnternet Bağlantısı Yok")),
                content: Text(
                    Ctanim.translate("Aktif internet bağlantısı bulunamadı.İnternete bağlı olduğunuzdan emin olun.")),
                actions: [
                  TextButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: Text(
                     Ctanim.translate("Uygulamayı Kapat") ,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
            );
          } else {
            if (Ctanim.cari != null && widget.viewDanMi == false&& smsVarMi == false) {
               s.getMenu(cariGuid: Ctanim.cari!.guid!, plasiyerGuid: Ctanim.PlasiyerGuid == null || Ctanim.PlasiyerGuid == "" ? "" : Ctanim.PlasiyerGuid!);
              print(smsVarMi);
            
              if (Ctanim.cari!.guid != "" ) {
                var url = Uri.https(
                  SiteSabit.Link!,
                  '/Login/MobilGiris',
                  {
                    'Guid': Ctanim.cari!.guid,
                    'PlasiyerGuid': Ctanim.PlasiyerGuid,
                  },
                );
                return WebViewApp(url: url);
              }
            } else {
              bool sifemiUnuttumVarMi = false;
              if (Ctanim.SifremiUnuttum == true) {
                Ctanim.menuList.map((e) {
                  if (e.adi == "Şifremi Unuttum") {
                    sifemiUnuttumVarMi = true;
                  }
                });
              }
              bool misafir = false;
              if (Ctanim.Misafir == true) {
                Ctanim.menuList.map((e) {
                  if (e.adi == "Misafir Girişi") {
                    misafir = true;
                  }
                });
              }
              if (sifemiUnuttumVarMi == false &&
                  Ctanim.SifremiUnuttum == true) {
                Ctanim.menuList.insert(
                    0,
                    MenuModel(
                        id: -1, adi: "Şifremi Unuttum", url: "sifremiUnuttum"));
              }
              if (misafir == false && Ctanim.Misafir == true) {
                Ctanim.menuList.insert(
                    1,
                    MenuModel(
                        id: -2, adi: "Misafir Girişi", url: "misafirGirisi"));
              }

              return dfTabCont(
                  kulAdi: kulAdi, sifre: sifre, beniHatirla: beniHatirla);
            }

            return Container();
          }
        },
      ),
    );
  }
}

class dfTabCont extends StatelessWidget {
  const dfTabCont({
    super.key,
    required this.kulAdi,
    required this.sifre,
    required this.beniHatirla,
  });

  final String kulAdi;
  final String sifre;
  final bool beniHatirla;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: Ctanim.tabController,
                children: [
                  girisYap(
                    kulAdi: kulAdi,
                    sifre: sifre,
                    beniHatirla: beniHatirla,
                  ),
                  anasayfa()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
