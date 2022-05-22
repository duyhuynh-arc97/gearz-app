class City {
  late int id;
  late String code, name;

  City({required this.id, required this.code, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: int.parse(json["id"]),
      name: json["name"],
      code: json["code"],
    );
  }
}
