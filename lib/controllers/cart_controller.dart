import 'dart:convert';

import 'package:get/get.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/models/cart_item.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var isLoading = true.obs;

  UserController _userController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _userController.getMail().then((value) async {
      await _userController.getUser(value);
      getCartItems(_userController.user.value.id);
    });
  }

  //Get cart items
  getCartItems(int userId) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/user_controllers/get_cart_items.php"),
        body: {"userId": userId.toString()});
    var jsonData = jsonDecode(response.body);

    if (jsonData == "not found") {
      isLoading.value = false;
      return cartItems;
    }

    for (var data in jsonData) {
      CartItem c = CartItem.fromJson(data);
      cartItems.add(c);
    }
    isLoading.value = false;
    update();
  }

  //Total price
  totalPrice(List<CartItem> list) {
    var t = 0.0;
    for (CartItem i in list) {
      if (i.isChoosen == true) {
        t += double.parse(((i.item.price - i.item.price * i.item.discount / 100) *
            i.quantity).toStringAsFixed(2));
      }
    }

    return t;
  }

  //Add to cart
  Future<String> addToCart(
      {required int userId,
      required int productId,
      required int quantity}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/product_controllers/add_to_cart.php"),
        body: {
          "userId": userId.toString(),
          "productId": productId.toString(),
          "quantity": quantity.toString()
        });
    var jsonData = jsonDecode(response.body);

    return jsonData;
  }

  //Remove cart item
  Future<String> removeFromCart(
      {required int userId, required int productId}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/product_controllers/remove_cart_item.php"),
        body: {"userId": userId.toString(), "productId": productId.toString()});
    var jsonData = jsonDecode(response.body);

    return jsonData;
  }

  //Update cart item
  Future<String> updateCartItem(
      {required int userId,
      required int productId,
      required int quantity}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/product_controllers/update_cart_item.php"),
        body: {
          "userId": userId.toString(),
          "productId": productId.toString(),
          "quantity": quantity.toString()
        });
    var jsonData = jsonDecode(response.body);

    return jsonData;
  }
}
