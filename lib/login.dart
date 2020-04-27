import 'package:ads/orders.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {


  bool _isLoading = false;


  TextEditingController employeeController = TextEditingController();

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(251, 202, 0, 1),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextField(
                              style: TextStyle(color: Color.fromRGBO(51, 102, 153, 1)),
                              controller: employeeController,
                              cursorColor: Color.fromRGBO(51, 102, 153, 1),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                ),
                                hintText: "Employee Number",
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(51, 102, 153, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FlatButton(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  child: Text(
                                    _isLoading? 'Loging...' : 'Login',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                color: Color.fromRGBO(51, 102, 153, 1),
                                disabledColor: Color.fromRGBO(251, 202, 0, 1),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                onPressed: _isLoading ? null : _login,
                               
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
void _login() async{
    
  setState(() {
     _isLoading = true;
  });
   Map<String, dynamic> body = {'id': employeeController.text};
      var url = 'https://ads.morganchorlton.me/api/orders';
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        var ordersJson = json.decode(response.body);
        if(ordersJson.toString().contains("No Trip")){
          print("No Trip Found");
           Alert(
            context: context,
            type: AlertType.error,
            title: "Trip Error",
            desc: "No Trip Found",
          ).show();
        }else{
          SharedPreferences localStorage = await SharedPreferences.getInstance();
          localStorage.setString('orders', json.encode(ordersJson));
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => OrdersPage()
            )
          );
        }
      }

    setState(() {
       _isLoading = false;
    });
}

}