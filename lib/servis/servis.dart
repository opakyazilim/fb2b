import 'dart:convert';
import 'dart:io';
import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/model/menuModel.dart';
import 'package:get/get.dart';
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
      var json = jsonDecode(response.body);
      try {
        var cari = json["Cari"];
        Ctanim.PlasiyerGuid = json["PlasiyerGuid"];
        Ctanim.cari = Cari.fromJson(cari);
      } catch (e) {
        return false;
      }

      if (Ctanim.cari != null) {
        return true;
      } else {
        return false;
      }
    } else {
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
    var response;
    try {
      response = await http.post(url);
    } catch (e) {
      Ctanim.internet = false;
      return false;
    }

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print("Menu jSOn: " + json.toString());
      Ctanim.SifremiUnuttum = json["SifremiUnuttum"];
      Ctanim.Misafir = json["Misafir"];
      Ctanim.Telefon = json["Telefon"];
      Ctanim.Mail = json["Mail"];
      Ctanim.Adres = json["Adres"];
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
      Ctanim.internet = false;
      return false;
    }
  }

  Future<List<dynamic>> sifremiUnuttum(
      {required String mail,
      required String telefon,
      required String kullaniciAdi}) async {
    var url = Uri.https(
      SiteSabit.Link!,
      '/Login/SifremiUnuttumJs/',
      {'MailAdresi': mail, "KullaniciAdi": kullaniciAdi, "Telefon": telefon},
    );
    var response = await http.post(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      bool hataMi = json["Hatami"];
      if (json["Hatami"] == true) {
        return ["İstek Gönderilemedi"];
      }

      String hataMesaj = json["HataMesaj"];
      return [hataMi, hataMesaj];
    } else {
      return ["İstek Gönderilemedi"];
    }
  }

  Future<void> postCari(
      {required String plasiyerGuid, required String cariGuid}) async {
    var url = Uri.https(SiteSabit.Link!,'/Genel/MobilCihazKaydet/${Ctanim.oneSignalKey}');

    var response = await http.post(url,
        headers: {'PlasiyerGuid': plasiyerGuid, 'Guid': cariGuid});
    if (response.statusCode == 200) {
      print("Cari post edildi.");
    } else {
      print("Cari post edilemedi.");
    }
  }

  static Future<bool> internetDene() async {
    try {
      final result = await InternetAddress.lookup(SiteSabit.Link!);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<bool> getCariRehber(
      {required String plasiyerGuid, required String arama}) async {
    Ctanim.cariRehberList.clear();
    var url = Uri.https(
      SiteSabit.Link!,
      '/Plasiyer/CariRehberJs/',
      {'Arama': arama},
    );

    var response =
        await http.post(url, headers: {'PlasiyerGuid': plasiyerGuid});
    if (response.statusCode == 200) {
      print("istek başarılı");

      var json = jsonDecode(response.body);
      print(json.length);

      try {
        final List<dynamic> jsonList = json;
        for (final jsonItem in jsonList) {
          final cari = Cari.fromJson(jsonItem);
          Ctanim.cariRehberList.add(cari);
        }
        print(Ctanim.cariRehberList.length);
      } catch (e) {
        print("Hata: $e");
      }

      if (Ctanim.cari != null) {
        return true;
      } else {
        return false;
      }
    } else {
      print("BAŞAŞAŞAŞ");

      return false;
    }
  }
}
