import 'package:ads/login.dart';
import 'package:ads/models/compleatedOrder.dart';
import 'package:ads/models/order.dart';
import 'package:ads/orderView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class OrdersPage extends StatefulWidget {

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

int orderCounter = 0;
int ordersCount = 0;

List<CompletedOrder> compleatedOrders = new List<CompletedOrder>();


incrementCounter(Order order, String signature) async{
  CompletedOrder completedOrder = new CompletedOrder(order.id, "Hello", 1, order.userID);
  compleatedOrders.add(completedOrder);
  for(var i = 0; i < compleatedOrders.length; i++){
       // print(compleatedOrders[i].toJson());
  }
  /*final prefs = await SharedPreferences.getInstance();
  int orderCounter = prefs.get('orderCounter');
  if(orderCounter == null){
    orderCounter = 0;
  }else{
    orderCounter++;
  }
  prefs.setInt('orderCounter', orderCounter);
  print(orderCounter);
  */
  orderCounter++;  
}

class _OrdersPageState extends State<OrdersPage> {

  MapboxNavigation _directions;
  int _run;
  //bool _arrived = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapboxNavigation(onRouteProgress: (arrived) async {

      setState(() {
        //_arrived = arrived;
      });
      if (arrived)
        {
          await Future.delayed(Duration(seconds: 3));
          await _directions.finishNavigation();
        }
    });
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  Future<List<Order>> getOrders() async {
   SharedPreferences localStorage = await SharedPreferences.getInstance();
      var orderJson = localStorage.getString('orders'); 
      if(orderJson != null){
        var orders = List<Order>();
        var ordersJson = json.decode(orderJson);
        for (var orderJson in ordersJson) {
          orders.add(Order.fromJson(orderJson));
        }
        ordersCount = orders.length;
        _run = orders[0].runID;
        return orders;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(51, 102, 153, 1),
        body: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<Order>>(
                future: getOrders(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.data == null){
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color.fromRGBO(255, 255, 187, 1),
                        valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(251, 202, 0, 1)),

                      ),
                    );
                  }else{
                    return Container(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0), 
                            child: Card(
                              child: ListTile(
                                enabled: snapshot.data[index].orderCounter == orderCounter ? true : false,
                                leading: Icon(Icons.navigation),
                                title: Text(snapshot.data[index].name),
                                subtitle: Text(snapshot.data[index].postCode),
                                onTap: ()async {
                                  Position position = await Geolocator()
                                  .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                                  final cityhall = Location(name: "Current Pos", latitude: position.latitude, longitude: position.longitude);
                                  final downtown = Location(name: "New Destination", latitude: snapshot.data[index].lat , longitude: snapshot.data[index].lng);
                                
                                  await _directions.startNavigation(
                                    origin: cityhall, 
                                    destination: downtown, 
                                    mode: NavigationMode.drivingWithTraffic, 
                                    simulateRoute: false,
                                    language: "english"
                                  );
                                },          
                                trailing: Column(
                                  children: <Widget>[
                                    RaisedButton(
                                      child: Text("I'm here"),
                                      onPressed: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => OrderView(order: snapshot.data[index])),
                                          );
                                      },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            BottomAppBar(
              color: Color.fromRGBO(251, 202, 0, 1),
              child: Center(
                child: RaisedButton(
                  color: Color.fromRGBO(51, 102, 153, 1),
                  onPressed: orderCounter == ordersCount ? _endRun : null, 
                  child: Text("End Run"),
                ),
              )
            ),
          ],
        ),
      );
  }

  _endRun() async{
    print("Run Finished");
    var url = 'https://ads.morganchorlton.me/api/run/save?id=' + this._run.toString();
    print(json.encode(compleatedOrders));
    var response = await http.post(url, body: json.encode(compleatedOrders));
    print(response.body);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => LogIn()
                )
              );
              Alert(
      context: context,
      type: AlertType.success,
      title: "Trip Saved",
      desc: "Trip Compleate",
    ).show();
    }
    
  
}