 class KategoriModel  {

  int? id;
  String? adi;
  String? aciklama;
  int? ustId;
  int? sira;
  int? seviye;
  bool? ustMenu;
  bool? aktif;
  bool? active;
  bool? resim; // SOR
  int? resimId;
  dynamic extra;
  List<KategoriModel> AltKategori = [];


 KategoriModel({
   required this.id,
   required this.adi,
    this.aciklama,
    this.ustId,
    this.sira,
    this.seviye,
    this.ustMenu,
    this.aktif,
    this.active,
    this.resim,
    this.resimId,
   required this.AltKategori,
    this.extra,
  });

  KategoriModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    adi = json['Adi'];
    aciklama = json['Aciklama'];
    ustId = json['UstId'];
    sira = json['Sira'];
    seviye = json['Seviye'];
    ustMenu = json['UstMenu'];
    aktif = json['Aktif'];
    active = json['Active'];
    resim = json['Resim'];
    resimId = json['ResimId'];
    if (json['AltKategori'] != null) {
      AltKategori = [];
      json['AltKategori'].forEach((v) {
        AltKategori.add(KategoriModel.fromJson(v));
      });
    }

  }
/*
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.altKategori != null) {
      data['AltKategori'] = this.altKategori!.map((v) => v.toJson()).toList();
    }
    data['Id'] = this.id;
    data['Adi'] = this.adi;
    data['Aciklama'] = this.aciklama;
    data['UstId'] = this.ustId;
    data['Sira'] = this.sira;
    data['Seviye'] = this.seviye;
    data['UstMenu'] = this.ustMenu;
    data['Aktif'] = this.aktif;
    data['Active'] = this.active;
    data['Resim'] = this.resim;
    data['ResimId'] = this.resimId;
    return data;
  }
  */
}