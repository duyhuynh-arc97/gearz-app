class OrderItem {
  late int? id, orderId;
  late int quantity, productId, isReviewed;
  late double shippingCost, subtotal, unitPrice, productCost;

  OrderItem(
      {this.id,
      required this.quantity,
      required this.productId,
      this.orderId,
      required this.shippingCost,
      required this.subtotal,
      required this.unitPrice,
      required this.productCost,
      required this.isReviewed});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: int.parse(json["id"]),
      quantity: int.parse(json["quantity"]),
      shippingCost: double.parse(json["shipping_cost"]),
      subtotal: double.parse(json["subtotal"]),
      unitPrice: double.parse(json["unit_price"]),
      orderId: int.parse(json["order_id"]),
      productId: int.parse(json["product_id"]),
      productCost: double.parse(json["product_cost"]),
      isReviewed: json["isReviewed"],
    );
  }
}
