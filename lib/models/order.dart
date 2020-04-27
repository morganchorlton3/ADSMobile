class Order {
  Order({
    this.id,
    this.addressLine1,
    this.addressLine2,
    this.postCode,
    this.name,
    //For Directions
    this.lng,
    this.lat,
    this.isExpanded = false,
    //OrderView
    this.amTray,
    this.chTray,
    this.fzTray,
  });

  int id;
  String addressLine1, addressLine2, postCode, name;
  double lng, lat;
  int amTray, chTray, fzTray;
  bool isExpanded;

  factory Order.fromJson(Map<String, dynamic> json) {
    return new Order(
      id: json['id'],
      name: json['name'],
      postCode: json['postCode'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      lat: json['lat'],
      lng: json['long'],
      amTray: json['amTray'],
      chTray: json['chTray'],
      fzTray: json['fzTray'],
    );
  }

}

List<Order> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Order(
      id: index,
      addressLine1: "5 Lennox House",
      addressLine2: "40 Henrietta Street",
      postCode: "OL6 6HW",
      name:"Mr Morgan Chorlcsdston",
      lng: -2.03468,
      lat: 53.49757,
      amTray: 3,
      chTray: 2,
      fzTray: 1,
    );
  });

  
}