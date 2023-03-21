import 'parents/model.dart';

class AlbumModel extends Model {
  String id;
  String name;
  String description;
  String e_provider_id;
  String album_image;
  String created_at;
  String updated_at;

  AlbumModel({
    this.id,
    this.name,
    this.description,
    this.e_provider_id,
    this.album_image,
    this.created_at,
    this.updated_at,
  });

  AlbumModel.fromJson(Map<String, dynamic> json) {
    id = transStringFromJson(json, 'id');
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description');
    e_provider_id = transStringFromJson(json, 'e_provider_id');
    album_image = transStringFromJson(json, 'album_image');
    created_at = transStringFromJson(json, 'created_at');
    updated_at = transStringFromJson(json, 'updated_at');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    if (this.description != null) data['description'] = this.description;
    if (this.e_provider_id != null) data['e_provider_id'] = this.e_provider_id;
    if (album_image != null) data['discount_price'] = this.album_image;
    if (created_at != null) data['created_at'] = this.created_at;
    if (updated_at != null) data['updated_at'] = this.updated_at;
    return data;
  }

  @override
  bool get hasData {
    return id != null && name != null && description != null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is AlbumModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          e_provider_id == other.e_provider_id &&
          album_image == other.album_image &&
          created_at == other.created_at &&
          updated_at == other.updated_at;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      e_provider_id.hashCode ^
      album_image.hashCode ^
      created_at.hashCode ^
      updated_at.hashCode;
}
