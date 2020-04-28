class CompletedOrder {

  int orderID, status, userID;
  var signature;

  CompletedOrder(
    this.orderID,
    this.signature,
    this.status,
    this.userID,
  );

  factory CompletedOrder.fromJson(Map<String, dynamic> json) {
    return new CompletedOrder(
      json['orderID'],
      json['userID'],
      json['signature'],
      json['status']
    );
  }

  Map<String, dynamic> toJson() => {
        'orderID': orderID,
        'userID': userID,
        'signature': signature,
        'status': status
      };
    }
