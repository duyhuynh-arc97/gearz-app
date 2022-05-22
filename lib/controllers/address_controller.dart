import 'dart:convert';

import 'package:get/get.dart';
import 'package:itproject_gadget_store/models/city.dart';
import 'package:itproject_gadget_store/models/district.dart';
import 'package:http/http.dart' as http;
import 'package:itproject_gadget_store/models/ward.dart';

class AddressController extends GetxController {
  var cities = <City>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();
    getCities();
  }

  //Get cities
  getCities() async {
    var response = await http.get(Uri.parse(
        "https://gearz-gadget.000webhostapp.com/address_controllers/get_cities.php"));
    var jsonData = jsonDecode(response.body);

    for (var data in jsonData) {
      City c = City.fromJson(data);
      cities.add(c);
    }

    isLoading.value = false;
    update();
  }

  //Get districts by city
  Future<List<District>?> getDistricts(int id) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/address_controllers/get_districts.php"),
        body: {"cityId": id.toString()});
    var jsonData = jsonDecode(response.body);
    List<District> list = [];

    if (jsonData == "no data") {
      return null;
    }

    for (var data in jsonData) {
      District d = District.fromJson(data);
      list.add(d);
    }

    return list;
  }

  //Get wards by district
  Future<List<Ward>?> getWards(int id) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/address_controllers/get_wards.php"),
        body: {"districtId": id.toString()});
    var jsonData = jsonDecode(response.body);
    List<Ward> list = [];

    if (jsonData == "no data") {
      return null;
    }

    for (var data in jsonData) {
      Ward w = Ward.fromJson(data);
      list.add(w);
    }

    return list;
  }
}
