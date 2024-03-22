import 'package:b2b/const/siteSabit.dart';
import 'package:b2b/model/altKullaniciModel.dart';
import 'package:b2b/model/kategoriModel.dart';
import 'package:b2b/model/kategoriModelDeneme.dart';
import 'package:b2b/model/menuModel.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import '../model/cariModel.dart';

class Ctanim {
  static TabController? tabController;
  static Cari? cari;
  static String? Dil = SiteSabit.Dil;
  static String? PlasiyerGuid;
  static String SmsKodu = "";
  static int? SmsUzunluk = 0;
  static List<MenuModel> menuList = [];
  static bool? Misafir;
  static bool? SifremiUnuttum;
  static String? Telefon;
  static String? Mail;
  static String? Adres;
  static WebViewController? controller;
  static List<String> sifreGondermeSecenekleri = [
    "Mail İle Gönder",
    "Kullanıcı Adi İle Gönder",
    "Telefon Numarası İle Gönder"
  ];
  static var seciliSifreGonderme = "".obs;
  static List<Cari> cariRehberList = [];
  static String anaKullaniciID = "";
  static List<AltKullaniciModel> altKullaniciList = [];
  static List<KategoriModelDeneme> listKategori = [];
  static bool internet = true;
  static String bildirimUrlVarMi = "";
  static bool bildirimvar = false;
  static String oneSignalKey = "";
  static double drawerWidth = 0;
  static var gelenKategoriJson = [];
  static var gelenPlasiyerMenuJson = [];
  static var gelenCariMenuJson = [];
  static bool cariMenuGoster = false;
  static bool plasiyerMenuGoster = false;
  static int secilKategoriID = -1;
  static String currentUrl = "";
  static String sil = "";
  static int sepetAdet = 0;
  static bool sepetGozuksunMu = false;

  static void yanMenu(context) {
    drawerWidth = MediaQuery.of(context).size.width * 0.7;
  }

  static String translate(String input) {
    // İngilizce - Türkçe çeviri map'i oluşturulması
    Map<String, String> translations = {
      "Giriş": "Login",
      "Kayıt ol": "Sign up",
      "Çıkış yap": "Log out",
      SiteSabit.FirmaAdi!.replaceAll("B2B", "").replaceAll("b2b", "").replaceAll("B4B", "").replaceAll("b4b", "") + " B2B'ye Hoş Geldiniz":
          "Welcome to ${SiteSabit.FirmaAdi!.replaceAll("B2B", "").replaceAll("b2b", "").replaceAll("B4B", "").replaceAll("b4b", "")} B2B",
      "İyi Çalışmalar": "Enjoy your work",
      "Bize Ulaşın": "Contact us",
      "Mail Adresimiz": "Our mail address",
      "Firma Adresi": "Company address",
      "Kopyala!": "Copy!",
      "Lütfen Giriş Yapın": "Please log in",
      "Beni Hatırla": "Remember me",
      "Plasiyer Menü": "Salesman Menu",
      "Cari Menü": "Customer Menu",
      "Kategoriler": "Categories",
      "Misafir Girişi Engellendi": "Guest Login Blocked",
      "Geri": "Back",
      "Mail Adresinizi Giriniz": "Enter your email address",
      "Telefon Numaranızı Giriniz": "Enter your phone number",
      "Kullanıcı Adınızı Giriniz": "Enter your username",
      "Not: Gireceğiniz mail adresine tarafımızca şifreniz gönderilecekir.":
          "Note: Your password will be sent to the email address you will enter.",
      "Hata": "Error",
      "Şifre Gönderilecek Alan Adı Boş.":
          "The field name to send the password is empty.",
      "Böyle Bir Kullanıcı Yok": "There is no such user",
      "Başarılı": "Successful",
      "Tamam": "Okay",
      "Aktif İnternet Bağlantısı Bulunamadı. Tekrar Deneyin.":
          "Active internet connection not found. Try again.",
      "Şifremi Gönder": "Send my password",
      "İnternet Bağlantısı Yok": "No internet connection",
      "Aktif internet bağlantısı bulunamadı.İnternete bağlı olduğunuzdan emin olun.":
          "Active internet connection not found. Make sure you are connected to the internet.",
      "Mail İle Gönder": "Send by mail",
      "Kullanıcı Adi İle Gönder": "Send with username",
      "Telefon Numarası İle Gönder": "Send with phone number",
      "Uygulamayı Kapat": "Close the application",
      "Şifremi Unuttum": "I forgot my password",
      "Misafir Girişi": "Guest Login",
      "Bayilik Başvurusu": "Acquire a Franchise",
      "Kullanıcı Adı": "Username",
      "Parola": "Password",
    };

    if (translations.containsKey(input) && Ctanim.Dil == "EN") {
      return translations[input]!;
    } else {
      return input;
    }
  }
}
