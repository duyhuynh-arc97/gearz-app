import 'dart:convert';

import 'package:get/get.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/models/additional_contact.dart';
import 'package:http/http.dart' as http;
import 'package:itproject_gadget_store/models/city.dart';
import 'package:itproject_gadget_store/models/district.dart';
import 'package:itproject_gadget_store/models/ward.dart';

class AdditionalContactController extends GetxController {
  var contactList = <AdditionalContact>[].obs;
  var isLoading = true.obs;
  UserController _userController = Get.find();
  var deliveryContact = {
    "userId": 0,
    "name": "",
    "addressLine": "",
    "ward": null,
    "district": null,
    "city": null,
    "phone": "",
  }.obs;

  @override
  void onInit() {
    super.onInit();

    _userController.getMail().then((value) async {
      await _userController.getUser(value);
      await getAdditionalContacts(userId: _userController.user.value.id);
      deliveryContact["userId"] = _userController.user.value.id;
      deliveryContact["name"] = _userController.user.value.fullName;
      deliveryContact["addressLine"] = _userController.user.value.addressLine;
      deliveryContact["ward"] = _userController.user.value.ward;
      deliveryContact["district"] = _userController.user.value.district;
      deliveryContact["city"] = _userController.user.value.city;
      deliveryContact["phone"] = _userController.user.value.phone;
    });
  }

  //Get additional contacts
  getAdditionalContacts({required int userId}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/address_controllers/get_additional_contacts.php"),
        body: {"userId": userId.toString()});
    var jsonData = jsonDecode(response.body);

    if (jsonData == "no data") {
      isLoading.value = false;
      return contactList;
    }

    for (var data in jsonData) {
      AdditionalContact a = AdditionalContact.fromJson(data);
      contactList.add(a);
    }

    isLoading.value = false;
    update();
  }

//Add contact
  Future<bool> addContact(
      {required int id,
      required String name,
      required String phone,
      required String addressLine,
      required City city,
      required District district,
      required Ward ward}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/user_controllers/add_contact.php"),
        body: {
          "userId": id.toString(),
          "name": name,
          "phone": phone,
          "addressLine": addressLine,
          "cityId": city.id.toString(),
          "districtId": district.id.toString(),
          "wardId": ward.id.toString()
        });
    var jsonData = jsonDecode(response.body);

    if (jsonData == "failed") {
      return false;
    }

    contactList.add(AdditionalContact(
        userId: id,
        name: name,
        addressLine: addressLine,
        ward: ward,
        district: district,
        city: city,
        phone: phone,
        isDefault: 0));

    return true;
  }

  //Update contact
  Future<bool> updateContact(
      {required int? id,
      required int userId,
      required String name,
      required String phone,
      required String addressLine,
      required City city,
      required District district,
      required Ward ward}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/user_controllers/update_contact.php"),
        body: {
          "contactId": id.toString(),
          "userId": userId.toString(),
          "name": name,
          "phone": phone,
          "addressLine": addressLine,
          "cityId": city.id.toString(),
          "districtId": district.id.toString(),
          "wardId": ward.id.toString()
        });
    var jsonData = jsonDecode(response.body);

    if (jsonData == "failed") {
      return false;
    }

    update();

    return true;
  }

  //Remove contact
  Future<String> removeContact(
      {required int userId, required String name}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/user_controllers/remove_contact.php"),
        body: {"userId": userId.toString(), "name": name});
    var jsonData = jsonDecode(response.body);

    return jsonData;
  }

  //Update delivery contact
  updateDeliveryContact({required AdditionalContact contact}) {
    deliveryContact["userId"] = contact.userId;
    deliveryContact["name"] = contact.name;
    deliveryContact["addressLine"] = contact.addressLine;
    deliveryContact["ward"] = contact.ward;
    deliveryContact["district"] = contact.district;
    deliveryContact["city"] = contact.city;
    deliveryContact["phone"] = contact.phone;

    update();
  }
}
