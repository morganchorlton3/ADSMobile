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
      // check if user is logged in
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var token = localStorage.getString('orders');
      print(token);
      if(token!= null){
         setState(() {
            _isLoggedIn = true;
         });
      }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(51, 102, 153, 1),
        body: _isLoggedIn ? OrdersPage() :  LogIn(),
      ),
      
    );
  }
}