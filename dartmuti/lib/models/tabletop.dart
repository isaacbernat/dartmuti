library dartmuti.model.tabletop;

import 'dart:math';
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
  bool startedGame = false;
  int seed = 0;

  Tabletop(var seed, DeckService DS, [List<String> playerNames]) {
    this.DS = DS;
    if (seed != null) {
      this.seed = seed.toInt();
    }
    for (string name in playerNames) {
      players.add(new Player(name));
    }
  }

  void startGame() {
    startedGame = true;
    discardPile = [];
    seed = seed.toInt();
    deck = DS.getDeck();
    deck.shuffle(new Random(seed));
    players.shuffle(new Random(seed));

    discardPile = deal(deck, players);
    for (var p in players) {
      p.sortHand();
    }
  }

  String toString() =>
      '$name -> trick to beat: $currentTricks.last . $discardPile cards discarded.';

  List<Card> deal(List<Card> deck, List<Player> players) {
    // Exhausts deck
    int cardsPerPlayer = (deck.length / players.length).toInt();
    for (int i = 0; i < players.length; i++) {
      players[i].hand =
          deck.sublist(i * cardsPerPlayer, (i + 1) * cardsPerPlayer);
    }
    List<Card> remainder = deck.sublist(players.length * cardsPerPlayer);
    deck.removeRange(0, deck.length);
    return remainder;
  }

  bool startRound() {
    // returns True if there are still valid moves
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
  }

  bool passTurn(int position) {
    for (var c in players[position].hand) {
      c.selected = false;
    }
    players[position].currentTurn = false;
    players[position].hasPassed = true;
    currentPlayer = nextPlayerPosition();
    if (currentPlayer == position) {
      startRound();
      return false;
    }
    return true;
  }

  bool playTurn(int position) {
    players[position].currentTurn = true;
  }

  bool playTrick(int playerPosition) {
    List<Card> selectedCards = [];
    Trick newTrick;
    for (var c in players[playerPosition].hand) {
      if (c.selected) {
        selectedCards.add(c);
      }
    }
    try {
      newTrick = new Trick(selectedCards);
    } catch (e) {
      print("You can't form a Trick with these cards!");
      return;
    }
    if (currentTricks.length == 0 ||
        newTrick.beats(currentTricks[currentTricks.length - 1])) {
      for (var c in selectedCards) {
        players[playerPosition].hand.remove(c);
      }
      if (currentTricks.length > 0) {
        for (var c in currentTricks[currentTricks.length - 1].cards) {
          c.selected = false;
        }
      }
      currentTricks.add(newTrick);
    } else {
      print("This trick is not 'powerful' enough to trink the current one");
      return;
    }
    currentPlayer = nextPlayerPosition();
    if (currentPlayer == playerPosition) {
      startRound();
      return false;
    }
    players[playerPosition].currentTurn = false;
    return true;
  }

  int nextPlayerPosition() {
    // returns current player if no other eligible
    int i = 1;
    do {
      int nextPosition = (i + currentPlayer) % players.length;

      if (!players[nextPosition].hasPassed) {
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
