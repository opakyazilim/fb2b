import 'dart:convert' as convert;
import 'dart:convert';
import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/model/menuModel.dart';
import 'package:http/http.dart' as http;

import '../model/cariModel.dart';

class Servis {
  Future<bool> login(
      {required String kullaniciAdi, required String sifre}) async {
    var url = Uri.https(
      SiteSabit.Link!,
      '/Login/GetMobilGiris',
      {
        'Username': kullaniciAdi,
        'Password': sifre,
      },
    );

    var response = await http.post(url);
    if (response.statusCode == 200) {
      var rawXmlResponse = response.body;
      var json = jsonDecode(response.body);
      var cari = json["Cari"];
      Ctanim.PlasiyerGuid = json["PlasiyerGuid"];
      Ctanim.cari = Cari.fromJson(cari);
      if (Ctanim.cari != null) {
        return true;
      } else {
        return false;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future<bool> getMenu(
      {required String cariGuid, required String plasiyerGuid}) async {
    var url = Uri.https(
      SiteSabit.Link!,
      '/Genel/GetMobilAyarlar',
      {
        'ExServisId': SiteSabit.ExServisId,
        'CariGuid': cariGuid,
        'PlasiyerGuid': plasiyerGuid,
        'Platform': SiteSabit.Platform,
        'Versiyon': SiteSabit.Versiyon,
      },
    );
    print(url);

    var response = await http.post(url);
    if (response.statusCode == 200) {
      var rawXmlResponse = response.body;
      var json = jsonDecode(response.body);
      Ctanim.SifremiUnuttum = json["SifremiUnuttum"];
      Ctanim.Misafir = json["Misafir"];
      Ctanim.menuList.clear();
      List<dynamic> loginMenu = json["LoginMenu"];
      Ctanim.menuList =
          loginMenu.map((item) => MenuModel.fromJson(item)).toList();

      if (Ctanim.menuList.isNotEmpty &&
          Ctanim.Misafir != null &&
          Ctanim.SifremiUnuttum != null) {
        return true;
      } else {
        return false;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future<List<dynamic>> sifremiUnuttum({required String mail}) async {
    var url = Uri.https(
      SiteSabit.Link!,
      '/Login/SifremiUnuttumJs',
      {
        'MailAdresi': mail,
      },
    );

    var response = await http.post(url);
    if (response.statusCode == 200) {
      var rawXmlResponse = response.body;
      var json = jsonDecode(response.body);
      bool hataMi = json["Hatami"];
      String hataMesaj = json["HataMesaj"];
      return [hataMi, hataMesaj];
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return ["İstek Gönderilemedi"];
    }
  }
}
