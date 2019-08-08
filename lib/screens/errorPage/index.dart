import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ErrorPage extends StatelessWidget {
  final String _customMessage;

  ErrorPage([this._customMessage]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Center(child: Icon(FontAwesomeIcons.dizzy, size: 40.0,)),
            Container(
                child: Column(
              children: <Widget>[
                Expanded(child: Container()),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    color: Colors.redAccent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.error),
                        Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: _customMessage != null ? Text(_customMessage) : Text('Failed To Connect With Server'))
                      ],
                    )),
              ],
            ))
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
