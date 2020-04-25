import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:ads/models/order.dart';

import 'main.dart';
import 'models/order.dart';

class OrderView extends StatelessWidget {

  final Order order;

  OrderView({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(51, 102, 153, 1),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(251, 202, 0, 1),
            automaticallyImplyLeading: false,
             leading: IconButton(icon:Icon(Icons.arrow_back, color: Color.fromRGBO(51, 102, 153, 1),),
              onPressed:() => Navigator.pop(context, false),
            ),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car, color: Color.fromRGBO(51, 102, 153, 1),)),
                Tab(icon: Icon(Icons.directions_transit, color: Color.fromRGBO(51, 102, 153, 1),)),
              ],
            ),
            title: Text("Delivery", style: TextStyle(color: Color.fromRGBO(51, 102, 153, 1),),),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              currentDelivery(),
              finishDelivery(context), 
            ],
          ),
        ),
      ),
    );
  }

  Widget currentDelivery(){
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              trayCount("AM", 3),
              trayCount("CH", 1),
              trayCount("FZ", 1),
            ],
          )
        ]
      ),
    );
  }

  Widget trayCount(String type, int trayCount){
    return Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150),
          child: Container(
            width: 100,
            color : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                  Text(type, style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(51, 102, 153, 1)),),
                  Text(trayCount.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(51, 102, 153, 1))),
                ],
              ),
            ),
          ),
        ),
      )
    ],
  );
  }

  Widget finishDelivery(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Customer Signature:", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
          Container(
            width: 400,
            height: 200,
            color: Colors.white,
            child: Signature(
              color: Colors.black,
              strokeWidth: 5.0, 
              backgroundPainter: null, 
              onSign: null, 
              key: null, 
            ),
          ),
          RaisedButton(
            child: Text("Save"),
            onPressed: () {
               Navigator.pop(context, false);
            },             
          ),
          ],
        ),
      ),
    );
  }
}
