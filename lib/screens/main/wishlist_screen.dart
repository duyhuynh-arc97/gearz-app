import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/controllers/wishlist_controller.dart';
import 'package:itproject_gadget_store/models/user.dart';
import 'package:itproject_gadget_store/models/wishlist.dart';
import 'package:itproject_gadget_store/screens/additional_screens/all_product_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/product_details_screen.dart';
import 'package:shimmer/shimmer.dart';

class WishlistScreen extends StatefulWidget {
  final User user;
  const WishlistScreen({Key? key, required this.user}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  UserController _userController = Get.find();
  final listKey = GlobalKey<AnimatedListState>();
  WishlistController _wishlistController = Get.find();
  Color _cardColor = Color(hexColor("#f7f7f7"));

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_wishlistController.isLoading == false) {
        if (_wishlistController.wishlistItems.length == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300 * screenScale(context),
                  child: Text(
                    "Your have no product in your favourite. \n Let's explore the amazing gadget in our store and choose for you something.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey, fontSize: 14 * fontScale(context)),
                  ),
                ),
                SizedBox(
                  height: 40 * screenScale(context),
                  width: 150 * screenScale(context),
                  child: MaterialButton(
                    onPressed: () => Get.to(() => AllProductScreen()),
                    textColor: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.search_favorite_1,
                          color: Colors.blue,
                          size: 24 * screenScale(context),
                        ),
                        SizedBox(width: 5 * screenScale(context)),
                        Text(
                          "Explore",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14 * fontScale(context)),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(5 * screenScale(context)),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5 * screenScale(context))),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(10 * screenScale(context), 0,
              10 * screenScale(context), 10 * screenScale(context)),
          key: listKey,
          itemBuilder: (context, index) {
            return Slidable(
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      openCustomizedAlertDialog2(
                          context: context,
                          title: "Dislike product!",
                          mainText: "Are you sure that you want to ",
                          additionalText: "this product from your wishlist?",
                          iconName: "error.png",
                          importantText: "remove ",
                          okAction: () {
                            _wishlistController
                                .removeFromWishlist(
                                    userId: _userController.user.value.id,
                                    productId: _wishlistController
                                        .wishlistItems[index].item.id)
                                .then((value) {
                              if (value == "successful") {
                                Get.back();
                                Get.snackbar(
                                  "Disliked!",
                                  "You've just disliked  product. Double check in Your wishlist.",
                                  dismissDirection: DismissDirection.horizontal,
                                  colorText: Colors.white,
                                  snackStyle: SnackStyle.FLOATING,
                                  barBlur: 30,
                                  backgroundColor: Colors.black54,
                                  isDismissible: true,
                                  duration: Duration(seconds: 3),
                                );
                                setState(() {
                                  _wishlistController.wishlistItems
                                      .removeAt(index);
                                });
                              } else {
                                print("nah");
                              }
                            });
                          });
                    },
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    icon: Ionicons.heart_dislike_outline,
                    label: 'Dislike',
                  ),
                ],
              ),
              child: _itemCard(
                  wishlist: _wishlistController.wishlistItems[index],
                  index: index),
            );
          },
          separatorBuilder: (context, index) =>
              SizedBox(height: 10 * screenScale(context)),
          itemCount: _wishlistController.wishlistItems.length,
        );
      } else {
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(10 * screenScale(context), 0,
              10 * screenScale(context), 10 * screenScale(context)),
          key: listKey,
          itemBuilder: (context, index) {
            return _shimmerCard();
          },
          separatorBuilder: (context, index) =>
              SizedBox(height: 10 * screenScale(context)),
          itemCount: 8,
        );
      }
    });
  }

  //Card for items
  Container _itemCard({required Wishlist wishlist, required int index}) {
    return Container(
      padding: EdgeInsets.only(right: 5 * screenScale(context)),
      height: 110 * screenScale(context),
      decoration: BoxDecoration(
          border: Border.all(color: _cardColor),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: _cardColor),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10 * screenScale(context)),
            child: Container(
                color: Colors.white,
                width: 110 * screenScale(context),
                height: 110 * screenScale(context),
                child: Hero(
                  tag: wishlist,
                  child: Image.network(
                    wishlist.item.mainImg,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          SizedBox(width: 5 * screenScale(context)),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 5 * screenScale(context)),
                Text(
                  wishlist.item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14 * fontScale(context)),
                ),
                SizedBox(height: 10 * screenScale(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    wishlist.item.discount != 0
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("\$",
                                      style: TextStyle(
                                          fontSize: 11 * fontScale(context),
                                          color: Color(hexColor("#ff408d")),
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      (wishlist.item.price -
                                              wishlist.item.price *
                                                  wishlist.item.discount /
                                                  100)
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: 15 * fontScale(context),
                                          fontWeight: FontWeight.bold,
                                          color: Color(hexColor("#ff408d")))),
                                ],
                              ),
                              SizedBox(width: 5 * screenScale(context)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("\$",
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11 * fontScale(context))),
                                  Text(wishlist.item.price.toString(),
                                      style: TextStyle(
                                          fontSize: 15 * fontScale(context),
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey.shade500)),
                                ],
                              )
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\$",
                                  style: TextStyle(
                                      fontSize: 11 * fontScale(context),
                                      color: Color(hexColor("#ff408d")),
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  isInt(wishlist.item.price)
                                      ? wishlist.item.price.toStringAsFixed(0)
                                      : wishlist.item.price.toString(),
                                  style: TextStyle(
                                      fontSize: 15 * fontScale(context),
                                      fontWeight: FontWeight.bold,
                                      color: Color(hexColor("#ff408d")))),
                            ],
                          ),
                    wishlist.item.discount != 0
                        ? Text("${wishlist.item.discount}% off",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 14 * fontScale(context)))
                        : Text(""),
                  ],
                ),
                SizedBox(height: 5 * screenScale(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(
                          () => ProductDetailsScreen(product: wishlist.item)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Details",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14 * fontScale(context)),
                          ),
                          Icon(
                            Ionicons.chevron_forward_outline,
                            size: 17 * screenScale(context),
                            color: Colors.blue,
                          )
                        ],
                      ),
                    ),
                    Icon(
                      Iconsax.heart5,
                      color: Colors.red,
                      size: 24 * screenScale(context),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Shimmer card
  Widget _shimmerCard() {
    return Container(
      padding: EdgeInsets.only(right: 5 * screenScale(context)),
      height: 110 * screenScale(context),
      decoration: BoxDecoration(
          border: Border.all(color: _cardColor),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: _cardColor),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10 * screenScale(context)),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade100,
              child: Container(
                color: Colors.white,
                width: 110 * screenScale(context),
                height: 110 * screenScale(context),
              ),
            ),
          ),
          SizedBox(width: 5 * screenScale(context)),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 5 * screenScale(context)),
                Shimmer.fromColors(
                    child: Container(
                      height: 40 * screenScale(context),
                      color: Colors.grey.shade200,
                    ),
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100),
                SizedBox(height: 10 * screenScale(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                        child: Container(
                          height: 20 * screenScale(context),
                          width: 100 * screenScale(context),
                          color: Colors.grey.shade200,
                        ),
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade100),
                    Shimmer.fromColors(
                        child: Container(
                          height: 20 * screenScale(context),
                          width: 70 * screenScale(context),
                          color: Colors.grey.shade200,
                        ),
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade100),
                  ],
                ),
                SizedBox(height: 5 * screenScale(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                        child: Container(
                          height: 20 * screenScale(context),
                          width: 70 * screenScale(context),
                          color: Colors.grey.shade200,
                        ),
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade100),
                    Shimmer.fromColors(
                        child: Container(
                          height: 20 * screenScale(context),
                          width: 30 * screenScale(context),
                          color: Colors.grey.shade200,
                        ),
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade100),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
