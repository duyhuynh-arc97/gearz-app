class OrderTracking {
  late int? id, orderId;
  late String statusDesc, status;
  late DateTime updateTime;

  OrderTracking(
      {this.id,
      this.orderId,
      required this.status,
      required this.statusDesc,
      required this.updateTime});

  factory OrderTracking.fromJson(Map<String, dynamic> json) {
    return OrderTracking(
        id: int.parse(json["id"]),
        orderId: int.parse(json["order_id"]),
        status: json["status"],
        statusDesc: json["status_detail"],
        updateTime: DateTime.parse(json["updated_time"]));
  }
}
