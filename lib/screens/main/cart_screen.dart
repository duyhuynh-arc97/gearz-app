import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/cart_controller.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/models/cart_item.dart';
import 'package:itproject_gadget_store/screens/additional_screens/checkout_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../additional_screens/all_product_screen.dart';
import '../additional_screens/product_details_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartController _cartController = Get.find();
  UserController _userController = Get.find();
  Color _cardColor = Color(hexColor("#f7f7f7"));
  final listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_cartController.isLoading == false) {
        if (_cartController.cartItems.length == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300 * screenScale(context),
                  child: Text(
                    "Your haven't added anything to your cart. \n Let's explore the amazing gadget in our store and choose for you something.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14 * fontScale(context),
                    ),
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
                          Iconsax.search_status_1,
                          color: Colors.blue,
                          size: 24 * screenScale(context),
                        ),
                        SizedBox(width: 5),
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
        return Scaffold(
          backgroundColor: Colors.white,
          body: ListView.builder(
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
                        _cartController
                            .removeFromCart(
                                userId: _userController.user.value.id,
                                productId:
                                    _cartController.cartItems[index].item.id)
                            .then((value) {
                          if (value == "successful") {
                            Get.snackbar(
                              "Product was removed!",
                              "You just removed a product. Double check in Your cart.",
                              dismissDirection: DismissDirection.horizontal,
                              colorText: Colors.white,
                              snackStyle: SnackStyle.FLOATING,
                              barBlur: 30,
                              backgroundColor: Colors.black45,
                              isDismissible: true,
                              duration: Duration(seconds: 3),
                            );
                            setState(() {
                              _cartController.cartItems.removeAt(index);
                            });
                          } else {
                            print("nah");
                          }
                        });
                      },
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      icon: Iconsax.trash,
                      label: 'Remove',
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.standard,
                  dense: true,
                  leading: Checkbox(
                    onChanged: (value) {
                      var a = _cartController.cartItems[index];
                      a.isChoosen = value!;
                      _cartController.cartItems[index] = a;
                    },
                    value: _cartController.cartItems[index].isChoosen,
                  ),
                  title: _itemCard(
                      cartItem: _cartController.cartItems[index], index: index),
                ),
              );
            },
            itemCount: _cartController.cartItems.length,
          ),
          bottomNavigationBar: _bottomAppBar(context),
        );
      } else {
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(10 * screenScale(context), 0,
              10 * screenScale(context), 10 * screenScale(context)),
          key: listKey,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.standard,
              dense: true,
              leading: Shimmer.fromColors(
                  child: Container(
                    height: 20 * screenScale(context),
                    width: 20 * screenScale(context),
                    color: Colors.grey.shade200,
                  ),
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100),
              title: _shimmerCard(),
            );
          },
          itemCount: 8,
        );
      }
    });
  }

  //Bottom appbar
  BottomAppBar _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      elevation: 15 * screenScale(context),
      child: Container(
        padding: EdgeInsets.only(
            left: 10 * screenScale(context), right: 10 * screenScale(context)),
        height: 65 * screenScale(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 200 * screenScale(context),
              child: Row(
                children: [
                  Text(
                    "Total:  ",
                    style: TextStyle(
                        fontSize: 17 * fontScale(context),
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("\$",
                          style: TextStyle(
                              fontSize: 14 * fontScale(context),
                              color: Color(hexColor("#ff408d")),
                              fontWeight: FontWeight.bold)),
                      Obx(
                        () => Text(
                            _cartController
                                .totalPrice(_cartController.cartItems)
                                .toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 20 * fontScale(context),
                                fontWeight: FontWeight.bold,
                                color: Color(hexColor("#ff408d")))),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 45 * screenScale(context),
              width: 170 * screenScale(context),
              child: ElevatedButton(
                onPressed:
                    _cartController.totalPrice(_cartController.cartItems) > 0
                        ? () => Get.to(() => CheckoutScreen())
                        : () => Get.snackbar(
                              "Nothing is selected!",
                              "You have not choosen any items. Please select at least 1 product to proceed.",
                              colorText: Colors.white,
                              snackStyle: SnackStyle.FLOATING,
                              barBlur: 30,
                              backgroundColor: Colors.black45,
                              isDismissible: true,
                              duration: Duration(seconds: 3),
                              dismissDirection: DismissDirection.horizontal,
                            ),
                child: Text("Confirm cart",
                    style: TextStyle(
                        fontSize: 17 * fontScale(context),
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(7 * screenScale(context))),
                  primary: Color(hexColor("#346ec9")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Card for items
  Widget _itemCard({required CartItem cartItem, required int index}) {
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
                  tag: cartItem,
                  child: Image.network(
                    cartItem.item.mainImg,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          SizedBox(width: 5 * screenScale(context)),
          Expanded(
            child: Column(
              children: [
                Text(
                  cartItem.item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10 * screenScale(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cartItem.item.discount != 0
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\$",
                                  style: TextStyle(
                                      fontSize: 11 * fontScale(context),
                                      color: Color(hexColor("#ff408d")),
                                      fontWeight: FontWeight.bold)),
                              Text(cartItem.total.toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: 15 * fontScale(context),
                                      fontWeight: FontWeight.bold,
                                      color: Color(hexColor("#ff408d")))),
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
                                  isInt(cartItem.total)
                                      ? cartItem.total.toStringAsFixed(0)
                                      : cartItem.total.toString(),
                                  style: TextStyle(
                                      fontSize: 15 * fontScale(context),
                                      fontWeight: FontWeight.bold,
                                      color: Color(hexColor("#ff408d")))),
                            ],
                          ),
                  ],
                ),
                SizedBox(height: 5 * screenScale(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(() =>
                              ProductDetailsScreen(product: cartItem.item)),
                          child: Text(
                            "Details",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14 * fontScale(context)),
                          ),
                        ),
                        Icon(
                          Ionicons.chevron_forward_outline,
                          size: 17 * screenScale(context),
                          color: Colors.blue,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 120 * screenScale(context),
                      height: 24 * screenScale(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                            height: 20 * screenScale(context),
                            minWidth: 20 * screenScale(context),
                            onPressed: () async {
                              setState(() {
                                cartItem.quantity++;
                                _cartController.updateCartItem(
                                    userId: _userController.user.value.id,
                                    productId: cartItem.item.id,
                                    quantity: cartItem.quantity);
                              });
                            },
                            color: Color(hexColor("#e3e3e3")),
                            textColor: Colors.black,
                            child: Icon(
                              Ionicons.add_outline,
                              size: 15 * screenScale(context),
                            ),
                            padding: EdgeInsets.all(5 * screenScale(context)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5 * screenScale(context))),
                            elevation: 0,
                          ),
                          Text(
                            cartItem.quantity.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          MaterialButton(
                            height: 20 * screenScale(context),
                            minWidth: 20 * screenScale(context),
                            onPressed: () async {
                              setState(() {
                                if (cartItem.quantity > 1) {
                                  cartItem.quantity--;
                                } else {
                                  cartItem.quantity = 1;
                                }
                                _cartController.updateCartItem(
                                    userId: _userController.user.value.id,
                                    productId: cartItem.item.id,
                                    quantity: cartItem.quantity);
                              });
                            },
                            color: Color(hexColor("#e3e3e3")),
                            textColor: Colors.black,
                            child: Icon(
                              Ionicons.remove_outline,
                              size: 15 * screenScale(context),
                            ),
                            padding: EdgeInsets.all(5 * screenScale(context)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5 * screenScale(context))),
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
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
