import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FAQPage extends StatelessWidget {
  final Map<String, String> _faqs = {
    "How are teams' winrate calculated?":
        "Winrate is calculated by diving the number of games a team has won by the number of games played. A draw counts as a ​1⁄2 win. For example, if a team's record is 3 wins and 2 losses, the winning rate would be .600.",
  };
  @override
  Widget build(BuildContext context) {
    final List<String> _questions = _faqs.keys.toList();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55.0),
          child: AppBar(
            elevation: 9.0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              'FAQs',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            automaticallyImplyLeading: false,
          )),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => ExpansionTile(
            title: Text(_questions[index],
                style: TextStyle(fontFamily: 'Raleway', fontSize: 20.0)),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top:10.0, bottom: 20.0, left: 20.0, right: 20.0),
                child: AutoSizeText(
                  _faqs[_questions[index]],
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 16.0),
                ),
              )
            ]),
        itemCount: _faqs.length,
      ),
    );
  }
}
