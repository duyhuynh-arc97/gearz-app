import 'package:itproject_gadget_store/models/city.dart';
import 'package:itproject_gadget_store/models/district.dart';
import 'package:itproject_gadget_store/models/ward.dart';

class AdditionalContact {
  late int? id;
  late int userId, isDefault;
  late String name, addressLine, phone;
  late City? city;
  late District? district;
  late Ward? ward;

  AdditionalContact(
      {this.id,
      required this.userId,
      required this.name,
      required this.addressLine,
      required this.ward,
      required this.district,
      required this.city,
      required this.phone,
      required this.isDefault});

  factory AdditionalContact.fromJson(Map<String, dynamic> json) {
    return AdditionalContact(
        id: int.parse(json["id"]),
        userId: int.parse(json["customer_id"]),
        name: json["full_name"],
        addressLine: json["address_line"],
        ward: Ward.fromJson(json["ward"]),
        district: District.fromJson(json["district"]),
        city: City.fromJson(json["city"]),
        phone: json["phone_number"],
        isDefault: int.parse(json["default_address"]));
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'userId': this.userId,
        'name': this.name,
        'addressLine': this.addressLine,
        'ward': this.ward!.name,
        'district': this.district!.name,
        'city': this.city!.name,
        'phone': this.phone,
        'isDefault': this.isDefault,
      };
}
