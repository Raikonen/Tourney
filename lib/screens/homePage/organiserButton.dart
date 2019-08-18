import 'package:flutter/material.dart';
import 'package:tourney/models/tournament.dart';

import 'package:tourney/screens/homePage/pinInput.dart';

class OrganiserButton extends StatelessWidget {
  final Tournament _data;

  OrganiserButton(this._data);

  @override
  Widget build(BuildContext context) {
    void _errorCallback() => Scaffold.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        content: Row(
          children: <Widget>[
            Icon(Icons.error),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text('Invalid Organiser Code'))
          ],
        )));
    return RaisedButton(
        child: Text("I am an Organiser"),
        textColor: Colors.white,
        color: Colors.pink,
        onPressed: () async {
          Scaffold.of(context).removeCurrentSnackBar();
          await showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (context) => PinInput(_data, _errorCallback));
        });
  }
}
