import 'package:flutter/material.dart';

class GameTileBottomPlaceholder extends StatelessWidget {
  final int _index;
  GameTileBottomPlaceholder(this._index);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
      color: _index % 2 == 0 ? Color(0xFFDCD9CD) : Color(0xFFF1F0EA),
      width: 250.0,
      height: 20.0,
      child: Center(
        child: Icon(Icons.arrow_downward),
      ),
    ));
  }
}
