import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/model/FTreeView.dart';
import 'package:b2b/model/FTreeViewForPlasiyerCariMenu.dart';

import 'package:b2b/model/kategoriModel.dart';
import 'package:b2b/model/kategoriModelDeneme.dart';

import 'package:b2b/model/cariVePlasiyerMenuModel.dart';
import 'package:b2b/view/webviewStack.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class deneme extends StatefulWidget {
  const deneme({super.key, required this.controller});
  final WebViewController controller;

  @override
  State<deneme> createState() => _denemeState();
}

class _denemeState extends State<deneme> {
  List<Widget> expensionList = [];

  /// Your server data
  /// 
  /// 

  KategoriModelDeneme mapServerDataToTreeData(Map data) {
    return KategoriModelDeneme(
      id: data['Id'],
      extra: data,
      adi: data['Adi'],
      AltKategori:
          List.from(data['AltKategori'].map((x) => mapServerDataToTreeData(x))),
    );
  }

  CariVePlasiyerMenuModel mapServerDataToTreeDataForCariPlasiyer(Map data) {
    return CariVePlasiyerMenuModel(
      id: data['Id'],
      extra: data,
      adi: data['Adi'],
      AltMenuler: List.from(data['AltMenuler']
          .map((x) => mapServerDataToTreeDataForCariPlasiyer(x))),
      url: data['Url'],
    );
  }

/*
  Widget icIceGelenJsonTuran(KategoriModel data) {
    List<Widget> listTile = [];

    bool altiVarMi = false;
    if (data.AltKategori.isNotEmpty) {
      altiVarMi = true;
    }
    bool tralingAcik = false;

    return altiVarMi == false
        ? ListTile(
            title: Text(data.adi!),
            onTap: () {
              print(data.adi);
            },
          )
        : GestureDetector(
            onTap: () {
              print(data.adi);
            },
            child: ExpansionTile(
              childrenPadding: EdgeInsets.only(left: 20),
              title: Text(data.adi!),
              maintainState: true,
              trailing: IconButton(
                icon: tralingAcik == false
                    ? Icon(Icons.keyboard_arrow_down)
                    : Icon(Icons.keyboard_arrow_up),
                onPressed: () {
                  setState(() {
                    tralingAcik = !tralingAcik;
                  });
                },
              ),
              onExpansionChanged: (value) {
                print("VALUEEEE" + value.toString());
                if (tralingAcik == false && value == false) {
                  print("LİNK");
                } else {
                  listTile.clear();
                  for (var el in data.AltKategori) {
                    listTile.add(icIceGelenJsonTuran(el));
                  }
                }
              },
              children: listTile,
            ),
          );
  }

  Widget ayriAyriGelenTuran(KategoriModel data) {
    List<Widget> listTile = [];

    bool altiVarMi =
        Ctanim.listKategori.any((element) => element.ustId == data.id);

    return altiVarMi == false
        ? ListTile(
            title: Text(data.adi!),
            onTap: () {
              print(data.adi);
            },
          )
        : ExpansionTile(
            childrenPadding: EdgeInsets.only(left: 20),
            title: Text(data.adi!),
            onExpansionChanged: (value) {
              listTile.clear();
              List<KategoriModel> list = Ctanim.listKategori
                  .where((element) => element.ustId == data.id)
                  .toList();
              for (var el in list) {
                listTile.add(ayriAyriGelenTuran(el));
              }
            },
            children: listTile,
          );
  }
  */
  int plasiyerMenuLength = 0;
  int cariMenuLength = 0;
  List<KategoriModelDeneme> treeData = [];
  List<CariVePlasiyerMenuModel> treeDataCari = [];
  List<CariVePlasiyerMenuModel> treeDataPlasiyer = [];
  ScrollController? _controller;
  double sayac = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ScrollController();
    print(Ctanim.listKategori);
    treeData = List.generate(
      Ctanim.gelenKategoriJson.length,
      (index) => mapServerDataToTreeData(Ctanim.gelenKategoriJson[index]),
    );
    treeDataCari = List.generate(
      Ctanim.gelenCariMenuJson.length,
      (index) => mapServerDataToTreeDataForCariPlasiyer(
          Ctanim.gelenCariMenuJson[index]),
    );
    treeDataPlasiyer = List.generate(
      Ctanim.gelenPlasiyerMenuJson.length,
      (index) => mapServerDataToTreeDataForCariPlasiyer(
          Ctanim.gelenPlasiyerMenuJson[index]),
    );

    Ctanim.listKategori.clear();
    Ctanim.listKategori.addAll(treeData);

    for (var el in treeDataPlasiyer) {
      plasiyerMenuLength += el.AltMenuler.length;
    }
    for (var el in treeDataCari) {
      cariMenuLength += el.AltMenuler.length;
    }
    if(plasiyerMenuLength <3){
      plasiyerMenuLength = 15;
    }
    if(cariMenuLength <3){
      cariMenuLength = 15;
    }

    kategoriIsExpand = true;

    if (Ctanim.secilKategoriID != -1) {
      int aa = treeData
          .indexWhere((element) => element.id == Ctanim.secilKategoriID);
      if (aa == -1) {
        treeData.asMap().forEach((index, element) {
          if (element.AltKategori.any(
              (el1) => el1.id == Ctanim.secilKategoriID)) {
            aa = index;
            return;
          }
        });
      }
      print("SAYACCCC " + sayac.toString());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller!.animateTo(
          aa * MediaQuery.of(context).size.height * 0.05,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      });
    }

/*
    for (var el in Ctanim.listKategori) {
      if (el.ustId == 0) {
        expensionList.add(ayriAyriGelenTuran(el));
      }
    }
    */
    /*
    for(var el in Ctanim.listKategori){
        expensionList.add(icIceGelenJsonTuran(el));
    }
    */
  }

  bool plasiyerIsExpand = false;
  bool cariIsExpand = false;
  bool kategoriIsExpand = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Ctanim.drawerWidth,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: Ctanim.drawerWidth / 1.5,
                      child: Image.asset("assets/logo.png"),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      scaffoldKey.currentState!.closeDrawer();
                    },
                    icon: Icon(Icons.arrow_back_ios_outlined),
                  )
                ],
              ),
              Divider(
                height: 3,
                thickness: 2,
                color: Colors.grey,
              ),
              Ctanim.cariMenuGoster == true
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: Ctanim.drawerWidth / 1.5,
                            child: yanBaslik(
                              title: Ctanim.translate("Cari Menü"),
                              icon: Icons.account_balance_wallet_outlined,
                              color: const Color.fromARGB(255, 15, 89, 149),
                            ),
                          ),
                          SizedBox(
                              width: Ctanim.drawerWidth / 5,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      cariIsExpand = !cariIsExpand;
                                      plasiyerIsExpand = false;
                                      kategoriIsExpand = false;
                                    });
                                  },
                                  icon: Icon(cariIsExpand == false
                                      ? Icons.arrow_drop_down
                                      : Icons.arrow_drop_up)))
                        ],
                      ),
                    )
                  : Container(),
              Ctanim.cariMenuGoster == true && cariIsExpand == true
                  ? SizedBox(
                
                      child: FTreeViewForPlasiyerCariMenu(
                        data: treeDataCari,
                        controller: widget.controller,
                      ))
                  : Container(),
              Ctanim.cariMenuGoster == true
                  ? Divider(
                      height: 5,
                      thickness: 1,
                      color: Colors.grey,
                    )
                  : Container(),
              Ctanim.plasiyerMenuGoster == true
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: Ctanim.drawerWidth / 1.5,
                            child: yanBaslik(
                              title: Ctanim.translate("Plasiyer Menü"),
                              icon: Icons.account_circle_outlined,
                              color: const Color.fromARGB(255, 32, 141, 36),
                            ),
                          ),
                          SizedBox(
                              width: Ctanim.drawerWidth / 5,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      plasiyerIsExpand = !plasiyerIsExpand;
                                      cariIsExpand = false;
                                      kategoriIsExpand = false;
                                    });
                                  },
                                  icon: Icon(plasiyerIsExpand == false
                                      ? Icons.arrow_drop_down
                                      : Icons.arrow_drop_up)))
                        ],
                      ),
                    )
                  : Container(),
              Ctanim.plasiyerMenuGoster == true && plasiyerIsExpand == true
                  ? SizedBox(
                 
                      child: FTreeViewForPlasiyerCariMenu(
                        data: treeDataPlasiyer,
                        controller: widget.controller,
                      ))
                  : Container(),
              Ctanim.plasiyerMenuGoster == true
                  ? Divider(
                      height: 5,
                      thickness: 1,
                      color: Colors.grey,
                    )
                  : Container(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Ctanim.drawerWidth / 1.5,
                      child: yanBaslik(
                        title: Ctanim.translate("Kategoriler"),
                        icon: Icons.category_outlined,
                        color: const Color.fromARGB(255, 211, 159, 4),
                      ),
                    ),
                    SizedBox(
                        width: Ctanim.drawerWidth / 5,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                kategoriIsExpand = !kategoriIsExpand;
                                cariIsExpand = false;
                                plasiyerIsExpand = false;
                              });
                            },
                            icon: Icon(kategoriIsExpand == false
                                ? Icons.arrow_drop_down
                                : Icons.arrow_drop_up)))
                  ],
                ),
              ),
              kategoriIsExpand == false
                  ? Divider(
                      height: 5,
                      thickness: 1,
                      color: Colors.grey,
                    )
                  : Container(),
              kategoriIsExpand == true
                  ? FTreeView(
                      load: (parent) {
                        return Future.value(treeData
                            .where((element) => element.id == parent.id)
                            .first
                            .AltKategori);
                      },
                      data: treeData,
                      controller: widget.controller,
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
/*
      child: SingleChildScrollView(
        child: Column(
          children: expensionList,
        ),
      ),
      */

class yanBaslik extends StatelessWidget {
  const yanBaslik({
    super.key,
    this.title,
    required this.color,
    required this.icon,
  });
  final title;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * .035,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans'),
      ),
    );
  }
}
