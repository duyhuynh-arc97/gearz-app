import 'dart:convert';

import 'package:get/get.dart';
import 'package:itproject_gadget_store/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var user = User(
    fullName: "",
    mail: "",
    password: "",
    enabled: 0,
    createdTime: DateTime.now(),
  ).obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getMail().then((value) async {
      getUser(value);
    });
  }

  //Get user's mail
  Future<String?> getMail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("mail");
  }

  //Get user
  getUser(String? mail) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/user_controllers/get_user.php"),
        body: {"email": mail});
    var jsonData = jsonDecode(response.body);

    if (jsonData == "not found") {
      return null;
    }

    User u = User.fromJson(jsonData);
    user.value = u;
    isLoading.value = false;
    update();
  }

  //Update info
  Future<bool> updateInfo({required User inputUser}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/user_controllers/update_info.php"),
        body: {
          "userId": inputUser.id.toString(),
          "name": inputUser.fullName,
          "phone": inputUser.phone,
          "addressLine": inputUser.addressLine,
          "cityId": inputUser.city!.id.toString(),
          "districtId": inputUser.district!.id.toString(),
          "wardId": inputUser.ward!.id.toString()
        });
    var jsonData = jsonDecode(response.body);

    if (jsonData == "failed") {
      return false;
    }

    user.value = inputUser;
    update();
    return true;
  }

  //Review
  Future reviewProduct(
      {required String heading,
      required String comment,
      required int userId,
      required int productId,
      required int rating}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/user_controllers/review.php"),
        body: {
          "userId": userId.toString(),
          "productId": productId.toString(),
          "rate": rating.toString(),
          "cmt": comment,
          "headline": heading,
          "time": DateTime.now().toString(),
        });
    var jsonData = jsonDecode(response.body);

    return jsonData;
  }
}
