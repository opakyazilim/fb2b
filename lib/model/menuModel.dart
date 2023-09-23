class MenuModel {
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
  List<String>? altMenuler;

  MenuModel(
      {this.id,
      this.adi,
      this.ustId,
      this.sira,
      this.url,
      this.stoks,
      this.iconUrl,
      this.htmlIcon,
      this.target,
      this.aktif,
      this.altMenuler});

  MenuModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    adi = json['Adi'];
    ustId = json['UstId'];
    sira = json['Sira'];
    url = json['Url'];
    stoks = json['Stoks'];
    iconUrl = json['IconUrl'];
    htmlIcon = json['HtmlIcon'];
    target = json['Target'];
    aktif = json['Aktif'];
    /*
    if (json['AltMenuler'] != null) {
      altMenuler = <String>[];
      json['AltMenuler'].forEach((v) {
        altMenuler!.add(fromJson(v));
      });
    }
    */
  }
}
// ALT MENU İÇİN MODEL YOK 