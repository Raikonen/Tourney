import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tourney/models/tournament.dart';
import 'package:tourney/models/inheritedWidget.dart';

import 'package:tourney/screens/homePage/pinInput.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);

    Future<bool> showPinInput(Tournament tourData, BuildContext context) async {
      return await showDialog<bool>(
          barrierDismissible: true,
          context: context,
          builder: (mycontext) => PinInput(tourData));
    }

    return StreamBuilder(
        stream: state.currentTournamnent,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Tournament tourData = Tournament.fromSnapshot(snapshot.data);
            return Scaffold(
                body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    tourData.tourName,
                    style: TextStyle(fontSize: 50.0, fontFamily: "FjallaOne"),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Raleway',
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Teams: '),
                        TextSpan(
                            text: '${tourData.teamNames.length}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Raleway',
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Games Ongoing: '),
                        TextSpan(
                            text: '${tourData.games['ongoing'].length}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Raleway',
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Games Completed: '),
                        TextSpan(
                            text: '${tourData.games['completed'].length}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FlatButton.icon(
                      icon: Icon(
                        FontAwesomeIcons.userCircle,
                        color: Colors.pink,
                      ),
                      shape: ContinuousRectangleBorder(
                          side: BorderSide(color: Colors.pink, width: 2.0)),
                      label: Text("For Organisers",
                          style: TextStyle(
                              color: Colors.pink,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0)),
                      onPressed: () async {
                        await showPinInput(tourData, context);
                      }),
                ],
              ),
            ));
          } else {
            return Container();
          }
        });
  }
}
