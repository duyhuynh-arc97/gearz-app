import 'dart:convert';

import 'package:get/get.dart';
import 'package:itproject_gadget_store/models/cart_item.dart';
import 'package:itproject_gadget_store/models/shipping_rate.dart';
import 'package:http/http.dart' as http;

class ShippingController extends GetxController {
  var shippingRateList = <ShippingRate>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getShippingRates();
  }

  //Get shipping rates
  getShippingRates() async {
    var response = await http.get(Uri.parse(
        "https://gearz-gadget.000webhostapp.com/address_controllers/get_shipping_rate.php"));
    var jsonData = jsonDecode(response.body);

    for (var data in jsonData) {
      ShippingRate s = ShippingRate.fromJson(data);
      shippingRateList.add(s);
    }

    update();
  }

  //Calculate shipping fee
  calculateShippingFee(
      {required List<CartItem> items,
      required int cityId,
      required String district}) {
    var rate = 0.0, totalfee = 0.0;

    for (var i in shippingRateList) {
      if (i.cityId == cityId && i.district == district) {
        rate = i.rate;
        break;
      }
    }

    for (var i in items) {
      var dimweight = (i.item.length * i.item.width * i.item.height) / 139;
      var finalweight = 0.0;
      if (dimweight < i.item.weight) {
        finalweight = i.item.weight;
      } else {
        finalweight = dimweight;
      }

      totalfee += finalweight * rate;
    }

    return totalfee / items.length;
  }

  //Check if cod is supported
  checkCODSupported({required int cityId, required String district}) {
    for (var i in shippingRateList) {
      if (i.cityId == cityId && i.district == district) {
        if (i.codSupported == 1) {
          return true;
        }
        return false;
      }
    }
  }

  //Calculate the shipping date
  calculateShippingDate({required int cityId, required String district}) {
    List _month = [
      "Jan",
      "Feb",
      "March",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    for (var i in shippingRateList) {
      if (i.cityId == cityId && i.district == district) {
        String estArrMon = _month[
            DateTime.now().add(Duration(days: i.duration - 1)).month - 1];
        int estArrDay = DateTime.now().add(Duration(days: i.duration - 1)).day;
        String appxArrMon = _month[
            DateTime.now().add(Duration(days: i.duration + 1)).month - 1];
        int appArrDay = DateTime.now().add(Duration(days: i.duration + 1)).day;
        return estArrMon +
            " ${estArrDay}" +
            " - " +
            appxArrMon +
            " ${appArrDay}";
      }
    }

    return -1;
  }

  //Calculate shipping duration
  calculateShippingDuration({required int cityId, required String district}) {
    var d = 0;

    for (var i in shippingRateList) {
      if (i.cityId == cityId && i.district == district) {
        d = i.duration;
        break;
      }
    }

    return d;
  }
}
