library dartmuti.model.tabletop;

import 'dart:math';
import 'dart:html';
import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'package:dartmuti/models/player.dart';
import 'package:dartmuti/models/card.dart';
import 'package:dartmuti/models/trick.dart';
import 'package:dartmuti/services/deck.service.dart';

class Tabletop {
  DeckService DS;
  String name;
  List<Card> deck = [];
  List<Card> discardPile = [];
  List<Trick> currentTricks = [];
  List<Player> players = [];
  int currentPlayer = 0;
  bool gameInProgress = false;
  String gameID = '';
  int seed = 0;
  int currentIteration = 0;
  int maxIterations;
  String auditEndpoint;

  Tabletop(DeckService DS, Map<String, String> playerConfigs, int iterations,
      String audit) {
    this.DS = DS;
    if (playerConfigs == null) {
      return;
    }
    playerConfigs
        .forEach((name, baseURL) => players.add(new Player(name, baseURL)));
    maxIterations = iterations;
    auditEndpoint = audit;
  }

  void startGame(int randomSeed) {
    seed = randomSeed;
    var uuid = new Uuid();
    gameID = uuid.v1();
    gameInProgress = true;
    currentIteration += 1;
    discardPile = [];
    deck = DS.getDeck();
    deck.shuffle(new Random(seed));
    players.shuffle(new Random(seed));

    discardPile = deal(deck, players);
    int currentPosition = 0;
    for (var p in players) {
      p.endPosition = 0;
      p.position = currentPosition++;
      p.sortHand();
    }
    deliverRemoteInfo();
  }

  void restartGame() {
    var r = new Random();
    int seed = r.nextInt(16777216);
    startGame(seed);
  }

  String toString() =>
      '$name -> trick to beat: $currentTricks.last . $discardPile cards discarded.';

  List<Card> deal(List<Card> deck, List<Player> players) {
    // Exhausts deck
    int cardsPerPlayer =
        players.length == 0 ? 0 : (deck.length / players.length).toInt();
    for (int i = 0; i < players.length; i++) {
      players[i].hand =
          deck.sublist(i * cardsPerPlayer, (i + 1) * cardsPerPlayer);
    }
    List<Card> remainder = deck.sublist(players.length * cardsPerPlayer);
    deck.removeRange(0, deck.length);
    return remainder;
  }

  void sendAudit(String payload) {
    if (auditEndpoint == "") {
      return;
    }
    HttpRequest request = new HttpRequest();
    request.open("POST", auditEndpoint, async: true);
    request.send(payload);
  }

  void deliverRemoteInfo() {
    for (Player p in players) {
      if (p.baseURL == '') {
        continue;
      }
      HttpRequest request = new HttpRequest();
      request.open("POST", p.baseURL + "/state", async: true);
      String playerState = JSON.encode(getState(p.position));
      request.send(playerState);
      sendAudit(playerState);
      if (!gameInProgress) {
        continue;
      }
      if (p.position == currentPlayer) {
        request.onReadyStateChange.listen((data) {
          if (request.readyState != HttpRequest.DONE || request.status != 200) {
            return;
          }
          Map res = JSON.decode(request.responseText);
          res["current_player"] = p.position;
          sendAudit(JSON.encode(res));
          switch (res["action"]) {
            case "pass":
              break;
            case "play":
              if (p.setCardsSelected(res["card_positions"], true)) {
                if (playTrick(p.position)) {
                  break;
                }
                p.setCardsSelected(res["card_positions"], false);
              }
              break;
            default:
              print("Not acceptable response. Turn skipped.");
          }
          passTurn(p.position);
        });
      }
      if (!gameInProgress && currentIteration < maxIterations) {
        restartGame();
      }
    }
  }

  Map getState(int position) {
    var state = {
      "general": {
        "game_id": gameID,
        "seed": seed,
        "current_player": currentPlayer,
        "discard_pile": discardPile.length,
        "players": players.length,
        "tricks": [],
      },
      "you": {},
      "players": [],
    };
    for (Player p in players) {
      state["players"].add({
        "name": p.name,
        "position": p.position,
        "end_position": p.endPosition, // 0 means the player has not ended
        "cards_remaining": p.hand.length,
        "has_passed": p.hasPassed,
      });
      if (p.position == position) {
        state["you"] = {"position": position, "hand": p.getHandValues()};
      }
    }
    for (Trick t in currentTricks) {
      state["general"]["tricks"].add(
          {"value": t.cardValue, "cards": t.cards.length, "player": t.player});
    }
    return {"state": state};
  }

  void startRound() {
    List<Player> playersWithCards = [];
    for (var p in players) {
      p.currentTurn = false;
      p.hasPassed = false;
      if (p.hand.length > 0) {
        playersWithCards.add(p);
      }
    }
    for (var t in currentTricks) {
      for (var c in t.cards) {
        c.selected = false;
        discardPile.add(c);
      }
    }
    currentTricks = [];
    gameInProgress = playersWithCards.length > 1;
    if (!gameInProgress &&
        playersWithCards.length > 0 &&
        playersWithCards[0].hand.length > 0) {
      playersWithCards[0].endPosition = players.length;
    }
    deliverRemoteInfo();
  }

  void passTurn(int position) {
    if (!gameInProgress) {
      if (currentIteration < maxIterations) {
        restartGame();
      }
      return;
    }
    Player p = players[position];
    for (var c in p.hand) {
      c.selected = false;
    }
    p.currentTurn = false;
    p.hasPassed = true;
    currentPlayer = nextPlayerPosition();
    if (currentPlayer == nextPlayerPosition()) {
      startRound();
    }
    deliverRemoteInfo();
    return;
  }

  bool playTurn(int position) {
    players[position].currentTurn = true;
  }

  bool playTrick(int playerPosition) {
    if (!gameInProgress) {
      if (currentIteration < maxIterations) {
        restartGame();
      }
      return false;
    }
    Player p = players[playerPosition];
    List<Card> selectedCards = p.getSelectedCards();
    Trick newTrick;
    try {
      newTrick = new Trick(selectedCards, playerPosition);
    } catch (e) {
      print("You can't form a Trick with these cards!");
      return false;
    }
    if (currentTricks.length > 0 && !newTrick.beats(currentTricks.last)) {
      print("This trick is not 'powerful' enough to beat the current one");
      return false;
    }

    p.removeCards(selectedCards, players);
    if (currentTricks.length > 0) {
      for (var c in currentTricks.last.cards) {
        c.selected = false;
      }
    }
    currentTricks.add(newTrick);
    p.currentTurn = false;
    currentPlayer = nextPlayerPosition();
    deliverRemoteInfo();
    return true;
  }

  int nextPlayerPosition() {
    // returns current player if no other eligible
    int i = 1;
    do {
      int nextPosition = (i + currentPlayer) % players.length;

      if (!players[nextPosition].hasPassed &&
          players[nextPosition].hand.length > 0) {
        return nextPosition;
      }
    } while (++i < players.length);
    return currentPlayer;
  }

  int countCardsTricks() {
    return currentTricks.fold(0, (t, e) => t + e.cards.length);
  }

  int countCardsPlayers() {
    return players.fold(0, (t, e) => t + e.hand.length);
  }

  int countCards() {
    return discardPile.length + countCardsPlayers() + countCardsTricks();
  }
}
