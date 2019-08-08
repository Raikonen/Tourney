import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:tourney/models/tournament.dart';
import 'package:tourney/models/inheritedWidget.dart';
import 'package:tourney/screens/rankingPage/rankingList.dart';

class Ranking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(55.0),
            child: AppBar(
              elevation: 9.0,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Standings',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              automaticallyImplyLeading: false,
            )),
        body: StreamBuilder(
            stream: state.currentTournamnent,
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                Tournament data = Tournament.fromSnapshot(snapshot.data);
                return RankingList(data.teams.values.toList());
              } else
                return Container();
            }));
  }
}
