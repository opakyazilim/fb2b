import 'package:b2b/model/menuModel.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import '../model/cariModel.dart';
class Ctanim {
  static TabController? tabController;
  static Cari? cari;
  static String? PlasiyerGuid;
  static List<MenuModel> menuList = [];
  static bool? Misafir;
  static bool? SifremiUnuttum;
  static String? Telefon;
  static String? Mail;
  static String? Adres;
  static WebViewController? controller;
  static List<String> sifreGondermeSecenekleri = ["Mail İle Gönder","Kullanıcı Adi İle Gönder","Telefon Numarası İle Gönder"];
  static var seciliSifreGonderme = "".obs;
  static List<Cari> cariRehberList = [];
  static bool internet = true;
  static String bildirimUrlVarMi = "";
  static bool bildirimvar = false;
  static String oneSignalKey = "";
 

}
