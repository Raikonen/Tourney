import 'package:flutter/material.dart';
import 'package:tourney/screens/gamesPage/leftBranch.dart';
import 'package:tourney/screens/gamesPage/rightBranch.dart';

class PointsTree extends StatelessWidget {
  final Map<String, dynamic> _team1PointsHistory;
  final Map<String, dynamic> _team2PointsHistory;
  final int _startTimeStamp;

  PointsTree(List<Map<String, dynamic>> pointsHistory, startTimeStamp)
      : this._team1PointsHistory = pointsHistory[0],
        this._team2PointsHistory = pointsHistory[1],
        this._startTimeStamp = startTimeStamp;

  @override
  Widget build(BuildContext context) {
    List<String> timeStamps =
        _team1PointsHistory.keys.followedBy(_team2PointsHistory.keys).toList();
    timeStamps.sort();

    return Container(
        child: Scrollbar(
            child: ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        int millisecondsDiff = int.parse(timeStamps[index]) - _startTimeStamp;
        return _team1PointsHistory[timeStamps[index]] != null
            ? LeftBranch(
                millisecondsDiff, _team1PointsHistory[timeStamps[index]])
            : RightBranch(
                millisecondsDiff, _team2PointsHistory[timeStamps[index]]);
      },
      itemCount: timeStamps.length,
    )));
  }
}
