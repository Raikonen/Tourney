import 'package:flutter/material.dart';
import 'package:tourney/screens/gamesPage/gameTile.dart';

class CompletedGamesList extends StatelessWidget {
  final Map _games;

  CompletedGamesList(this._games);

  @override
  Widget build(BuildContext context) {
    List _gameIDs = _games.keys.toList();

    return _games.isEmpty
        // Empty Games List
        ? Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(Icons.clear), Text("Currently Empty")],
          ))
        // Games List
        : Scrollbar(
            child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _games.length,
            itemBuilder: (BuildContext context, int index) {
              return GameTile(_games[_gameIDs[index]], index);
            }));
  }
}
