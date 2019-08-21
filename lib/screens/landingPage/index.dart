import 'package:flutter/material.dart';
import 'package:tourney/screens/faqPage/index.dart';

import 'package:tourney/screens/landingPage/landingForm.dart';
import 'package:tourney/screens/tourCreatePage/index.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              child: Center(
                  child: Text(
            "TOURNEY",
            style: TextStyle(fontFamily: 'PermanentMarker', fontSize: 60.0),
          ))),
          LandingForm(),
          // New Tournament Button
            SizedBox(
                width: 250.0,
                child: OutlineButton(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    borderSide: BorderSide(width: 2.0, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TourCreate(),
                          ));
                    },
                    child: Text(
                      "New Tournament",
                      style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ))),
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                width: 250.0,
                child: OutlineButton(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    borderSide: BorderSide(width: 2.0, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FAQPage(),
                          ));
                    },
                    child: Text(
                      "FAQ",
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    )))
        ],
      ),
    );
  }
}
