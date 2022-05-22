class Ward {
  late int id, districtId;
  late String name;

  Ward({required this.id, required this.name, required this.districtId});

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      id: int.parse(json["id"]),
      name: json["name"],
      districtId: int.parse(json["district_id"]),
    );
  }
}
