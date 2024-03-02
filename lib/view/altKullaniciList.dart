import 'dart:developer';

import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/model/altKullaniciModel.dart';
import 'package:b2b/model/cariModel.dart';
import 'package:b2b/servis/servis.dart';
import 'package:b2b/view/webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AltKullaniciList extends StatefulWidget {
  const AltKullaniciList({super.key});

  @override
  State<AltKullaniciList> createState() => _AltKullaniciListState();
}

class _AltKullaniciListState extends State<AltKullaniciList> {
  final _formKey = GlobalKey<FormState>();
  List<AltKullaniciModel> tempList = [];
  bool veriYok = false;
  TextEditingController aranacak = TextEditingController();
  Servis servis = Servis();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tempList.add(AltKullaniciModel(
        aKod: Ctanim.cari!.kod,
        adi: Ctanim.cari!.adi!+"(Ana Kullanıcı)",
        guid: Ctanim.cari!.guid,
        mail: Ctanim.cari!.mail,
        tel: Ctanim.cari!.tel
    ));
    tempList.addAll(Ctanim.altKullaniciList);
  }

  void searchB(String aranan) {
    tempList.clear();
    if(aranan == ""){
    if (Ctanim.altKullaniciList.isEmpty) {
      veriYok = true;
    } else {
      veriYok = false;
         tempList.add(AltKullaniciModel(
        aKod: Ctanim.cari!.kod,
        adi: Ctanim.cari!.adi!+"(Ana Kullanıcı)",
        guid: Ctanim.cari!.guid,
        mail: Ctanim.cari!.mail,
        tel: Ctanim.cari!.tel
    ));

      tempList.addAll(Ctanim.altKullaniciList);
    }
    }else{
      var result = Ctanim.altKullaniciList.where((element) => element.adi!.toLowerCase().contains(aranan.toLowerCase()) || element.aKod!.toLowerCase().contains(aranan.toLowerCase())).toList();
      if(result.isEmpty){
        veriYok = true;
      }else{
        veriYok = false;
        tempList.addAll(result);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
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
                    builder: (BuildContext context) {
                      return WebViewApp(
                        url: url,
                      );
                    },
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ))
        ],
        backgroundColor: Colors.white,
        title: Text(
          "Alt Kullanıcılar",
          style: TextStyle(color: Colors.black, fontFamily: "OpenSans"),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 10),
              child: TextFormField(
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (newValue) async {
                  searchB(newValue);
                  setState(() {});
                
                   
                },
                controller: aranacak,
                style: TextStyle(color: Colors.white),
                cursorColor: Color(0xFF00b8a6),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.7),
                  suffixIcon: IconButton(icon:Icon(Icons.search),onPressed: () async {
                  searchB(aranacak.text);
                  setState(() {});
                    
                  },),
                  hintText: 'Aramak İstediğiniz Cari Adı/Kodu Giriniz',
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
          ),
          veriYok == false ?  Expanded(
            child: ListView.builder(
              itemCount: tempList.length,
              itemBuilder: (context, index) {
                AltKullaniciModel altKullanici = tempList[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if(index>0){
                          Ctanim.anaKullaniciID = Ctanim.cari!.guid!;
                        }else{
                         altKullanici.guid= Ctanim.anaKullaniciID == "" ? Ctanim.cari!.guid! : Ctanim.anaKullaniciID;
                        }

                        Ctanim.cari!.guid = altKullanici.guid;
                        if (Ctanim.internet) {
                       servis.postCari(
                      plasiyerGuid: Ctanim.PlasiyerGuid ?? "",
                      cariGuid: Ctanim.cari!.guid ?? "");
                        }
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
                            builder: (BuildContext context) {
                              return WebViewApp(
                                url: url,
                              );
                            },
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              altKullanici.aKod!,
                              style: TextStyle(
                                  fontSize: 14, fontFamily: "OpenSans",fontWeight: FontWeight.bold),
                            ),
                            
                            Text(
                              altKullanici.adi!,
                              style: TextStyle(fontFamily: "OpenSans",fontSize: 14,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        leading: Padding(
                          padding:  EdgeInsets.only(top:19),
                          child: Icon(Icons.person),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tel: "+altKullanici.tel!,
                              style: TextStyle(fontFamily: "OpenSans"),
                            ),
                            Text(
                            altKullanici.mail!,
                              style: TextStyle(fontFamily: "OpenSans"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    )
                  ],
                );
              },
            ),
          ):Center(child: Text("Veri Yok"),),
        ],
      ),
    );
  }
}
