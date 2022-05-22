class Category {
  late int id;
  late String name, tag, image;
  late Category? parent;

  Category(
      {required this.id,
      required this.name,
      required this.tag,
      this.parent,
      required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    if (json["parent_category"] == null) {
      return Category(
          id: int.parse(json["id"]),
          name: json["name"],
          tag: json["tag"],
          parent: null,
          image:
              "https://gearz-gadget.000webhostapp.com/category_images/${json["id"]}/${json["image"]}");
    }
    return Category(
        id: int.parse(json["id"]),
        name: json["name"],
        tag: json["tag"],
        parent: Category(
            parent: null,
            id: int.parse(json["parent_category"]["id"]),
            name: json["parent_category"]["name"],
            tag: json["parent_category"]["tag"],
            image:
                "https://gearz-gadget.000webhostapp.com/category_images/${json["parent_category"]["id"]}/${json["parent_category"]["image"]}"),
        image:
            "https://gearz-gadget.000webhostapp.com/category_images/${json["id"]}/${json["image"]}");
  }
}
