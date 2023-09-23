import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/model/cariModel.dart';
import 'package:b2b/model/menuModel.dart';
import 'package:b2b/servis/sharedPrefsHelper.dart';
import 'package:b2b/view/girisYap.dart';
import 'package:b2b/main.dart';
import 'package:b2b/servis/servis.dart';
import 'package:b2b/view/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class anasayfa extends StatefulWidget {
  const anasayfa({super.key, this.cikisMiYapti = true});
  final bool cikisMiYapti;

  @override
  State<anasayfa> createState() => _anasayfaState();
}

class _anasayfaState extends State<anasayfa> {
  TextEditingController sifremiUnuttum = TextEditingController();
  bool telAcikMi = false;
  bool mailAcikMi = false;
  bool adresAcikMi = false;
  bool bottomAcikMi = false;
  Future<void> loadCari() async {
    await Future.delayed(Duration(milliseconds: 500));
    Cari? cari = await SharedPrefsHelper.getUser();
    setState(() {
      Ctanim.cari = cari;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.cikisMiYapti == true) {
      loadCari();
    }
  }

  void _copyToClipboard(String kopyalanacakMetin) {
    Clipboard.setData(ClipboardData(text: kopyalanacakMetin));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Metin kopyalandı!'),
    ));
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                bottomAcikMi = false;
                telAcikMi = false;
                mailAcikMi = false;
                adresAcikMi = false;
                setState(() {});
              },
              child: Container(
                  // dkfsflşksdkfkşsdl

                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/wer.jpg"), fit: BoxFit.cover),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: bottomAcikMi == false ? 200 : 100,
                                      left: 30),
                                  child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.person_2,
                                          color:
                                              Color.fromARGB(255, 54, 151, 255),
                                          size: 90,
                                        ),
                                      ))),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, top: 40),
                                child: SizedBox(
                                    width: 11600,
                                    child: Text(
                                      "Opak B2B'ye Hoş Geldiniz",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontFamily: "OpenSans",
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, top: 20),
                                child: Text(
                                  Ctanim.cari != null
                                      ? Ctanim.cari!.kullaniciAdi!
                                      : "İyi çalışmalar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 30, top: 30),
                                  child: SizedBox(
                                    width: 150,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (Ctanim.cari == null) {
                                          Ctanim.tabController!.animateTo(0,
                                              duration:
                                                  Duration(milliseconds: 500));
                                        } else {
                                          if (Ctanim.cari!.guid != "") {
                                            var url = Uri.https(
                                              SiteSabit.Link!,
                                              '/Login/MobilGiris',
                                              {
                                                'Guid': Ctanim.cari!.guid,
                                                'PlasiyerGuid': '',
                                              },
                                            );
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: ((context) =>
                                                    WebViewApp(url: url)),
                                              ),
                                            );
                                          }
                                        }

                                        /*
                    
                                        */
                                      },
                                      child: Text(
                                        "Giriş",
                                        style: TextStyle(
                                            color: const Color(0xFF00b8a6),
                                            fontSize: 17),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8.0), // Köşe yuvarlama
                                          ),
                                          primary: Colors.white),
                                    ),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(left: 30, top: 40),
                                child: Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: Ctanim.menuList.length,
                                    separatorBuilder: (context, index) {
                                      return VerticalDivider(
                                        thickness: 1,
                                        color: Colors.white,
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      return TextButton(
                                        onPressed: () {
                                          var yeniUrl = Uri.parse("https://" +
                                              SiteSabit.Link! +
                                              Ctanim.menuList[index].url!);
                                          print(yeniUrl);
                                          if (yeniUrl
                                              .toString()
                                              .contains("sifremiunuttum")) {
                                            Servis servis = Servis();
                                            showModalBottomSheet(
                                              backgroundColor: Color.fromARGB(
                                                      255, 171, 242, 255)
                                                  .withOpacity(0.9),
                                              context: context,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(16.0),
                                                ),
                                              ),
                                              builder: (BuildContext context) {
                                                return Container(
                                                  padding: EdgeInsets.all(16.0),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.7,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10)),
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/back1.png"),
                                                        fit: BoxFit.cover),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Divider(
                                                        thickness: 3,
                                                        indent: 150,
                                                        endIndent: 150,
                                                        color: Colors.grey,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 20,
                                                                left: 20,
                                                                right: 20),
                                                        child: TextFormField(
                                                          controller:
                                                              sifremiUnuttum,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87),
                                                          cursorColor:
                                                              Color(0xFF00b8a6),
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            filled: true,
                                                            fillColor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.7),
                                                            prefixIcon: Icon(
                                                                Icons.mail),
                                                            hintText:
                                                                'Mail Adresinizi Giriniz',
                                                            hintStyle: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        80,
                                                                        79,
                                                                        79)),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                            ),
                                                            disabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 20,
                                                                left: 20,
                                                                right: 20),
                                                        child: Text(
                                                          "Not: Gireceğiniz mail adresine tarafımızca şifreniz gönderilecekir.",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "OpenSans"),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 20,
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .25,
                                                            right: 20),
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            Image.asset(
                                                                "assets/ee1.gif");
                                                            List<dynamic>
                                                                donen =
                                                                await servis
                                                                    .sifremiUnuttum(
                                                                        mail: sifremiUnuttum
                                                                            .text);
                                                            if (donen.length ==
                                                                1) {
                                                              // hata
                                                            } else {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(32.0))),
                                                                      insetPadding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      title:
                                                                          Text(
                                                                        donen[0] ==
                                                                                true
                                                                            ? "Hata"
                                                                            : "Başarılı",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                17),
                                                                      ),
                                                                      content:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.8,
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Text(donen[1]),
                                                                            SizedBox(
                                                                              height: 30,
                                                                            ),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: MediaQuery.of(context).size.width / 3.5,
                                                                                  height: 50,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.only(right: 4),
                                                                                    child: ElevatedButton(
                                                                                        child: Text(
                                                                                          "Tamam",
                                                                                          style: TextStyle(fontSize: 15),
                                                                                        ),
                                                                                        style: ElevatedButton.styleFrom(
                                                                                            foregroundColor: Colors.white,
                                                                                            backgroundColor: Color.fromARGB(255, 30, 38, 45),
                                                                                            shadowColor: Colors.black,
                                                                                            elevation: 0,
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                                            )),
                                                                                        onPressed: () {
                                                                                          if (donen[0] == false) {
                                                                                            Navigator.pushAndRemoveUntil(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                builder: (context) => anasayfa(),
                                                                                              ),
                                                                                              (route) => false,
                                                                                            );
                                                                                          } else {
                                                                                            Navigator.pop(context);
                                                                                          }
                                                                                        }),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                          child: Text(
                                                            "Şifremi Gönder",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 17),
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0), // Köşe yuvarlama
                                                                  ),
                                                                  primary: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          248,
                                                                          247,
                                                                          247)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      WebViewApp(
                                                    url: yeniUrl,
                                                  ),
                                                ));
                                          }

                                          //  _showModelSheet(yeniUrl);
                                        },
                                        child: Text(
                                          Ctanim.menuList[index].adi!,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: bottomAcikMi == false ? 90 : 50),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      bottomAcikMi = false;
                                      telAcikMi = false;
                                      mailAcikMi = false;
                                      adresAcikMi = false;
                                    });
                                  },
                                  child: Container(
                                    height: bottomAcikMi == false
                                        ? MediaQuery.of(context).size.height *
                                            0.1713
                                        : MediaQuery.of(context).size.height *
                                            0.3,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        Divider(
                                          thickness: 4,
                                          color: Color.fromARGB(
                                              255, 177, 177, 177),
                                          endIndent: 180,
                                          indent: 180,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, right: 40, left: 40),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundColor: Color.fromARGB(
                                                    255, 222, 222, 222),
                                                child: IconButton(
                                                  icon: Icon(Icons.phone,
                                                      size: 25,
                                                      color: Color(0xFF00b8a6)),
                                                  onPressed: () {
                                                    setState(() {
                                                      bottomAcikMi = true;
                                                      mailAcikMi = false;
                                                      adresAcikMi = false;
                                                      telAcikMi = true;
                                                    });
                                                  },
                                                ),
                                              ),
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundColor: Color.fromARGB(
                                                    255, 222, 222, 222),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.mail,
                                                    size: 25,
                                                    color: Color(0xFF00b8a6),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      bottomAcikMi = true;
                                                      telAcikMi = false;
                                                      adresAcikMi = false;
                                                      mailAcikMi = true;
                                                    });
                                                  },
                                                ),
                                              ),
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundColor: Color.fromARGB(
                                                    255, 222, 222, 222),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.home_work_rounded,
                                                    size: 25,
                                                    color: Color(0xFF00b8a6),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      bottomAcikMi = true;
                                                      telAcikMi = false;
                                                      mailAcikMi = false;
                                                      adresAcikMi = true;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, right: 20, left: 34),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Bize Ulaşın",
                                                style: TextStyle(
                                                    fontFamily: "OpenSans",
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Spacer(),
                                              Text("Mail Adresimiz",
                                                  style: TextStyle(
                                                      fontFamily: "OpenSans",
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Spacer(),
                                              Text("Firma Adresi",
                                                  style: TextStyle(
                                                      fontFamily: "OpenSans",
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, right: 20, left: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              telAcikMi == true
                                                  ? Column(
                                                      children: [
                                                        Text(
                                                          SiteSabit.telefon!,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "OpenSans",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          width: 40,
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              _copyToClipboard(
                                                                  SiteSabit
                                                                      .telefon!);
                                                            },
                                                            child: Text(
                                                                "Kopyala!"))
                                                      ],
                                                    )
                                                  : Container(),
                                              mailAcikMi == true
                                                  ? Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 30),
                                                          child: Text(
                                                              SiteSabit.mail!,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "OpenSans",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        SizedBox(
                                                          width: 40,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          child: TextButton(
                                                              onPressed: () {
                                                                _copyToClipboard(
                                                                    SiteSabit
                                                                        .mail!);
                                                              },
                                                              child: Text(
                                                                  "Kopyala!")),
                                                        )
                                                      ],
                                                    )
                                                  : Container(),
                                              adresAcikMi == true
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(SiteSabit.adress!,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "OpenSans",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                          width: 40,
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              _copyToClipboard(
                                                                  SiteSabit
                                                                      .adress!);
                                                            },
                                                            child: Text(
                                                                "Kopyala!"))
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
