class CompletedOrder {

  int orderID, status;
  var signature;

  CompletedOrder(
    this.orderID,
    this.signature,
    this.status
  );

  factory CompletedOrder.fromJson(Map<String, dynamic> json) {
    return new CompletedOrder(
      json['id'],
      json['signature'],
      json['status']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': orderID,
        'signature': signature,
        'status': status
      };
    }
