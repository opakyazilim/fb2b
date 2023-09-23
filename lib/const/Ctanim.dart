import 'package:b2b/model/menuModel.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/cariModel.dart';

// 1.5
class Ctanim {
  static TabController? tabController;
  static Cari? cari;
  static String? PlasiyerGuid;
  static List<MenuModel> menuList = [];
  static bool? Misafir;
  static bool? SifremiUnuttum;
  static WebViewController? controller;
}
