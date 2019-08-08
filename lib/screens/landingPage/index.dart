import 'package:flutter/material.dart';

import 'package:tourney/screens/landingPage/landingForm.dart';

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
        ],
      ),
    );
  }
}
