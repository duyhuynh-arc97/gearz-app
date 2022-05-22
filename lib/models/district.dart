class District {
  late int id, cityId;
  late String name;

  District({required this.id, required this.name, required this.cityId});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: int.parse(json["id"]),
      name: json["name"],
      cityId: int.parse(json["city_id"]),
    );
  }
}
