import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:tourney/models/game.dart';
import 'package:tourney/resources/repository.dart';
import 'package:tourney/assets/colors.dart';
import 'package:tourney/screens/ongoingGamePage/buttonsRow.dart';
import 'package:tourney/screens/ongoingGamePage/finishGameComponent.dart';
import 'package:tourney/screens/ongoingGamePage/pointsRow.dart';
import 'package:tourney/screens/ongoingGamePage/teamsRow.dart';
import 'package:tourney/screens/ongoingGamePage/versusComponent.dart';

class OnlyOnePointerRecognizer extends OneSequenceGestureRecognizer {
  int _p = 0;
  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);
    if (_p == 0) {
      resolve(GestureDisposition.rejected);
      _p = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  String get debugDescription => 'only one pointer recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if (!event.down && event.pointer == _p) {
      _p = 0;
    }
  }
}

class OnlyOnePointerRecognizerWidget extends StatelessWidget {
  final Widget child;
  OnlyOnePointerRecognizerWidget({this.child});
  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        OnlyOnePointerRecognizer: GestureRecognizerFactoryWithHandlers<OnlyOnePointerRecognizer>(
          () => OnlyOnePointerRecognizer(),
          (OnlyOnePointerRecognizer instance) {},
        ),
      },
      child: child,
    );
  }
}

class OngoingGamePage extends StatefulWidget {
  final String _tourID;
  final Game _game;

  OngoingGamePage(this._tourID, this._game);

  @override
  State<StatefulWidget> createState() {
    return _OngoingGamePageState();
  }
}

class _OngoingGamePageState extends State<OngoingGamePage> {
  final Repository _repository = Repository();
  bool _isLoading = false;
  int _firstTeamPoints = 0;
  int _secondTeamPoints = 0;

  void _toggleLoading() => this.setState(() {
        _isLoading = !_isLoading;
      });
  void _updatePoints(index, points) async {
    _toggleLoading();
    this.setState(() {
      index == 0 ? _firstTeamPoints += points : _secondTeamPoints += points;
    });
    await _repository.updatePoints(
        widget._tourID, widget._game.gameID, index, points);
    _toggleLoading();
  }

  void _finishGame() async {
    _toggleLoading();
    if (await _confirmFinish(context)) {
      await _repository.finishGame(widget._tourID, widget._game.gameID);
      Navigator.pop(context);
    } else {
      _toggleLoading();
    }
  }

  Future<bool> _confirmFinish(BuildContext context) {
    return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Ending game...'),
            content: Text(
              'There will be no way to rejoin this ongoing game. Are you sure you want to end the game?',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Raleway', color: Colors.red),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _backPop(BuildContext context) {
    return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Leaving Gamepage...'),
            content: Text(
              'Leaving the current page would cause you to lose all progress for this game!',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Raleway', color: Colors.red),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () { 
                  _repository.deleteOngoingGame(widget._tourID, widget._game.gameID);
                  Navigator.of(context).pop(true); },
                child: Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _backPop(context),
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(55.0),
              child: AppBar(
                elevation: 9.0,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  'Game Page',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              )),
          backgroundColor: tourneyMilkWhite,
          body: OnlyOnePointerRecognizerWidget(child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 40.0),
                      child: Stack(children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // Team Name and Avatar row
                              Expanded(
                                  child: TeamsRow(widget._game.teamsInvolved[0],
                                      widget._game.teamsInvolved[1])),
                              // Score Row
                              PointsRow(_firstTeamPoints, _secondTeamPoints),
                              // Buttons Rows
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ButtonsRow(_isLoading, _updatePoints, 1),
                                  ButtonsRow(_isLoading, _updatePoints, 2),
                                  ButtonsRow(_isLoading, _updatePoints, 3),
                                ],
                              ))
                            ]),
                        // Versus Component
                        VersusComponent(widget._game.timeStarted),
                      ]))),
              FinishGameComponent(_isLoading, _finishGame),
            ],
          ),
        ))));
  }
}
