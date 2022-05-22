class ProductSpecifications {
  late int id, productId;
  late String name, value;

  ProductSpecifications(
      {required this.id,
      required this.productId,
      required this.name,
      required this.value});

  factory ProductSpecifications.fromJson(Map<String, dynamic> json) {
    return ProductSpecifications(
        id: int.parse(json["id"]),
        productId: int.parse(json["product_id"]),
        name: json["name"],
        value: json["value"]);
  }
}
