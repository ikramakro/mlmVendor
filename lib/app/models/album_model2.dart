import 'media_model.dart';
import 'parents/model.dart';

class AlbumModelNew2 extends Model {
  String id;
  String albums_id;
  String description;
  String created_at;
  String updated_at;
  List<Media> media;

  AlbumModelNew2({
    this.id,
    this.albums_id,
    this.description,
    this.created_at,
    this.updated_at,
    this.media,
  });

  AlbumModelNew2.fromJson(Map<String, dynamic> json) {
    id = transStringFromJson(json, 'id');
    albums_id = transStringFromJson(json, 'albums_id');
    description = transStringFromJson(json, 'description');
    created_at = transStringFromJson(json, 'e_provider_id');
    updated_at = transStringFromJson(json, 'album_image');
    media = super.listFromJson(json, 'media', (value) => Media.fromJson(value));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (albums_id != null) data['albums_id'] = this.albums_id;
    if (this.description != null) data['description'] = this.description;
    if (media != null) data['media'] = this.media;
    if (created_at != null) data['created_at'] = this.created_at;
    if (updated_at != null) data['updated_at'] = this.updated_at;
    return data;
  }

  @override
  bool get hasData {
    return id != null && albums_id != null && description != null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is AlbumModelNew2 &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          albums_id == other.albums_id &&
          description == other.description &&
          media == other.media &&
          created_at == other.created_at &&
          updated_at == other.updated_at;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      albums_id.hashCode ^
      description.hashCode ^
      media.hashCode ^
      created_at.hashCode ^
      updated_at.hashCode;
}
