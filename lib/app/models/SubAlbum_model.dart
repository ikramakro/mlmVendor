import 'dart:core';

import 'SubAlbumGalleries_model.dart';
import 'parents/model.dart';

class SubAlbum extends Model {
  String id;
  String albums_id;
  String gallery_id;
  DateTime created_at;
  DateTime updated_at;
  List<SubAlbumGalleries> galleries;

  SubAlbum({
    this.id,
    this.albums_id,
    this.gallery_id,
    this.created_at,
    this.updated_at,
    this.galleries,
  });

  SubAlbum.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    id = transStringFromJson(json, 'id');
    albums_id = transStringFromJson(json, 'albums_id');
    gallery_id = transStringFromJson(json, 'gallery_id');
    created_at = dateFromJson(json, 'created_at',
        defaultValue: DateTime.now().toLocal());
    updated_at = dateFromJson(json, 'updated_at',
        defaultValue: DateTime.now().toLocal());

    galleries =
        listFromJson(json, 'galleries', (v) => SubAlbumGalleries.fromJson(v));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['albums_id'] = this.albums_id;
    data['gallery_id'] = this.gallery_id;
    data['created_at'] = this.created_at;
    data['updated_at'] = this.updated_at;
    data['galleries'] = this.galleries;
    return data;
  }

  // String get firstImageUrl => this.images?.first?.url ?? '';

  @override
  bool get hasData {
    return id != null && albums_id != null && galleries != null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is SubAlbum &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          albums_id == other.albums_id &&
          gallery_id == other.gallery_id &&
          created_at == other.created_at &&
          updated_at == other.updated_at &&
          galleries == other.galleries;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      albums_id.hashCode ^
      gallery_id.hashCode ^
      created_at.hashCode ^
      updated_at.hashCode ^
      galleries.hashCode;
}
