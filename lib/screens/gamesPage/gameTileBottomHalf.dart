import 'package:flutter/material.dart';
import 'package:tourney/models/inheritedWidget.dart';

import 'package:tourney/screens/gamesPage/pastGamesIndicator.dart';
import 'package:tourney/resources/repository.dart';
import 'package:tourney/screens/gamesPage/pointsTree.dart';

class Merged {
  final String _winloss;
  final List<Map<String, dynamic>> _pointsHistory;

  Merged([this._winloss, this._pointsHistory]);
}

class GameTileBottomHalf extends StatelessWidget {
  final dynamic _game;
  final Repository _repository = Repository();

  GameTileBottomHalf(this._game);

  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);

    return FutureBuilder(
        future: Future.wait([
          _repository.getWinLoss(state.getCurrentTournament(),
              _game['teamsinvolved'][0], _game['teamsinvolved'][1]),
          _repository.getPointsHistory(
              state.getCurrentTournament(), _game['gameid'])
        ]).then(
          (response) {
            return Merged(response[0], response[1]);
          },
        ),
        builder: (BuildContext context, AsyncSnapshot<Merged> snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 5.0,
                  ),
                  // Score Tree
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 25.0,
                          child: Text("Score Tree",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Raleway', fontSize: 18.0)),
                        ),
                        Expanded(
                            child: Stack(children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              child: VerticalDivider(
                                endIndent: 0.0,
                                indent: 0.0,
                                color: Colors.black,
                              )),
                          PointsTree(snapshot.data._pointsHistory,
                              _game['timestarted'])
                        ]))
                      ],
                    ),
                  ),

                  // Past Games
                  Divider(
                    color: Colors.black,
                    indent: 0.0,
                    endIndent: 0.0,
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                      height: 30.0,
                      child: Row(
                        children: <Widget>[
                          PastGamesIndicator(snapshot.data._winloss, false),
                          Expanded(
                            child: Text("Past Games",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Raleway', fontSize: 18.0)),
                          ),
                          PastGamesIndicator(snapshot.data._winloss, true),
                        ],
                      )),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xFFE0E0E0),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 200.0,
            );
          } else {
            return Container();
          }
        });
  }
}
