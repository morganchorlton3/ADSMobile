import 'dart:convert';

import 'package:ads/services/webService.dart';

class PickingProduct {

  int id, orderID, productID, aisle, mod, shelf, qty;
  String productName, slot, barcode;

  PickingProduct({
    this.id,
    this.orderID,
    this.productName,
    this.barcode,
    this.qty,
    //Product Location
    this.aisle,
    this.mod,
    this.shelf,
    this.slot
  });

  factory PickingProduct.fromJson(Map<String, dynamic> json) {
    return PickingProduct(
      id: json['id'],
      orderID: json['orderID'],
      productName: json['products']['name'],
      barcode: json['products']['barcode'],
      aisle: json['products']['product_location']['aisle'],
      mod: json['products']['product_location']['mod'],
      shelf: json['products']['product_location']['shelf'],
      slot: json['products']['product_location']['slot'],
      qty: json['quantity']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderID': orderID,
    'name': productName,
    'barcode' : barcode,
    'aisle': aisle,
    'mod': mod,
    'shelf': shelf,
    'slot': slot,
    'qty': qty
  };

  static Resource<List<PickingProduct>> get all {
    
    return Resource(
      url: "https://ads.morganchorlton.me/api/picking/get",
      parse: (response) {
        final result = json.decode(response.body); 
        Iterable list = result;
        return list.map((model) => PickingProduct.fromJson(model)).toList();
      }
    );

  }

}
