import 'parents/model.dart';

class Charge extends Model {
  String name;
  int price;

  Charge({
    this.name,
    this.price,
  });

  Charge.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    price = intFromJson(json, 'price');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Charge &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          price == other.price;

  @override
  int get hashCode => super.hashCode ^ name.hashCode ^ price.hashCode;
}
