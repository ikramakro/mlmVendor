import 'parents/model.dart';

class PortfolioAlbum extends Model {
  List image;
  List desc;
  String album;
  String album_name;
  String album_desc;
  String album_image;
  String e_provider_id;

  PortfolioAlbum({
    this.image,
    this.desc,
    this.album,
    this.album_name,
    this.album_desc,
    this.album_image,
    this.e_provider_id,
  });

  // PortfolioAlbum.fromJson(Map<String, dynamic> json) {
  //   super.fromJson(json);
  //   name = transStringFromJson(json, 'name');
  //   color = colorFromJson(json, 'color');
  //   description = transStringFromJson(json, 'description');
  //   image = mediaFromJson(json, 'image');
  //   featured = boolFromJson(json, 'featured');
  //   eServices = listFromJsonArray(json, ['e_services', 'featured_e_services'],
  //       (v) => EService.fromJson(v));
  //   subCategories =
  //       listFromJson(json, 'sub_categories', (v) => Category.fromJson(v));
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['image'] = this.image;
    data['desc'] = this.desc;
    data['album'] = this.album;
    data['album_name'] = this.album_name;
    data['album_desc'] = this.album_desc;
    data['album_image'] = this.album_image;
    data['e_provider_id'] = this.e_provider_id;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is PortfolioAlbum &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          desc == other.desc &&
          album == other.album &&
          album_name == other.album_name &&
          album_desc == other.album_desc &&
          album_image == other.album_image &&
          e_provider_id == other.e_provider_id;

  @override
  int get hashCode =>
      super.hashCode ^
      image.hashCode ^
      desc.hashCode ^
      album.hashCode ^
      album_name.hashCode ^
      album_desc.hashCode ^
      album_image.hashCode ^
      e_provider_id.hashCode;
}
