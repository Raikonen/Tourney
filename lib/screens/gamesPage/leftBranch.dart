import 'package:flutter/material.dart';

class LeftBranch extends StatelessWidget {
  final int _seconds;
  final int _minutes;
  final String _points;

  LeftBranch(int milliseconds, String points)
      : this._minutes = (milliseconds / 60000).floor(),
        this._seconds = (milliseconds / 1000).floor(),
        this._points = points;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Padding(
            padding: EdgeInsets.only(right: 100.0,bottom: 5.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              width: 100.0,
              height: 25.0,
              decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$_minutes\m $_seconds\s',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(_points, style: TextStyle(color: Colors.white))
                ],
              ),
            )));
  }
}
