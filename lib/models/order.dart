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
  Long lng, lat;
  bool isExpanded;
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