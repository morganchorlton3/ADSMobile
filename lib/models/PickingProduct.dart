import 'dart:convert' show jsonDecode;
class PickingProduct {
  PickingProduct({
    this.id,
    this.productName,
    //Product Location
    this.aisle,
    this.mod,
    this.shelf,
    this.slot
  });

  int id, productID, aisle, mod, shelf;
  String productName, slot;


  factory PickingProduct.fromJson(Map<String, dynamic> json) {
    return new PickingProduct(
      id: json['id'],
      productName: json['products']['name'],
      aisle: json['products']['product_location']['aisle'],
      mod: json['products']['product_location']['mod'],
      shelf: json['products']['product_location']['shelf'],
      slot: json['products']['product_location']['slot'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': productName,
    'aisle': aisle,
    'mod': mod,
    'shelf': shelf,
    'slot': slot
  };
}
