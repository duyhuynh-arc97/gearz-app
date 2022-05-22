// ignore_for_file: unused_field

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/additional_contact_controller.dart';
import 'package:itproject_gadget_store/controllers/address_controller.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/cart_controller.dart';
import 'package:itproject_gadget_store/controllers/order_controller.dart';
import 'package:itproject_gadget_store/controllers/product_controller.dart';
import 'package:itproject_gadget_store/controllers/shipping_controller.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/controllers/wishlist_controller.dart';
import 'package:itproject_gadget_store/screens/main/home_screen.dart';
import 'package:itproject_gadget_store/screens/main/cart_screen.dart';
import 'package:itproject_gadget_store/screens/main/notification_screen.dart';
import 'package:itproject_gadget_store/screens/main/profile_screen.dart';
import 'package:itproject_gadget_store/screens/main/wishlist_screen.dart';

class MainScreen extends StatefulWidget {
  final String? userMail;
  const MainScreen({Key? key, this.userMail})
      : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  var _controller = Get.put(UserController());
  var _cartController = Get.put(CartController());
  var _wishlistController = Get.put(WishlistController());
  var _additionalContactController = Get.put(AdditionalContactController());
  var _addressAPIController = Get.put(AddressController());
  var _shippingController = Get.put(ShippingController());
  var _orderController = Get.put(OrderController());
  var _productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading == false) {
        final screens = [
          HomeScreen(),
          WishlistScreen(user: _controller.user.value),
          CartScreen(),
          NotificationScreen(),
          ProfileScreen()
        ];

        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
            currentIndex: _selectedIndex,
            unselectedItemColor: Colors.grey.shade600,
            selectedItemColor: Colors.blue,
            selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14 * fontScale(context)),
            selectedIconTheme: IconThemeData(size: 26 * screenScale(context)),
            iconSize: 24 * screenScale(context),
            elevation: 10 * screenScale(context),
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex != 0 ? Iconsax.home_2 : Iconsax.home_25,
                  size: 24 * screenScale(context),
                ),
                label: "Home",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Obx(() => _wishlistController.wishlistItems.length > 0
                    ? Badge(
                        child: Icon(
                          _selectedIndex != 1 ? Iconsax.heart : Iconsax.heart5,
                          size: 24 * screenScale(context),
                        ),
                      )
                    : Icon(_selectedIndex != 1 ? Iconsax.heart : Iconsax.heart5,
                        size: 24 * screenScale(context))),
                label: "Wishlist",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Obx(() => _cartController.cartItems.length > 0
                    ? Badge(
                        child: Icon(
                          _selectedIndex != 2
                              ? Ionicons.bag_handle_outline
                              : Ionicons.bag_handle,
                          size: 24 * screenScale(context),
                        ),
                      )
                    : Icon(
                        _selectedIndex != 2
                            ? Ionicons.bag_handle_outline
                            : Ionicons.bag_handle,
                        size: 24 * screenScale(context),
                      )),
                label: "Cart",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex != 3
                      ? Iconsax.notification
                      : Iconsax.notification5,
                  size: 24 * screenScale(context),
                ),
                label: "Notification",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex != 4
                      ? Iconsax.profile_circle
                      : Iconsax.profile_circle5,
                  size: 24 * screenScale(context),
                ),
                label: "Profile",
                backgroundColor: Colors.white,
              )
            ],
          ),
          appBar: _selectedIndex != 0 && _selectedIndex != 4
              ? AppBar(
                  title: _selectedIndex == 1
                      ? Text(
                          "Your wishlist",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20 * fontScale(context)),
                        )
                      : _selectedIndex == 2
                          ? Text(
                              "Your cart",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20 * fontScale(context)),
                            )
                          : _selectedIndex == 3
                              ? Text(
                                  "Notifications",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20 * fontScale(context)),
                                )
                              : Text(
                                  "Your profile",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20 * fontScale(context)),
                                ),
                  elevation: 0,
                  centerTitle: true,
                  backgroundColor: Colors.white,
                )
              : null,
          backgroundColor: Colors.white,
          body: screens[_selectedIndex],
        );
      }
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator(color: Colors.grey)));
    });
  }
}
