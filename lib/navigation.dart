import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:geolocator/geolocator.dart';

class Order {
  final int id;
  final String name, postCode, address, slot;
  final String ambientTrays, chilledTrays, frozenTrays;
  final int itemCount;
  final double lng, lat;

  Order({this.id, this.name, this.postCode, this.address, this.slot, this.ambientTrays , this.chilledTrays, this.frozenTrays, this.itemCount, this.lat, this.lng});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['key'],
      name: json['name'],
      postCode: json['postCode'],
      lng: json['long'],
      lat: json['lat'],
      address: json['addressLine1'],
      slot: json['deliverySlot'],
      ambientTrays: json['ambientTrays'],
      chilledTrays: json['chilledTrays'],
      frozenTrays: json['frozenTrays'],
      itemCount: json['itemCount'],
    );
  }
}

class OrdersListView extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<OrdersListView> {
  String _platformVersion = 'Unknown';
  MapboxNavigation _directions;
  bool _arrived = false;
  double _distanceRemaining, _durationRemaining;

  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapboxNavigation(onRouteProgress: (arrived) async {
      _distanceRemaining = await _directions.distanceRemaining;
      _durationRemaining = await _directions.durationRemaining;

      setState(() {
        _arrived = arrived;
      });
      if (arrived)
        {
          await Future.delayed(Duration(seconds: 3));
          await _directions.finishNavigation();
        }
    });

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
  

    setState(() {
      _platformVersion = platformVersion;
    });
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Order> data = snapshot.data;
          return _ordersListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Order>> _fetchJobs() async {

    final url= 'http://ads.morganchorlton.me/api/orders';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      //print(json.decode(response.body));
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((order) => new Order.fromJson(order)).toList();
    } else {
      throw Exception('Error Fetching Order');
    }
  }

  ListView _ordersListView(data) {
    print(data[1].lat);
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].name, data[index].address, data[index].lat, data[index].lng, Icons.directions);
        });
  }

  ListTile _tile(String title, String address, double lat, double lng, IconData icon) => ListTile(
    
    title: Text(title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
      )
    ),
    subtitle: Text(address),
    leading: Icon(
      icon,
      color: Colors.blue[500],
    ),
    onTap: () async {
      _getCurrentLocation();

      var latitude = _currentPosition.latitude;
      var longitude = _currentPosition.longitude;

      print(Location(name: "Name", latitude: lat, longitude: lng).toString());

      await _directions.startNavigation(
        origin: Location(name: "Current", latitude: latitude, longitude: longitude),
        destination: Location(name: "Name", latitude: lat, longitude: lng),
        mode: NavigationMode.drivingWithTraffic,
        simulateRoute: false, language: "English", units: VoiceUnits.metric);
      },
  );
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}