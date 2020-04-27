import 'package:ads/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }
  void _checkIfLoggedIn() async{
      // check if token is there
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var token = localStorage.getString('token');
      if(token!= null){
         setState(() {
            _isLoggedIn = true;
         });
      }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(51, 102, 153, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(251, 202, 0, 1),
          title: Center(
            child: Text('ADS', style: TextStyle(color: Color.fromRGBO(51, 102, 153, 1),),),
          ),
        ),
        body: _isLoggedIn ? OrdersPage() :  LogIn(),
      ),
      
    );
  }
}