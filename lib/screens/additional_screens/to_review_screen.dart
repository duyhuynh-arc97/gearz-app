import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/order_controller.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/models/order.dart';
import 'package:itproject_gadget_store/models/product.dart';
import 'package:itproject_gadget_store/screens/additional_screens/order_details_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/product_details_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/to_receive_screen.dart';
import 'package:itproject_gadget_store/widgets/common_widgets.dart';

import 'all_product_screen.dart';

class ToReviewScreen extends StatefulWidget {
  const ToReviewScreen({Key? key}) : super(key: key);

  @override
  _ToReviewScreenState createState() => _ToReviewScreenState();
}

class _ToReviewScreenState extends State<ToReviewScreen> {
  OrderController _orderController = Get.find();
  Color _cardColor = Color(hexColor("#f7f7f7"));
  TextEditingController _headingController = TextEditingController();
  TextEditingController _cmtController = TextEditingController();
  double _rate = 0;
  bool _isLoading = false;
  UserController _userController = Get.find();

  _convertTime(DateTime time) {
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

    List _dayinweek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    var mon = _month[time.month - 1].toString();
    var dayinweek = _dayinweek[time.weekday - 1].toString();
    var day = time.day.toString();
    var year = time.year.toString();

    return dayinweek + ", " + mon + " " + day + " " + year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "To review",
            style: TextStyle(
                color: Colors.black, fontSize: 20 * fontScale(context)),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Ionicons.chevron_back_outline,
                color: Colors.black,
                size: 24 * screenScale(context),
              )),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Obx(
          () => _orderController.myOrders.length > 0
              ? DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      _subTabBar(),
                      SizedBox(height: 15 * screenScale(context)),
                      _subTabViews(),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300 * screenScale(context),
                        child: Text(
                          "There are no ordered products. \n Let's continue exploring our store.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14 * fontScale(context)),
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
                              borderRadius: BorderRadius.circular(
                                  5 * screenScale(context))),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }

  //Small tabbar in page
  Widget _subTabBar() {
    return SizedBox(
      child: TabBar(
        indicator: UnderlineTabIndicator(
            insets: EdgeInsets.symmetric(
                vertical: 5 * screenScale(context),
                horizontal: 20 * screenScale(context)),
            borderSide: BorderSide(
              width: 3 * screenScale(context),
              color: Colors.blue,
            )),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
            fontSize: 16 * fontScale(context),
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans'),
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(
            text: "Unrated products",
          ),
          Tab(
            text: "Paid orders",
          )
        ],
      ),
    );
  }

  //Small tabs in page
  Widget _subTabViews() {
    return Expanded(
      child: TabBarView(
        children: [
          _orderController.unratedProducts.length > 0
              ? ListView.separated(
                  padding: EdgeInsets.fromLTRB(10 * screenScale(context), 0,
                      10 * screenScale(context), 10 * screenScale(context)),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => _unratedCard(
                      unratedProduct: _orderController.unratedProducts[index]),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 10 * screenScale(context)),
                  itemCount: _orderController.unratedProducts.length,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300 * screenScale(context),
                        child: Text(
                          "There are no unrated products. \n Let's continue exploring our store.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14 * fontScale(context)),
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
                              borderRadius: BorderRadius.circular(
                                  5 * screenScale(context))),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ),
          _orderController.paidOrders.length > 0
              ? ListView.separated(
                  padding: EdgeInsets.fromLTRB(10 * screenScale(context), 0,
                      10 * screenScale(context), 10 * screenScale(context)),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      _orderCard(order: _orderController.paidOrders[index]),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 10 * screenScale(context)),
                  itemCount: _orderController.paidOrders.length,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300 * screenScale(context),
                        child: Text(
                          "There are no paid orders. \n Your orders might be being delivered.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14 * fontScale(context)),
                        ),
                      ),
                      SizedBox(
                        height: 40 * screenScale(context),
                        width: 150 * screenScale(context),
                        child: MaterialButton(
                          onPressed: () => Get.to(() => ToReceiveScreen()),
                          textColor: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.radar_2,
                                color: Colors.blue,
                                size: 24 * screenScale(context),
                              ),
                              SizedBox(width: 5 * screenScale(context)),
                              Text(
                                "Track orders",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14 * fontScale(context)),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(5 * screenScale(context)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5 * screenScale(context))),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  //Card for items
  Container _unratedCard({required Product unratedProduct}) {
    return Container(
      padding: EdgeInsets.only(right: 5 * screenScale(context)),
      height: 111 * screenScale(context),
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
                  tag: unratedProduct,
                  child: Image.network(
                    unratedProduct.mainImg,
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
                  unratedProduct.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14 * fontScale(context)),
                ),
                SizedBox(height: 10 * screenScale(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    unratedProduct.discount != 0
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
                                      (unratedProduct.price -
                                              unratedProduct.price *
                                                  unratedProduct.discount /
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
                                  Text(unratedProduct.price.toString(),
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
                                  isInt(unratedProduct.price)
                                      ? unratedProduct.price.toStringAsFixed(0)
                                      : unratedProduct.price.toString(),
                                  style: TextStyle(
                                      fontSize: 15 * fontScale(context),
                                      fontWeight: FontWeight.bold,
                                      color: Color(hexColor("#ff408d")))),
                            ],
                          ),
                    unratedProduct.discount != 0
                        ? Text("${unratedProduct.discount}% off",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 14 * fontScale(context)))
                        : Text(""),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5 * screenScale(context)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() =>
                            ProductDetailsScreen(product: unratedProduct)),
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
                      Container(
                          height: 30 * screenScale(context),
                          width: 80 * screenScale(context),
                          child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Get.back();
                                      _headingController.clear();
                                      _cmtController.clear();
                                      _isLoading = false;
                                    },
                                    child: DraggableScrollableSheet(
                                      initialChildSize: 0.75,
                                      builder: (context, scrollController) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return Container(
                                            padding: EdgeInsets.all(
                                                15 * screenScale(context)),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(
                                                    20 * screenScale(context)),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Your thoughts",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16 *
                                                          fontScale(context)),
                                                ),
                                                SizedBox(
                                                    height: 10 *
                                                        screenScale(context)),
                                                _headingField(),
                                                SizedBox(
                                                    height: 15 *
                                                        screenScale(context)),
                                                Text(
                                                  "Tell us in details",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16 *
                                                          fontScale(context)),
                                                ),
                                                SizedBox(
                                                    height: 10 *
                                                        screenScale(context)),
                                                _cmtField(),
                                                SizedBox(
                                                    height: 15 *
                                                        screenScale(context)),
                                                Text(
                                                  "Your rating",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16 *
                                                          fontScale(context)),
                                                ),
                                                SizedBox(
                                                    height: 10 *
                                                        screenScale(context)),
                                                RatingBar.builder(
                                                  itemBuilder: (context, _) =>
                                                      Icon(Iconsax.star1,
                                                          color: Colors.amber),
                                                  onRatingUpdate: (value) {
                                                    setState(() {
                                                      _rate = value;
                                                    });
                                                  },
                                                  ignoreGestures: false,
                                                  initialRating: 0,
                                                  itemSize:
                                                      50 * screenScale(context),
                                                  unratedColor:
                                                      Colors.grey.shade400,
                                                ),
                                                SizedBox(
                                                    height: 10 *
                                                        screenScale(context)),
                                                Text(
                                                  "Product",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16 *
                                                          fontScale(context)),
                                                ),
                                                SizedBox(
                                                    height: 10 *
                                                        screenScale(context)),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10 *
                                                                  screenScale(
                                                                      context)),
                                                      child: Container(
                                                          color: Colors.white,
                                                          width: 80 *
                                                              screenScale(
                                                                  context),
                                                          height: 80 *
                                                              screenScale(
                                                                  context),
                                                          child: Hero(
                                                            tag: unratedProduct,
                                                            child:
                                                                Image.network(
                                                              unratedProduct
                                                                  .mainImg,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )),
                                                    ),
                                                    SizedBox(
                                                        width: 5 *
                                                            screenScale(
                                                                context)),
                                                    Expanded(
                                                      child: Text(
                                                        unratedProduct.name,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 14 *
                                                                fontScale(
                                                                    context)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: 45 *
                                                        screenScale(context)),
                                                Container(
                                                  height:
                                                      45 * screenScale(context),
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      if (_headingController
                                                              .text.isEmpty &&
                                                          _cmtController
                                                              .text.isEmpty) {
                                                        Get.snackbar(
                                                          "Please tell us your thoughts!",
                                                          "You haven't tell us anything about your thought for that product. Tell us your thoughts.",
                                                          colorText:
                                                              Colors.white,
                                                          snackStyle: SnackStyle
                                                              .FLOATING,
                                                          barBlur: 30,
                                                          backgroundColor:
                                                              Colors.black45,
                                                          isDismissible: true,
                                                          duration: Duration(
                                                              seconds: 3),
                                                          dismissDirection:
                                                              DismissDirection
                                                                  .horizontal,
                                                        );
                                                      } else {
                                                        setState(() {
                                                          _isLoading = true;
                                                        });

                                                        var res = await _userController.reviewProduct(
                                                            heading:
                                                                _headingController
                                                                    .text,
                                                            comment:
                                                                _cmtController
                                                                    .text,
                                                            userId:
                                                                _userController
                                                                    .user
                                                                    .value
                                                                    .id,
                                                            productId:
                                                                unratedProduct
                                                                    .id,
                                                            rating:
                                                                _rate.toInt());
                                                        if (res ==
                                                            "successful") {
                                                          setState(() {
                                                            _isLoading = false;
                                                          });
                                                          int _count = 0;
                                                          openSuccessMessageDialog(
                                                              context: context,
                                                              title:
                                                                  "Submitted!",
                                                              mainText:
                                                                  "Thanks for your feedback. Hope you have the best experience in our store.",
                                                              additionalText:
                                                                  "",
                                                              iconName:
                                                                  "thank.png",
                                                              action: () {
                                                                _orderController
                                                                    .unratedProducts
                                                                    .removeWhere((element) =>
                                                                        element
                                                                            .id ==
                                                                        unratedProduct
                                                                            .id);
                                                                Navigator
                                                                    .popUntil(
                                                                        context,
                                                                        (route) {
                                                                  return _count++ ==
                                                                      2;
                                                                });
                                                              });
                                                        } else {
                                                          setState(() {
                                                            _isLoading = false;
                                                          });
                                                          print(
                                                              "smth was wrong");
                                                        }
                                                      }
                                                    },
                                                    child: _isLoading == false
                                                        ? Text('Submit',
                                                            style: TextStyle(
                                                                fontSize: 17 *
                                                                    fontScale(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                color: Colors
                                                                    .white))
                                                        : loadingText(
                                                            "Please wait",
                                                            context),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(7 *
                                                                  screenScale(
                                                                      context))),
                                                      primary: Color(
                                                          hexColor("#346ec9")),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  );
                                },
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                              );
                            },
                            child: Text(
                              "Review",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14 * screenScale(context)),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blue,
                                      width: 1 * screenScale(context)),
                                  borderRadius: BorderRadius.circular(
                                      7 * screenScale(context))),
                              primary: Colors.white,
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Input field
  Widget _headingField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _headingController,
      validator: inputCheck,
      style: TextStyle(fontSize: 15 * fontScale(context)),
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7 * screenScale(context))),
        contentPadding: EdgeInsets.only(
            top: 25 * screenScale(context), left: 10 * screenScale(context)),
        hintText: 'Thoughts',
      ),
    );
  }

  //Input field
  Widget _cmtField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      controller: _cmtController,
      minLines: 5,
      maxLines: 7,
      validator: inputCheck,
      style: TextStyle(fontSize: 15 * fontScale(context)),
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7 * screenScale(context))),
        contentPadding: EdgeInsets.only(
            top: 25 * screenScale(context), left: 10 * screenScale(context)),
        hintText: 'Details',
      ),
    );
  }

  //Order card
  Widget _orderCard({required Order order}) {
    int _q = 0;
    for (var i in order.items) {
      _q += i.quantity;
    }

    return Container(
      padding: EdgeInsets.all(10 * screenScale(context)),
      decoration: BoxDecoration(
          border: Border.all(color: _cardColor),
          borderRadius:
              BorderRadius.all(Radius.circular(20 * screenScale(context))),
          color: _cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 5 * screenScale(context),
                    right: 5 * screenScale(context)),
                child: Text(
                  _convertTime(order.orderTime),
                  style: TextStyle(
                      fontSize: 16 * fontScale(context),
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(() => OrderDetailsScreen(order: order)),
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
              )
            ],
          ),
          SizedBox(height: 10 * screenScale(context)),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.all(
                    Radius.circular(10 * screenScale(context))),
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
                            order.name,
                            style: TextStyle(
                                fontSize: 16 * fontScale(context),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 20 * screenScale(context)),
                          Text(
                            order.phone,
                            style: TextStyle(fontSize: 14 * fontScale(context)),
                          ),
                        ],
                      ),
                      SizedBox(height: 5 * screenScale(context)),
                      Text(
                        "${order.addressLine}, ${order.ward}, ${order.district}, ${order.city}",
                        style: TextStyle(fontSize: 14 * fontScale(context)),
                      ),
                      SizedBox(height: 5 * screenScale(context)),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10 * screenScale(context)),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.all(
                    Radius.circular(10 * screenScale(context))),
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
                          " (${_q} items)",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14 * fontScale(context)),
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
                        Text(order.subtotal.toString(),
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
                        Text(order.shippingCost.toString(),
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
                              color: Colors.grey,
                              fontSize: 14 * fontScale(context)),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("\$",
                            style: TextStyle(
                                fontSize: 11 * screenScale(context),
                                fontWeight: FontWeight.bold)),
                        Text(order.total.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14 * screenScale(context))),
                      ],
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
}
