


import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/main.dart';
import 'package:b2b/servis/sharedPrefsHelper.dart';
import 'package:b2b/view/webviewStack.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'FTreeNodeForPlasiyerCariMenu.dart';
import 'cariVePlasiyerMenuModel.dart';

class FTreeViewForPlasiyerCariMenu extends StatefulWidget {



  final bool lazy;
  final Widget icon;
  final double offsetLeft;
  final bool showFilter;
  final bool showActions;
  final bool showCheckBox;
    final List<CariVePlasiyerMenuModel> data;

  final Function(CariVePlasiyerMenuModel node)? onTap;
  final void Function(CariVePlasiyerMenuModel node)? onLoad;
  final void Function(CariVePlasiyerMenuModel node)? onExpand;
  final void Function(CariVePlasiyerMenuModel node)? onCollapse;
  final void Function(bool checked, CariVePlasiyerMenuModel node)? onCheck;
  final void Function(
      CariVePlasiyerMenuModel node, CariVePlasiyerMenuModel parent)? onAppend;
  final void Function(
      CariVePlasiyerMenuModel node, CariVePlasiyerMenuModel parent)? onRemove;

  final CariVePlasiyerMenuModel Function(CariVePlasiyerMenuModel parent)?
      append;
  final Future<List<CariVePlasiyerMenuModel>> Function(
      CariVePlasiyerMenuModel parent)? load;
  final WebViewController controller;

  const FTreeViewForPlasiyerCariMenu({
    Key? key,
    required this.controller,
    required this.data,
    this.onTap,
    this.onCheck,
    this.onLoad,
    this.onExpand,
    this.onCollapse,
    this.onAppend,
    this.onRemove,
    this.append,
    this.load,
    this.lazy = false,
    this.offsetLeft = 24.0,
    this.showFilter = false,
    this.showActions = false,
    this.showCheckBox = false,
    this.icon = const Icon(Icons.expand_more, size: 16.0),
  }) : super(key: key);

  @override
  State<FTreeViewForPlasiyerCariMenu> createState() =>
      _FTreeViewForPlasiyerCariMenuState();
}

class _FTreeViewForPlasiyerCariMenuState
    extends State<FTreeViewForPlasiyerCariMenu> {
  late CariVePlasiyerMenuModel _root;
  List<CariVePlasiyerMenuModel> _renderList = [];

  List<CariVePlasiyerMenuModel> _filter(
      String val, List<CariVePlasiyerMenuModel> list) {
    List<CariVePlasiyerMenuModel> temp = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].adi!.contains(val)) {
        temp.add(list[i]);
      }
      if (list[i].AltMenuler.isNotEmpty) {
        list[i].AltMenuler = _filter(val, list[i].AltMenuler);
      }
    }
    return temp;
  }

  void _onChange(String val) {
    if (val.isNotEmpty) {
      _renderList = _filter(val, _renderList);
    } else {
      _renderList = widget.data;
    }
    setState(() {});
  }

  void append(CariVePlasiyerMenuModel parent) {
    parent.AltMenuler.add(widget.append!(parent));
    setState(() {});
  }

  void _remove(
      CariVePlasiyerMenuModel node, List<CariVePlasiyerMenuModel> list) {
    for (int i = 0; i < list.length; i++) {
      if (node == list[i]) {
        list.removeAt(i);
      } else {
        _remove(node, list[i].AltMenuler);
      }
    }
  }

  void remove(CariVePlasiyerMenuModel node) {
    _remove(node, _renderList);
    setState(() {});
  }

  Future<bool> load(CariVePlasiyerMenuModel node) async {
    try {
      final data = await widget.load!(node);
      node.AltMenuler = data;
      setState(() {});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _renderList = widget.data;
    _root = CariVePlasiyerMenuModel(
        adi: "root",
        id: 0,
        AltMenuler: widget.data,
        ustId: 0,
        aktif: true,
        url: "",
        iconUrl: "",
        htmlIcon: "",
        stoks: false,
        target: "", sira: 0 
        );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.showFilter)
            Padding(
              padding: const EdgeInsets.only(
                left: 18.0,
                right: 18.0,
                bottom: 12.0,
              ),
              child: TextField(onChanged: _onChange),
            ),
          ...List.generate(
            _renderList.length,
            (int index) {
              return FTreeNodeForPlasiyerCariMenu(
                load: load,
                remove: remove,
                append: append,
                parent: _root,
                data: _renderList[index],
                icon: _renderList[index].AltMenuler.isNotEmpty
                    ? widget.icon
                    : Container(),
                lazy: widget.lazy,
                offsetLeft: widget.offsetLeft,
                showCheckBox: widget.showCheckBox,
                showActions: widget.showActions,
                onTap: widget.onTap ??
                    (n) async {
                       scaffoldKey.currentState!.closeDrawer();
                       String url = "https://" +SiteSabit.Link! + n.url!;
                     
                    
                       if ((url.toLowerCase().contains('login') ||
                    url.toLowerCase().contains('/giris')) &&
                !url.toLowerCase().contains('mobilgiris')) {
              await SharedPrefsHelper.clearUser();
              widget.controller.clearLocalStorage();
              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(title: '', viewDanMi: true),
                ),
                (route) => false,
              );

         
            }else{
                   widget.controller.loadRequest(Uri.parse(url));
            }
        
                 


                    },
                onLoad: widget.onLoad ??
                    (n) {
                      // print(n.adi);
                    },
                onCheck: widget.onCheck ??
                    (b, n) {
                      // print(n.adi);
                    },
                onExpand: widget.onExpand ??
                    (n) {
                      // print(n.adi);
                    },
                onRemove: widget.onRemove ?? (n, p) {},
                onAppend: widget.onAppend ?? (n, p) {},
                onCollapse: widget.onCollapse ??
                    (n) {
                      //  print(n.adi);
                    },
              );
            },
          )
        ],
      ),
    );
  }
}
