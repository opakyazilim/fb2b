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
    String? plasiyerGuid =
        await SharedPrefsHelper.getStringFromSharedPreferences("plasiyerGuid");
    setState(() {
      Ctanim.cari = cari;
      Ctanim.PlasiyerGuid = plasiyerGuid;
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
  Servis servis = Servis();

  @override
  Widget build(BuildContext context) {
    print("EKRAN "+ MediaQuery.of(context).size.height.toString());
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
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/b1.jpeg"),
                          fit: BoxFit.fitHeight),
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
                                        top: bottomAcikMi == false
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .23
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .1,
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
                                        child: Image.asset("assets/logo.png"),
                                      ),
                                    )),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 30, top: 40),
                                  child: SizedBox(
                                      width: 11600,
                                      child: Text(
                                       Ctanim.translate(SiteSabit.FirmaAdi! + " B2B'ye Hoş Geldiniz"),
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
                                        : Ctanim.translate("İyi Çalışmalar"),
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
                                         Ctanim.translate("Giriş"),
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
                                          onPressed: () async {
                                            var yeniUrl = Uri.parse("https://" +
                                                SiteSabit.Link! +
                                                "/" +
                                                Ctanim.menuList[index].url!);

                                            if (yeniUrl
                                                .toString()
                                                .toLowerCase()
                                                .contains("sifremiunuttum")) {
                                              print("abc");
                                              Servis servis = Servis();

                                              await sifremiUnuttumWidget(
                                                  context, servis);
                                            } else if (yeniUrl
                                                .toString()
                                                .toLowerCase()
                                                .contains("misafirgirisi")) {
                                              Servis servis = Servis();
                                              bool donusDegeri =
                                                  await servis.login(
                                                      kullaniciAdi:
                                                          "MobilMisafirGirisi",
                                                      sifre: "311574007");
                                              if (donusDegeri == true) {
                                                var url = Uri.https(
                                                  SiteSabit.Link!,
                                                  '/Login/MobilGiris',
                                                  {
                                                    'Guid': Ctanim.cari!.guid,
                                                    'PlasiyerGuid':
                                                        Ctanim.PlasiyerGuid,
                                                  },
                                                );
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return WebViewApp(
                                                        url: url,
                                                      );
                                                    },
                                                  ),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              } else {
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CustomAlertDialog(
                                                      title: "Hata ",
                                                      message:
                                                          Ctanim.translate("Misafir Girişi Engellendi"),
                                                      onPres: () {
                                                        Navigator.pop(context);
                                                      },
                                                      buttonText: Ctanim.translate("Geri"),
                                                      textColor: Colors.red,
                                                    );
                                                  },
                                                );
                                              }
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
                                            Ctanim.translate(Ctanim.menuList[index].adi!),
                                            style: TextStyle(
                                                color: genelColor,
                                                fontSize: 16),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: bottomAcikMi == false
                                          ? MediaQuery.of(context).size.height *
                                              .124
                                          : MediaQuery.of(context).size.height *
                                              .151),
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
                                                      Ctanim.translate("Bize Ulaşın"),
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
                                                       Ctanim.translate("Mail Adresimiz"),
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
                                                    child: Text(Ctanim.translate("Firma Adresi"),
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
                                                            Ctanim.Telefon!,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "OpenSans",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .27,
                                                          ),
                                                          TextButton(
                                                              onPressed: () {
                                                                _copyToClipboard(
                                                                    Ctanim.Telefon!);
                                                              },
                                                              child: Text(
                                                                  Ctanim.translate("Kopyala!"),))
                                                        ],
                                                      )
                                                    : Container(),
                                                mailAcikMi == true
                                                    ? Column(
                                                        children: [
                                                          Text(Ctanim.Mail!,
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
                                                                    Ctanim.Mail!);
                                                              },
                                                              child:  Text(
                                                                 Ctanim.translate("Kopyala!")))
                                                        ],
                                                      )
                                                    : Container(),
                                                adresAcikMi == true
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .8,
                                                            child: Text(
                                                                maxLines: 3,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                Ctanim.Adres!,
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
                                                          TextButton(
                                                              onPressed: () {
                                                                _copyToClipboard(
                                                                    Ctanim.Adres!);
                                                              },
                                                              child: Text(
                                                                 Ctanim.translate("Kopyala!")))
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

  Future<dynamic> sifremiUnuttumWidget(BuildContext context, Servis servis) {
    return showModalBottomSheet(
      backgroundColor: Color.fromARGB(255, 171, 242, 255).withOpacity(0.9),
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            image: DecorationImage(
                image: AssetImage("assets/s7.jpg"), fit: BoxFit.cover),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                thickness: 3,
                indent: 150,
                endIndent: 150,
                color: Colors.grey,
              ),
              dropDown(sec: Ctanim.seciliSifreGonderme.value),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Obx(
                  () => TextFormField(
                    keyboardType:
                        Ctanim.seciliSifreGonderme.value == "Mail İle Gönder"
                            ? TextInputType.emailAddress
                            : Ctanim.seciliSifreGonderme.value ==
                                    "Telefon Numarası İle Gönder"
                                ? TextInputType.phone
                                : Ctanim.seciliSifreGonderme.value ==
                                        "Kullanıcı Adi İle Gönder"
                                    ? TextInputType.name
                                    : TextInputType.text,
                    controller: sifremiUnuttum,
                    style: TextStyle(color: Colors.black87),
                    cursorColor: Color(0xFF00b8a6),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.7),
                      prefixIcon:
                          Ctanim.seciliSifreGonderme.value == "Mail İle Gönder"
                              ? Icon(Icons.mail)
                              : Ctanim.seciliSifreGonderme.value ==
                                      "Telefon Numarası İle Gönder"
                                  ? Icon(Icons.phone)
                                  : Ctanim.seciliSifreGonderme.value ==
                                          "Kullanıcı Adi İle Gönder"
                                      ? Icon(Icons.person)
                                      : Icon(Icons.abc),
                      hintText:
                          Ctanim.seciliSifreGonderme.value == "Mail İle Gönder"
                              ? Ctanim.translate("Mail Adresinizi Giriniz")
                              : Ctanim.seciliSifreGonderme.value ==
                                      "Telefon Numarası İle Gönder"
                                  ?Ctanim.translate("Telefon Numaranızı Giriniz")
                                  : Ctanim.seciliSifreGonderme.value ==
                                          "Kullanıcı Adi İle Gönder"
                                      ? Ctanim.translate("Kullanıcı Adınızı Giriniz")
                                      : "",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 80, 79, 79)),
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Text(
                  Ctanim.translate("Not: Gireceğiniz mail adresine tarafımızca şifreniz gönderilecekir."),
                  style: TextStyle(fontFamily: "OpenSans"),
                ),
              ),
              
              Padding(
                padding: EdgeInsets.only(
                    top: 20,
                    left: MediaQuery.of(context).size.width * .25,
                    right: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    Ctanim.internet = await Servis.internetDene();
                    if(Ctanim.internet){
                              if (sifremiUnuttum.text == "") {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            title: Ctanim.translate("Hata"),
                            message: Ctanim.translate("Şifre Gönderilecek Alan Adı Boş."),
                            onPres: () {
                              Navigator.pop(context);
                            },
                            buttonText: Ctanim.translate("Geri"),
                            textColor: Colors.red,
                          );
                        },
                      );
                    } else {
                      List<dynamic> donen = [];
                      Image.asset("assets/ee1.gif");
                      if (Ctanim.seciliSifreGonderme.value ==
                          "Mail İle Gönder") {
                        donen = await servis.sifremiUnuttum(
                            mail: sifremiUnuttum.text,
                            kullaniciAdi: "",
                            telefon: "");
                      } else if (Ctanim.seciliSifreGonderme.value ==
                          "Kullanıcı Adi İle Gönder") {
                        await servis.sifremiUnuttum(
                            mail: "",
                            kullaniciAdi: sifremiUnuttum.text,
                            telefon: "");
                      } else {
                        await servis.sifremiUnuttum(
                            mail: "",
                            kullaniciAdi: "",
                            telefon: sifremiUnuttum.text);
                      }

                      if (donen.length < 1) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              title: Ctanim.translate("Hata"),
                              message:Ctanim.translate("Böyle Bir Kullanıcı Yok") ,
                              onPres: () {
                                Navigator.pop(context);
                              },
                              buttonText: Ctanim.translate("Geri"),
                              textColor: Colors.red,
                            );
                          },
                        );
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(32.0))),
                                insetPadding: EdgeInsets.zero,
                                title: Text(
                                  donen[0] == true ? Ctanim.translate("Hata") : Ctanim.translate("Başarılı"),
                                  style: TextStyle(fontSize: 17),
                                ),
                                content: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(donen[1]),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.5,
                                            height: 50,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 4),
                                              child: ElevatedButton(
                                                  child: Text(
                                                    Ctanim.translate("Tamam"),
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          foregroundColor:
                                                              genelColor,
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  30,
                                                                  38,
                                                                  45),
                                                          shadowColor:
                                                              Colors.black,
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0)),
                                                          )),
                                                  onPressed: () {
                                                    if (donen[0] == false) {
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              anasayfa(),
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

                    }else{
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                title: Ctanim.translate("Hata"),
                                message: Ctanim.translate("Aktif İnternet Bağlantısı Bulunamadı. Tekrar Deneyin."),
                                onPres: () {
                                  Navigator.pop(context);
                                },
                                buttonText: Ctanim.translate("Geri"),
                                textColor: Colors.red,
                              );
                            },
                          );
                    }
            
                  },
                  child: Text(
                   Ctanim.translate( "Şifremi Gönder"),
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      primary: Color.fromARGB(255, 248, 247, 247)),
                ),
              )
            ],
          ),
        );
      },
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
                          DropdownMenuItem<String>(value: e, child: Text(Ctanim.translate(e))))
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
