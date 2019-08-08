class Game {
  String _gameID;
  Map<String, dynamic> _team1PointsHistory;
  Map<String, dynamic> _team2PointsHistory;
  List<int> _points;
  int _timeStarted;
  int _timeEnded;
  List<String> _teamsInvolved;
  String _winningTeam;
  String _losingTeam;

  Game(String team1, String team2) {
    // Instantiate properties
    _gameID = team1.compareTo(team2) <= 0 ? (team1 + "_" + team2) : (team2 + "_" + team1);
    _team1PointsHistory = {};
    _team2PointsHistory = {};
    _points = [0,0];
    _timeStarted = DateTime.now().millisecondsSinceEpoch;
    _timeEnded = null;
    _teamsInvolved = team1.compareTo(team2) <= 0 ? [team1, team2] : [team2, team1];
    _winningTeam = null;
    _losingTeam = null;    
  }

  // Getters
  String get gameID => _gameID;
  List<int> get points => _points;
  Map<String, dynamic> get team1PointsHistory => _team1PointsHistory;
  Map<String, dynamic> get team2PointsHistory => _team2PointsHistory;
  int get timeStarted =>_timeStarted;
  int get timeEnded =>_timeEnded;
  List<String> get teamsInvolved => _teamsInvolved;
  String get winningTeam => _winningTeam;
  String get losingTeam => _losingTeam;

  // Setters
  set setEndTime(int endtime) => _timeEnded = endtime;
  set setWin(String winteam) => _winningTeam = winteam;
  set setLose(String loseteam) => _losingTeam = loseteam;

  //toJSON for firestore
  Map<String, dynamic> toJSON() => {
    'gameid': _gameID,
    'points' : _points,
    'team1pointshistory': _team1PointsHistory,
    'team2pointshistory': _team2PointsHistory,
    'timestarted': _timeStarted,
    'timeended': _timeEnded,
    'teamsinvolved': _teamsInvolved,
    'winningteam' : _winningTeam,
    'losingteam' : _losingTeam,
  };

  //fromJSON from firestore
  Game.fromJSON(Map<dynamic, dynamic> data)
       : _gameID = data['gameid'],
        _points = data['points'],
        _team1PointsHistory = data['team1pointshistory'],
        _team2PointsHistory = data['team2pointshistory'],
        _timeStarted = data['timestarted'],
        _timeEnded = data['timeended'],
        _teamsInvolved = data['teamsinvolved'],
        _winningTeam = data['winningteam'],
        _losingTeam = data['losingteam'];
}
