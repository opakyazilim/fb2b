
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
    
    
      var json = jsonDecode(response.body);
      try{
  var cari = json["Cari"];
      Ctanim.PlasiyerGuid = json["PlasiyerGuid"];
      Ctanim.cari = Cari.fromJson(cari);
      }catch(e){
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
 
    var response = await http.post(url);
    if (response.statusCode == 200) {
    
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
     
      return false;
    }
  }

  Future<List<dynamic>> sifremiUnuttum({required String mail,required String telefon,required String kullaniciAdi}) async {
    var url = Uri.https(
      SiteSabit.Link!,
      '/Login/SifremiUnuttumJs/',
      {
        'MailAdresi': mail,
        "KullaniciAdi" : kullaniciAdi,
        "Telefon" : telefon
      },
    );
    var response = await http.post(url);
    if (response.statusCode == 200) {
     
      var json = jsonDecode(response.body);
      bool hataMi = json["Hatami"];
      if(json["Hatami"]==true){
        return ["İstek Gönderilemedi"];
      }

      String hataMesaj = json["HataMesaj"];
      return [hataMi, hataMesaj];
    } else {
    
      return ["İstek Gönderilemedi"];
    }
  }
}
