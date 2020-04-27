
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:ads/models/order.dart';
import 'models/order.dart';
import 'orders.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui' as ui;

class OrderView extends StatelessWidget {

  final Order order;
  //Signature Image
  ByteData _img = ByteData(0);
  //Signature pad Date
  final _sign = GlobalKey<SignatureState>();

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
                    onPressed: () { _makePhoneCall(order.phoneNumber);},
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
        child: Card(
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
          Padding(
            padding: const EdgeInsets.only(bottom:8.0),
            child: Center(child: Text("Customer Signature", style: TextStyle(color: Colors.white, fontSize: 18)),),
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Signature(
                  color: Colors.black,
                  key: _sign,
                  onSign: () {
                    final sign = _sign.currentState;
                  },
                  strokeWidth: 2,
                ),
              ),
              color: Colors.black12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:24.0, left: 12, right: 12),
            child: Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Color.fromRGBO(251, 202, 0, 1),
                      child: Text("Finish Delivery", style: TextStyle(color: Color.fromRGBO(51, 102, 153, 1), fontSize: 16),),
                      onPressed: () async{
                        final sign = _sign.currentState;

                        //retrieve image data, do whatever you want with it (send to server, save locally...)
                        final image = await sign.getData();
                        var data = await image.toByteData(format: ui.ImageByteFormat.png);
                        sign.clear();
                        final encoded = base64.encode(data.buffer.asUint8List());
                        incrementCounter(order, encoded);
                        Navigator.pop(context, false);
                      },             
                    ),
                  ),
                    SizedBox(
                    width: double.infinity,
                    child:RaisedButton(
                      color: Colors.red,
                      child: Text("Could not Deliver", style: TextStyle(color: Colors.white, fontSize: 16),),
                      onPressed: () async{
                        
                      },             
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch('tel://' + url)) {
      await launch('tel://' + url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
