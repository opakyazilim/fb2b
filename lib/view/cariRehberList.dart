import 'dart:developer';

import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/model/cariModel.dart';
import 'package:b2b/servis/servis.dart';
import 'package:b2b/view/webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class CariRehberList extends StatefulWidget {
  const CariRehberList({super.key});

  @override
  State<CariRehberList> createState() => _CariRehberListState();
}

class _CariRehberListState extends State<CariRehberList> {
  final _formKey = GlobalKey<FormState>();
  List<Cari> tempList = [];
  bool veriYok = false;
  TextEditingController aranacak = TextEditingController();
  Servis servis = Servis();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tempList.addAll(Ctanim.cariRehberList);
  }

  void searchB() {
    tempList.clear();
    if (Ctanim.cariRehberList.isEmpty) {
     veriYok = true;
    } else {
      veriYok = false;
     
      tempList.addAll(Ctanim.cariRehberList);
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
          "Cari Rehber",
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
                 
                     await servis.getCariRehber(plasiyerGuid: Ctanim.PlasiyerGuid!,arama: aranacak.text);
                  searchB();
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
                      await servis.getCariRehber(plasiyerGuid: Ctanim.PlasiyerGuid!,arama: aranacak.text);
                  searchB();
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
                Cari cari = tempList[index];
                MoneyFormatter fmf = MoneyFormatter(
    amount: cari.bakiye ?? 0.0,
    settings: MoneyFormatterSettings(
      thousandSeparator: ".",
      decimalSeparator: ","
    )
);

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Ctanim.cari = cari;
                        if (Ctanim.internet) {
                       servis.postCari(
                      plasiyerGuid: Ctanim.PlasiyerGuid ?? "",
                      cariGuid: Ctanim.cari!.guid ?? "");
                        }
                        var url = Uri.https(
                          SiteSabit.Link!,
                          '/Login/MobilGiris',
                          {
                            'Guid': cari.guid,
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
                              cari.kod!,
                              style: TextStyle(
                                  fontSize: 14, fontFamily: "OpenSans",fontWeight: FontWeight.bold),
                            ),
                            
                            Text(
                              cari.adi!,
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
                              "Tel: "+cari.tel!,
                              style: TextStyle(fontFamily: "OpenSans"),
                            ),
                            Text(
                            cari.il != "" && cari.ilce != ""?  cari.il!+" / "+cari.ilce! :cari.il!+cari.ilce!  ,
                              style: TextStyle(fontFamily: "OpenSans"),
                            ),
                            
                            Text(
                              "Güncel Bakiye: " + fmf.output.nonSymbol,
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
