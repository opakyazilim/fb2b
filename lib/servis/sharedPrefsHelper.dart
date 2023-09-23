import 'dart:convert';

import 'package:b2b/const/Ctanim.dart';
import 'package:b2b/model/cariModel.dart';
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
      return Cari.fromJson(userMap);
    }
    return null;
  }

  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("kullanici");
  }
}
