import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/product_controller.dart';
import 'package:itproject_gadget_store/models/product.dart';
import 'package:itproject_gadget_store/screens/additional_screens/product_details_screen.dart';

class AppSearchBar extends SearchDelegate {
  final int? categoryId, brandId;
  final List<Product>? items;
  AppSearchBar({this.categoryId, this.brandId, this.items});

  ProductController _productController = Get.find();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(
            Ionicons.close_outline,
            color: Colors.black,
            size: 24 * screenScale(context),
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Ionicons.chevron_back_outline,
          color: Colors.black,
          size: 24 * screenScale(context),
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    var _results = [];

    if (categoryId != null) {
      var _plist = [];
      for (var i in _productController.categoryList) {
        _plist += _productController.productList
            .where((p0) => p0.categoryId == i.id && i.parent!.id == categoryId)
            .toList();
      }

      _results = query.isEmpty
          ? []
          : _plist
              .where((element) =>
                  element.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    } else if (brandId != null) {
      _results = _productController.productList
          .where((p0) =>
              p0.name.toLowerCase().contains(query.toLowerCase()) &&
              p0.brandId == brandId)
          .toList();
    } else if (items != null) {
      _results = items!
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _results = _productController.productList
          .where((p0) => p0.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    if (_results.length == 0) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No results ",
              style: TextStyle(
                  color: Colors.grey, fontSize: 15 * fontScale(context)),
            ),
            Icon(
              Iconsax.emoji_sad,
              color: Colors.blue,
              size: 17 * screenScale(context),
            )
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(10),
      separatorBuilder: (context, index) => Divider(
        thickness: 1.5 * screenScale(context),
      ),
      itemBuilder: (context, index) {
        return ListTile(
          visualDensity: VisualDensity.comfortable,
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$" + _results[index].price.toString(),
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14 * fontScale(context)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Details",
                    style: TextStyle(
                        color: Colors.blue, fontSize: 14 * fontScale(context)),
                  ),
                  Icon(
                    Ionicons.chevron_forward_outline,
                    size: 17 * screenScale(context),
                    color: Colors.blue,
                  )
                ],
              )
            ],
          ),
          onTap: () =>
              Get.to(() => ProductDetailsScreen(product: _results[index])),
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(10 * screenScale(context)),
              child: Image.network(_results[index].mainImg)),
          title: Text(
            _results[index].name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14 * screenScale(context)),
          ),
        );
      },
      itemCount: _results.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var _suggestions = [];

    if (categoryId != null) {
      var _plist = [];
      for (var i in _productController.categoryList) {
        _plist += _productController.productList
            .where((p0) => p0.categoryId == i.id && i.parent!.id == categoryId)
            .toList();
      }

      _suggestions = query.isEmpty
          ? []
          : _plist
              .where((element) =>
                  element.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    } else if (brandId != null) {
      _suggestions = query.isEmpty
          ? []
          : _productController.productList
              .where((p0) =>
                  p0.name.toLowerCase().contains(query.toLowerCase()) &&
                  p0.brandId == brandId)
              .toList();
    } else if (items != null) {
      _suggestions = query.isEmpty
          ? []
          : items!
              .where(
                  (p0) => p0.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    } else {
      _suggestions = query.isEmpty
          ? []
          : _productController.productList
              .where(
                  (p0) => p0.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    }

    if (_suggestions.length == 0) {
      if (query.length > 0) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No results ",
                style: TextStyle(
                    color: Colors.grey, fontSize: 15 * fontScale(context)),
              ),
              Icon(
                Iconsax.emoji_sad,
                color: Colors.blue,
                size: 17 * screenScale(context),
              )
            ],
          ),
        );
      }
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Let's find some cool stuffs.",
              style: TextStyle(
                  color: Colors.grey, fontSize: 15 * fontScale(context)),
            ),
            Icon(
              Iconsax.search_normal,
              color: Colors.blue,
              size: 17 * screenScale(context),
            )
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(10 * screenScale(context)),
      separatorBuilder: (context, index) => Divider(
        thickness: 1.5,
      ),
      itemBuilder: (context, index) {
        return ListTile(
          visualDensity: VisualDensity.comfortable,
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$" + _suggestions[index].price.toString(),
                style: TextStyle(
                    color: Colors.red.shade300,
                    fontWeight: FontWeight.bold,
                    fontSize: 14 * fontScale(context)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Details",
                    style: TextStyle(
                        color: Colors.blue.shade300,
                        fontSize: 14 * fontScale(context)),
                  ),
                  Icon(
                    Ionicons.chevron_forward_outline,
                    size: 17 * screenScale(context),
                    color: Colors.blue.shade300,
                  )
                ],
              )
            ],
          ),
          onTap: () =>
              Get.to(() => ProductDetailsScreen(product: _suggestions[index])),
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(10 * screenScale(context)),
              child: Image.network(_suggestions[index].mainImg)),
          title: Text(_suggestions[index].name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14 * fontScale(context))),
        );
      },
      itemCount: _suggestions.length,
    );
  }
}
