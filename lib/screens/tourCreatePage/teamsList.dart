import 'package:flutter/material.dart';
import 'package:tourney/screens/tourCreatePage/teamNameTile.dart';

class TeamsList extends StatelessWidget {
  final int _numOfPlayers;
  final List<String> _teamNames;
  final Function _updateTeamName;

  TeamsList(this._numOfPlayers, this._teamNames, this._updateTeamName);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: this._numOfPlayers,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: TeamNameTile(
                index, this._teamNames[index], this._updateTeamName),
          );
        });
  }
}
