import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/model/FTreeNode.dart';
import 'package:b2b/model/kategoriModelDeneme.dart';
import 'package:b2b/view/webviewStack.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FTreeView extends StatefulWidget {
  final List<KategoriModelDeneme> data;

  final bool lazy;
  final Widget icon;
  final double offsetLeft;
  final bool showFilter;
  final bool showActions;
  final bool showCheckBox;

  final Function(KategoriModelDeneme node)? onTap;
  final void Function(KategoriModelDeneme node)? onLoad;
  final void Function(KategoriModelDeneme node)? onExpand;
  final void Function(KategoriModelDeneme node)? onCollapse;
  final void Function(bool checked, KategoriModelDeneme node)? onCheck;
  final void Function(KategoriModelDeneme node, KategoriModelDeneme parent)?
      onAppend;
  final void Function(KategoriModelDeneme node, KategoriModelDeneme parent)?
      onRemove;

  final KategoriModelDeneme Function(KategoriModelDeneme parent)? append;
  final Future<List<KategoriModelDeneme>> Function(KategoriModelDeneme parent)?
      load;
  final WebViewController controller;

  const FTreeView({
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
  State<FTreeView> createState() => _FTreeViewState();
}

class _FTreeViewState extends State<FTreeView> {
  late KategoriModelDeneme _root;
  List<KategoriModelDeneme> _renderList = [];

  List<KategoriModelDeneme> _filter(
      String val, List<KategoriModelDeneme> list) {
    List<KategoriModelDeneme> temp = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].adi!.contains(val)) {
        temp.add(list[i]);
      }
      if (list[i].AltKategori.isNotEmpty) {
        list[i].AltKategori = _filter(val, list[i].AltKategori);
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

  void append(KategoriModelDeneme parent) {
    parent.AltKategori.add(widget.append!(parent));
    setState(() {});
  }

  void _remove(KategoriModelDeneme node, List<KategoriModelDeneme> list) {
    for (int i = 0; i < list.length; i++) {
      if (node == list[i]) {
        list.removeAt(i);
      } else {
        _remove(node, list[i].AltKategori);
      }
    }
  }

  void remove(KategoriModelDeneme node) {
    _remove(node, _renderList);
    setState(() {});
  }

  Future<bool> load(KategoriModelDeneme node) async {
    try {
      final data = await widget.load!(node);
      node.AltKategori = data;
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
    _root = KategoriModelDeneme(
      id: 0,
      adi: "",
      extra: null,
      AltKategori: _renderList,
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
              return FTreeNode(
                controller: widget.controller,
                load: load,
                remove: remove,
                append: append,
                parent: _root,
                data: _renderList[index],
                icon: _renderList[index].AltKategori.isNotEmpty
                    ? widget.icon
                    : Container(),
                lazy: widget.lazy,
                offsetLeft: widget.offsetLeft,
                showCheckBox: widget.showCheckBox,
                showActions: widget.showActions,
                onTap: widget.onTap ??
                    (n) {
                      Ctanim.secilKategoriID = n.id!;
                      scaffoldKey.currentState!.closeDrawer();
                      var url = Uri.https(SiteSabit.Link!,"/Kategori/kategoriPage/${n.id}");
                      Ctanim.currentUrl = url.toString();
                      widget.controller.loadRequest(url);
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
