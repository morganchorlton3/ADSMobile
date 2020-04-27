import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:ads/models/order.dart';
import 'models/order.dart';
import 'orders.dart';
import 'package:url_launcher/url_launcher.dart';


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
                Tab(icon: Icon(Icons.description, color: Color.fromRGBO(51, 102, 153, 1),)),
                Tab(icon: Icon(Icons.perm_identity, color: Color.fromRGBO(51, 102, 153, 1),)),
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
    return Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                      child: Center(
                        child: Text('Customer Details', style: TextStyle(fontSize: 20),)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: customerDetails(),
                    ),
                  ],
                ),
              )
            ),
          ),
        ), 
        Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  trayCount("AM", order.amTray),
                  trayCount("CH", order.chTray),
                  trayCount("FZ", order.fzTray),
                ],
              )
            ]
          ),
        ),
      ],
    );
  }

  Widget customerDetails(){
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(order.name)// textLeft(order.name),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(children: <Widget>[
                  textLeft(order.addressLine1),
                  //textLeft(order.addressLine2),
                  textLeft(order.postCode),
                ],
              ),
              Column(children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.phone),
                    onPressed: null//_callPhone("tel:+07783075935"),
                  )
                ],
              ),
            ]
          )
        ],
      ),
    );
  }

  Widget textLeft(String txt){
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(txt),
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
              incrementCounter();
              print(order.id);
               Navigator.pop(context, false);
            },             
          ),
          ],
        ),
      ),
    );
  }

  _callPhone(String phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }
}
