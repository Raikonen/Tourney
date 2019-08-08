import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TeamsRow extends StatelessWidget {
  final String _firstTeam;
  final String _secondTeam;

  TeamsRow(this._firstTeam, this._secondTeam);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: Column(
        children: <Widget>[
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFFFDB7AA), const Color(0xFF7F1019)],
                  tileMode: TileMode.repeated,
                ),
                shape: BoxShape.circle),
          ),
          AutoSizeText(
            _firstTeam,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 35.0,
            ),
          ),
        ],
      )),
      Expanded(
          child: Column(
        children: <Widget>[
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFFAFDBDE), const Color(0xFF083663)],
                  tileMode: TileMode.repeated,
                ),
                shape: BoxShape.circle),
          ),
          AutoSizeText(
            _secondTeam,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Ubuntu', fontSize: 35.0),
          ),
        ],
      )),
    ]);
  }
}
