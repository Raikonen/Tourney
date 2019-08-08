import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tournament.dart';
import '../models/game.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Stream<DocumentSnapshot> tournamentStream(String tourID) {
    return _firestore.collection("tournaments").document(tourID).snapshots();
  }

  Stream<QuerySnapshot> allTournamentsStream() {
    return _firestore.collection("tournaments").snapshots();
  }

  Future<dynamic> checkTournament(String tourID) async {
    return await _firestore
        .collection("tournaments")
        .document(tourID)
        .get()
        .then((DocumentSnapshot res) {
      return (res.data != null);
    }).catchError((error) {
      print('this is the error: ${error}');
      return null;
    });
  }

  Future<Tournament> createTournament(
      String tourName, List<String> teamNames) async {
    Tournament newTournament = Tournament(tourName, teamNames);
    await _firestore
        .collection("tournaments")
        .document(newTournament.tourID)
        .setData(newTournament.toJSON());

    return newTournament;
  }

  Future<Game> createGame(String tourID, String team1, String team2) async {
    Game newGame = Game(team1, team2);
    final DocumentReference postRef =
        _firestore.collection("tournaments").document(tourID);
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        var games =
            new Map<String, dynamic>.from(await postSnapshot.data['games']);
        games['ongoing'][newGame.gameID] = (newGame.toJSON());
        await tx.update(postRef, <String, dynamic>{'games': games});
      }
    });
    return newGame;
  }

  Future<void> updatePoints(
      String tourID, String gameID, int index, int points) async {
    final DocumentReference postRef =
        _firestore.collection("tournaments").document(tourID);
    await _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        // Current Game
        Map<String, dynamic> games =
            Map<String, dynamic>.from(await postSnapshot.data['games']);
        Map<String, dynamic> currentGame =
            Map<String, dynamic>.from(games['ongoing'].remove(gameID));
        if (index == 0) {
          currentGame['team1pointshistory']
                  [DateTime.now().millisecondsSinceEpoch.toString()] =
              points > 0 ? '+$points' : '$points';
          currentGame['points'][0] += points;
        } else {
          currentGame['team2pointshistory']
                  [DateTime.now().millisecondsSinceEpoch.toString()] =
              points > 0 ? '+$points' : '$points';
          currentGame['points'][1] += points;
        }
        games['ongoing'][gameID] = currentGame;
        await tx.update(postRef, <String, dynamic>{'games': games});
      }
    });
  }

  Future<String> getWinLoss(String tourID, String team1, String team2) async {
    String winloss = "";
    final DocumentReference postRef =
        _firestore.collection("tournaments").document(tourID);
    await postRef.get().then((DocumentSnapshot res) {
      if (res.exists) {
        Map<String, dynamic> games =
            Map<String, dynamic>.from(res.data['games']);
        Map<String, dynamic> completedGames = Map<String, dynamic>.from(games['completed']);
        completedGames.forEach((key, val) => key == (team1 + "_" + team2)
            ? val['winningteam'] == team1
                ? winloss += "W"
                : val['winningteam'] == team2 ? winloss += "L" : winloss += "D"
            : null);
      }
    });
    return winloss;
  }

  Future<List<Map<String,dynamic>>> getPointsHistory(String tourID, String gameID) async {
    final DocumentReference postRef =
        _firestore.collection("tournaments").document(tourID);
    List<Map<String,dynamic>> result = [];
    await postRef.get().then((DocumentSnapshot res) {
      if (res.exists) {
        result.add(Map<String,dynamic>.from(res.data['games']['completed'][gameID]['team1pointshistory']));
        result.add(Map<String,dynamic>.from(res.data['games']['completed'][gameID]['team2pointshistory']));
    }});
    return result;
    
  }

  Future<void> finishGame(String tourID, String gameID) async {
    final DocumentReference postRef =
        _firestore.collection("tournaments").document(tourID);
    // Transaction to update game
    Map<String, dynamic> currentGame;
    await _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        // Current Game
        Map<String, dynamic> games =
            Map<String, dynamic>.from(await postSnapshot.data['games']);
        currentGame =
            Map<String, dynamic>.from(games['ongoing'].remove(gameID));
        currentGame['timeended'] = DateTime.now().millisecondsSinceEpoch;

        // Set Winning Team for Current Game
        if (currentGame['points'][0] > currentGame['points'][1]) {
          currentGame['winningteam'] = currentGame['teamsinvolved'][0];
          currentGame['losingteam'] = currentGame['teamsinvolved'][1];
        } else if (currentGame['points'][1] > currentGame['points'][0]) {
          currentGame['winningteam'] = currentGame['teamsinvolved'][1];
          currentGame['losingteam'] = currentGame['teamsinvolved'][0];
        } else {
          currentGame['winningteam'] = 'Draw';
          currentGame['losingteam'] = 'Draw';
        }

        // Move game to completed List
        Map<String,dynamic> currentList = Map<String,dynamic>.from(games['completed']);
        currentList[currentGame['gameid']] = currentGame;
        games['completed'] = currentList;
        await tx.update(postRef, <String, dynamic>{'games': games});
      }
    }).catchError((err) => print(err));

    // Update Team Statistics
    await _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        // List of teams
        Map<String, dynamic> teams =
            Map<String, dynamic>.from(await postSnapshot.data['teams']);
        // Draw Case
        if (currentGame['winningteam'] == 'Draw') {
          Map<String, dynamic> drawingTeam1 = Map<String, dynamic>.from(
              teams.remove(currentGame['teamsinvolved'][0]));
          Map<String, dynamic> drawingTeam2 = Map<String, dynamic>.from(
              teams.remove(currentGame['teamsinvolved'][1]));

          drawingTeam1['gamesplayed'] = drawingTeam1['gamesplayed'] + 1;
          List<String> oldDraws1 = List<String>.from(drawingTeam1['draws']);
          oldDraws1.add(drawingTeam2['teamname']);
          drawingTeam1['draws'] = oldDraws1;
          drawingTeam1['winrate'] = (List.from(drawingTeam1['wins']).length +
                  List.from(drawingTeam1['draws']).length * 0.5) /
              drawingTeam1['gamesplayed'];

          drawingTeam2['gamesplayed'] = drawingTeam2['gamesplayed'] + 1;
          List<String> oldDraws2 = List<String>.from(drawingTeam2['draws']);
          oldDraws2.add(drawingTeam1['teamname']);
          drawingTeam2['draws'] = oldDraws2;
          drawingTeam2['winrate'] = (List.from(drawingTeam2['wins']).length +
                  List.from(drawingTeam2['draws']).length * 0.5) /
              drawingTeam2['gamesplayed'];

          teams[drawingTeam1['teamname']] = drawingTeam1;
          teams[drawingTeam2['teamname']] = drawingTeam2;
        } else {
          Map<String, dynamic> winningTeam = Map<String, dynamic>.from(
              teams.remove(currentGame['winningteam']));
          Map<String, dynamic> losingTeam = Map<String, dynamic>.from(
              teams.remove(currentGame['losingteam']));

          winningTeam['gamesplayed'] = winningTeam['gamesplayed'] + 1;
          List<String> oldWins = List<String>.from(winningTeam['wins']);
          oldWins.add(losingTeam['teamname']);
          winningTeam['wins'] = oldWins;
          winningTeam['winrate'] = (List.from(winningTeam['wins']).length +
                  List.from(winningTeam['draws']).length * 0.5) /
              winningTeam['gamesplayed'];

          losingTeam['gamesplayed'] = losingTeam['gamesplayed'] + 1;
          List<String> oldLosses = List<String>.from(losingTeam['losses']);
          oldLosses.add(winningTeam['teamname']);
          losingTeam['losses'] = oldLosses;
          losingTeam['winrate'] = (List.from(losingTeam['wins']).length +
                  List.from(losingTeam['draws']).length * 0.5) /
              losingTeam['gamesplayed'];

          teams[winningTeam['teamname']] = winningTeam;
          teams[losingTeam['teamname']] = losingTeam;
        }

        await tx
            .update(postRef, <String, Map<String, dynamic>>{'teams': teams});
      }
    }).catchError((err) => print(err));
  }

  Future<void> finishTournament(String tourID) async {
    final DocumentReference postRef =
        _firestore.collection("tournaments").document(tourID);
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, {'status': 'completed'});
      }
    });
  }
}
