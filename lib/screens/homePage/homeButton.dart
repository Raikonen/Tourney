import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String _desc;
  final Function _callback;

  HomeButton(this._desc, this._callback);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text(this._desc),
        textColor: Colors.white,
        color: Colors.pink,
        onPressed: this._callback);
  }
  
}