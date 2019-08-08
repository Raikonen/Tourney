import 'package:flutter/material.dart';

class PointsButton extends StatelessWidget {
  final Color _color;
  final int _points;
  final int _index;
  final bool _enabled;
  final Function _updatePoints;

  PointsButton(this._color, this._enabled, this._index, this._points,
      this._updatePoints);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45.0,
        width: 65.0,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: OutlineButton(
            onPressed: _enabled
                ? null
                : () async {
                    await _updatePoints(_index, _points);
                  },
            highlightedBorderColor: Colors.pink,
            borderSide: BorderSide(
              color: _color,
              style: BorderStyle.solid,
              width: 1.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _points > 0
                    ? Text('+$_points',
                        style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 24.0,
                            color: !_enabled ? _color : Colors.grey))
                    : Text('$_points',
                        style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 24.0,
                            color: !_enabled ? _color : Colors.grey))
              ],
            )));
  }
}
