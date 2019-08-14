import 'package:flutter/material.dart';

import 'package:tourney/screens/gamesPage/gameTileBottomHalf.dart';
import 'package:tourney/screens/gamesPage/gameTileTopHalf.dart';

class GameTile extends StatefulWidget {
  final dynamic _game;
  final int _index;

  GameTile(this._game, this._index);

  @override
  _GameTileState createState() => _GameTileState();
}

class _GameTileState extends State<GameTile> {
  bool _isExpanded = false;

  void _handleTap() async {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isExpanded
        ? Column(
            children: <Widget>[
              InkWell(
                  onTap: _handleTap,
                  child: GameTileTopHalf(
                      widget._game, widget._index, false, true)),
              GameTileBottomHalf(widget._game),
            ],
          )
        : InkWell(
            onTap: _handleTap,
            child: GameTileTopHalf(widget._game, widget._index, false, false));
  }
}
