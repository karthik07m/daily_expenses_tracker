import 'dart:async';

import 'package:coinsaver/screens/main_screen.dart';
import 'package:coinsaver/utilities/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 2);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacementNamed(context, MainScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: kPrimaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
                child: Image.asset(
              "assets/icon/icon.png",
              fit: BoxFit.fill,
              width: 150,
              height: 150,
            )),
            SizedBox(
              height: 15,
            ),
            Text(
              appName,
              style: TextStyle(fontSize: 26, color: kBackgroundColor),
            )
          ],
        ),
      ),
    );
  }
}
