library dartmuti.model.tabletop;

import 'dart:math';
import 'dart:html';
import 'dart:convert';
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
  int seed = 0;

  Tabletop(int seed, DeckService DS, Map<String, String> playerConfigs) {
    this.DS = DS;
    if (seed != null) {
      this.seed = seed.toInt();
    }
    if (playerConfigs == null) {
      return;
    }
    playerConfigs
        .forEach((name, baseURL) => players.add(new Player(name, baseURL)));
  }

  void startGame() {
    discardPile = [];
    seed = seed.toInt();
    deck = DS.getDeck();
    deck.shuffle(new Random(seed));
    players.shuffle(new Random(seed));

    discardPile = deal(deck, players);
    int currentPosition = 0;
    for (var p in players) {
      p.position = currentPosition++;
      p.sortHand();
    }
    deliverRemoteInfo();
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

  void deliverRemoteInfo() {
    // TODO implement the CORS thingie on the server end
    for (Player p in players) {
      if (p.baseURL == '') {
        continue;
      }
      HttpRequest request = new HttpRequest();
      request.open("POST", p.baseURL + "/state", async: true);
      request.send(JSON.encode(getState(p.position)));
      if (p.position == currentPlayer) {
        request.onReadyStateChange.listen((data) {
          if (request.readyState != HttpRequest.DONE || request.status != 200) {
            return;
          }
          Map res = JSON.decode(request.responseText);
          switch (res["action"]) {
            case "pass":
              passTurn(p.position);
              break;
            case "play":
              if (p.setCardsSelected(res["card_positions"], true)) {
                if (playTrick(p.position)) {
                  break;
                }
                p.setCardsSelected(res["card_positions"], false);
              }
              passTurn(p.position);
              break;
            default:
              print("Not acceptable response. Turn skipped.");
              passTurn(p.position);
          }
        });
      }
    }
  }

  Map getState(int position) {
    var state = {
      "general": {
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

  bool startRound() {
    gameInProgress = true;
    // TODO: returns True if there are still valid moves
    for (var p in players) {
      p.currentTurn = false;
      p.hasPassed = false;
    }
    for (var t in currentTricks) {
      for (var c in t.cards) {
        c.selected = false;
        discardPile.add(c);
      }
    }
    currentTricks = [];
    deliverRemoteInfo();
  }

  bool passTurn(int position) {
    Player p = players[position];
    for (var c in p.hand) {
      c.selected = false;
    }
    p.currentTurn = false;
    p.hasPassed = true;
    currentPlayer = nextPlayerPosition();
    if (currentPlayer == nextPlayerPosition()) {
      startRound();
      return false;
    }
    deliverRemoteInfo();
    return true;
  }

  bool playTurn(int position) {
    players[position].currentTurn = true;
  }

  bool playTrick(int playerPosition) {
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
