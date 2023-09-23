class Cari {
  int? id;
  String? guid;
  String? kod;
  String? kullaniciAdi;
  String? adi;
  String? sifre;
  String? mail;
  String? tel;
  String? plasiyerKodu;
  bool? smsAktif;
  double? bakiye;
  double? isk1;
  double? isk2;
  double? isk3;
  double? isk4;
  double? isk5;
  double? isk6;
  String? grup;
  String? text1;
  String? text2;
  String? text3;
  String? text4;
  String? text5;
  String? text6;
  String? text7;
  String? text8;
  String? text9;
  String? text10;
  String? text11;
  String? text12;
  String? text13;
  String? text14;
  String? text15;
  double? dec1;
  double? dec2;
  double? dec3;
  double? dec4;
  double? dec5;
  double? puan;
  bool? sLimitAktif;
  double? sLimit;
  String? cTarih;
  String? uTarih;
  bool? aktif;
  bool? krediKarti;
  bool? onlineOdeme;
  bool? kapidaOdeme;
  bool? acikHesap;
  bool? havaleEft;
  String? tip;
  double? enlem;
  double? boylam;
  double? eBDuyarlilik;
  String? taksitKosulKodu;
  bool? onaySys;
  String? dil;
  String? il;
  String? ilce;
  AltKullanici? altKullanici;
  List<String>? altKullaniciListesi;

  Cari(
      {this.id,
      this.guid,
      this.kod,
      this.kullaniciAdi,
      this.adi,
      this.sifre,
      this.mail,
      this.tel,
      this.plasiyerKodu,
      this.smsAktif,
      this.bakiye,
      this.isk1,
      this.isk2,
      this.isk3,
      this.isk4,
      this.isk5,
      this.isk6,
      this.grup,
      this.text1,
      this.text2,
      this.text3,
      this.text4,
      this.text5,
      this.text6,
      this.text7,
      this.text8,
      this.text9,
      this.text10,
      this.text11,
      this.text12,
      this.text13,
      this.text14,
      this.text15,
      this.dec1,
      this.dec2,
      this.dec3,
      this.dec4,
      this.dec5,
      this.puan,
      this.sLimitAktif,
      this.sLimit,
      this.cTarih,
      this.uTarih,
      this.aktif,
      this.krediKarti,
      this.onlineOdeme,
      this.kapidaOdeme,
      this.acikHesap,
      this.havaleEft,
      this.tip,
      this.enlem,
      this.boylam,
      this.eBDuyarlilik,
      this.taksitKosulKodu,
      this.onaySys,
      this.dil,
      this.il,
      this.ilce,
      this.altKullanici,
      this.altKullaniciListesi});

  Cari.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    guid = json['Guid'];
    kod = json['Kod'];
    kullaniciAdi = json['KullaniciAdi'];
    adi = json['Adi'];
    sifre = json['Sifre'];
    mail = json['Mail'];
    tel = json['Tel'];
    plasiyerKodu = json['PlasiyerKodu'];
    smsAktif = json['SmsAktif'];
    bakiye = json['Bakiye'];
    isk1 = json['Isk1'];
    isk2 = json['Isk2'];
    isk3 = json['Isk3'];
    isk4 = json['Isk4'];
    isk5 = json['Isk5'];
    isk6 = json['Isk6'];
    grup = json['Grup'];
    text1 = json['Text1'];
    text2 = json['Text2'];
    text3 = json['Text3'];
    text4 = json['Text4'];
    text5 = json['Text5'];
    text6 = json['Text6'];
    text7 = json['Text7'];
    text8 = json['Text8'];
    text9 = json['Text9'];
    text10 = json['Text10'];
    text11 = json['Text11'];
    text12 = json['Text12'];
    text13 = json['Text13'];
    text14 = json['Text14'];
    text15 = json['Text15'];
    dec1 = json['Dec1'];
    dec2 = json['Dec2'];
    dec3 = json['Dec3'];
    dec4 = json['Dec4'];
    dec5 = json['Dec5'];
    puan = json['Puan'];
    sLimitAktif = json['SLimitAktif'];
    sLimit = json['SLimit'];
    cTarih = json['CTarih'];
    uTarih = json['UTarih'];
    aktif = json['Aktif'];
    krediKarti = json['KrediKarti'];
    onlineOdeme = json['OnlineOdeme'];
    kapidaOdeme = json['KapidaOdeme'];
    acikHesap = json['AcikHesap'];
    havaleEft = json['HavaleEft'];
    tip = json['Tip'];
    enlem = json['Enlem'];
    boylam = json['Boylam'];
    eBDuyarlilik = json['EBDuyarlilik'];
    taksitKosulKodu = json['TaksitKosulKodu'];
    onaySys = json['OnaySys'];
    dil = json['Dil'];
    il = json['Il'];
    ilce = json['Ilce'];
    altKullanici = json['AltKullanici'] != null
        ? new AltKullanici.fromJson(json['AltKullanici'])
        : null;
    /*
    if (json['AltKullaniciListesi'] != null) {
      altKullaniciListesi = <Null>[];
      json['AltKullaniciListesi'].forEach((v) {
        altKullaniciListesi!.add(new Null.fromJson(v));
      });
    }
    */
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Guid'] = this.guid;
    data['Kod'] = this.kod;
    data['KullaniciAdi'] = this.kullaniciAdi;
    data['Adi'] = this.adi;
    data['Sifre'] = this.sifre;
    data['Mail'] = this.mail;
    data['Tel'] = this.tel;
    data['PlasiyerKodu'] = this.plasiyerKodu;
    data['SmsAktif'] = this.smsAktif;
    data['Bakiye'] = this.bakiye;
    data['Isk1'] = this.isk1;
    data['Isk2'] = this.isk2;
    data['Isk3'] = this.isk3;
    data['Isk4'] = this.isk4;
    data['Isk5'] = this.isk5;
    data['Isk6'] = this.isk6;
    data['Grup'] = this.grup;
    data['Text1'] = this.text1;
    data['Text2'] = this.text2;
    data['Text3'] = this.text3;
    data['Text4'] = this.text4;
    data['Text5'] = this.text5;
    data['Text6'] = this.text6;
    data['Text7'] = this.text7;
    data['Text8'] = this.text8;
    data['Text9'] = this.text9;
    data['Text10'] = this.text10;
    data['Text11'] = this.text11;
    data['Text12'] = this.text12;
    data['Text13'] = this.text13;
    data['Text14'] = this.text14;
    data['Text15'] = this.text15;
    data['Dec1'] = this.dec1;
    data['Dec2'] = this.dec2;
    data['Dec3'] = this.dec3;
    data['Dec4'] = this.dec4;
    data['Dec5'] = this.dec5;
    data['Puan'] = this.puan;
    data['SLimitAktif'] = this.sLimitAktif;
    data['SLimit'] = this.sLimit;
    data['CTarih'] = this.cTarih;
    data['UTarih'] = this.uTarih;
    data['Aktif'] = this.aktif;
    data['KrediKarti'] = this.krediKarti;
    data['OnlineOdeme'] = this.onlineOdeme;
    data['KapidaOdeme'] = this.kapidaOdeme;
    data['AcikHesap'] = this.acikHesap;
    data['HavaleEft'] = this.havaleEft;
    data['Tip'] = this.tip;
    data['Enlem'] = this.enlem;
    data['Boylam'] = this.boylam;
    data['EBDuyarlilik'] = this.eBDuyarlilik;
    data['TaksitKosulKodu'] = this.taksitKosulKodu;
    data['OnaySys'] = this.onaySys;
    data['Dil'] = this.dil;
    data['Il'] = this.il;
    data['Ilce'] = this.ilce;
    if (this.altKullanici != null) {
      data['AltKullanici'] = this.altKullanici!.toJson();
    }
    /*
    if (this.altKullaniciListesi != null) {
      data['AltKullaniciListesi'] =
          this.altKullaniciListesi!.map((v) => v.toJson()).toList();
    }
    */
    return data;
  }
}

class AltKullanici {
  int? id;
  String? guid;
  int? ustId;
  int? cariId;
  String? aKod;
  String? adi;
  String? kullaniciAdi;
  String? sifre;
  String? tel;
  String? mail;
  bool? aktif;
  bool? onaySys;
  String? aciklama;
  String? text1;
  String? text2;
  String? text3;
  int? dec1;
  int? dec2;
  int? dec3;
  bool? silindi;
  String? taksitKosulKodu;

  AltKullanici(
      {this.id,
      this.guid,
      this.ustId,
      this.cariId,
      this.aKod,
      this.adi,
      this.kullaniciAdi,
      this.sifre,
      this.tel,
      this.mail,
      this.aktif,
      this.onaySys,
      this.aciklama,
      this.text1,
      this.text2,
      this.text3,
      this.dec1,
      this.dec2,
      this.dec3,
      this.silindi,
      this.taksitKosulKodu});

  AltKullanici.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    guid = json['Guid'];
    ustId = json['UstId'];
    cariId = json['CariId'];
    aKod = json['AKod'];
    adi = json['Adi'];
    kullaniciAdi = json['KullaniciAdi'];
    sifre = json['Sifre'];
    tel = json['Tel'];
    mail = json['Mail'];
    aktif = json['Aktif'];
    onaySys = json['OnaySys'];
    aciklama = json['Aciklama'];
    text1 = json['Text1'];
    text2 = json['Text2'];
    text3 = json['Text3'];
    dec1 = json['Dec1'];
    dec2 = json['Dec2'];
    dec3 = json['Dec3'];
    silindi = json['Silindi'];
    taksitKosulKodu = json['TaksitKosulKodu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Guid'] = this.guid;
    data['UstId'] = this.ustId;
    data['CariId'] = this.cariId;
    data['AKod'] = this.aKod;
    data['Adi'] = this.adi;
    data['KullaniciAdi'] = this.kullaniciAdi;
    data['Sifre'] = this.sifre;
    data['Tel'] = this.tel;
    data['Mail'] = this.mail;
    data['Aktif'] = this.aktif;
    data['OnaySys'] = this.onaySys;
    data['Aciklama'] = this.aciklama;
    data['Text1'] = this.text1;
    data['Text2'] = this.text2;
    data['Text3'] = this.text3;
    data['Dec1'] = this.dec1;
    data['Dec2'] = this.dec2;
    data['Dec3'] = this.dec3;
    data['Silindi'] = this.silindi;
    data['TaksitKosulKodu'] = this.taksitKosulKodu;
    return data;
  }
}
