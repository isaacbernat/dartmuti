import 'dart:math';
import 'player.dart';
import 'card.dart';
import 'trick.dart';
import 'deck_service.dart';

class Tabletop {
  DeckService DeckService;
  String name;
  int seed = 1337;
  List<Card> deck = [];
  List<Card> discardPile = [];
  List<Trick> currentTricks = [];
  List<Player> players = [];
  int currentPlayer = 0;

  Tabletop() {}

  void startGame() {
    seed = seed.toInt();
    deck = DeckService.getDeck();
    deck.shuffle(new Random(seed));
    players.shuffle(new Random(seed));

    discardPile = deal(deck, players);
    for (var p in players) {
      p.sortHand();
    }
  }

  void addPlayer(String name) {
    if (name?.length > 0) {
      players.add(new Player(name));
    }
    name = '';
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
  }

  bool passTurn(int position) {
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

  int nextPlayerPosition() {
    // returns current player if no other eligible
    int i = 0;
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

  void randomiseSeed() {
    var r = new Random();
    seed = r.nextInt(65535);
  }
}
