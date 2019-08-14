import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tourney/models/tournament.dart';
import 'package:tourney/models/game.dart';
import 'package:tourney/models/team.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Stream<DocumentSnapshot> tournamentStream(String tourID) {
    return _firestore.collection("tournaments").document(tourID).snapshots();
  }

  Stream<QuerySnapshot> allTournamentsStream() {
    return _firestore.collection("tournaments").snapshots();
  }

  Future<bool> checkTournament(String tourID) async {
    return await _firestore
        .collection("tournaments")
        .document(tourID)
        .get()
        .then((DocumentSnapshot res) {
      return (res.data != null);
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
    bool isValid = true;

    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        Map<String, dynamic> games =
            Map<String, dynamic>.from(postSnapshot.data['games']);
        Map<String, dynamic>.from(games['ongoing'])
          .forEach((key, val) {
            if(setEquals<String>(Set<String>.from(val['teamsinvolved']),newGame.teamsInvolved.toSet()))
              isValid = false;
          });
        if(isValid)
          games['ongoing'][newGame.gameID] = newGame.toJSON();
        await tx.update(postRef, <String, dynamic>{'games': games});
      }
    });
    return isValid ? newGame : null;
  }

  Future<void> updatePoints(
      String tourID, String gameID, int index, int points) async {
    final DocumentReference postRef =
        _firestore.collection("tournaments").document(tourID);
    await _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        Map<String, dynamic> games =
            Map<String, dynamic>.from(postSnapshot.data['games']);

        Game currentGame = Game.fromJSON(games['ongoing'][gameID]);

        if (index == 0) {
          currentGame.addTeam1Point(points);
        } else {
          currentGame.addTeam2Point(points);
        }
        games['ongoing'][gameID] = currentGame.toJSON();
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
        Map<String, dynamic>.from(res.data['games']['completed'])
            .forEach((key, val) {
          Game game = Game.fromJSON(val);
          if (game.teamsInvolved[0] == team1 &&
              game.teamsInvolved[1] == team2) {
            if (game.winningTeam == team1)
              winloss += "W";
            else if (game.winningTeam == team2)
              winloss += "L";
            else
              winloss += "D";
          }
        });
      }
    });
    return winloss;
  }

  Future<Map<String, dynamic>> getCompletedGames(String tourID) async {
    final DocumentReference postRef =
        _firestore.collection("tournaments").document(tourID);
    return await postRef.get().then((DocumentSnapshot res) {
      if (res.exists) {
        return Map<String, dynamic>.from(res.data['games']['completed']);
      } else
        return null;
    });
  }

  Future<List<Map<String, dynamic>>> getPointsHistory(
      String tourID, String gameID) async {
    final DocumentReference postRef =
        _firestore.collection("tournaments").document(tourID);
    List<Map<String, dynamic>> result = [];
    await postRef.get().then((DocumentSnapshot res) {
      if (res.exists) {
        result.add(Map<String, dynamic>.from(
            res.data['games']['completed'][gameID]['team1pointshistory']));
        result.add(Map<String, dynamic>.from(
            res.data['games']['completed'][gameID]['team2pointshistory']));
      }
    });
    return result;
  }

  Future<void> deleteOngoingGame(String tourID, String gameID) async {
    final DocumentReference postRef =
        _firestore.collection("tournaments").document(tourID);
    // Transaction to update game
    await _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        // Current Game
        Map<String, dynamic> games =
            Map<String, dynamic>.from(postSnapshot.data['games']);
        games['ongoing'].remove(gameID);
        await tx.update(postRef, <String, dynamic>{'games': games});
      }
    });
  }

  Future<void> deleteCompletedGame(String tourID, String gameID) async {
    final DocumentReference postRef =
        _firestore.collection("tournaments").document(tourID);
    String winningTeamName;
    String losingTeamName;
    List<String> teamsInvolved;
    // Transaction to update game
    await _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        // Current Game
        Map<String, dynamic> games =
            Map<String, dynamic>.from(postSnapshot.data['games']);
        Game gameToDelete = Game.fromJSON(games['completed'].remove(gameID));
        winningTeamName = gameToDelete.winningTeam;
        losingTeamName = gameToDelete.losingTeam;
        teamsInvolved = List<String>.from(gameToDelete.teamsInvolved);
        await tx.update(postRef, <String, dynamic>{'games': games});
      }
    });
    await _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        // Current Teams Info
        Map<String, dynamic> teams =
            Map<String, dynamic>.from(await postSnapshot.data['teams']);
        // Update Winning Team
        if (winningTeamName == "Draw") {
          Team drawingTeam1 =
              Team.fromJSON(Map<String, dynamic>.from(teams[teamsInvolved[0]]));
          Team drawingTeam2 =
              Team.fromJSON(Map<String, dynamic>.from(teams[teamsInvolved[1]]));
          drawingTeam1.removeDraw(gameID);
          drawingTeam2.removeDraw(gameID);
          teams[drawingTeam1.teamName] = drawingTeam1.toJSON();
          teams[drawingTeam2.teamName] = drawingTeam2.toJSON();
        } else {
          Team winningTeam =
              Team.fromJSON(Map<String, dynamic>.from(teams[winningTeamName]));
          Team losingTeam =
              Team.fromJSON(Map<String, dynamic>.from(teams[losingTeamName]));
          winningTeam.removeWin(gameID);
          losingTeam.removeLoss(gameID);
          teams[winningTeamName] = winningTeam.toJSON();
          teams[losingTeamName] = losingTeam.toJSON();
        }
        await tx.update(postRef, <String, dynamic>{'teams': teams});
      }
    });
  }

  Future<void> finishGame(String tourID, String gameID) async {
    final DocumentReference postRef =
        _firestore.collection("tournaments").document(tourID);
    Game currentGame;

    // Transaction to update game
    await _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        // Current Game
        Map<String, dynamic> games =
            Map<String, dynamic>.from(postSnapshot.data['games']);

        // Finish Current Game
        currentGame = Game.fromJSON(games['ongoing'].remove(gameID));
        currentGame.finishGame();

        // Move game to completed List
        games['completed'][currentGame.gameID] = currentGame.toJSON();

        await tx.update(postRef, <String, dynamic>{'games': games});
      }
    });

    // Update Team Statistics
    await _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        // List of teams
        Map<String, dynamic> teams =
            Map<String, dynamic>.from(postSnapshot.data['teams']);
        // Draw Case
        if (currentGame.winningTeam == 'Draw') {
          Team drawingTeam1 =
              Team.fromJSON(teams.remove(currentGame.teamsInvolved[0]));
          Team drawingTeam2 =
              Team.fromJSON(teams.remove(currentGame.teamsInvolved[1]));
          drawingTeam1.addDraw(gameID);
          drawingTeam2.addDraw(gameID);
          teams[drawingTeam1.teamName] = drawingTeam1.toJSON();
          teams[drawingTeam2.teamName] = drawingTeam2.toJSON();
        } else {
          Team winningTeam =
              Team.fromJSON(teams.remove(currentGame.winningTeam));
          Team losingTeam = Team.fromJSON(teams.remove(currentGame.losingTeam));
          winningTeam.addWin(gameID);
          losingTeam.addLoss(gameID);
          teams[winningTeam.teamName] = winningTeam.toJSON();
          teams[losingTeam.teamName] = losingTeam.toJSON();
        }
        await tx
            .update(postRef, <String, Map<String, dynamic>>{'teams': teams});
      }
    });
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
