class Status {
  late String name;
  late String desc;

  Status({required this.name, required this.desc});

  static List<Status> statusList = [
    Status(name: "NEW", desc: "Order accepted"),
    Status(name: "CANCELLED", desc: "Order dropped"),
    Status(name: "PROCESSING", desc: "In progress"),
    Status(name: "PACKAGED", desc: "Parcel ready for dispatch"),
    Status(name: "PICKED", desc: "Parcel dispatched"),
    Status(name: "SHIPPING", desc: "Out for delivery"),
    Status(name: "DELIVERED", desc: "Order arrived"),
    Status(name: "RETURN_REQUESTED", desc: "Customer requested order return"),
    Status(name: "PAID", desc: "Order was paid"),
    Status(name: "REFUNDED", desc: "Order refunded")
  ];
}
