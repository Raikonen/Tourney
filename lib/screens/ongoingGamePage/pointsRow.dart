import 'package:auto_size_text/auto_size_text.dart';
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
            child: AutoSizeText(
              _firstTeamPoints.toString(),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DMSans',
                  fontSize: 90.0),
            ),
          ),
          SizedBox(width: 80.0),
          Expanded(
            child: AutoSizeText(
              _secondTeamPoints.toString(),
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DMSans',
                  fontSize: 90.0),
            ),
          ),
        ]);
  }
}
