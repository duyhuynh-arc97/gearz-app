import 'dart:convert';

import 'package:get/get.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/models/wishlist.dart';
import 'package:http/http.dart' as http;

class WishlistController extends GetxController {
  var wishlistItems = <Wishlist>[].obs;
  var isLoading = true.obs;

  UserController _userController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _userController.getMail().then((value) async {
      await _userController.getUser(value);
      getWishlistItems(_userController.user.value.id);
    });
  }

  //Get wishlist items
  getWishlistItems(int userId) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/user_controllers/get_wishlist.php"),
        body: {"userId": userId.toString()});
    var jsonData = jsonDecode(response.body);

    if (jsonData == "not found") {
      isLoading.value = false;
      return wishlistItems;
    }

    for (var data in jsonData) {
      Wishlist w = Wishlist.fromJson(data);
      wishlistItems.add(w);
    }
    
    isLoading.value = false;
    update();
  }

  //Like/Dislike
  Future<String> addToWishlist(
      {required int userId, required int productId}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/product_controllers/add_to_wishlist.php"),
        body: {"userId": userId.toString(), "productId": productId.toString()});
    var jsonData = jsonDecode(response.body);

    return jsonData;
  }

  //Remove wishlist item
  Future<String> removeFromWishlist(
      {required int userId, required int productId}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/product_controllers/remove_wishlist_item.php"),
        body: {"userId": userId.toString(), "productId": productId.toString()});
    var jsonData = jsonDecode(response.body);

    return jsonData;
  }
}
