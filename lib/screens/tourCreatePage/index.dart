import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';

import 'package:tourney/resources/repository.dart';
import 'package:tourney/screens/tourCreatePage/teamsList.dart';

import 'package:tourney/models/inheritedWidget.dart';

import 'package:tourney/screens/pageController/index.dart';
import 'package:tourney/assets/colors.dart';
import 'package:tourney/screens/tourCreatePage/pickerOption.dart';

class TourCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TourCreateState();
  }
}

class _TourCreateState extends State<TourCreate> {
  int _numOfPlayers = 5;
  final _formKey = GlobalKey<FormState>();
  final Repository _repository = Repository();
  final _myController = TextEditingController();

  // Default values
  List<String> _teamNames = ["Team 1", "Team 2", "Team 3", "Team 4", "Team 5"];

  void _updateTeamName(int index, String newName) => this.setState(() {
        _teamNames[index] = newName;
      });

  Future<void> _createTournament(myContext) async {
    // Error if team name is empty string
    if (this._teamNames.sublist(0, _numOfPlayers).contains("")) {
      Scaffold.of(myContext).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.red,
          content: Row(
            children: <Widget>[
              Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              SizedBox(width: 10.0),
              Text('Please Enter Valid Teamnames')
            ],
          )));
      return;
    }

    // Else Proceed
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FutureBuilder(
              future: _repository.createTournament(_myController.text,
                  this._teamNames.sublist(0, _numOfPlayers)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return SimpleDialog(
                      title: Text(
                        'My Codes',
                        textAlign: TextAlign.center,
                      ),
                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Tournament Code: ',
                                      style: TextStyle(
                                          fontFamily: 'DMSans',
                                          fontSize: 20.0)),
                                  TextSpan(
                                      text: '${snapshot.data.tourID}',
                                      style: TextStyle(
                                          fontFamily: 'DMSans',
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            )),
                        Align(
                            alignment: Alignment.center,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Organiser Code: ',
                                      style: TextStyle(
                                          fontFamily: 'DMSans',
                                          fontSize: 20.0)),
                                  TextSpan(
                                      text: '${snapshot.data.orgCode}',
                                      style: TextStyle(
                                          fontFamily: 'DMSans',
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            )),
                        SizedBox(height: 20.0),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                                color: Color(0xFF33B17C),
                                padding: EdgeInsets.all(10.0),
                                child: InkWell(
                                    child: Text('I have noted the codes down',
                                        style: TextStyle(
                                            fontFamily: 'Ubuntu',
                                            fontSize: 15.0,
                                            color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  MyInheritedWidget(
                                                      child: MyPageController(
                                                          snapshot
                                                              .data.tourID))),
                                          ModalRoute.withName('/'));
                                    })))
                      ]);
                } else {
                  return SizedBox(
                      width: 300.0,
                      height: 300.0,
                      child: Center(child: CircularProgressIndicator()));
                }
              });
        });
  }

  showPicker(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(pickerOptions),
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [this._numOfPlayers - 2],
        title: Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          this.setState(() {
            _numOfPlayers = value[0] + 2;
            // Add till reach number
            for (int i = _teamNames.length + 1; i < _numOfPlayers + 1; i++)
              _teamNames.add("Team $i");
          });
        }).showDialog(context);
  }

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
                    'Tournament Creation',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                )),
            backgroundColor: tourneyMilkWhite,
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                // Tournment Name Input
                Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty)
                        return "Please enter a Tournament Name";
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                    decoration: InputDecoration(
                        errorStyle:
                            TextStyle(fontSize: 14.0, fontFamily: 'Ubuntu'),
                        hintStyle:
                            TextStyle(fontSize: 18.0, fontFamily: 'Ubuntu'),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(),
                        ),
                        hintText: 'Tournament Name'),
                    controller: _myController,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Number of Team Picker
                Row(
                  children: <Widget>[
                    Text(
                      "Number of Teams:",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    RaisedButton(
                      color: Colors.white,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.pink)),
                      onPressed: () {
                        showPicker(context);
                      },
                      child: Text(_numOfPlayers.toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DMSans')),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Team Names List
                Expanded(
                    child:
                        TeamsList(_numOfPlayers, _teamNames, _updateTeamName)),
                SizedBox(
                  height: 15.0,
                ),
                // Create Tournament Button
                (MediaQuery.of(context).viewInsets.bottom > 200)
                    ? Container()
                    : Builder(
                        builder: (context) => SizedBox(
                            width: 110.0,
                            height: 40.0,
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState.validate())
                                  // Create tournament
                                  await _createTournament(context);
                              },
                              child: Center(
                                  child: Text("Confirm",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green))),
                            )),
                      )
              ]),
            )));
  }
}
