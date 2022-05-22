class ProductImages {
  late int id, productId;
  late String image;

  ProductImages(
      {required this.id, required this.productId, required this.image});

  factory ProductImages.fromJson(Map<String, dynamic> json) {
    return ProductImages(
        id: int.parse(json["id"]),
        productId: int.parse(json["product_id"]),
        image: json["image"]);
  }
}
