// import 'parents/model.dart';
//
// class Extra extends Model {
//   String name;
//   int price;
//
//   Extra({this.name, this.price});
//
//   Extra.fromJson(Map<String, dynamic> json) {
//     super.fromJson(json);
//
//     name = transStringFromJson(json, 'name');
//     price = intFromJson(json, 'name');
//   }
//
//   Map<String, dynamic> toJson() {
//     var map = new Map<String, dynamic>();
//     if (name != null) map["name"] = name;
//     if (price != null) map["price"] = name;
//     return map;
//   }
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       super == other &&
//           other is Extra &&
//           runtimeType == other.runtimeType &&
//           name == other.name;
//
//   @override
//   int get hashCode => super.hashCode ^ name.hashCode;
// }
