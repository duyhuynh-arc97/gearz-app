class ShippingRate {
  late int? id;
  late int cityId;
  late String district;
  late double rate;
  late int duration;
  late int codSupported;

  ShippingRate(
      {this.id,
      required this.cityId,
      required this.district,
      required this.rate,
      required this.duration,
      required this.codSupported});

  factory ShippingRate.fromJson(Map<String, dynamic> json) {
    return ShippingRate(
      id: int.parse(json["id"]),
      district: json["district"],
      cityId: int.parse(json["city_id"]),
      rate: double.parse(json["rate"]),
      duration: int.parse(json["days"]),
      codSupported: int.parse(json["cod_supported"]),
    );
  }
}
