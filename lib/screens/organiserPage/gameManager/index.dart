import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tourney/resources/repository.dart';
import 'package:tourney/screens/organiserPage/gameManager/sortVars.dart';
import 'package:tourney/models/game.dart';
import 'package:timeago/timeago.dart' as timeago;

class GameManager extends StatefulWidget {
  final String _tourID;

  GameManager(this._tourID);

  @override
  State<StatefulWidget> createState() {
    return _GameManagerState();
  }
}

class _GameManagerState extends State<GameManager> {
  final Repository _repository = Repository();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  SortVars _currentSort = SortVars.recent;

  Future<List<Game>> _getCompletedGames() async {
    Map<String, dynamic> completedGames =
        await _repository.getCompletedGames(widget._tourID);
    return completedGames.values.map((game) => Game.fromJSON(game)).toList();
  }

  Future<void> _handleRefresh() async {
    this.setState(() {});
  }

  void _showGameOptions(title, currentGame) => showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (context) => Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Container(
            color: Colors.white,
            height: 110.0,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: (TextStyle(fontFamily: 'DMSans', fontSize: 20.0)),
                    )),
                Divider(
                  color: Colors.grey,
                  indent: 10.0,
                  endIndent: 10.0,
                ),
                Material(
                    color: Colors.white,
                    child: InkWell(
                        onTap: () async {
                          await _repository.deleteCompletedGame(
                              widget._tourID, currentGame.gameID);
                          Navigator.pop(context);
                          _handleRefresh();
                        },
                        child: Container(
                            padding: EdgeInsets.only(
                                left: 20.0, top: 10.0, bottom: 20.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey[600],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 15.0),
                                    child: Text("Delete",
                                        style: TextStyle(
                                            fontFamily: 'DMSans',
                                            fontSize: 16.0))),
                              ],
                            )))),
              ],
            ),
          )));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getCompletedGames(),
        builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
          if (snapshot.hasData) {
            List<Game> sortedList = snapshot.data;
            sortedList.sort((Game a, Game b) {
              return _currentSort == SortVars.recent
                  ? b.timeEnded.compareTo(a.timeEnded)
                  : a.gameID.compareTo(b.gameID);
            });
            return SafeArea(
                child: Scaffold(
                    appBar: PreferredSize(
                        preferredSize: Size.fromHeight(55.0),
                        child: AppBar(
                          elevation: 9.0,
                          backgroundColor: Colors.white,
                          centerTitle: true,
                          title: Text(
                            'Manage Games',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          leading: BackButton(color: Colors.black,),
                        )),
                    body: RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: _handleRefresh,
                        child: ListView.builder(
                            itemCount:
                                sortedList == null ? 1 : sortedList.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return Container(
                                    color: Colors.blue,
                                    child: ListTile(
                                      title: _currentSort == SortVars.recent
                                          ? Text("Most Recent")
                                          : Text("Alphabetical"),
                                      trailing: IconButton(
                                        icon: Icon(Icons.sort),
                                        onPressed: () {
                                          this.setState(() {
                                            _currentSort = (_currentSort ==
                                                    SortVars.recent)
                                                ? SortVars.alphabetical
                                                : SortVars.recent;
                                          });
                                        },
                                      ),
                                    ));
                              }
                              index -= 1;
                              String title =
                                  '${sortedList[index].teamsInvolved[0].toString()} VS ${sortedList[index].teamsInvolved[1].toString()}';
                              Game currentGame = sortedList[index];
                              return ListTile(
                                title: Text(title),
                                subtitle: Text(timeago.format(
                                    (DateTime.fromMillisecondsSinceEpoch(
                                        currentGame.timeEnded)))),
                                trailing: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.ellipsisH,
                                    size: 18.0,
                                  ),
                                  onPressed: () =>
                                      _showGameOptions(title, currentGame),
                                ),
                              );
                            }))));
          } else
            return Container();
        });
  }
}
