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
  double? bakiye;
  String? il ;
  String? ilce;
  String? dil;


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
      this.il,
      this.ilce,
      this.bakiye,
      this.dil
      });

  Cari.fromJson(Map<String, dynamic> json) {
    id = int.parse(  json['Id'].toString());
    guid = json['Guid'];
    kod = json['Kod'];
    kullaniciAdi = json['KullaniciAdi'];
    adi = json['Adi'];
    sifre = json['Sifre'];
    mail = json['Mail'];
    tel = json['Tel'];
    il = json["Il"];
    ilce = json ["Ilce"];
    plasiyerKodu = json['PlasiyerKodu'];
    dil = json["Dil"];
    
    bakiye =double.parse(json['Bakiye'].toString())  ;
    
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
    data['Dil'] = this.dil;
   
    data['Bakiye'] = this.bakiye;
    
    return data;
  }
}



