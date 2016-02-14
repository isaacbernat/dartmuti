import 'dart:math';
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
  List<int> currentPassedPlayers = [];

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
  }

  String toString() =>
      '$name -> trick to beat: $currentTricks.last . $discardPile cards discarded.';
}
