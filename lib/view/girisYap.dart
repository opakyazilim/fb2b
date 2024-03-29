import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/servis/servis.dart';
import 'package:b2b/servis/sharedPrefsHelper.dart';
import 'package:b2b/view/alertDiyalog.dart';
import 'package:b2b/view/smsDogrulama.dart';
import 'package:b2b/view/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class girisYap extends StatefulWidget {
  const girisYap(
      {super.key,
      required this.kulAdi,
      required this.sifre,
      required this.beniHatirla});
  final String kulAdi;
  final String sifre;
  final bool beniHatirla;

  @override
  State<girisYap> createState() => _girisYapState();
}

class _girisYapState extends State<girisYap> {
  bool _isChecked = false;

  TextEditingController kullaniciAdi = TextEditingController(text: "");
  TextEditingController sifre = TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.kulAdi != "" &&
        widget.sifre != "" &&
        widget.beniHatirla == true) {
      _isChecked = widget.beniHatirla;
      kullaniciAdi.text = widget.kulAdi;
      sifre.text = widget.sifre;

      setState(() {});
    } else {
      _isChecked = false;
      kullaniciAdi.text = "";
      sifre.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/wer2.jpg"), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
        
  
              children: [
                SizedBox(
                  height:MediaQuery.of(context).size.height * 0.2,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
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
                          Ctanim.translate(SiteSabit.FirmaAdi!
                                  .replaceAll("B2B", "")
                                  .replaceAll("b2b", "")
                                  .replaceAll("B4B", "")
                                  .replaceAll("b4b", "") +
                              " B2B'ye Hoş Geldiniz"),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: "OpenSans",
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Ctanim.translate("Lütfen Giriş Yapın"),
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
                      hintText: Ctanim.translate('Kullanıcı Adı'),
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
                      hintText: Ctanim.translate('Parola'),
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
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: CheckboxListTile(
                      title: Text(
                        Ctanim.translate('Beni Hatırla'),
                        style: TextStyle(
                            color: Colors.white, fontFamily: "OpenSans"),
                      ),
                      controlAffinity: ListTileControlAffinity.trailing,
                      side: BorderSide(color: Colors.white, width: 2),
                      checkColor: Colors.teal,
                      activeColor: Colors.white,
                      value: _isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isChecked = newValue ?? false;
                        });
                      },
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
                        Ctanim.internet = await Servis.internetDene();
                        if (Ctanim.internet) {
                          if (sifre.text == "" || kullaniciAdi.text == "") {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return CustomAlertDialog(
                                  title: "Hata ",
                                  message: "Kullanıcı adı veya şifre boş.",
                                  onPres: () {
                                    Navigator.pop(context);
                                  },
                                  buttonText: "Geri",
                                  textColor: Colors.red,
                                );
                              },
                            );
                          } else {
                            Servis servis = Servis();
          
                            bool donusDegeri = await servis.login(
                                kullaniciAdi: kullaniciAdi.text,
                                sifre: sifre.text);
          
                            if (donusDegeri == true) {
                              var _id;
          
                              if (Ctanim.internet) {
                                MethodChannel _channel = const MethodChannel(
                                    'OneSignal#pushsubscription');
                                _id = await _channel
                                    .invokeMethod("OneSignal#pushSubscriptionId");
                                SharedPrefsHelper.saveStringToSharedPreferences(
                                    "oneSignalID", _id);
                              }
                              Ctanim.oneSignalKey = _id;
                              await servis.postCari(
                                  plasiyerGuid: Ctanim.PlasiyerGuid ?? "",
                                  cariGuid: Ctanim.cari!.guid ?? "");
          
                              if (Ctanim.cari!.guid != "") {
                                var url = Uri.https(
                                  SiteSabit.Link!,
                                  '/Login/MobilGiris',
                                  {
                                    'Guid': Ctanim.cari!.guid,
                                    'PlasiyerGuid': Ctanim.PlasiyerGuid,
                                  },
                                );
          
                                await SharedPrefsHelper.saveUser(Ctanim.cari!);
                                await SharedPrefsHelper
                                    .saveStringToSharedPreferences(
                                        "plasiyerGuid", Ctanim.PlasiyerGuid!);
          
                                if (_isChecked == true) {
                                  SharedPrefsHelper.saveStringToSharedPreferences(
                                      "kulAdi", kullaniciAdi.text);
                                  SharedPrefsHelper.saveStringToSharedPreferences(
                                      "sifre", sifre.text);
                                  SharedPrefsHelper.saveBoolToSharedPreferences(
                                      "beniHatirla", _isChecked);
                                } else {
                                  SharedPrefsHelper.saveBoolToSharedPreferences(
                                      "beniHatirla", _isChecked);
                                }
                                await servis.getMenu(
                                    cariGuid: Ctanim.cari!.guid!,
                                    plasiyerGuid: Ctanim.PlasiyerGuid!);
                                if (Ctanim.SmsKodu == "") {
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
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SmsDogrulama(
                                                phoneNumber: Ctanim.cari!.tel!,
                                                url: url,
                                              )));
                                }
                              } else {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      title: "Hata ",
                                      message: "Kullanıcı adı veya şifre yanlış.",
                                      onPres: () {
                                        Navigator.pop(context);
                                      },
                                      buttonText: "Geri",
                                      textColor: Colors.red,
                                    );
                                  },
                                );
                              }
                            } else {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    title: "Hata ",
                                    message: "Kullanıcı bilgileri çekilemedi.",
                                    onPres: () {
                                      Navigator.pop(context);
                                    },
                                    buttonText: "Geri",
                                    textColor: Colors.red,
                                  );
                                },
                              );
          
                              /*
                              
                              */
                            }
                          }
                        } else {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                title: "Hata ",
                                message:
                                    "Aktif İnternet Bağlantısı Bulunamadı. Tekrar Deneyin.",
                                onPres: () {
                                  Navigator.pop(context);
                                },
                                buttonText: "Geri",
                                textColor: Colors.red,
                              );
                            },
                          );
                        }
                      },
                      child: Text(Ctanim.translate('Giriş'),
                          style: TextStyle(
                              color: const Color(0xFF00b8a6), fontSize: 17)),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          primary: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
