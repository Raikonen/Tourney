import 'package:flutter/material.dart';

import 'package:tourney/models/inheritedWidget.dart';

import 'package:tourney/screens/pageController/navBar.dart';
import 'package:tourney/screens/homePage/index.dart';
import 'package:tourney/screens/rankingPage/index.dart';
import 'package:tourney/screens/gamesPage/index.dart';

class MyPageController extends StatefulWidget {
  final String tourID;

  MyPageController(this.tourID);

  @override
  State<StatefulWidget> createState() {
    return _MyPageController(this.tourID);
  }
}

class _MyPageController extends State<MyPageController> {
  final String tourID;
  int _currentPage = 0;
  List<Widget> _children;

  _MyPageController(this.tourID);

  void _onTabTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    // Set Current Tournament
    MyInheritedWidget.of(context).currentTournament(tourID);
    // Set Children Pages
    _children = [
      Home(),
      Ranking(),
      Games(),
    ];

    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xFFFAFAFA),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton:
                showFab ? HomeFAB(_currentPage, _onTabTapped) : null,
            body: _children[_currentPage],
            bottomNavigationBar: NavBar(_currentPage, _onTabTapped)));
  }
}
