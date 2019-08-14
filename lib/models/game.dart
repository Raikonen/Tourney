class Game {
  String _gameID;
  Map<String, String> _team1PointsHistory;
  Map<String, String> _team2PointsHistory;
  List<int> _points;
  int _timeStarted;
  int _timeEnded;
  List<String> _teamsInvolved;
  String _winningTeam;
  String _losingTeam;

  Game(String team1, String team2) {
    // Instantiate properties
    _gameID = team1.compareTo(team2) <= 0
        ? (team1 +
            "_" +
            team2 +
            "_" +
            DateTime.now().millisecondsSinceEpoch.toString())
        : (team2 +
            "_" +
            team1 +
            "_" +
            DateTime.now().millisecondsSinceEpoch.toString());
    _team1PointsHistory = {};
    _team2PointsHistory = {};
    _points = [0, 0];
    _timeStarted = DateTime.now().millisecondsSinceEpoch;
    _timeEnded = null;
    _teamsInvolved =
        team1.compareTo(team2) <= 0 ? [team1, team2] : [team2, team1];
    _winningTeam = null;
    _losingTeam = null;
  }

  // Getters
  String get gameID => _gameID;
  List<int> get points => _points;
  Map<String, String> get team1PointsHistory => _team1PointsHistory;
  Map<String, String> get team2PointsHistory => _team2PointsHistory;
  int get timeStarted => _timeStarted;
  int get timeEnded => _timeEnded;
  List<String> get teamsInvolved => _teamsInvolved;
  String get winningTeam => _winningTeam;
  String get losingTeam => _losingTeam;

  // Setter
  set timeEnded(int time) => _timeEnded = time;
  set winningTeam(String winningTeam) => _winningTeam = winningTeam;
  set losingTeam(String losingTeam) => _losingTeam = losingTeam;

  void finishGame() {
    _timeEnded = DateTime.now().millisecondsSinceEpoch;
    if (_points[0] > _points[1]) {
      _winningTeam = _teamsInvolved[0];
      _losingTeam = _teamsInvolved[1];
    } else if (_points[1] > _points[0]) {
      _winningTeam = _teamsInvolved[1];
      _losingTeam = _teamsInvolved[0];
    } else {
      _winningTeam = 'Draw';
      _losingTeam = 'Draw';
    }
  }

  void addTeam1Point(int points) {
    _team1PointsHistory[DateTime.now().millisecondsSinceEpoch.toString()] =
        points > 0 ? '+$points' : '$points';
    _points[0] += points;
  }
   void addTeam2Point(int points) {
    _team2PointsHistory[DateTime.now().millisecondsSinceEpoch.toString()] =
        points > 0 ? '+$points' : '$points';
    _points[1] += points;
  }

  //toJSON for firestore
  Map<String, dynamic> toJSON() => {
        'gameid': _gameID,
        'points': _points,
        'team1pointshistory': _team1PointsHistory,
        'team2pointshistory': _team2PointsHistory,
        'timestarted': _timeStarted,
        'timeended': _timeEnded,
        'teamsinvolved': _teamsInvolved,
        'winningteam': _winningTeam,
        'losingteam': _losingTeam,
      };

  //fromJSON from firestore
  Game.fromJSON(Map<dynamic, dynamic> data)
      : _gameID = data['gameid'],
        _points = List<int>.from(data['points']),
        _team1PointsHistory =
            Map<String, String>.from(data['team1pointshistory']),
        _team2PointsHistory =
            Map<String, String>.from(data['team2pointshistory']),
        _timeStarted = data['timestarted'],
        _timeEnded = data['timeended'],
        _teamsInvolved = List<String>.from(data['teamsinvolved']),
        _winningTeam = data['winningteam'],
        _losingTeam = data['losingteam'];

  @override
  String toString() {
    return _gameID;
  }
}
