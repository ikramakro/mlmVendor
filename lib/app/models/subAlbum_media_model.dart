import 'dart:convert';

class SubMedia {
  SubMedia({
    this.id,
    this.name,
    this.url,
    this.thumb,
    this.icon,
    this.formatedSize,
  });

  int id;
  String name;
  String url;
  String thumb;
  String icon;
  String formatedSize;

  factory SubMedia.fromJson(String str) => SubMedia.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubMedia.fromMap(Map<String, dynamic> json) => SubMedia(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        thumb: json["thumb"],
        icon: json["icon"],
        formatedSize: json["formated_size"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "url": url,
        "thumb": thumb,
        "icon": icon,
        "formated_size": formatedSize,
      };
}
