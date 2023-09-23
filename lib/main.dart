import 'package:b2b/servis/servis.dart';
import 'package:b2b/servis/sharedPrefsHelper.dart';
import 'package:b2b/view/anasayfa.dart';
import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/view/webview.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'model/cariModel.dart';
import 'model/menuModel.dart';
import 'view/girisYap.dart';

void main() {
  //Remove this method to stop OneSignal Debugging
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("74ab2e46-7997-42ca-b4ce-157a99698459");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/anasayfa': (context) => anasayfa(),
        '/girisYap': (context) => girisYap(),
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
          SharedPrefsHelper.getUser(),
          s.getMenu(cariGuid: "", plasiyerGuid: ""),
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
          } else if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          } else {
            print(Ctanim.menuList.length);
            if (Ctanim.cari != null && widget.viewDanMi == false) {
              if (Ctanim.cari!.guid != "") {
                var url = Uri.https(
                  SiteSabit.Link!,
                  '/Login/MobilGiris',
                  {
                    'Guid': Ctanim.cari!.guid,
                    'PlasiyerGuid': '',
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
              if (sifemiUnuttumVarMi == false) {
                Ctanim.menuList.insert(
                    0,
                    MenuModel(
                        id: -1, adi: "Şifremi Unuttum", url: "sifremiUnuttum"));
              }
              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  body: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          controller: Ctanim.tabController,
                          children: [girisYap(), anasayfa()],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return Container();
          }
        },
      ),
    );

/*
    if (Ctanim.cari != null && widget.viewDanMi == false) {
      if (Ctanim.cari!.guid != "") {
        var url = Uri.https(
          SiteSabit.Link!,
          '/Login/MobilGiris',
          {
            'Guid': Ctanim.cari!.guid,
            'PlasiyerGuid': '',
          },
        );
        return WebViewApp(url: url);
      }
    } else {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: Ctanim.tabController,
                  children: [
                    girisYap(),
                    anasayfa(
                      
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    return Container();
    */
  }
}
