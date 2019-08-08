import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tourney/models/tournament.dart';
import 'package:tourney/models/inheritedWidget.dart';
import 'package:tourney/screens/homePage/organiserButton.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);

    return StreamBuilder(
        stream: state.currentTournamnent,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Tournament data = Tournament.fromSnapshot(snapshot.data);
            return Scaffold(
                body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    data.tourName,
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
                            text: '${data.teamNames.length}',
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
                            text: '${data.games['ongoing'].length}',
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
                            text: '${data.games['completed'].length}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  OrganiserButton(data),
                ],
              ),
            ));
          } else {
            return Container();
          }
        });
  }
}
