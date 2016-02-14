import 'dart:math';
import 'card.dart';
import 'trick.dart';

class Tabletop {
  String name;
  int seed;
  List<Card> deck;
  List<Card> discardPile = [];
  List<Trick> currentTricks = [];
  List<int> currentPassedPlayers = [];
  List<String> roleNames = [
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
  Observable<List<Map>> roles = [];  // each element contains name, value, amount

  Tabletop(this.name,
      [this.discardPile, this.currentTricks, this.currentPassedPlayers]);

  void init() {
    seed = 1337;
    roles = initRoles(roleNames);
    deck = buildDeck(roles);
    currentTricks = [
      new Trick([deck[10]]),
      new Trick([deck[6]]),
      new Trick([deck[3], deck[4]]),
      new Trick([deck[1], deck[2]]),
    ];
    deck.shuffle(new Random(seed));
  }

  List<Map> initRoles(List<String> roleNames) {
    Observable<List<Map>> roles = [];
    for (int value = 1; value < roleNames.length + 1; value++) {
      Map role = {
        "name": roleNames[value -1],
        "value": value,
        "amount": value,  // by default there are N cards with value N
      };
      roles.add(role);
    }
    return roles;
  }

  List<Card> buildDeck(List<Map> roles) {
    List<Card> cards = [];
    int cardID = 0;
    for (int i = 0; i < roles.length; i++) {
      for (int j = 0; j < roles[i]['amount']; j++) {
        ++cardID;
        cards.add(new Card(cardID, roles[i]['value'], roles[i]['name']));
      }
    }
    return cards;
  }

  String toString() =>
      '$name -> trick to beat: $currentTricks.last . $discardPile cards discarded.';
}
