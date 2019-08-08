import 'package:flutter/material.dart';
import 'package:tourney/screens/ongoingGamePage/pointsButton.dart';

class ButtonsRow extends StatelessWidget {
  final bool _isLoading;
  final Function _updatePoints;
  final int _points;

  ButtonsRow(this._isLoading, this._updatePoints, this._points);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          // Left Team Buttons
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                PointsButton(
                    Colors.pink, _isLoading, 0, _points, _updatePoints),
                PointsButton(
                    Colors.pink, _isLoading, 0, -1 * _points, _updatePoints)
              ])),
          // Right Team Buttons
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                PointsButton(
                    Colors.blue, _isLoading, 1, _points, _updatePoints),
                PointsButton(
                    Colors.blue, _isLoading, 1, -1 * _points, _updatePoints)
              ])),
        ]),
      ],
    );
  }
}
