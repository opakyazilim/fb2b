import 'dart:convert';
import 'dart:io';
import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/model/altKullaniciModel.dart';
import 'package:b2b/model/kategoriModel.dart';
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
        Ctanim.Dil = Ctanim.cari!.dil!= "" ? Ctanim.cari!.dil : SiteSabit.Dil;
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
        'Platform': SiteSabit.Platform,
        'Versiyon': SiteSabit.Versiyon,
      },
    );
    print(url.toString());
    var response;
    try {
      response = await http.post(url, headers: {'PlasiyerGuid': plasiyerGuid,'Guid': cariGuid});
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
      Ctanim.menuList = loginMenu.map((item) => MenuModel.fromJson(item)).toList();
      Ctanim.gelenPlasiyerMenuJson = json["PlasiyerMenu"];
      Ctanim.gelenPlasiyerMenuJson.isNotEmpty ? Ctanim.plasiyerMenuGoster = true : Ctanim.plasiyerMenuGoster = false; 
      Ctanim.gelenCariMenuJson = json["CariMenu"];
      Ctanim.gelenCariMenuJson.isNotEmpty ? Ctanim.cariMenuGoster = true : Ctanim.cariMenuGoster = false;
      

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
    var url = Uri.https(
        SiteSabit.Link!, '/Genel/MobilCihazKaydet/${Ctanim.oneSignalKey}');

    var response = await http
        .post(url, headers: {'PlasiyerGuid': plasiyerGuid, 'Guid': cariGuid});
    if (response.statusCode == 200) {
      print("Cari post edildi.");
    } else {
      print("Cari post edilemedi.");
    }
  }

  static Future<bool> internetDene() async {
    HttpClient userAgent = new HttpClient();
    try {
      var url = Uri.https(SiteSabit.Link!);
      await userAgent.getUrl(url);
      print("internet var");
      return true;
    } catch (e) {
      print("internet yok");
      print(e);
      return false;
    }
  }



  Future<bool> getAltKullanici({required String plasiyerGuid,required String cariGuid}) async {

    var url;
 
      url = Uri.https(
        SiteSabit.Link!,
        '/Hesabim/AltKullaniciList',
        {
          'ExServisId': SiteSabit.ExServisId,
        }
        
      );
  

    var response =
        await http.post(url, headers: {'PlasiyerGuid': plasiyerGuid,'Guid': cariGuid});
    if (response.statusCode == 200) {
      print("istek başarılı");
      Ctanim.altKullaniciList.clear();

      var json = jsonDecode(response.body);
      try {
        final List<dynamic> jsonList = json;
        for (final jsonItem in jsonList) {
          final altKullanici = AltKullaniciModel.fromJson(jsonItem);
          Ctanim.altKullaniciList.add(altKullanici);
        }
        print(Ctanim.altKullaniciList.length);
      } catch (e) {
        print("Hata: $e");
      }
      return true;
    } else {
      print("BAŞAŞAŞAŞ");

      return false;
    }

  }
  Future<bool> getCariRehber(
      {required String plasiyerGuid, required String arama}) async {
    Ctanim.cariRehberList.clear();
    var url;
    if (arama != "") {
      url = Uri.https(
        SiteSabit.Link!,
        '/Plasiyer/CariRehberJs',
        {'Arama': arama},
      );
    } else {
      url = Uri.https(
        SiteSabit.Link!,
        '/Plasiyer/CariRehberJs',
      );
    }

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

 Future<void> getYanMenu( {required String plasiyerGuid, required String cariGuid}) async {
    var url;
    url = Uri.https(
      SiteSabit.Link!,
      '/Kategori/_KategoriMbl',
     {'ExServisId': SiteSabit.ExServisId, 'UstMenu': 'false'},
    );
    print(url.toString());
    var response = await http.post(url,headers: {'PlasiyerGuid': plasiyerGuid, 'Guid': cariGuid});
    if (response.statusCode == 200) {
      print("istek başarılı");

      var json = jsonDecode(response.body);
      Ctanim.gelenKategoriJson = json;
      //var json = jsonDecode(temp);
      //var json = jsonDecode(serverData);
      print(json.length);

      try {
        final List<dynamic> jsonList = json;
        for (final jsonItem in jsonList) {
          final kategori = KategoriModel.fromJson(jsonItem);
          //Ctanim.listKategori.add(kategori);
        }
        print("lkfdsjsşld");
      } catch (e) {
        print("Hata: $e");
      }
    } else {
      print("BAŞAŞAŞAŞ");
    }
  }
}