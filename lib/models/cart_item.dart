import 'package:get/get.dart';
import 'package:itproject_gadget_store/controllers/additional_contact_controller.dart';
import 'package:itproject_gadget_store/controllers/shipping_controller.dart';
import 'package:itproject_gadget_store/models/product.dart';

import 'city.dart';
import 'district.dart';

class CartItem {
  late int? id;
  late int userId, quantity;
  late Product item;
  late bool isChoosen;

  ShippingController _shipC = Get.find();
  AdditionalContactController _contactC = Get.find();

  CartItem(
      {this.id,
      required this.userId,
      required this.item,
      required this.quantity,
      required this.isChoosen});

  double get total {
    return (this.item.price - this.item.price * this.item.discount / 100) *
        this.quantity;
  }

  double get shippingFee {
    var totalfee = 0.0, rate = 0.0;

    for (var i in _shipC.shippingRateList) {
      if (i.cityId == (_contactC.deliveryContact["city"] as City).id &&
          i.district ==
              (_contactC.deliveryContact["district"] as District).name) {
        rate = i.rate;
        break;
      }
    }

    var dimweight =
        (this.item.length * this.item.width * this.item.height) / 139;
    var finalweight = 0.0;
    if (dimweight < this.item.weight) {
      finalweight = this.item.weight;
    } else {
      finalweight = dimweight;
    }

    totalfee += finalweight * rate;

    return totalfee;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        id: int.parse(json["id"]),
        item: Product.fromJson(json["product"]),
        userId: int.parse(json["customer_id"]),
        quantity: int.parse(json["quantity"]),
        isChoosen: false);
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'userId': this.userId,
        'quantity': this.quantity,
        'productId': this.item.id,
        'subtotal': total.toStringAsFixed(2),
        'shippingFee': shippingFee,
        'unitprice': this.item.price,
      };
}
