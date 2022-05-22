import 'dart:convert';

import 'package:get/get.dart';
import 'package:itproject_gadget_store/models/brand.dart';
import 'package:http/http.dart' as http;
import 'package:itproject_gadget_store/models/product.dart';

import '../models/category.dart';

class ProductController extends GetxController {
  var categoryList = <Category>[].obs;
  var brandList = <Brand>[].obs;
  var productList = <Product>[].obs;
  var popularProductList = <Product>[];
  var isLoadingC = true.obs;
  var isLoadingB = true.obs;
  var isLoadingP = true.obs;

  @override
  void onInit() async {
    super.onInit();
    getCategoryList();
    getBrandList();
    await getProductList();
    popularProductList = productList.where((p0) => p0.rating > 3).toList();
  }

  //List of categories
  Future<void> getCategoryList() async {
    var response = await http.get(Uri.parse(
        "https://gearz-gadget.000webhostapp.com/product_controllers/get_category_details.php"));
    var jsonData = jsonDecode(response.body);

    for (var data in jsonData) {
      Category c = Category.fromJson(data);
      categoryList.add(c);
    }

    isLoadingC.value = false;
    update();
  }

  //List of brands
  Future<void> getBrandList() async {
    var response = await http.get(Uri.parse(
        "https://gearz-gadget.000webhostapp.com/product_controllers/get_brand_details.php"));
    var jsonData = jsonDecode(response.body);

    for (var data in jsonData) {
      Brand b = Brand.fromJson(data);
      brandList.add(b);
    }

    isLoadingB.value = false;
    update();
  }

  //List of products
  getProductList() async {
    var response = await http.get(Uri.parse(
        "https://gearz-gadget.000webhostapp.com/product_controllers/get_products.php"));
    var jsonData = jsonDecode(response.body);

    for (var data in jsonData) {
      Product p = Product.fromJson(data);
      productList.add(p);
    }

    isLoadingP.value = false;
    update();
  }

  //Get product details
  static Future<Product> getProductDetails({required int id}) async {
    var response = await http.post(
        Uri.parse(
            "https://gearz-gadget.000webhostapp.com/product_controllers/get_product_details.php"),
        body: {"id": id.toString()});
    var jsonData = jsonDecode(response.body);
    Product p = Product.fromJson(jsonData);

    return p;
  }
}
