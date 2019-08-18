class Team {
  final String _teamName;
  int _gamesPlayed;
  List<String> _wins;
  List<String> _draws;
  List<String> _losses;
  double _winrate;

  Team(this._teamName) {
    this._gamesPlayed = 0;
    this._wins = [];
    this._draws = [];
    this._losses = [];
    this._winrate = 0.0;
  }

  // Getters
  String get teamName => _teamName;
  int get gamesPlayed => _gamesPlayed;
  List<String> get wins => _wins;
  List<String> get draws => _draws;
  List<String> get losses => _losses;
  double get winrate => _winrate;

  void updateWinrate() {
    _winrate = _gamesPlayed == 0
        ? 0
        : (_wins.length + _draws.length * 0.5) / _gamesPlayed;
  }

  void addWin(String gameID) {
    _gamesPlayed++;
    _wins.add(gameID);
    updateWinrate();
  }

  void addLoss(String gameID) {
    _gamesPlayed++;
    _losses.add(gameID);
    updateWinrate();
  }

  void addDraw(String gameID) {
    _gamesPlayed++;
    _draws.add(gameID);
    updateWinrate();
  }

  void removeWin(String gameID) {
    _gamesPlayed--;
    _wins.remove(gameID);
    updateWinrate();
  }

  void removeLoss(String gameID) {
    _gamesPlayed--;
    _losses.remove(gameID);
    updateWinrate();
  }

  void removeDraw(String gameID) {
    _gamesPlayed--;
    _draws.remove(gameID);
    updateWinrate();
  }

  //toJSON for firestore
  Map<String, dynamic> toJSON() => {
        'teamname': _teamName,
        'gamesplayed': _gamesPlayed,
        'wins': _wins,
        'draws': _draws,
        'losses': _losses,
        'winrate': _winrate,
      };

  //fromJSON from firestore
  Team.fromJSON(Map<dynamic, dynamic> data)
      : _teamName = data['teamname'],
        _gamesPlayed = data['gamesplayed'],
        _wins = List<String>.from(data['wins']),
        _draws = List<String>.from(data['draws']),
        _losses = List<String>.from(data['losses']),
        _winrate = data['winrate'].toDouble();

  @override
  String toString() {
    return _teamName;
  }
}
