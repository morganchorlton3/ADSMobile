import 'package:ads/login.dart';
import 'package:ads/models/PickingProduct.dart';
import 'package:ads/models/compleatedOrder.dart';
import 'package:ads/models/order.dart';
import 'package:ads/services/webService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class PickingPage extends StatefulWidget {

  @override
  _PickingPageState createState() => _PickingPageState();
}

int orderCounter = 0;
int ordersCount = 0;

class _PickingPageState extends State<PickingPage> {

  List<PickingProduct> _products;
  bool _progressController = true;

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  Future<List<PickingProduct>> getPick() async {
   SharedPreferences localStorage = await SharedPreferences.getInstance();
      var orderJson = localStorage.getString('Pick'); 
      if(orderJson != null){
        var picks = List<PickingProduct>();
        var pickJson = json.decode(orderJson);
        for (var pickJson in pickJson) {
          picks.add(PickingProduct.fromJson(pickJson));
          print('---------------------------------');
          print(PickingProduct.fromJson(pickJson).toJson());
          print('---------------------------------');
        }
        ordersCount = picks.length;
        return picks;
      }
  }

  void getProducts(){
    Webservice().load(PickingProduct.all).then((products) => {
      setState(() => {
        _products = products,
         _progressController = false,
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(251, 202, 0, 1),
          title: Center(
            child: Text('ADS', style: TextStyle(color: Color.fromRGBO(51, 102, 153, 1),),),
          ),
        ),
      backgroundColor: Color.fromRGBO(51, 102, 153, 1),
        body: _products.length == 0 ?
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("No Items Left", style: TextStyle(color: Colors.white, fontSize: 24),),
                  RaisedButton(
                    child: Text("Logout"),
                    onPressed: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.clear();
                     Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => LogIn()
                          )
                        );
                     },
                  )
                ],
              ),
            )
        : Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _products == null ? 0 : _products.length ,
                itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0), 
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Center(child: Text(_products[index].productName, style: TextStyle(fontSize: 18),),),
                              ),
                              Row(
                                 mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  innerCard("Aisle", _products[index].aisle.toString()),
                                  innerCard("Mod", _products[index].mod.toString()),
                                  innerCard("Shelf", _products[index].shelf.toString()),
                                  innerCard("Slot", _products[index].slot.toString())

                                ],
                              )
                            ],
                          ),
                        )
                      ),
                    );
                }
              ),
            ),
            BottomAppBar(
              color: Color.fromRGBO(251, 202, 0, 1),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.camera),
                  tooltip: "Scan",
                  onPressed: scan,
                )
              ),
            ),
          ],
        ),
      );
  }

  Widget innerCard(String type, String value){
    return Flexible(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            Text(type),
            Text(value)
            ],
          ),
        ),
      )
    );
  }

  Future scan() async {
  String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print("Barcode Result:" + barcodeScanRes);
          setState(() {
          _products.removeWhere((item) => item.barcode == barcodeScanRes);
          _products = _products;
          print(_products.length);
        });
      
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }
}
