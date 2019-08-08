import 'package:flutter/material.dart';
import 'package:tourney/models/game.dart';
import 'package:tourney/resources/repository.dart';
import 'package:tourney/screens/ongoingGamePage/index.dart';

class TeamSelect extends StatefulWidget {
  final List<dynamic> _teamnames;
  final String _tourID;

  TeamSelect(this._tourID, this._teamnames);

  @override
  State<StatefulWidget> createState() {
    return _TeamSelectState();
  }
}

class _TeamSelectState extends State<TeamSelect> {
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
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0)),
                child: (_selectedIndex.length > 1)
                    ? Container(
                        height: 40.0,
                        child: FlatButton(
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
                                      widget._teamnames[_selectedIndex[0]],
                                      widget._teamnames[_selectedIndex[1]]);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => (OngoingGamePage(
                                            widget._tourID, newGame)),
                                      ));
                                },
                        ))
                    : null),
          )
        ],
      ),
    ));
  }

  Widget _createButtonChild() {
    return Text("GO",
        style: TextStyle(
          fontFamily: 'FjallaOne',
          fontSize: 20.0,
        ));
  }
}
