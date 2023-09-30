import 'dart:convert';

import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/model/cariModel.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static Future<void> saveUser(Cari user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString("kullanici", userJson);
  }

  static Future<Cari?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("kullanici");
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      Ctanim.cari = Cari.fromJson(userMap);
      if(Ctanim.internet){
          await OneSignal.User.removeTag("CariId");
  await OneSignal.User.removeTag("CariKodu");
  await OneSignal.User.removeTag("PlasiyerGuid");
  await OneSignal.User.removeTag("CariEmail");
  await OneSignal.User.removeTag("CariTel");

  
   await OneSignal.User.addTagWithKey("CariEmail",Ctanim.cari!.mail.toString());
       await   OneSignal.User.addTagWithKey("CariTel",Ctanim.cari!.tel.toString());
       await   OneSignal.User.addTagWithKey("CariId", Ctanim.cari!.id.toString());
        await  OneSignal.User.addTagWithKey("CariKodu", Ctanim.cari!.kod.toString());
        await  OneSignal.User.addTagWithKey("PlasiyerGuid", Ctanim.PlasiyerGuid.toString());
      }

      return Cari.fromJson(userMap);
    }
    return null;
  }

  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("kullanici");
  }





 static Future<void> saveStringToSharedPreferences(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}


static Future<String?> getStringFromSharedPreferences(String key) async {
  final prefs = await SharedPreferences.getInstance();
  if(prefs.getString(key)==null || prefs.getString(key) == ""){
    return "";

  }else{
    if(key == "plasiyerGuid"){
      Ctanim.PlasiyerGuid = prefs.getString(key);
    }
return prefs.getString(key);
  }
  

}

 static Future<void> saveBoolToSharedPreferences(String key, bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}


static Future<bool?> getSBoolFromSharedPreferences(String key) async {
  final prefs = await SharedPreferences.getInstance();
  if(prefs.getBool(key)==null){
    return false;
  }else{
return prefs.getBool(key);
  }
  

}






}
