import 'dart:async';
import 'package:flutter/material.dart';
import './login_page.dart';
import 'package:provider/provider.dart';
import './guest_home_screen.dart';
import './farmer_home_screen.dart';

import '../providers/auth.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
 /*  @override
  void initState() {

 /*    final dynamic authData = Provider.of<Auth>(context, listen: false);
    Timer(
        Duration(seconds: 1),
        () => Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => 
           
            
            GuestHomeScreen())));  */
    super.initState();
 
  }  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[500],
      body: Center(
          child: Container(
            //color: Colors.greenAccent,
              child: Image.asset(
                  'assets/img/SmartFarms.png',
                  height: MediaQuery.of(context).size.width / 1.5,
                  width: MediaQuery.of(context).size.width / 1.5,
              )
          ))
     );
  }
}