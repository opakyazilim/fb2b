import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/model/cariModel.dart';
import 'package:b2b/view/webview.dart';
import 'package:flutter/material.dart';

class CariRehberList extends StatefulWidget {
  const CariRehberList({super.key});

  @override
  State<CariRehberList> createState() => _CariRehberListState();
}

class _CariRehberListState extends State<CariRehberList> {
  List<Cari> tempList = [];
  TextEditingController aranacak = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tempList.addAll(Ctanim.cariRehberList);
  }
    void searchB(String query) {
      tempList.clear();
    if (query.isEmpty) {
      tempList.addAll(Ctanim.cariRehberList);
    } else {
     
      var results = Ctanim.cariRehberList
          .where((value) =>
              value.adi!.toLowerCase().contains(query.toLowerCase()) ||
              value.kod!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      tempList.addAll(results);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
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
            return WebViewApp(url: url,); 
              },
            ),
            (Route<dynamic> route) => false, 
          );
          }, icon: Icon(Icons.arrow_back,color: Colors.black,))
        ],
        backgroundColor: Colors.white,
        title: Text("Cari Rehber",style: TextStyle(color: Colors.black,fontFamily: "OpenSans"),),
        elevation: 0,
        
      ),
      body: Column(
        children: [
          SizedBox(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child:  Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20,bottom: 10),
                child: TextFormField(
                  onChanged: (value){
                    searchB(aranacak.text);
                    setState(() {
                      
                    });

                  },
                  controller: aranacak,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Color(0xFF00b8a6),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.7),
                    prefixIcon: Icon(Icons.search),
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
          Expanded(
            child: ListView.builder(
              itemCount: tempList.length,
              itemBuilder:(context, index) {
               Cari cari = tempList[index];
                return Column(
          children: [
              GestureDetector(
            onTap: (){
              Ctanim.cari = cari;
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
            return WebViewApp(url: url,); 
              },
            ),
            (Route<dynamic> route) => false, 
          );
            },
            child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cari.kod!,style: TextStyle(fontSize: 17,fontFamily: "OpenSans"),),
                SizedBox(height: 10,),
                Text(cari.adi!,style: TextStyle(fontFamily: "OpenSans"),),
                
              ],
            ),
            leading: Icon(Icons.person),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cari.tel!,style: TextStyle(fontFamily: "OpenSans"),),
                SizedBox(height: 10,),
                Text("Güncel Bakiye"+ cari.bakiye.toString(),style: TextStyle(fontFamily: "OpenSans"),)
              ],
            ),
            ),
              ),
            Divider(thickness: 2,indent: 20,endIndent: 20,)
          ],
                );
              
            },),
          ),
        ],
      ),
    );
  }
}