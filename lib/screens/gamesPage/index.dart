import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:tourney/models/tournament.dart';
import 'package:tourney/models/inheritedWidget.dart';
import 'package:tourney/screens/gamesPage/completedGamesList.dart';
import 'package:tourney/screens/gamesPage/ongoingGamesList.dart';

class Games extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(85.0),
                child: AppBar(
                  elevation: 9.0,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: Text(
                    'Games',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0),
                  ),
                  bottom: TabBar(
                    indicatorColor: Colors.red,
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.black38,
                    tabs: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Ongoing",
                              style: TextStyle(fontSize: 14.0))),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Completed",
                              style: TextStyle(fontSize: 14.0)))
                    ],
                  ),
                  automaticallyImplyLeading: false,
                )),
            body: StreamBuilder(
              stream: state.currentTournamnent,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  Tournament data = Tournament.fromSnapshot(snapshot.data);
                  Map<String, dynamic> games = data.games;
                  return Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, bottom: 15.0, top: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: Color(0xFF8AA29E),
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: TabBarView(
                            children: <Widget>[
                              OngoingGamesList(games['ongoing']),
                              CompletedGamesList(games['completed'])
                            ],
                          )),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Icon(Icons.error));
                }
                return Container();
              },
            )));
  }
}
