import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/order_controller.dart';
import 'package:itproject_gadget_store/models/order.dart';
import 'package:itproject_gadget_store/screens/additional_screens/all_product_screen.dart';

import 'order_details_screen.dart';

class CancellationScreen extends StatefulWidget {
  const CancellationScreen({Key? key}) : super(key: key);

  @override
  _CancellationScreenState createState() => _CancellationScreenState();
}

class _CancellationScreenState extends State<CancellationScreen> {
  Color _cardColor = Color(hexColor("#f7f7f7"));

  OrderController _orderController = Get.find();

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
            "Cancellations & Returns",
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
          () => _orderController.cancelledOrders.length > 0
              ? ListView.separated(
                  padding: EdgeInsets.fromLTRB(10 * screenScale(context), 0,
                      10 * screenScale(context), 10 * screenScale(context)),
                  itemBuilder: (context, index) => _orderCard(
                      order: _orderController.cancelledOrders[index]),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 15 * screenScale(context)),
                  itemCount: _orderController.cancelledOrders.length)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300 * screenScale(context),
                        child: Text(
                          "There are no cancelled or returned orders. \n Let's continue exploring our store.",
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

  //Order card
  Widget _orderCard({required Order order}) {
    int _q = 0;
    for (var i in order.items) {
      _q += i.quantity;
    }

    return Container(
      padding: EdgeInsets.all(15 * screenScale(context)),
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
              Text(
                _convertTime(order.orderTime),
                style: TextStyle(
                    fontSize: 16 * fontScale(context),
                    fontWeight: FontWeight.bold),
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
                  size: 24 * fontScale(context),
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
                              fontSize: 14 * screenScale(context)),
                        ),
                        Text(
                          " (VAT included)",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14 * screenScale(context)),
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
                                fontSize: 14 * fontScale(context))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10 * screenScale(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    "Status:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * fontScale(context)),
                  ),
                  SizedBox(width: 5 * screenScale(context)),
                  Text(
                    order.finalTrack.statusDesc,
                    style: TextStyle(
                        color: Colors.red, fontSize: 14 * fontScale(context)),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                "Updated: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14 * fontScale(context)),
              ),
              Text(
                order.finalTrack.updateTime.toString(),
                style: TextStyle(
                    color: Colors.blue, fontSize: 14 * fontScale(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
