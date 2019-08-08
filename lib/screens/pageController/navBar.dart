import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends StatelessWidget {
  final int _currentPage;
  final Function _onTapTappedCallback;

  NavBar(this._currentPage, this._onTapTappedCallback);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
        child: PhysicalModel(
            color: Colors.white,
            child: Container(
                height: 45.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(width: 2),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: BottomAppBar(
                        color: Colors.white, child: _bottomBarItems())))));
  }

  Widget _bottomBarItems() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: InkWell(
                  onTap: () {
                    _onTapTappedCallback(1);
                  },
                  child: (_currentPage == 1)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.trophy,
                              size: 20.0,
                              color: Colors.pink,
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 6.5),
                                child: Text(
                                  "Leaderboard",
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      color: Colors.pink),
                                )),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                              Icon(
                                FontAwesomeIcons.trophy,
                                size: 20.0,
                                color: Color(0xFFA8A8A8),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 6.5),
                                child: Text(
                                  "Leaderboard",
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFA8A8A8),
                                      fontSize: 12.0),
                                ),
                              )
                            ]),
                ))),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: InkWell(
                    onTap: () {
                      _onTapTappedCallback(2);
                    },
                    child: (_currentPage == 2)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.gamepad,
                                  size: 20.0, color: Colors.pink),
                              Padding(
                                  padding: EdgeInsets.only(left: 6.5),
                                  child: Text(
                                    "Games",
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                        color: Colors.pink),
                                  )),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.gamepad,
                                size: 20.0,
                                color: Color(0xFFA8A8A8),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 6.5),
                                  child: Text(
                                    "Games",
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                        color: Color(0xFFA8A8A8)),
                                  )),
                            ],
                          )))),
      ],
    );
  }
}

class HomeFAB extends StatelessWidget {
  final int _currentPage;
  final Function _onTapTappedCallback;

  HomeFAB(this._currentPage, this._onTapTappedCallback);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: (_currentPage == 0) ? Colors.pink : Color(0xFFA8A8A8),
      onPressed: () => _onTapTappedCallback(0),
      tooltip: 'Home',
      child: Padding(
          padding: EdgeInsets.only(right: 2.0),
          child: Icon(FontAwesomeIcons.home)),
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
    );
  }
}
