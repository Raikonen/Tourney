import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';

import 'package:tourney/screens/errorPage/index.dart';
import 'package:tourney/screens/landingPage/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapShot) {
          var result = snapShot.data;
          switch (result) {
            case ConnectivityResult.none:
              return ErrorPage();
              break;
            case ConnectivityResult.mobile:
            case ConnectivityResult.wifi:
            default:
              return MaterialApp(
                title: 'Tourney',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: TextTheme(
                    title: TextStyle(color: Colors.black),
                    body2: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "DMSans",
                        color: Colors.black),
                  ),
                ),
                home: Scaffold(
                  body: LandingPage(),
                ),
                debugShowCheckedModeBanner: false,
              );
          }
        });
  }
}
