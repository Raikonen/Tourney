import 'package:flutter/material.dart';

class PastGamesIndicator extends StatelessWidget {
  final String _winsLoss;
  final bool _isInverted;

  PastGamesIndicator([this._winsLoss = "", this._isInverted]);

  List<Widget> _buildCircles() {
    List<int> charCodes = _winsLoss.runes.toList().reversed.toList();
    while (charCodes.length < 5) {
      // Add E for Empty Games
      charCodes.add(69);
    }
    return charCodes.sublist(0, 5).map((charCode) {
      return (String.fromCharCode(charCode) == "W" && !_isInverted) ||
              (String.fromCharCode(charCode) == "L" && _isInverted)
          ? Container(
              width: 14.0,
              height: 14.0,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                  color: Colors.green,
                  shape: BoxShape.circle),
            )
          : (String.fromCharCode(charCode) == "L" && !_isInverted) ||
                  (String.fromCharCode(charCode) == "W" && _isInverted)
              ? Container(
                  width: 14.0,
                  height: 14.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      color: Colors.red,
                      shape: BoxShape.circle),
                )
              : (String.fromCharCode(charCode) == "D")
                  ? Container(
                      width: 14.0,
                      height: 14.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2.0),
                          color: Colors.black,
                          shape: BoxShape.circle),
                    )
                  : Container(
                      width: 14.0,
                      height: 14.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2.0),
                          color: Colors.transparent,
                          shape: BoxShape.circle),
                    );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildCircles(),
    );
  }
}
