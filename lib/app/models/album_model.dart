import 'parents/model.dart';

class AlbumModelNew extends Model {
  String name;
  String description_album;
  String e_provider_id;
  List image;
  List description;

  AlbumModelNew({
    this.name,
    this.description_album,
    this.e_provider_id,
    this.image,
    this.description,
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
    data['name'] = this.name;
    data['description_album'] = this.description_album;
    data['e_provider_id'] = this.e_provider_id;
    data['image'] = this.image;
    data['description'] = this.description;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is AlbumModelNew &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          name == other.name &&
          description_album == other.description_album &&
          description == other.description &&
          e_provider_id == other.e_provider_id;

  @override
  int get hashCode =>
      super.hashCode ^
      image.hashCode ^
      name.hashCode ^
      description_album.hashCode ^
      description.hashCode ^
      e_provider_id.hashCode;
}
