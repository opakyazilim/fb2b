class KategoriModelDeneme {
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
  List<KategoriModelDeneme> AltKategori;

  KategoriModelDeneme({
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
}

/*
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
*/