import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:ads/models/order.dart';

class OrderView extends StatelessWidget {

  final Order order;

  OrderView({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
             leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context, false),
            ),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
              ],
            ),
            title: Text("Delivery"),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              currentDelivery(),
              finishDelivery(),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget currentDelivery(){
    return Container(
      child: Text("Hello"),
    );
  }

  Widget finishDelivery() {
    return Container(
      child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Customer Signature:"),
            ),
          ],
        ),
        Container(
          width: 400,
          height: 200,
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Signature(
              color: Colors.black,
              strokeWidth: 5.0, 
              backgroundPainter: null, 
              onSign: null, 
              key: null, 
            ),
          ),
        ),
        RaisedButton(
          child: Text("Save"),
          onPressed: () {
            print("SAVED!");
          },             
        ),
        ],
      ),
    );
  }
}
