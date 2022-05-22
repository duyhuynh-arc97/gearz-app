import 'package:itproject_gadget_store/models/category.dart';

class Brand {
  late int id;
  late String name, logo;
  late List<Category>? categoryList;

  Brand(
      {required this.id,
      required this.name,
      required this.logo,
      this.categoryList});

  factory Brand.fromJson(Map<String, dynamic> json) {
    if (json["categories"] == null) {
      return Brand(
          id: int.parse(json["id"]),
          name: json["name"],
          logo:
              "https://gearz-gadget.000webhostapp.com/brand_logos/${json["id"]}/${json["logo"]}");
    }

    List<Category> list = [];
    for (var data in json["categories"]) {
      Category c = Category.fromJson(data);
      list.add(c);
    }
    return Brand(
        id: int.parse(json["id"]),
        name: json["name"],
        logo:
            "https://gearz-gadget.000webhostapp.com/brand_logos/${json["id"]}/${json["logo"]}",
        categoryList: list);
  }
}
