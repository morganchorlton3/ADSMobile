import 'package:ads/models/order.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



List<Order> _data = generateItems(8);

class _MyHomePageState extends State<MyHomePage> {

  MapboxNavigation _directions;
  //bool _arrived = false;

  @override
  void initState() {
    super.initState();
  }


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

                    await _directions.startNavigation(
                      origin: Location(name: "Current", latitude: 53.49183, longitude: -2.09196),
                      destination: Location(name: "Name", latitude: order.lat, longitude: order.lng),
                      mode: NavigationMode.drivingWithTraffic,
                      simulateRoute: true, language: "English", units: VoiceUnits.metric);

                    },
                  ),
                  RaisedButton(
                    child: Text("I'm Here"),
                    onPressed: (){
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
