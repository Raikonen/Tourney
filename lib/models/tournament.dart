import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import './team.dart';

class Tournament {
  final _rng = Random();
  String _tourID;
  String _tourName;
  String _orgCode;
  String _status;
  Map<String, dynamic> _teams;
  Map<String, dynamic> _games;
  List<String> _teamNames;

  Tournament(this._tourName, this._teamNames) {
    // Instantiate properties
    String tourIDStr = "";
    for (int i = 0; i < 6; i++) {
      tourIDStr = tourIDStr + _rng.nextInt(9).toString();
    }
    this._tourID = tourIDStr;
    String orgCodeStr = "";
    for (int i = 0; i < 4; i++) {
      orgCodeStr = orgCodeStr + _rng.nextInt(9).toString();
    }
    this._orgCode = orgCodeStr;
    this._status = "ongoing";
    this._teams = Map.fromIterable(_teamNames, key: (team) => team.toString(), value: (team) => Team(team.toString()).toJSON());
    var initialiseGames = new Map<String, dynamic>();
    initialiseGames['ongoing'] = new Map<String, dynamic>();
    initialiseGames['completed'] = new Map<String, dynamic>();
    this._games = initialiseGames;
  }

  // Getters
  String get tourID => _tourID;
  String get tourName => _tourName;
  String get orgCode => _orgCode;
  String get status => _status;
  Map<String, dynamic> get teams => _teams;
  Map<String, dynamic> get games => _games;
  List<String> get teamNames => _teamNames;

  // toJSON for firestore
  Map<String, dynamic> toJSON() {
    return {
      'tourid': _tourID,
      'tourname': _tourName,
      'orgcode': _orgCode,
      'status': _status,
      'teams': _teams,
      'games': _games,
      'teamnames': _teamNames,
    };
  }

  //fromJSON from firestore
  Tournament.fromSnapshot(DocumentSnapshot snapshot)
      : _tourID = snapshot['tourid'],
        _tourName = snapshot['tourname'],
        _orgCode = snapshot['orgcode'],
        _status = snapshot['status'],
        _teams = Map<String, dynamic>.from(snapshot['teams']),
        _games = Map<String, dynamic>.from(snapshot['games']),
        _teamNames = List<String>.from(snapshot['teamnames']);

  Tournament.fromJSON(Map<dynamic, dynamic> data)
      : _tourID = data['tourid'],
        _tourName = data['tourname'],
        _orgCode = data['orgcode'],
        _status = data['status'],
        _teams = Map<String, dynamic>.from(data['teams']),
        _games = Map<String, dynamic>.from(data['games']),
        _teamNames = List<String>.from(data['teamnames']);

  @override
  String toString() {
    return _tourName;
  }
}
