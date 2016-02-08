import 'card.dart';

class Tabletop {
  String name;
  List<Card> deck;
  List<Card> discardPile = [];
  List<List<int>> currentTricks = [];
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
    "Peasants"];

  Tabletop(this.name, [this.discardPile, this.currentTricks, this.currentPassedPlayers]);

  void init() {
      List<Card> discards = [];
      var lol = new Card(1, 4, "Marshall");
      discards.add(lol);
      discardPile = discards;
      currentTricks = [[4, 4], [3, 3]];
      deck = buildDeck(12, roles);
  }

  List<Card> buildDeck(int highestValue, [List <String> roles]) {
    List<Card> cards = [];
    int cardID = 0;
    for (int value = 1; value < highestValue +1; value++) {
        for (int i = 0; i < value; i++) {
            ++cardID;
            cards.add(new Card(cardID, value, roles[value -1]));
        }
    }
    return cards;
  }

  String toString() => '$name -> trick to beat: $currentTricks.last . $discardPile.length cards discarded.';
}
