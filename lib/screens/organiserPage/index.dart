import 'package:flutter/material.dart';
import 'package:tourney/screens/organiserPage/gameManager/index.dart';
import 'package:tourney/screens/organiserPage/optionButton.dart';
import 'package:tourney/screens/organiserPage/gameCreate/index.dart';

class OrganiserPage extends StatelessWidget {
  final String _tourID;
  final List<dynamic> _teamNames;

  OrganiserPage(this._tourID, this._teamNames);

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
              'Organiser Options',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            automaticallyImplyLeading: false,
          )),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Add Game Option
          OptionButton(
              false,
              "Add Game",
              Icon(
                Icons.add,
                color: Colors.white,
              ), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GameCreate(this._tourID, this._teamNames)));
          }),
          SizedBox(
            height: 30.0,
          ),
          // Delete Game Option
          OptionButton(
              false,
              "Manage Games",
              Icon(
                Icons.remove,
                color: Colors.white,
              ), () {
                Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GameManager(this._tourID)));
          }),
          SizedBox(
            height: 30.0,
          ),
          // Home Option
          OptionButton(
              false,
              "Back to Tournament",
              Icon(
                Icons.home,
                color: Colors.white,
              ), () {
            Navigator.pop(context);
          }),
        ],
      )),
    ));
  }
}
