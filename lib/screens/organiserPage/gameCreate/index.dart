import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

import 'package:tourney/models/game.dart';
import 'package:tourney/resources/repository.dart';
import 'package:tourney/screens/ongoingGamePage/index.dart';

class GameCreate extends StatefulWidget {
  final List<dynamic> _teamnames;
  final String _tourID;

  GameCreate(this._tourID, this._teamnames);

  @override
  State<StatefulWidget> createState() {
    return _GameCreateState();
  }
}

class _GameCreateState extends State<GameCreate> {
  final Repository _repository = Repository();
  List<int> _selectedIndex = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55.0),
          child: AppBar(
            elevation: 9.0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              'Team Selection',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            automaticallyImplyLeading: false,
          )),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
            itemCount: widget._teamnames.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                this.setState(() {
                  _selectedIndex.contains(index)
                      ? _selectedIndex.remove(index)
                      : _selectedIndex.length > 1
                          ? null
                          : _selectedIndex.add(index);
                });
              },
              title: Text(widget._teamnames[index]),
              trailing: _selectedIndex.contains(index)
                  ? Icon(Icons.check, color: Colors.green)
                  : null,
            ),
          )),
          Text('${_selectedIndex.length} of 2 teams selected',
              style: TextStyle(fontFamily: 'DMSans', fontSize: 20.0)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
                decoration: BoxDecoration(
                    color: (_selectedIndex.length > 1)
                        ? Colors.green
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                    height: 40.0,
                    child: Builder(
                        builder: (myContext) => FlatButton(
                              child: _createButtonChild(),
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      this.setState(() {
                                        _isLoading = true;
                                      });
                                      Game newGame =
                                          await _repository.createGame(
                                              widget._tourID,
                                              widget._teamnames[
                                                  _selectedIndex[0]],
                                              widget._teamnames[
                                                  _selectedIndex[1]]);
                                      if (newGame == null) {
                                        Flushbar(
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 28.0,
                                            color: Colors.red[300],
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor:
                                              Colors.red[300],
                                          messageText: Text(
                                            "Selected teams are currently ingame!",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        )..show(context);
                                        this.setState(() {
                                          _isLoading = false;
                                        });
                                      } else {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  (OngoingGamePage(
                                                      widget._tourID, newGame)),
                                            ));
                                      }
                                    },
                            )))),
          )
        ],
      ),
    ));
  }

  Widget _createButtonChild() {
    return _isLoading
        ? SizedBox(
            height: 20.0,
            width: 20.0,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ))
        : Text("GO",
            style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 16.0,
                fontWeight: FontWeight.bold));
  }
}
