import 'dart:core';

import 'package:home_services_provider/app/models/subAlbum_media_model.dart';

import 'parents/model.dart';

class SubAlbumGalleries extends Model {
  String id;
  String description;
  String e_provider_id;
  String created_at;
  String updated_at;
  String custom_fields;
  List<SubMedia> media;

  SubAlbumGalleries(this.id, this.description, this.e_provider_id,
      this.created_at, this.updated_at, this.custom_fields, this.media);

  SubAlbumGalleries.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    id = stringFromJson(json, 'id');
    description = transStringFromJson(json, 'description');
    e_provider_id = stringFromJson(json, 'e_provider_id');
    created_at = stringFromJson(json, 'created_at');
    updated_at = stringFromJson(json, 'updated_at');
    custom_fields = stringFromJson(json, 'custom_fields');
    media = listFromJson(json, 'media', (v) => SubMedia.fromMap(v));
    ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.description;
    data['start_at'] = this.e_provider_id;
    data['end_at'] = this.created_at;
    data['data'] = this.updated_at;
    data['data'] = this.custom_fields;
    return data;
  }
}
