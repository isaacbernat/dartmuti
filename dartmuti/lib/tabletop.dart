import 'dart:math';
import 'player.dart';
import 'card.dart';
import 'trick.dart';
import 'deck_service.dart';

class Tabletop {
  DeckService DeckService;
  String name;
  int seed;
  List<Card> deck = [];
  List<Card> discardPile = [];
  List<Trick> currentTricks = [];
  List<Player> players = [];

  Tabletop(String name) {
    this.name = name;
  }

  void init() {
    deck = DeckService.getDeck();
    seed = 1337;
    currentTricks = [
      new Trick([deck[10]]),
      new Trick([deck[6]]),
      new Trick([deck[3], deck[4]]),
      new Trick([deck[1], deck[2]]),
    ];
    deck.shuffle(new Random(seed));

    players = [
      new Player(1, "k05", 0),
      new Player(2, "9001", 1),
      new Player(3, "1338", 2),
      new Player(4, "hest", 3)
    ];
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
}
