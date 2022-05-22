import 'package:itproject_gadget_store/models/brand.dart';
import 'package:itproject_gadget_store/models/category.dart';
import 'package:itproject_gadget_store/models/product_images.dart';
import 'package:itproject_gadget_store/models/product_specifications.dart';

class Product {
  late int id, inStock, discount, brandId, categoryId, enabled;
  late String name, tag, shortDesc, fullDesc, mainImg;
  late double price, length, weight, width, height, rating;
  late Brand? brand;
  late Category? category;
  late List<ProductImages>? imgList;
  late List<ProductSpecifications>? specList;
  late List? reviews;

  Product(
      {required this.id,
      required this.name,
      required this.tag,
      required this.shortDesc,
      required this.fullDesc,
      required this.price,
      required this.discount,
      required this.length,
      required this.width,
      required this.height,
      required this.weight,
      required this.inStock,
      required this.mainImg,
      required this.brandId,
      required this.categoryId,
      required this.enabled,
      required this.rating,
      this.brand,
      this.category,
      this.specList,
      this.imgList,
      this.reviews});

  factory Product.fromJson(Map<String, dynamic> json) {
    if (json["brand"] == null &&
        json["category"] == null &&
        json["images"] == null &&
        json["specifications"] == null) {
      return Product(
        id: int.parse(json["id"]),
        name: json["name"],
        tag: json["tag"],
        enabled: int.parse(json["enabled"]),
        brandId: int.parse(json["brand_id"]),
        categoryId: int.parse(json["category_id"]),
        shortDesc: json["short_description"],
        fullDesc: json["full_description"],
        price: double.parse(json["price"]),
        discount: int.parse(json["discount_percentage"]),
        length: double.parse(json["length"]),
        width: double.parse(json["width"]),
        height: double.parse(json["height"]),
        weight: double.parse(json["weight"]),
        inStock: int.parse(json["in_stock"]),
        rating: json["average_rating"] == null
            ? 0.0
            : double.parse(json["average_rating"]),
        mainImg:
            "https://gearz-gadget.000webhostapp.com/product_images/${json["id"]}/${json["main_image"]}",
      );
    }

    List<ProductImages> iList = [];
    List<ProductSpecifications> sList = [];
    List rList = [];

    for (var i in json["reviews"]) {
      rList.add(i);
    }

    for (var idata in json["images"]) {
      ProductImages i = ProductImages.fromJson(idata);
      iList.add(i);
    }

    for (var sdata in json["specifications"]) {
      ProductSpecifications s = ProductSpecifications.fromJson(sdata);
      sList.add(s);
    }

    return Product(
      id: int.parse(json["id"]),
      name: json["name"],
      tag: json["tag"],
      enabled: int.parse(json["enabled"]),
      shortDesc: json["short_description"],
      fullDesc: json["full_description"],
      price: double.parse(json["price"]),
      discount: int.parse(json["discount_percentage"]),
      length: double.parse(json["length"]),
      width: double.parse(json["width"]),
      height: double.parse(json["height"]),
      weight: double.parse(json["weight"]),
      brand: Brand(
          id: int.parse(json["brand"]["id"]),
          name: json["brand"]["name"],
          logo: json["brand"]["logo"],
          categoryList: []),
      brandId: int.parse(json["brand_id"]),
      category: Category(
        id: int.parse(json["category"]["id"]),
        name: json["category"]["name"],
        tag: json["category"]["tag"],
        image: json["category"]["image"],
        parent: Category(
          parent: null,
          id: int.parse(json["category"]["parent_category"]["id"]),
          name: json["category"]["parent_category"]["name"],
          tag: json["category"]["parent_category"]["tag"],
          image: json["category"]["parent_category"]["image"],
        ),
      ),
      categoryId: int.parse(json["category_id"]),
      inStock: int.parse(json["in_stock"]),
      rating: json["average_rating"] == null
          ? 0.0
          : double.parse(json["average_rating"]),
      mainImg:
          "https://gearz-gadget.000webhostapp.com/product_images/${json["id"]}/${json["main_image"]}",
      specList: sList,
      imgList: iList,
      reviews: rList,
    );
  }
}
