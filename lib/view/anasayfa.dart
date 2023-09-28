
import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/model/cariModel.dart';
import 'package:b2b/servis/sharedPrefsHelper.dart';
import 'package:b2b/view/alertDiyalog.dart';
import 'package:b2b/servis/servis.dart';
import 'package:b2b/view/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class anasayfa extends StatefulWidget {
  const anasayfa({super.key, this.cikisMiYapti = true});
  final bool cikisMiYapti;

  @override
  State<anasayfa> createState() => _anasayfaState();
}

class _anasayfaState extends State<anasayfa> {
  Color genelColor = Color(0xFF100740);
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

    Ctanim.seciliSifreGonderme.value = Ctanim.sifreGondermeSecenekleri.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FocusManager.instance.primaryFocus != null &&
          FocusManager.instance.primaryFocus!.hasFocus) {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    });
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
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          //image: AssetImage("assets/wer.jpg"), fit: BoxFit.fitHeight),
                          image: NetworkImage("https://" +
                              SiteSabit.Link! +
                              "/mobilgiris.jpg?v=3"),
                          fit: BoxFit.cover),
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
                                        left: 0),
                                    child: Container(
                                      height: 80,
                                      width: MediaQuery.of(context).size.width *
                                          .55,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight:
                                                  Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset("assets/logo2.png"),
                                      ),
                                    )),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 30, top: 40),
                                  child: SizedBox(
                                      width: 11600,
                                      child: Text(
                                        SiteSabit.FirmaAdi! +
                                            " B2B'ye Hoş Geldiniz",
                                        style: TextStyle(
                                            color: genelColor,
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
                                        color: genelColor,
                                        fontSize: 22,
                                        fontFamily: "OpenSans",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, top: 30),
                                    child: SizedBox(
                                      width: 150,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (Ctanim.cari == null) {
                                            Ctanim.tabController!.animateTo(0,
                                                duration: Duration(
                                                    milliseconds: 500));
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
                                        },
                                        child: Text(
                                          "Giriş",
                                          style: TextStyle(
                                              color: const Color(0xFF00b8a6),
                                              fontSize: 17),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
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
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.all(16.0),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.7,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
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
                                                        dropDown(
                                                            sec: Ctanim
                                                                .seciliSifreGonderme
                                                                .value),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 20,
                                                                  left: 20,
                                                                  right: 20),
                                                          child: Obx(
                                                            () => TextFormField(
                                                              keyboardType: Ctanim
                                                                          .seciliSifreGonderme
                                                                          .value ==
                                                                      "Mail İle Gönder"
                                                                  ? TextInputType
                                                                      .emailAddress
                                                                  : Ctanim.seciliSifreGonderme
                                                                              .value ==
                                                                          "Telefon Numarası İle Gönder"
                                                                      ? TextInputType
                                                                          .phone
                                                                      : Ctanim.seciliSifreGonderme.value ==
                                                                              "Kullanıcı Adi İle Gönder"
                                                                          ? TextInputType
                                                                              .name
                                                                          : TextInputType
                                                                              .text,
                                                              controller:
                                                                  sifremiUnuttum,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87),
                                                              cursorColor: Color(
                                                                  0xFF00b8a6),
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                filled: true,
                                                                fillColor: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.7),
                                                                prefixIcon: Ctanim
                                                                            .seciliSifreGonderme
                                                                            .value ==
                                                                        "Mail İle Gönder"
                                                                    ? Icon(Icons
                                                                        .mail)
                                                                    : Ctanim.seciliSifreGonderme.value ==
                                                                            "Telefon Numarası İle Gönder"
                                                                        ? Icon(Icons
                                                                            .phone)
                                                                        : Ctanim.seciliSifreGonderme.value ==
                                                                                "Kullanıcı Adi İle Gönder"
                                                                            ? Icon(Icons.person)
                                                                            : Icon(Icons.abc),
                                                                hintText: Ctanim
                                                                            .seciliSifreGonderme
                                                                            .value ==
                                                                        "Mail İle Gönder"
                                                                    ? 'Mail Adresinizi Giriniz'
                                                                    : Ctanim.seciliSifreGonderme.value ==
                                                                            "Telefon Numarası İle Gönder"
                                                                        ? "Telefonunuzu Giriniz"
                                                                        : Ctanim.seciliSifreGonderme.value ==
                                                                                "Kullanıcı Adi İle Gönder"
                                                                            ? "Kullanıcı adınızı Giriniz"
                                                                            : "",
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
                                                            onPressed:
                                                                () async {
                                                              if (sifremiUnuttum
                                                                      .text ==
                                                                  "") {
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return CustomAlertDialog(
                                                                      title:
                                                                          "Hata ",
                                                                      message:
                                                                          "Şifre Gönderilecek Alan Adı Boş.",
                                                                      onPres:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      buttonText:
                                                                          "Geri",
                                                                      textColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                  },
                                                                );
                                                              } else {
                                                                List<dynamic>
                                                                    donen = [];
                                                                Image.asset(
                                                                    "assets/ee1.gif");
                                                                if (Ctanim
                                                                        .seciliSifreGonderme
                                                                        .value ==
                                                                    "Mail İle Gönder") {
                                                              
                                                                  donen = await servis.sifremiUnuttum(
                                                                      mail: sifremiUnuttum
                                                                          .text,
                                                                      kullaniciAdi:
                                                                          "",
                                                                      telefon:
                                                                          "");
                                                                } else if (Ctanim
                                                                        .seciliSifreGonderme
                                                                        .value ==
                                                                    "Kullanıcı Adi İle Gönder") {
                                                                 
                                                                  await servis.sifremiUnuttum(
                                                                      mail: "",
                                                                      kullaniciAdi:
                                                                          sifremiUnuttum
                                                                              .text,
                                                                      telefon:
                                                                          "");
                                                                } else {
                                                              
                                                                  await servis.sifremiUnuttum(
                                                                      mail: "",
                                                                      kullaniciAdi:
                                                                          "",
                                                                      telefon:
                                                                          sifremiUnuttum
                                                                              .text);
                                                                }

                                                                if (donen
                                                                        .length <
                                                                    1) {
                                                                  await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return CustomAlertDialog(
                                                                        title:
                                                                            "Hata ",
                                                                        message:
                                                                            "Böyle Bir Kullanıcı Yok",
                                                                        onPres:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        buttonText:
                                                                            "Geri",
                                                                        textColor:
                                                                            Colors.red,
                                                                      );
                                                                    },
                                                                  );
                                                                } else {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                                                          insetPadding:
                                                                              EdgeInsets.zero,
                                                                          title:
                                                                              Text(
                                                                            donen[0] == true
                                                                                ? "Hata"
                                                                                : "Başarılı",
                                                                            style:
                                                                                TextStyle(fontSize: 17),
                                                                          ),
                                                                          content:
                                                                              SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.8,
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
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
                                                                                                foregroundColor: genelColor,
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
                                                              }
                                                            },
                                                            child: Text(
                                                              "Şifremi Gönder",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize: 17),
                                                            ),
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
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
                                          },
                                          child: Text(
                                            Ctanim.menuList[index].adi!,
                                            style: TextStyle(
                                                color: genelColor,
                                                fontSize: 16),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: bottomAcikMi == false
                                          ? MediaQuery.of(context).size.height *
                                              .2
                                          : MediaQuery.of(context).size.height *
                                              .25),
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
                                              0.3
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
                                              top: 15,
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .33,
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: IconButton(
                                                      icon: Icon(Icons.phone,
                                                          size: 25,
                                                          color: Color(
                                                              0xFF00b8a6)),
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
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .33,
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.mail,
                                                        size: 25,
                                                        color:
                                                            Color(0xFF00b8a6),
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
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .33,
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.home_work_rounded,
                                                        size: 25,
                                                        color:
                                                            Color(0xFF00b8a6),
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
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 2,
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .33,
                                                  child: Center(
                                                    child: Text(
                                                      "Bize Ulaşın",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "OpenSans",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .33,
                                                  child: Center(
                                                    child: Text(
                                                        "Mail Adresimiz",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "OpenSans",
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .33,
                                                  child: Center(
                                                    child: Text("Firma Adresi",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "OpenSans",
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, right: 20, left: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                                child: const Text(
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
                                                          Text(
                                                              SiteSabit.adress!,
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
      ),
    );
  }
}

class dropDown extends StatefulWidget {
  const dropDown({super.key, required this.sec});
  final String sec;
  @override
  State<dropDown> createState() => _dropDownState();
}

class _dropDownState extends State<dropDown> {
  String asd = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asd = widget.sec;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 25, right: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  padding: EdgeInsets.only(left: 8),
                  value: asd,
                  items: Ctanim.sifreGondermeSecenekleri
                      .map((e) =>
                          DropdownMenuItem<String>(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value1) {
                    setState(() {
                      asd = value1!;
                      Ctanim.seciliSifreGonderme.value = asd;
                    });

                  
                  })),
        ),
      ),
    );
  }
}
