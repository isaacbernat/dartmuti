import 'card.dart';
import 'trick.dart';

class Tabletop {
  String name;
  List<Card> deck;
  List<Card> discardPile = [];
  List<Trick> currentTricks = [];
  List<int> currentPassedPlayers = [];
  List<String> roles = [
    "The Great Dalmuti",
    "Archbishop",
    "Earl Marshal",
    "Baroness",
    "Abbess",
    "Knight",
    "Seamstress",
    "Mason",
    "Cook",
    "Shepherdess",
    "Stonecutter",
    "Peasants"
  ];

  Tabletop(this.name,
      [this.discardPile, this.currentTricks, this.currentPassedPlayers]);

  void init() {
    discardPile = buildDeck(3, roles);
    deck = buildDeck(12, roles);
    currentTricks = [
      new Trick([deck[10]]),
      new Trick([deck[6]]),
      new Trick([deck[3], deck[4]]),
      new Trick([deck[1], deck[2]]),
    ];
    deck = deck.reversed.toList();
  }

  List<Card> buildDeck(int highestValue, [List<String> roles]) {
    List<Card> cards = [];
    int cardID = 0;
    for (int value = 1; value < highestValue + 1; value++) {
      for (int i = 0; i < value; i++) {
        ++cardID;
        cards.add(new Card(cardID, value, roles[value - 1]));
      }
    }
    return cards;
  }

  String toString() =>
      '$name -> trick to beat: $currentTricks.last . $discardPile cards discarded.';
}
