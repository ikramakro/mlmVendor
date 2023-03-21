// import 'parents/model.dart';
//
// class ChargesExtra extends Model {
//   String key;
//   String value;
//
//   ChargesExtra({
//     this.key,
//     this.value,
//   });
//
//   ChargesExtra.fromJson(Map<String, dynamic> json) {
//     super.fromJson(json);
//     if (json['extra'] != null) {
//       extra = <List>[];
//       json['extra'].forEach((v) { extra!.add(new List.fromJson(v)); });
//     }
//     order = intFromJson(json, 'order');
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['id'] = this.id;
//     data['status'] = this.status;
//     data['order'] = this.order;
//     return data;
//   }
// }
