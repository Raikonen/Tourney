import 'package:flutter/material.dart';

class VersusComponent extends StatelessWidget {
  final int _timeStarted;

  VersusComponent(this._timeStarted);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 2.0)),
            child: Text(
              "VS",
              style: TextStyle(fontSize: 26.0, fontFamily: 'PermanentMarker'),
            )),
        SizedBox(
          height: 10.0,
        ),
        Text("Time Started"),
        Text(
            "${((DateTime.fromMillisecondsSinceEpoch(_timeStarted).hour) % 24).toString().padLeft(2, '0')}:${DateTime.fromMillisecondsSinceEpoch(_timeStarted).minute.toString().padLeft(2, '0')}"),
      ],
    ));
  }
}
