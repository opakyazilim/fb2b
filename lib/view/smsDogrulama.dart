
import 'dart:async';

import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/servis/sharedPrefsHelper.dart';
import 'package:b2b/view/anasayfa.dart';
import 'package:b2b/view/webview.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
class SmsDogrulama extends StatefulWidget {
  const SmsDogrulama({
    Key? key,
    required this.phoneNumber, required this.url,
  }) : super(key: key);

  final String? phoneNumber;
  final Uri? url ;

  @override
  State<SmsDogrulama> createState() =>
      _SmsDogrulamaState();
}

class _SmsDogrulamaState extends State<SmsDogrulama> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    SharedPrefsHelper.saveBoolToSharedPreferences("sms", true);
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }
    String cleanPhoneNumber(String phoneNumber) {
  phoneNumber = phoneNumber.replaceAll(' ', '').replaceAll('-', '');
  phoneNumber = phoneNumber.replaceAll('+', '');
  
  if (phoneNumber.length < 10) {
    return maskPhoneNumber('+90' + phoneNumber);
  }
  else if (phoneNumber.startsWith('+90') && phoneNumber.length == 12) {
    return maskPhoneNumber(phoneNumber);
  }
 else  if (phoneNumber.startsWith('0')) {
    phoneNumber = "+9" + phoneNumber;
    return maskPhoneNumber(phoneNumber);
  }
else   if (phoneNumber.length == 10) {
    return maskPhoneNumber('+90' + phoneNumber);
  }

  return maskPhoneNumber(phoneNumber);
}
String maskPhoneNumber(String phoneNumber) {
  // Telefon numarasının uzunluğunu kontrol et
  if (phoneNumber.length != 13) {
    // Geçersiz bir numara olduğunda orijinal numarayı geri döndür
    return phoneNumber;
  }

  // Telefon numarasının ilk iki hanesi ve son iki hanesini al
  String countryCode = phoneNumber.substring(0, 3);
  String lastTwoDigits = phoneNumber.substring(11);

  // Yıldız karakteriyle aynı uzunlukta bir dize oluştur
  String stars = '*' * 9;

  // Son iki hane ile birleştir ve maskeleme yap
  String maskedPhoneNumber = '$countryCode$stars$lastTwoDigits';

  return maskedPhoneNumber;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFD6A4E1), // Açık Mor
              Colors.white,      // Beyaz
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 30),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Lottie.asset("assets/den1.json"),
                ),
              ),
               SizedBox(height: 8),
               Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                 Ctanim.translate('Lütfen doğrulama kodunu girin'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                    text: cleanPhoneNumber(widget.phoneNumber!),
                    spellOut: true,
                    children: [
                       TextSpan(
                        text: Ctanim.translate(' numarasına gönderilen 4 haneli kodu girin'),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    
                    ],
                   
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 30,
                  ),
                  child: PinCodeTextField(
                    autoFocus: true,
                    dialogConfig: DialogConfig(
                      dialogTitle: Ctanim.translate('Kodu Kopyala!'),
                      dialogContent: Ctanim.translate('Kopyalanmış metni yapıştırmak ister misiniz: '),
                      affirmativeText: Ctanim.translate('Yapıştır'),
                      negativeText: Ctanim.translate('İptal'),
                    ),
                    
                    
                    showCursor: false,
                    appContext: context,
                  
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,
                    blinkWhenObscuring: true,
                    animationType: AnimationType.scale,
                    /*
                    validator: (v) {
                      if (v!.length < 3) {
                        return "I'm from validator";
                      } else {
                        return null;
                      }
                    },
                    */
                    pinTheme: PinTheme(
                      activeColor: Color(0xFFD6A4E1),
                      inactiveColor: Colors.white60,
                      selectedColor: Colors.green,
                      disabledColor: Colors.red, 
                      inactiveFillColor: Colors.grey.shade100,
                      selectedFillColor: Colors.white,
                
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: MediaQuery.of(context).size.height / 12,
                      fieldWidth: MediaQuery.of(context).size.width / 7,
                      activeFillColor: Colors.white,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) {
                      debugPrint("Completed");
                      formKey.currentState!.validate();
                      // conditions for validating
                      if (currentText.length != Ctanim.SmsUzunluk || currentText != Ctanim.SmsKodu) {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        SharedPrefsHelper.saveBoolToSharedPreferences("sms", false);
                      
                        setState(
                          () {
                            hasError = false;
                          },
                        );
                                        var url = Uri.https(
                  SiteSabit.Link!,
                  '/Login/MobilGiris',
                  {
                    'Guid': Ctanim.cari!.guid,
                    'PlasiyerGuid': Ctanim.PlasiyerGuid,
                  },
                );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewApp(url: url,),
                ),
                (route) => false,
              );
                      }
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ?  Ctanim.translate("* Kod yanlış"): "",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    Ctanim.translate("Kodu almadınız mı?"),
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {
                         Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return anasayfa();
                    },
                  ),
                  (Route<dynamic> route) => false,
                );
                    },
                    child:  Text(
                     Ctanim.translate("Tekrar Giriş Yapın") ,
                      style: TextStyle(
                        color: Color(0xFF91D3B3),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              /*
              const SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                      // conditions for validating
                      if (currentText.length != 4 || currentText != "1234") {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        setState(
                          () {
                            hasError = false;
                            snackBar("Başarılı!!");
                          },
                        );
                      }
                    },
                    child: Center(
                      child: Text(
                        "VERIFY".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: const Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: const Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              */
              const SizedBox(
                height: 16,
              ),
              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: TextButton(
                      child: const Text("Clear"),
                      onPressed: () {
                        textEditingController.clear();
                      },
                    ),
                  ),
                  Flexible(
                    child: TextButton(
                      child: const Text("Set Text"),
                      onPressed: () {
                        setState(() {
                          textEditingController.text = "123456";
                        });
                      },
                    ),
                  ),
                ],
              )
              */
            ],
          ),
        ),
      ),
    );
  }
}