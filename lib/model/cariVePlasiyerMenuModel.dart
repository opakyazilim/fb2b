class CariVePlasiyerMenuModel {
  int? id;
  String? adi;
  int? ustId;
  int? sira;
  String? url;
  bool? stoks;
  String? iconUrl;
  String? htmlIcon;
  String? target;
  bool? aktif;
  dynamic extra;
  List<CariVePlasiyerMenuModel> AltMenuler;

  CariVePlasiyerMenuModel({
    required this.id,
    required this.adi,
    this.ustId,
    this.sira,
    required this.url,
    this.stoks,
    this.iconUrl,
    this.htmlIcon,
    this.target,
    this.aktif,
    required this.AltMenuler,
    this.extra,
  });
}
