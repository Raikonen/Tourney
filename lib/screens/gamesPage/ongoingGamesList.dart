import 'package:flutter/material.dart';

import 'package:tourney/screens/gamesPage/gameTileTopHalf.dart';

class OngoingGamesList extends StatelessWidget {
  final Map _games;

  OngoingGamesList(this._games);

  @override
  Widget build(BuildContext context) {
    List _gameIDs = _games.keys.toList();

    return _games.isEmpty
        ? Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(Icons.clear), Text("Currently Empty")],
          ))
        : Scrollbar(
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _gameIDs.length,
                itemBuilder: (BuildContext context, int index) {
                  return GameTileTopHalf(
                      _games[_gameIDs[index]], index, true, null);
                }));
  }
}
