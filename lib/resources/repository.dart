import 'package:cloud_firestore/cloud_firestore.dart';

import './firestoreProvider.dart';
import '../models/tournament.dart';
import '../models/game.dart';

class Repository {
  
  final _firestoreProvider = FirestoreProvider();

  Stream<DocumentSnapshot> tournamentStream(String tourID) => _firestoreProvider.tournamentStream(tourID);
  
  Stream<QuerySnapshot> allTournamentsStream() => _firestoreProvider.allTournamentsStream();
  
  Future<bool> checkTournament(String tourID) => _firestoreProvider.checkTournament(tourID);

  Future<Tournament> createTournament(String tourName, List<String> teamNames) => _firestoreProvider.createTournament(tourName, teamNames);
  
  Future<Game> createGame(String tourID, String team1, String team2) => _firestoreProvider.createGame(tourID, team1, team2);
  
  Future<void> updatePoints(String tourID, String gameID, int index, int points) => _firestoreProvider.updatePoints(tourID, gameID, index, points);
    
  Future<String> getWinLoss(String tourID, String team1, String team2) => _firestoreProvider.getWinLoss(tourID, team1, team2);

  Future<Map<String, dynamic>> getCompletedGames(String tourID) => _firestoreProvider.getCompletedGames(tourID);

  Future<List<Map<String,dynamic>>> getPointsHistory(String tourID, String gameID) => _firestoreProvider.getPointsHistory(tourID, gameID);
  
  Future<void> deleteOngoingGame(String tourID, String gameID) => _firestoreProvider.deleteOngoingGame(tourID, gameID);

  Future<void> finishGame(String tourID, String gameID) => _firestoreProvider.finishGame(tourID, gameID);
  
  Future<void> finishTournament(String tourID) => _firestoreProvider.finishTournament(tourID);
}
