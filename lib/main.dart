import 'package:ads/models/order.dart';
import 'package:ads/orderView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      home: Scaffold(
        appBar: AppBar(
          title: Text('ADS'),
        ),
        body: MyHomePage(),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<Order> _data = generateItems(8);

class _MyHomePageState extends State<MyHomePage> {


  MapboxNavigation _directions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

Widget _buildPanel() {
  return ExpansionPanelList(
    expansionCallback: (int index, bool isExpanded) {
      setState(() {
        _data[index].isExpanded = !isExpanded;
      });
    },
    children: _data.map<ExpansionPanel>((Order order) {
      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(order.name),
          );
        },
        body: Container(
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(order.addressLine1),
                    Text(order.addressLine2),
                    Text(order.postCode),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  
                  children: <Widget>[
                  RaisedButton(
                    child: Icon(Icons.directions),
                    onPressed: () async {

                    final cityhall = Location(name: "City Hall", latitude: 42.886448, longitude: -78.878372);
    final downtown = Location(name: "Downtown Buffalo", latitude: 42.8866177, longitude: -78.8814924);
            
    await _directions.startNavigation(
                                origin: cityhall, 
                                destination: downtown, 
                                mode: NavigationMode.drivingWithTraffic, 
                                simulateRoute: false,
                                language: "French");

                    },
                  ),
                  RaisedButton(
                    child: Text("I'm Here"),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderView()),
                      );
                  },
                )
                ],
                ),
              )
            ],
            )
          ),
        isExpanded: order.isExpanded,
      );
    }).toList(),
  );
}
}
