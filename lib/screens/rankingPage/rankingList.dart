import 'package:flutter/material.dart';

import 'package:tourney/models/team.dart';

class RankingList extends StatelessWidget {
  final List<dynamic> _teams;

  RankingList(this._teams);

  @override
  Widget build(BuildContext context) {
    List<Team> _teamsList = _teams.map((team) => Team.fromJSON(team)).toList();
    _teamsList.sort((a, b) {
      return (b.winrate.compareTo(a.winrate) == 0)
          ? (a.gamesPlayed.compareTo(b.gamesPlayed) == 0)
              ? a.teamName.compareTo(b.teamName)
              : b.gamesPlayed.compareTo(a.gamesPlayed)
          : b.winrate.compareTo(a.winrate);
    });

    return Container(
        child: DataTable(
            columnSpacing: 10.0,
            columns: <DataColumn>[
              DataColumn(
                label: Text("TEAM"),
              ),
              DataColumn(label: Text("W"), numeric: true),
              DataColumn(label: Text("D"), numeric: true),
              DataColumn(label: Text("L"), numeric: true),
              DataColumn(label: Text("WIN%"), numeric: true),
            ],
            rows: _teamsList
                .map((team) => DataRow(cells: <DataCell>[
                      DataCell(Text(team.teamName)),
                      DataCell(Text(team.wins.length.toString())),
                      DataCell(Text(team.draws.length.toString())),
                      DataCell(Text(team.losses.length.toString())),
                      DataCell(Text((team.winrate).toStringAsFixed(2))),
                    ]))
                .toList()));
  }
}
