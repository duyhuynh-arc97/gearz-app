import 'package:itproject_gadget_store/models/city.dart';
import 'package:itproject_gadget_store/models/district.dart';
import 'package:itproject_gadget_store/models/ward.dart';

class User {
  late String fullName, mail, password, phone, addressLine, profilePic;
  late int id, enabled;
  late DateTime createdTime;
  late City? city;
  late District? district;
  late Ward? ward;

  User({
    this.id = 0,
    required this.fullName,
    required this.mail,
    required this.password,
    this.phone = "",
    this.addressLine = "",
    required this.enabled,
    required this.createdTime,
    this.profilePic = "",
    this.city,
    this.district,
    this.ward,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json["phone_number"] == null &&
        json["address_line"] == null &&
        json["ward_id"] == null &&
        json["district_id"] == null &&
        json["city_id"] == null) {
      return User(
        id: int.parse(json["id"]),
        fullName: json["full_name"],
        mail: json["email"],
        password: json["password"],
        enabled: int.parse(json["enabled"]),
        createdTime: DateTime.parse(json["created_time"]),
        profilePic: json["profile_pic"] == null ? "" : json["profile_pic"],
      );
    }

    if (json["phone_number"] != null &&
        json["address_line"] != null &&
        json["ward_id"] != null &&
        json["district_id"] != null &&
        json["city_id"] != null &&
        json["profile_pic"] == null) {
      return User(
        id: int.parse(json["id"]),
        fullName: json["full_name"],
        mail: json["email"],
        password: json["password"],
        phone: json["phone_number"],
        addressLine: json["address_line"],
        enabled: int.parse(json["enabled"]),
        createdTime: DateTime.parse(json["created_time"]),
        city: City.fromJson(json["city"]),
        district: District.fromJson(json["district"]),
        ward: Ward.fromJson(json["ward"]),
        profilePic: json["profile_pic"] == null ? "" : json["profile_pic"],
      );
    }

    return User(
      id: int.parse(json["id"]),
      fullName: json["full_name"],
      mail: json["email"],
      password: json["password"],
      phone: json["phone_number"],
      addressLine: json["address_line"],
      enabled: int.parse(json["enabled"]),
      createdTime: DateTime.parse(json["created_time"]),
      profilePic: json["profile_pic"],
      city: City.fromJson(json["city"]),
      district: District.fromJson(json["district"]),
      ward: Ward.fromJson(json["ward"]),
    );
  }
}
