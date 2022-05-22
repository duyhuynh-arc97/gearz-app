import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/additional_contact_controller.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/cart_controller.dart';
import 'package:itproject_gadget_store/controllers/order_controller.dart';
import 'package:itproject_gadget_store/controllers/shipping_controller.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/models/additional_contact.dart';
import 'package:itproject_gadget_store/models/cart_item.dart';
import 'package:itproject_gadget_store/models/city.dart';
import 'package:itproject_gadget_store/models/district.dart';
import 'package:itproject_gadget_store/models/order.dart';
import 'package:itproject_gadget_store/models/order_item.dart';
import 'package:itproject_gadget_store/models/order_tracking.dart';
import 'package:itproject_gadget_store/models/ward.dart';
import 'package:itproject_gadget_store/screens/additional_screens/contact_list_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/edit_profile_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/product_details_screen.dart';
import 'package:itproject_gadget_store/widgets/common_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Color _cardColor = Color(hexColor("#f7f7f7"));
  late bool _codSelected, _ccdSelected;
  List<CartItem> _choosenItems = [];
  int _totalQty = 0;
  bool _isLoading = false;

  CartController _cartController = Get.find();
  AdditionalContactController _contactController = Get.find();
  ShippingController _shippingController = Get.find();
  UserController _userController = Get.find();
  OrderController _orderController = Get.find();

  @override
  void initState() {
    super.initState();
    _choosenItems =
        _cartController.cartItems.where((p0) => p0.isChoosen == true).toList();
    setState(() {
      _codSelected = true;
      _ccdSelected = false;
    });

    for (var i in _choosenItems) {
      _totalQty += i.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Check out",
          style:
              TextStyle(color: Colors.black, fontSize: 20 * fontScale(context)),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Ionicons.chevron_back_outline,
                color: Colors.black, size: 24 * screenScale(context))),
        elevation: 0,
      ),
      bottomNavigationBar: Obx(
        () => _contactController.deliveryContact["addressLine"].toString() == ''
            ? SizedBox()
            : _bottomAppBar(context),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10 * screenScale(context), 0,
              10 * screenScale(context), 10 * screenScale(context)),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10 * screenScale(context)),
                decoration: BoxDecoration(
                    border: Border.all(color: _cardColor),
                    borderRadius: BorderRadius.all(
                        Radius.circular(20 * screenScale(context))),
                    color: _cardColor),
                child: Column(
                  children: [
                    _headingLine(name: "Delivery contact"),
                    SizedBox(height: 15 * screenScale(context)),
                    Obx(
                      () => _userController.user.value.ward == null
                          ? _alertBox(
                              context: context,
                              alertText:
                                  "You have not set your home contact yet. \nPlease set home contact so we can get in touch with you.",
                              action: _navigateBtn(
                                  context: context,
                                  action: "Set home contact",
                                  icon: Iconsax.add_square,
                                  path:
                                      EditProfileScreen(fromCartScreen: true)))
                          : _contactCard(
                              name: _contactController.deliveryContact["name"]
                                  .toString(),
                              address: _contactController
                                      .deliveryContact["addressLine"]
                                      .toString() +
                                  ", " +
                                  (_contactController.deliveryContact["ward"]
                                          as Ward)
                                      .name +
                                  ", " +
                                  (_contactController
                                              .deliveryContact["district"]
                                          as District)
                                      .name +
                                  ", " +
                                  (_contactController.deliveryContact["city"]
                                          as City)
                                      .name,
                              phone: _contactController.deliveryContact["phone"]
                                  .toString()),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15 * screenScale(context)),
              Container(
                padding: EdgeInsets.all(10 * screenScale(context)),
                decoration: BoxDecoration(
                    border: Border.all(color: _cardColor),
                    borderRadius: BorderRadius.all(
                        Radius.circular(20 * screenScale(context))),
                    color: _cardColor),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5 * screenScale(context),
                              right: 5 * screenScale(context)),
                          child: Text(
                            "Your choices",
                            style: TextStyle(
                                fontSize: 16 * fontScale(context),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15 * screenScale(context)),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _itemCard(
                            cartItem: _choosenItems[index], index: index);
                      },
                      itemCount: _choosenItems.length,
                      separatorBuilder: (context, index) =>
                          Divider(thickness: 1.5 * screenScale(context)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15 * screenScale(context)),
              Container(
                padding: EdgeInsets.all(10 * screenScale(context)),
                decoration: BoxDecoration(
                    border: Border.all(color: _cardColor),
                    borderRadius: BorderRadius.all(
                        Radius.circular(20 * screenScale(context))),
                    color: _cardColor),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5 * screenScale(context),
                              right: 5 * screenScale(context)),
                          child: Text(
                            "Standard delivery",
                            style: TextStyle(
                                fontSize: 16 * fontScale(context),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15 * screenScale(context)),
                    Obx(
                      () => _userController.user.value.addressLine == ''
                          ? _alertBox(
                              context: context,
                              alertText:
                                  "You have not set your home contact yet. \nPlease set home contact so we can get in touch with you.",
                              action: _navigateBtn(
                                  context: context,
                                  action: "Set home contact",
                                  icon: Iconsax.add_square,
                                  path:
                                      EditProfileScreen(fromCartScreen: true)))
                          : _contactController.deliveryContact["ward"] == null
                              ? _alertBox(
                                  context: context,
                                  alertText:
                                      "We do not support delivery at your place. \nPlease change your location.",
                                  action: _navigateBtn(
                                      context: context,
                                      action: "Change location",
                                      icon: Iconsax.edit_2,
                                      path: ContactListScreen()))
                              : _shippingController.calculateShippingFee(
                                          items: _choosenItems,
                                          cityId: (_contactController
                                                      .deliveryContact["city"]
                                                  as City)
                                              .id,
                                          district: (_contactController
                                                      .deliveryContact[
                                                  "district"] as District)
                                              .name) !=
                                      0
                                  ? _feeCard()
                                  : _alertBox(
                                      context: context,
                                      alertText:
                                          "We do not support delivery at your place. \nPlease change your location.",
                                      action: _navigateBtn(
                                          context: context,
                                          action: "Change location",
                                          icon: Iconsax.edit_2,
                                          path: ContactListScreen())),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15 * screenScale(context)),
              Container(
                padding: EdgeInsets.all(10 * screenScale(context)),
                decoration: BoxDecoration(
                    border: Border.all(color: _cardColor),
                    borderRadius: BorderRadius.all(
                        Radius.circular(20 * screenScale(context))),
                    color: _cardColor),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5 * screenScale(context),
                              right: 5 * screenScale(context)),
                          child: Text(
                            "Select payment method",
                            style: TextStyle(
                                fontSize: 16 * fontScale(context),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15 * screenScale(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _codSelected = true;
                              _ccdSelected = false;
                            });
                          },
                          child: _paymentCard(
                              name: "Cash On Delivery",
                              desc: "Pay when you receive",
                              img: "cod.png",
                              selected: _codSelected),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _ccdSelected = !_ccdSelected;
                              _codSelected = !_codSelected;
                            });
                            if (_shippingController.calculateShippingFee(
                                    items: _choosenItems,
                                    cityId: (_contactController
                                            .deliveryContact["city"] as City)
                                        .id,
                                    district: (_contactController
                                                .deliveryContact["district"]
                                            as District)
                                        .name) ==
                                0) {
                              openCustomizedAlertDialog(
                                context: context,
                                title: "Delivery is not supported!",
                                mainText:
                                    "We do not support delivery at your place. Please change ",
                                additionalText: "your locoation.",
                                iconName: "error.png",
                              );
                              setState(() {
                                _ccdSelected = true;
                                _codSelected = false;
                              });
                            } else {
                              List _payItems = [];
                              for (var i in _choosenItems) {
                                var temp = {
                                  "name": i.item.name,
                                  "quantity": i.quantity,
                                  "price": (i.item.price *
                                          (1 - i.item.discount / 100))
                                      .toStringAsFixed(2),
                                  "currency": "USD"
                                };
                                _payItems.add(temp);
                              }

                              var _amount = {
                                "total": (_cartController
                                            .totalPrice(_choosenItems) +
                                        _shippingController
                                            .calculateShippingFee(
                                                items: _choosenItems,
                                                cityId: (_contactController
                                                            .deliveryContact[
                                                        "city"] as City)
                                                    .id,
                                                district: (_contactController
                                                            .deliveryContact[
                                                        "district"] as District)
                                                    .name))
                                    .toString(),
                                "currency": "USD",
                                "details": {
                                  "subtotal": _cartController
                                      .totalPrice(_choosenItems)
                                      .toString(),
                                  "shipping":
                                      (_shippingController.calculateShippingFee(
                                              items: _choosenItems,
                                              cityId: (_contactController
                                                          .deliveryContact[
                                                      "city"] as City)
                                                  .id,
                                              district: (_contactController
                                                          .deliveryContact[
                                                      "district"] as District)
                                                  .name))
                                          .toString(),
                                  "shipping_discount": 0
                                }
                              };

                              var _shippingAddr = {
                                "recipient_name":
                                    "${_contactController.deliveryContact["name"].toString()}",
                                "line1":
                                    "${_contactController.deliveryContact["addressLine"].toString()}, ${(_contactController.deliveryContact["ward"] as Ward).name}, ${(_contactController.deliveryContact["district"] as District).name}",
                                "line2": "",
                                "city":
                                    "${(_contactController.deliveryContact["city"] as City).name}",
                                "country_code": "VN",
                                "phone":
                                    "+84${_contactController.deliveryContact["phone"].toString()}",
                              };

                              Get.to(() => UsePaypal(
                                  sandboxMode: true,
                                  note:
                                      "Contact us for any questions on your order.",
                                  onSuccess: (Map params) async {
                                    print("onSuccess: $params");

                                    //Execute place-order function ---------------------------------------------------------------------
                                    _orderController
                                        .placeOrder(
                                            method: _codSelected == true
                                                ? "COD"
                                                : "PAYPAL",
                                            items: _choosenItems,
                                            total: _cartController
                                                .totalPrice(_choosenItems),
                                            shippingCost: _shippingController.calculateShippingFee(
                                                items: _choosenItems,
                                                cityId: (_contactController.deliveryContact["city"] as City)
                                                    .id,
                                                district: (_contactController
                                                            .deliveryContact["district"]
                                                        as District)
                                                    .name),
                                            contact: AdditionalContact(
                                                userId: _userController
                                                    .user.value.id,
                                                name: _contactController
                                                    .deliveryContact["name"]
                                                    .toString(),
                                                addressLine: _contactController
                                                    .deliveryContact["addressLine"]
                                                    .toString(),
                                                ward: _contactController.deliveryContact["ward"] as Ward,
                                                district: _contactController.deliveryContact["district"] as District,
                                                city: _contactController.deliveryContact["city"] as City,
                                                phone: _contactController.deliveryContact["phone"].toString(),
                                                isDefault: 0))
                                        .then((value) {
                                      if (value == "successful") {
                                        var _shipcost = _shippingController
                                            .calculateShippingFee(
                                                items: _choosenItems,
                                                cityId: (_contactController
                                                            .deliveryContact[
                                                        "city"] as City)
                                                    .id,
                                                district: (_contactController
                                                            .deliveryContact[
                                                        "district"] as District)
                                                    .name);
                                        var _subtotal = _cartController
                                            .totalPrice(_choosenItems);
                                        List<OrderItem> _ordList = [];

                                        for (var i in _choosenItems) {
                                          OrderItem o = OrderItem(
                                              quantity: i.quantity,
                                              productId: i.item.id,
                                              shippingCost: _shipcost,
                                              subtotal: i.total,
                                              unitPrice: i.item.price,
                                              productCost: i.item.price * 0.95,
                                              isReviewed: 0);
                                          _ordList.add(o);
                                        }

                                        List<OrderTracking> _otrList = [];
                                        OrderTracking ot = OrderTracking(
                                            status: "NEW",
                                            statusDesc: "Order accepted",
                                            updateTime: DateTime.now());
                                        _otrList.add(ot);

                                        //Add to controller-----------------------------------------------------------------------
                                        _orderController.myOrders.add(Order(
                                            userId:
                                                _userController.user.value.id,
                                            estArrivalDays: _shippingController
                                                .calculateShippingDuration(
                                                    cityId: (_contactController
                                                                .deliveryContact["city"]
                                                            as City)
                                                        .id,
                                                    district: (_contactController
                                                                .deliveryContact["district"]
                                                            as District)
                                                        .name),
                                            shippingCost: _shippingController.calculateShippingFee(
                                                items: _choosenItems,
                                                cityId: (_contactController.deliveryContact["city"] as City).id,
                                                district: (_contactController.deliveryContact["district"] as District).name),
                                            subtotal: _subtotal,
                                            total: _subtotal + _shipcost,
                                            productCost: _subtotal * 0.95,
                                            tax: 0,
                                            addressLine: _contactController.deliveryContact["addressLine"].toString(),
                                            name: _contactController.deliveryContact["name"].toString(),
                                            city: (_contactController.deliveryContact["city"] as City).name,
                                            district: (_contactController.deliveryContact["district"] as District).name,
                                            ward: (_contactController.deliveryContact["ward"] as Ward).name,
                                            paymentMethod: _codSelected == true ? "COD" : "PAYPAL",
                                            status: _codSelected == true ? "NEW" : "PAID",
                                            phone: _contactController.deliveryContact["phone"].toString(),
                                            orderTime: DateTime.now(),
                                            items: _ordList,
                                            tracks: _otrList,
                                            finalTrack: _otrList.last));

                                        _orderController.update();

                                        //Remove from cart controller
                                        for (var i in _choosenItems) {
                                          _cartController.cartItems.remove(i);
                                        }

                                        //Notify
                                        int _count = 0;
                                        openSuccessMessageDialog(
                                            context: context,
                                            title: "Order succesfully!",
                                            mainText:
                                                "You have successfully place your orders. You can view all your orders in ",
                                            additionalText: "",
                                            importantText: "Your profile.",
                                            iconName: "bravo.png",
                                            action: () {
                                              Navigator.popUntil(context,
                                                  (route) {
                                                return _count++ == 2;
                                              });
                                            });
                                      } else {
                                        print("you failed");
                                      }
                                    });
                                  },
                                  onError: (error) {
                                    print("onError: $error");
                                  },
                                  onCancel: (params) {
                                    print('cancelled: $params');
                                  },
                                  returnURL: "https://gearz.com/return",
                                  cancelURL: "https://gearz.com/cancel",
                                  transactions: [
                                    {
                                      "amount": _amount,
                                      "description":
                                          "The payment transaction description.",
                                      "item_list": {
                                        "items": _payItems,
                                        "shipping_address": _shippingAddr,
                                      }
                                    }
                                  ],
                                  clientId:
                                      "ARwff6ukSIy5QkKrfP4bcgqKSj_6CQCztZngiF_0DRnq30uXER2gn2O7c3B_m9JgaYAxLXbyLNoKB8nZ",
                                  secretKey:
                                      "EAySusn4HfSTi6g06XakRN1lR3qS1C9zG8T1tHv7fDpDJ8oi5s6AFNQxZZFWRxPXuXdVpPda8_SC1GRl"));
                            }
                          },
                          child: _paymentCard(
                              name: "",
                              desc: "Pay before you receive",
                              img: "paypal.png",
                              selected: _ccdSelected),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 15 * screenScale(context)),
              Container(
                padding: EdgeInsets.all(10 * screenScale(context)),
                decoration: BoxDecoration(
                    border: Border.all(color: _cardColor),
                    borderRadius: BorderRadius.all(
                        Radius.circular(20 * screenScale(context))),
                    color: _cardColor),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5 * screenScale(context),
                              right: 5 * screenScale(context)),
                          child: Text(
                            "Detailed cost",
                            style: TextStyle(
                                fontSize: 16 * fontScale(context),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15 * screenScale(context)),
                    Obx(
                      () => _contactController.deliveryContact["addressLine"] ==
                              ''
                          ? _alertBox(
                              context: context,
                              alertText:
                                  "Please set the delivery contact to view detailed cost.",
                              action: SizedBox())
                          : _detailCostCard(context),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Detail cost card
  Container _detailCostCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: Colors.white),
      padding: EdgeInsets.all(10 * screenScale(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Merchandise subtotal",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * fontScale(context)),
                  ),
                  Text(
                    " (${_totalQty} items)",
                    style: TextStyle(
                        color: Colors.grey, fontSize: 14 * fontScale(context)),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("\$",
                      style: TextStyle(
                          fontSize: 11 * fontScale(context),
                          fontWeight: FontWeight.bold)),
                  Text(
                      _cartController
                          .totalPrice(_choosenItems)
                          .toStringAsFixed(2),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale(context))),
                ],
              ),
            ],
          ),
          SizedBox(height: 5 * screenScale(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shipping fee subtotal",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14 * fontScale(context)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("\$",
                      style: TextStyle(
                          fontSize: 11 * fontScale(context),
                          fontWeight: FontWeight.bold)),
                  Obx(
                    () => Text(
                        _shippingController
                            .calculateShippingFee(
                                items: _choosenItems,
                                cityId: (_contactController
                                        .deliveryContact["city"] as City)
                                    .id,
                                district: (_contactController
                                            .deliveryContact["district"]
                                        as District)
                                    .name)
                            .toStringAsFixed(2),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14 * fontScale(context))),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 5 * screenScale(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Order amount",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * fontScale(context)),
                  ),
                  Text(
                    " (VAT included)",
                    style: TextStyle(
                        color: Colors.grey, fontSize: 14 * fontScale(context)),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("\$",
                      style: TextStyle(
                          fontSize: 11 * fontScale(context),
                          fontWeight: FontWeight.bold)),
                  Obx(() => Text(
                      (_cartController.totalPrice(_choosenItems) +
                              _shippingController.calculateShippingFee(
                                  items: _choosenItems,
                                  cityId: (_contactController
                                          .deliveryContact["city"] as City)
                                      .id,
                                  district: (_contactController
                                              .deliveryContact["district"]
                                          as District)
                                      .name))
                          .toStringAsFixed(2),
                      style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Alert box
  Container _alertBox(
      {required BuildContext context,
      required String alertText,
      required Widget action}) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: Colors.white),
      padding: EdgeInsets.all(10 * screenScale(context)),
      child: Column(
        children: [
          SizedBox(
            width: 300 * screenScale(context),
            child: Text(
              alertText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey, fontSize: 14 * fontScale(context)),
            ),
          ),
          action,
        ],
      ),
    );
  }

  //Navigation button
  SizedBox _navigateBtn(
      {required BuildContext context,
      required String action,
      required IconData icon,
      required Widget path}) {
    return SizedBox(
      height: 40 * screenScale(context),
      width: 160 * screenScale(context),
      child: MaterialButton(
        onPressed: () => Get.to(() => path),
        textColor: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.blue,
              size: 24 * screenScale(context),
            ),
            SizedBox(width: 5 * screenScale(context)),
            Text(
              action,
              style: TextStyle(
                  color: Colors.blue, fontSize: 14 * fontScale(context)),
            ),
          ],
        ),
        padding: EdgeInsets.all(5 * screenScale(context)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5 * screenScale(context))),
        elevation: 0,
      ),
    );
  }

  //Heading line of each block
  Widget _headingLine({required String name}) {
    return Padding(
      padding: EdgeInsets.only(
          left: 5 * screenScale(context), right: 5 * screenScale(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            name,
            style: TextStyle(
                fontSize: 16 * screenScale(context),
                fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () => Get.to(() => ContactListScreen()),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Change",
                  style: TextStyle(
                      color: Colors.blue, fontSize: 14 * fontScale(context)),
                ),
                Icon(
                  Ionicons.chevron_forward_outline,
                  size: 17 * screenScale(context),
                  color: Colors.blue,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //Address card
  Container _contactCard(
      {required String name, required String address, required String phone}) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: Colors.white),
      padding: EdgeInsets.all(10 * screenScale(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Iconsax.location5,
            size: 24 * screenScale(context),
            color: Colors.blue,
          ),
          SizedBox(width: 10 * screenScale(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 16 * fontScale(context),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20 * screenScale(context)),
                    Text(
                      phone,
                      style: TextStyle(fontSize: 14 * fontScale(context)),
                    ),
                  ],
                ),
                SizedBox(height: 5 * screenScale(context)),
                Text(
                  address,
                  style: TextStyle(fontSize: 14 * fontScale(context)),
                ),
                SizedBox(height: 5 * screenScale(context)),
              ],
            ),
          )
        ],
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
                  style: TextStyle(fontSize: 14 * fontScale(context)),
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
                    Text(
                      "Quantity: ${cartItem.quantity}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale(context)),
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

  //Shipping fee card
  Container _feeCard() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: Colors.white),
      padding: EdgeInsets.all(10 * screenScale(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: 10 * screenScale(context),
                left: 10 * screenScale(context)),
            child: Icon(
              Iconsax.truck_fast,
              size: 24 * screenScale(context),
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 10 * screenScale(context)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Shipping fee: ",
                      style: TextStyle(fontSize: 14 * screenScale(context))),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("\$",
                          style: TextStyle(
                              fontSize: 12 * fontScale(context),
                              fontWeight: FontWeight.bold)),
                      Obx(
                        () => Text(
                            _shippingController
                                .calculateShippingFee(
                                    items: _choosenItems,
                                    cityId: (_contactController
                                            .deliveryContact["city"] as City)
                                        .id,
                                    district: (_contactController
                                                .deliveryContact["district"]
                                            as District)
                                        .name)
                                .toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 16 * fontScale(context),
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5 * screenScale(context)),
              Text(
                "Est. Arrival: ${_shippingController.calculateShippingDate(cityId: (_contactController.deliveryContact["city"] as City).id, district: (_contactController.deliveryContact["district"] as District).name)}",
                style: TextStyle(fontSize: 14 * fontScale(context)),
              ),
              SizedBox(height: 5 * screenScale(context)),
            ],
          )
        ],
      ),
    );
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
                              color: Color(hexColor("#ff408d")),
                              fontWeight: FontWeight.bold,
                              fontSize: 14 * fontScale(context))),
                      Obx(() => Text(
                          (_cartController.totalPrice(_choosenItems) +
                                  _shippingController.calculateShippingFee(
                                      items: _choosenItems,
                                      cityId: (_contactController
                                              .deliveryContact["city"] as City)
                                          .id,
                                      district: (_contactController
                                                  .deliveryContact["district"]
                                              as District)
                                          .name))
                              .toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 20 * fontScale(context),
                              fontWeight: FontWeight.bold,
                              color: Color(hexColor("#ff408d"))))),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 45 * screenScale(context),
              width: 170 * screenScale(context),
              child: ElevatedButton(
                onPressed: () {
                  if (_userController.user.value.city == null) {
                    openCustomizedAlertDialog(
                      context: context,
                      title: "No location is choosen!",
                      mainText:
                          "Your home location has not set yet. Please provide us your ",
                      importantText: "Location and Contact ",
                      additionalText: "so we can serve you better.",
                      iconName: "error.png",
                    );
                  } else if (_shippingController.checkCODSupported(
                              cityId: (_contactController
                                      .deliveryContact["city"] as City)
                                  .id,
                              district: (_contactController
                                      .deliveryContact["district"] as District)
                                  .name) ==
                          false &&
                      _codSelected == true) {
                    openCustomizedAlertDialog(
                      context: context,
                      title: "COD is not supported!",
                      mainText:
                          "Your location is not supported for COD. Please try ",
                      importantText: "Credit/Debit card ",
                      additionalText:
                          "method or change the delivery locoation.",
                      iconName: "error.png",
                    );
                  } else {
                    if (_shippingController.calculateShippingFee(
                            items: _choosenItems,
                            cityId: (_contactController.deliveryContact["city"]
                                    as City)
                                .id,
                            district: (_contactController
                                    .deliveryContact["district"] as District)
                                .name) ==
                        0) {
                      openCustomizedAlertDialog(
                        context: context,
                        title: "Delivery is not supported!",
                        mainText:
                            "We do not support delivery at your place. Please change ",
                        additionalText: "your locoation.",
                        iconName: "error.png",
                      );
                    } else {
                      setState(() {
                        _isLoading = true;
                      });
                      //Execute place-order function ---------------------------------------------------------------------
                      _orderController
                          .placeOrder(
                              method: _codSelected == true ? "COD" : "PAYPAL",
                              items: _choosenItems,
                              total: _cartController.totalPrice(_choosenItems),
                              shippingCost: _shippingController.calculateShippingFee(
                                  items: _choosenItems,
                                  cityId: (_contactController.deliveryContact["city"]
                                          as City)
                                      .id,
                                  district:
                                      (_contactController.deliveryContact["district"]
                                              as District)
                                          .name),
                              contact: AdditionalContact(
                                  userId: _userController.user.value.id,
                                  name: _contactController.deliveryContact["name"]
                                      .toString(),
                                  addressLine: _contactController
                                      .deliveryContact["addressLine"]
                                      .toString(),
                                  ward: _contactController.deliveryContact["ward"]
                                      as Ward,
                                  district: _contactController
                                      .deliveryContact["district"] as District,
                                  city: _contactController.deliveryContact["city"] as City,
                                  phone: _contactController.deliveryContact["phone"].toString(),
                                  isDefault: 0))
                          .then((value) {
                        if (value == "successful") {
                          var _shipcost = _shippingController
                              .calculateShippingFee(
                                  items: _choosenItems,
                                  cityId: (_contactController
                                          .deliveryContact["city"] as City)
                                      .id,
                                  district: (_contactController
                                              .deliveryContact["district"]
                                          as District)
                                      .name);
                          var _subtotal =
                              _cartController.totalPrice(_choosenItems);
                          List<OrderItem> _ordList = [];

                          for (var i in _choosenItems) {
                            OrderItem o = OrderItem(
                                quantity: i.quantity,
                                productId: i.item.id,
                                shippingCost: _shipcost,
                                subtotal: i.total,
                                unitPrice: i.item.price,
                                productCost: i.item.price * 0.95,
                                isReviewed: 0);
                            _ordList.add(o);
                          }

                          List<OrderTracking> _otrList = [];
                          OrderTracking ot = OrderTracking(
                              status: "NEW",
                              statusDesc: "Order accepted",
                              updateTime: DateTime.now());
                          _otrList.add(ot);

                          //Add to controller-----------------------------------------------------------------------
                          _orderController.myOrders.add(Order(
                              userId: _userController.user.value.id,
                              estArrivalDays:
                                  _shippingController.calculateShippingDuration(
                                      cityId: (_contactController
                                              .deliveryContact["city"] as City)
                                          .id,
                                      district: (_contactController
                                                  .deliveryContact["district"]
                                              as District)
                                          .name),
                              shippingCost: _shippingController.calculateShippingFee(
                                  items: _choosenItems,
                                  cityId:
                                      (_contactController.deliveryContact["city"] as City).id,
                                  district: (_contactController.deliveryContact["district"] as District).name),
                              subtotal: _subtotal,
                              total: _subtotal + _shipcost,
                              productCost: _subtotal * 0.95,
                              tax: 0,
                              addressLine: _contactController.deliveryContact["addressLine"].toString(),
                              name: _contactController.deliveryContact["name"].toString(),
                              city: (_contactController.deliveryContact["city"] as City).name,
                              district: (_contactController.deliveryContact["district"] as District).name,
                              ward: (_contactController.deliveryContact["ward"] as Ward).name,
                              paymentMethod: _codSelected == true ? "COD" : "PAYPAL",
                              status: _codSelected == true ? "NEW" : "PAID",
                              phone: _contactController.deliveryContact["phone"].toString(),
                              orderTime: DateTime.now(),
                              items: _ordList,
                              tracks: _otrList,
                              finalTrack: _otrList.last));

                          _orderController.update();

                          //Remove from cart controller
                          for (var i in _choosenItems) {
                            _cartController.cartItems.remove(i);
                          }

                          setState(() {
                            _isLoading = false;
                          });
                          //Notify
                          int _count = 0;
                          openSuccessMessageDialog(
                              context: context,
                              title: "Order succesfully!",
                              mainText:
                                  "You have successfully place your orders. You can view all your orders in ",
                              additionalText: "",
                              importantText: "Your profile.",
                              iconName: "bravo.png",
                              action: () {
                                Navigator.popUntil(context, (route) {
                                  return _count++ == 2;
                                });
                              });
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
                          print("you failed");
                        }
                      });
                    }
                  }
                },
                child: _isLoading == false
                    ? Text('Place order',
                        style: TextStyle(
                            fontSize: 17 * fontScale(context),
                            fontWeight: FontWeight.w900,
                            color: Colors.white))
                    : loadingText("Please wait", context),
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

  //Payment card
  Widget _paymentCard(
      {required String name,
      required String desc,
      required String img,
      required bool selected}) {
    return Container(
      width: 180 * screenScale(context),
      decoration: BoxDecoration(
          border: Border.all(
              color: selected == false ? Colors.grey.shade300 : Colors.blue),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: Colors.white),
      padding: EdgeInsets.all(10 * screenScale(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/${img}"),
                height: 20 * screenScale(context),
              ),
              SizedBox(width: 5 * screenScale(context)),
              name != ""
                  ? Text(name,
                      style: TextStyle(
                          fontSize: 14 * fontScale(context),
                          fontWeight: FontWeight.bold))
                  : SizedBox(),
            ],
          ),
          SizedBox(height: 5 * screenScale(context)),
          Text(desc, style: TextStyle(fontSize: 12 * fontScale(context))),
          SizedBox(height: 5 * screenScale(context)),
        ],
      ),
    );
  }
}
