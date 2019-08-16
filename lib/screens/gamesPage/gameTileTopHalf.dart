import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:auto_size_text/auto_size_text.dart';

class GameTileTopHalf extends StatelessWidget {
  final dynamic _game;
  final int _index;
  final bool _isOngoing;
  final bool _isExpanded;

  GameTileTopHalf(this._game, this._index, this._isOngoing, this._isExpanded);

  @override
  Widget build(BuildContext context) {
    final String timeElapsed = timeago.format(
        (DateTime.fromMillisecondsSinceEpoch(_game['timestarted'])),
        locale: 'en_short');
    final Duration gameDuration = _game['timeended'] == null
        ? null
        : (DateTime.fromMillisecondsSinceEpoch(_game['timeended']).difference(
            DateTime.fromMillisecondsSinceEpoch(_game['timestarted'])));
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            height: _isOngoing ? 75.0 : 85.0,
            decoration: BoxDecoration(
                color: _isOngoing
                    ? _index % 2 == 0 ? Color(0xFFAFBAD7) : Color(0xFFD5DDF3)
                    : _index % 2 == 0 ? Color(0xFFDCD9CD) : Color(0xFFF1F0EA),
                borderRadius: BorderRadius.circular(10.0)),
            child: Stack(
              children: <Widget>[
                Padding(
                    padding: _isOngoing
                        ? EdgeInsets.all(0.0)
                        : EdgeInsets.only(bottom: 20.0),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: AutoSizeText(_game['teamsinvolved'][0],
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              minFontSize: 16.0,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.body2)),
                      // Center Details
                      Container(
                          width: 150.0,
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                "Score",
                                style: Theme.of(context).textTheme.body2,
                              )),
                              Expanded(
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(_game['points'][0].toString(),
                                      style: Theme.of(context).textTheme.body2),
                                  Icon(Icons.graphic_eq),
                                  Text(_game['points'][1].toString(),
                                      style: Theme.of(context).textTheme.body2),
                                ],
                              )),
                              Expanded(
                                  child: (_game['timeended'] == null)
                                      ? AutoSizeText(
                                          "Time Elapsed: $timeElapsed",
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .body2
                                              .copyWith(fontSize: 14.0))
                                      : AutoSizeText(
                                          "Game Duration: ${gameDuration.inMinutes == 0 ? gameDuration.inSeconds : gameDuration.inMinutes} ${gameDuration.inMinutes == 0 ? 'sec' : 'min'}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .body2
                                              .copyWith(fontSize: 14.0))),
                            ],
                          ))),
                      Expanded(
                          child: AutoSizeText(_game['teamsinvolved'][1],
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              minFontSize: 16.0,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.body2)),
                    ])),
                _isExpanded == null
                    ? Container()
                    : Container(
                        alignment: Alignment.bottomCenter,
                        child: Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 30.0,
                        ),
                      )
              ],
            )));
  }
}
