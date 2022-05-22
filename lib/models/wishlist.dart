import 'package:itproject_gadget_store/models/product.dart';

class Wishlist {
  late int? id;
  late int userId;
  late Product item;

  Wishlist({this.id, required this.item, required this.userId});

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
        id: int.parse(json["id"]), item: Product.fromJson(json["product"]),userId: int.parse(json["customer_id"]));
  }
}
