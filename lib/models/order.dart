class Order {
  Order({
    this.addressLine1,
    this.addressLine2,
    this.postCode,
    this.name,
    //For Directions
    this.lng,
    this.lat,
    this.isExpanded = false,
  });

  String addressLine1, addressLine2, postCode, name;
  double lng, lat;
  bool isExpanded;

  factory Order.fromJson(Map<String, dynamic> json) {
    return new Order(
      name: json['name'],
      postCode: json['postCode'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      lat: json['lat'],
      lng: json['long'],
    );
  }

}

List<Order> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Order(
      addressLine1: "5 Lennox House",
      addressLine2: "40 Henrietta Street",
      postCode: "OL6 6HW",
      name:"Mr Morgan Chorlcsdston",
      lng: -2.03468,
      lat: 53.49757,
    );
  });

  
}