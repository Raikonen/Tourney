class Team {
  final String _teamName;
  int _gamesPlayed;
  List<dynamic> _wins;
  List<dynamic> _draws;
  List<dynamic> _losses;
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
  List<dynamic> get wins => _wins;
  List<dynamic> get draws => _draws;
  List<dynamic> get losses => _losses;
  double get winrate => _winrate;

  //toJSON for firestore
  Map<String, dynamic> toJSON() => {
        'teamname': _teamName,
        'gamesplayed' : _gamesPlayed,
        'wins': _wins,
        'draws': _draws,
        'losses': _losses,
        'winrate': _winrate,
      };

  //fromJSON from firestore
  Team.fromJSON(Map<dynamic, dynamic> data)
      : _teamName = data['teamname'],
        _gamesPlayed = data['gamesplayed'],
        _wins = data['wins'],
        _draws = data['draws'],
        _losses = data['losses'],
        _winrate = data['winrate'].toDouble();

  @override
  String toString() {
    return _teamName;
  }
}
