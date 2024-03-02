class AltKullaniciModel {
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
  double? dec1;
  double? dec2;
  double? dec3;
  bool? silindi;
  String? taksitKosulKodu;

  AltKullaniciModel(
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

  AltKullaniciModel.fromJson(Map<String, dynamic> json) {
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