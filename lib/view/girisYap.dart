import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/servis/servis.dart';
import 'package:b2b/servis/sharedPrefsHelper.dart';
import 'package:b2b/view/webview.dart';
import 'package:flutter/material.dart';

class girisYap extends StatefulWidget {
  const girisYap({super.key});

  @override
  State<girisYap> createState() => _girisYapState();
}

class _girisYapState extends State<girisYap> {
  TextEditingController kullaniciAdi = TextEditingController();
  TextEditingController sifre = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          // dkfsflşksdkfkşsdl
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/wer2.jpg"), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        print(Ctanim.tabController!.index.toString());
                        Ctanim.tabController!.animateTo(1,
                            duration: Duration(milliseconds: 500));
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  SizedBox(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person_2,
                          color: Color.fromARGB(255, 54, 151, 255),
                          size: 50,
                        ),
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Opak B2B'ye Hoş Geldiniz",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Lütfen Giriş Yapın",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  controller: kullaniciAdi,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Color(0xFF00b8a6),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.7),
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Kullanıcı Adı',
                    hintStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  controller: sifre,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Color(0xFF00b8a6),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.7),
                    prefixIcon: Icon(Icons.key),
                    hintText: 'Parola',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (sifre.text == "" || kullaniciAdi.text == "") {
                        // boş girme gardaş
                      } else {
                        Servis servis = Servis();
                        bool donusDegeri = await servis.login(
                            kullaniciAdi: kullaniciAdi.text, sifre: sifre.text);
                        if (donusDegeri == true) {
                          if (Ctanim.cari!.guid != "") {
                            var url = Uri.https(
                              SiteSabit.Link!,
                              '/Login/MobilGiris',
                              {
                                'Guid': Ctanim.cari!.guid,
                                'PlasiyerGuid': '',
                              },
                            );
                            await SharedPrefsHelper.saveUser(Ctanim.cari!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => WebViewApp(url: url)),
                              ),
                            );
                          } else {
                            // cari guid boş
                          }
                        } else {
                          // donuş false
                        }
                      }
                    },
                    child: Text("Giriş",
                        style: TextStyle(
                            color: const Color(0xFF00b8a6), fontSize: 17)),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Köşe yuvarlama
                        ),
                        primary: Colors.white),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
