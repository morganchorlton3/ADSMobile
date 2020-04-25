import 'package:ads/gradientAppBar.dart';
import 'package:ads/models/order.dart';
import 'package:ads/orderView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';


import 'models/order.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('ADS'),
          ),
        ),
        body:HomePageBody(),
      ),
    );
  }
}


class HomePageBody extends StatelessWidget {

  MapboxNavigation _directions;

 Future<List<Order>> getOrders() async {
    var url = 'http://ads.morganchorlton.me/api/orders';
    var response = await http.get(url);
    
    var notes = List<Order>();
    
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Order.fromJson(noteJson));
      }
    }
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return new HomePage();
  }

}


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  MapboxNavigation _directions;
  bool _arrived = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapboxNavigation(onRouteProgress: (arrived) async {

      setState(() {
        _arrived = arrived;
      });
      if (arrived)
        {
          await Future.delayed(Duration(seconds: 3));
          await _directions.finishNavigation();
        }
    });
  }
  
  List<Order> _notes = List<Order>();

  Future<List<Order>> getOrders() async {
    var url = 'http://ads.morganchorlton.me/api/orders';
    var response = await http.get(url);
    
    var notes = List<Order>();
    
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Order.fromJson(noteJson));
      }
    }
    return notes;
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    padding: EdgeInsets.only(top: 8.0),
                    child: Card(
                      child: ListTile(
                        enabled: true,
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
    );
  }
}