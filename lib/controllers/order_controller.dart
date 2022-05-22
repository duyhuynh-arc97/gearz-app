import 'dart:convert';

import 'package:get/get.dart';
import 'package:itproject_gadget_store/controllers/product_controller.dart';
import 'package:itproject_gadget_store/controllers/shipping_controller.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/models/additional_contact.dart';
import 'package:itproject_gadget_store/models/cart_item.dart';
import 'package:itproject_gadget_store/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:itproject_gadget_store/models/product.dart';

class OrderController extends GetxController {
  var myOrders = <Order>[].obs;
  var isLoading = true.obs;
  var unratedProducts = <Product>[].obs;
  var unpaidOrders = <Order>[].obs;
  var cancelledOrders = <Order>[].obs;
  var paidOrders = <Order>[].obs;

  UserController _userController = Get.find();
  ShippingController _shippingController = Get.find();
  var _productController = Get.put(ProductController());

  @override
  void onInit() {
    super.onInit();
    _userController.getMail().then((value) async {
      await _userController.getUser(value);
      await getOrder(_userController.user.value.id);

      for (var i in myOrders
          .where((p0) =>
              p0.status == "PAID" ||
              (p0.finalTrack.status == "DELIVERED" ||
                  p0.finalTrack.status == "PAID"))
          .toList()) {
        for (var j in i.items) {
          unratedProducts += _productController.productList
              .where((p0) => p0.id == j.productId && j.isReviewed == 0)
              .toList();
        }
      }

      for (var i in myOrders) {
        if (i.status != "PAID" &&
            i.status != "RETURN_REQUESTED" &&
            i.status != "REFUNDED" &&
            i.status != "CANCELLED" &&
            i.status != "RETURNED") {
          unpaidOrders.add(i);
        }
      }

      for (var i in myOrders) {
        if (i.status == "RETURN_REQUESTED" ||
            i.status == "REFUNDED" ||
            i.status == "CANCELLED" ||
            i.status == "RETURNED") {
          cancelledOrders.add(i);
        }
      }

      for (var i in myOrders) {
        if (i.status == "PAID") {
          paidOrders.add(i);
        }
      }
    });
  }

  //Get orders
  getOrder(int userId) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/user_controllers/get_order.php"),
        body: {"userId": userId.toString()});
    var jsonData = jsonDecode(response.body);

    if (jsonData == "not found") {
      isLoading.value = false;
      return myOrders;
    }

    for (var data in jsonData) {
      Order o = Order.fromJson(data);
      myOrders.add(o);
    }

    isLoading.value = false;
    update();
  }

  //Place order
  Future<String> placeOrder(
      {required List<CartItem> items,
      required AdditionalContact contact,
      required double total,
      required double shippingCost,
      required String method}) async {
    var t = [];
    for (var i in items) {
      t.add(i.toJson());
    }
    var c = contact.toJson();
    var duration = 0;

    for (var i in _shippingController.shippingRateList) {
      if (i.cityId == contact.city!.id &&
          i.district == contact.district!.name) {
        duration = i.duration;
      }
    }

    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/user_controllers/add_order.php"),
        body: jsonEncode({
          "orders": t,
          "contact": c,
          "total": total.toStringAsFixed(2),
          "shipFee": shippingCost.toStringAsFixed(2),
          "orderTime": DateTime.now().toString(),
          "deliverTime":
              DateTime.now().add(Duration(days: duration)).toString(),
          "duration": duration,
          "pm": method,
        }));
    var jsonData = jsonDecode(response.body);

    return jsonData;
  }

  //Return the order
  Future returnOrder({required int? id}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/product_controllers/return_order.php"),
        body: {
          "orderId": id.toString(),
          "time": DateTime.now().toString(),
        });
    var jsonData = jsonDecode(response.body);

    print(response.body);

    return jsonData;
  }
}
