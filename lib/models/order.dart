import 'package:itproject_gadget_store/models/order_item.dart';
import 'package:itproject_gadget_store/models/order_tracking.dart';

class Order {
  late int? id;
  late int userId, estArrivalDays;
  late double shippingCost, subtotal, total, productCost, tax;
  late String addressLine,
      name,
      city,
      district,
      paymentMethod,
      status,
      ward,
      phone;
  late DateTime orderTime;
  late DateTime? deliveredTime;
  late List<OrderItem> items;
  late List<OrderTracking> tracks;
  late OrderTracking finalTrack;

  Order(
      {this.id,
      required this.userId,
      required this.estArrivalDays,
      required this.shippingCost,
      required this.subtotal,
      required this.total,
      required this.productCost,
      required this.tax,
      required this.addressLine,
      required this.name,
      required this.city,
      required this.district,
      required this.ward,
      required this.paymentMethod,
      required this.status,
      required this.phone,
      this.deliveredTime,
      required this.orderTime,
      required this.items,
      required this.tracks,
      required this.finalTrack});

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> iList = [];
    for (var i in json["items"]) {
      OrderItem o = OrderItem.fromJson(i);
      iList.add(o);
    }

    List<OrderTracking> jList = [];
    for (var i in json["tracks"]) {
      OrderTracking t = OrderTracking.fromJson(i);
      jList.add(t);
    }

    if (json["delivery_complete_date"] == null) {
      return Order(
        id: int.parse(json["id"]),
        userId: int.parse(json["customer_id"]),
        shippingCost: double.parse(json["shipping_cost"]),
        subtotal: double.parse(json["subtotal"]),
        tax: double.parse(json["tax"]),
        estArrivalDays: int.parse(json["estimated_delivery_days"]),
        productCost: double.parse(json["product_cost"]),
        addressLine: json["address_line"],
        city: json["city"],
        district: json["district"],
        ward: json["ward"],
        name: json["full_name"],
        orderTime: DateTime.parse(json["order_time"]),
        paymentMethod: json["payment_method"],
        phone: json["phone_number"],
        status: json["status"],
        total: double.parse(json["total"]),
        items: iList,
        tracks: jList,
        finalTrack: jList.last,
      );
    }

    return Order(
      id: int.parse(json["id"]),
      userId: int.parse(json["customer_id"]),
      shippingCost: double.parse(json["shipping_cost"]),
      subtotal: double.parse(json["subtotal"]),
      tax: double.parse(json["tax"]),
      estArrivalDays: int.parse(json["estimated_delivery_days"]),
      productCost: double.parse(json["product_cost"]),
      addressLine: json["address_line"],
      city: json["city"],
      district: json["district"],
      ward: json["ward"],
      name: json["full_name"],
      orderTime: DateTime.parse(json["order_time"]),
      paymentMethod: json["payment_method"],
      phone: json["phone_number"],
      status: json["status"],
      total: double.parse(json["total"]),
      deliveredTime: DateTime.parse(json["delivery_complete_date"]),
      items: iList,
      tracks: jList,
      finalTrack: jList.last,
    );
  }
}
