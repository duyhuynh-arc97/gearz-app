import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/address_controller.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/order_controller.dart';
import 'package:itproject_gadget_store/controllers/product_controller.dart';
import 'package:itproject_gadget_store/controllers/shipping_controller.dart';
import 'package:itproject_gadget_store/models/order.dart';
import 'package:itproject_gadget_store/models/order_item.dart';
import 'package:itproject_gadget_store/models/order_tracking.dart';
import 'package:itproject_gadget_store/models/product.dart';
import 'package:itproject_gadget_store/screens/additional_screens/product_details_screen.dart';
import 'package:itproject_gadget_store/widgets/common_widgets.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;
  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isLoading = false;
  OrderController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    Color _cardColor = Color(hexColor("#f7f7f7"));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Order details",
          style:
              TextStyle(color: Colors.black, fontSize: 20 * fontScale(context)),
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
                    _contactCard(
                      name: this.widget.order.name,
                      address: this.widget.order.addressLine +
                          ", " +
                          this.widget.order.ward +
                          ", " +
                          this.widget.order.district +
                          ", " +
                          this.widget.order.city,
                      phone: this.widget.order.phone,
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
                            orderItem: this.widget.order.items[index]);
                      },
                      itemCount: this.widget.order.items.length,
                      separatorBuilder: (context, index) =>
                          Divider(thickness: 1.5 * screenScale(context)),
                    ),
                    SizedBox(height: 10 * screenScale(context)),
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
                          this.widget.order.finalTrack.statusDesc,
                          style: TextStyle(
                              color: widget.order.status == "CANCELLED" ||
                                      widget.order.status == "REFUNDED" ||
                                      widget.order.status ==
                                          "RETURN_REQUESTED" ||
                                      widget.order.status == "RETURNED"
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 14 * fontScale(context)),
                        )
                      ],
                    ),
                    SizedBox(height: 5 * screenScale(context)),
                    Row(
                      children: [
                        Text(
                          "Updated: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14 * fontScale(context)),
                        ),
                        Text(
                          this.widget.order.finalTrack.updateTime.toString(),
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14 * fontScale(context)),
                        ),
                      ],
                    ),
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
                    _feeCard()
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
                            "Payment method",
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
                        _paymentCard(
                            name: "Cash On Delivery",
                            desc: "Pay when you receive",
                            img: "cod.png",
                            selected: this.widget.order.paymentMethod == "COD"),
                        _paymentCard(
                            name: "",
                            desc: "Pay before you receive",
                            img: "paypal.png",
                            selected:
                                this.widget.order.paymentMethod == "PAYPAL"),
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
                    _detailCostCard(context),
                  ],
                ),
              ),
              SizedBox(
                  height: widget.order.status == "CANCELLED" ||
                          widget.order.status == "REFUNDED" ||
                          widget.order.status == "RETURN_REQUESTED" ||
                          widget.order.status == "RETURNED"
                      ? 0
                      : 10 * screenScale(context)),
              widget.order.status == "CANCELLED" ||
                      widget.order.status == "REFUNDED" ||
                      widget.order.status == "RETURN_REQUESTED" ||
                      widget.order.status == "RETURNED"
                  ? SizedBox()
                  : _returnBtn(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _returnBtn(BuildContext context) {
    return Container(
      height: 45 * screenScale(context),
      width: double.infinity,
      margin: EdgeInsets.only(
          top: 5 * screenScale(context), bottom: 10 * screenScale(context)),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          int _count = 0;

          _controller.returnOrder(id: widget.order.id).then((value) {
            if (value == "successful") {
              setState(() {
                _isLoading = false;
              });
              openSuccessMessageDialog(
                  context: context,
                  title: "Request sent!",
                  mainText: this.widget.order.finalTrack.status ==
                              "DELIVERED" ||
                          this.widget.order.finalTrack.status == "PAID"
                      ? "You've just sent the return request. We will consider solve your situation."
                      : "You've just sent the cancel request. We will consider solve your situation.",
                  additionalText: "",
                  iconName: "success.png",
                  action: () {
                    _controller.unpaidOrders.removeWhere(
                        (element) => element.id == widget.order.id);
                    _controller.paidOrders.removeWhere(
                        (element) => element.id == widget.order.id);
                    var temp = widget.order;
                    temp.status = "RETURN_REQUESTED";
                    temp.tracks.add(OrderTracking(
                        status: "RETURN_REQUESTED",
                        statusDesc: "Customer requested order return",
                        updateTime: DateTime.now()));
                    _controller.cancelledOrders.add(temp);
                    _controller.update();
                    Navigator.popUntil(context, (route) {
                      return _count++ == 2;
                    });
                  });
            } else {
              setState(() {
                _isLoading = false;
              });
              print("smt wrong");
            }
          });
        },
        child: _isLoading == false
            ? Text(
                this.widget.order.finalTrack.status == "DELIVERED" ||
                        this.widget.order.finalTrack.status == "PAID"
                    ? 'Return order'
                    : "Cancel order",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17 * fontScale(context),
                    fontWeight: FontWeight.w900,
                    color: Colors.white))
            : loadingText("Please wait", context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          primary: Color(hexColor("#346ec9")),
        ),
      ),
    );
  }

  //Details cost cart
  Container _detailCostCard(BuildContext context) {
    int _q = 0;
    for (var i in this.widget.order.items) {
      _q += i.quantity;
    }

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
                        fontSize: 14 * screenScale(context)),
                  ),
                  Text(
                    " (${_q} items)",
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
                          fontSize: 11 * fontScale(context),
                          fontWeight: FontWeight.bold)),
                  Text(this.widget.order.subtotal.toStringAsFixed(2),
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
                  Text(this.widget.order.shippingCost.toString(),
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
                      (this.widget.order.subtotal +
                              this.widget.order.shippingCost)
                          .toStringAsFixed(2),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale(context))),
                ],
              ),
            ],
          ),
          SizedBox(
              height: this.widget.order.paymentMethod == "COD" &&
                      (widget.order.status != "CANCELLED" &&
                          widget.order.status != "REFUNDED" &&
                          widget.order.status != "RETURN_REQUESTED")
                  ? 15 * screenScale(context)
                  : 0),
          this.widget.order.paymentMethod == "COD" &&
                  (widget.order.status != "CANCELLED" &&
                      widget.order.status != "REFUNDED" &&
                      widget.order.status != "RETURN_REQUESTED")
              ? Text(
                  "Please prepare the corresponding amount on the delivery date.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blue, fontSize: 14 * fontScale(context)),
                )
              : SizedBox(),
        ],
      ),
    );
  }

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
                fontSize: 16 * fontScale(context), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

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

  Widget _itemCard({required OrderItem orderItem}) {
    ProductController _productController = Get.find();
    Product _p = _productController.productList
        .singleWhere((element) => element.id == orderItem.productId);

    return Container(
      padding: EdgeInsets.only(right: 5 * screenScale(context)),
      height: 110 * screenScale(context),
      decoration: BoxDecoration(
          border: Border.all(color: Color(hexColor("#f7f7f7"))),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: Color(hexColor("#f7f7f7"))),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10 * screenScale(context)),
            child: Container(
                color: Colors.white,
                width: 110 * screenScale(context),
                height: 110 * screenScale(context),
                child: Image.network(
                  _p.mainImg,
                  fit: BoxFit.cover,
                )),
          ),
          SizedBox(width: 5 * screenScale(context)),
          Expanded(
            child: Column(
              children: [
                Text(
                  _p.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14 * fontScale(context)),
                ),
                SizedBox(height: 10 * screenScale(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _p.discount != 0
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\$",
                                  style: TextStyle(
                                      fontSize: 11 * fontScale(context),
                                      color: Color(hexColor("#ff408d")),
                                      fontWeight: FontWeight.bold)),
                              Text(orderItem.subtotal.toStringAsFixed(2),
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
                                  isInt(orderItem.subtotal)
                                      ? orderItem.subtotal.toStringAsFixed(0)
                                      : orderItem.subtotal.toString(),
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
                          onTap: () =>
                              Get.to(() => ProductDetailsScreen(product: _p)),
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
                      "Quantity: ${orderItem.quantity}",
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

  Container _feeCard() {
    ShippingController _shippingController = Get.find();
    AddressController _addrController = Get.find();

    var tempcity = _addrController.cities
        .singleWhere((element) => element.name == this.widget.order.city);

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
                  Text(
                    "Shipping fee: ",
                    style: TextStyle(fontSize: 14 * fontScale(context)),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("\$",
                          style: TextStyle(
                              fontSize: 12 * fontScale(context),
                              fontWeight: FontWeight.bold)),
                      Text(this.widget.order.shippingCost.toString(),
                          style: TextStyle(
                              fontSize: 16 * fontScale(context),
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5 * screenScale(context)),
              Text(
                "Est. Arrival: ${_shippingController.calculateShippingDate(cityId: tempcity.id, district: this.widget.order.district)}",
                style: TextStyle(fontSize: 14 * fontScale(context)),
              ),
              SizedBox(height: 5 * screenScale(context)),
            ],
          )
        ],
      ),
    );
  }

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
