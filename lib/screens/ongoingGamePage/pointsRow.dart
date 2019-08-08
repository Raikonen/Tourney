import 'package:flutter/material.dart';

class PointsRow extends StatelessWidget {
  final int _firstTeamPoints;
  final int _secondTeamPoints;

  PointsRow(this._firstTeamPoints, this._secondTeamPoints);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                _firstTeamPoints.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DMSans',
                    fontSize: 100.0),
              ),
            ],
          )),
          SizedBox(width: 50.0),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                _secondTeamPoints.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DMSans',
                    fontSize: 100.0),
              ),
            ],
          )),
        ]);
  }
}
