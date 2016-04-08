library dartmuti.model.player;

class Player {
  String name;
  String baseURL;
  int endPosition; // FIXME not used ATM
  bool currentTurn;
  bool hasPassed;
  List<Card> hand = [];

  Player(String name, String baseURL) {
    this.name = name;
    this.baseURL = baseURL;
    this.hand = [];
    this.currentTurn = false;
    this.hasPassed = false;
  }

  void sortHand() {
    hand.sort((a, b) => a.value - b.value);
  }

  List<int> getHandValues() {
    List<int> values = [];
    for (var card in hand) {
      values.add(card.value);
    }
    return values;
  }

  String toString() => '$ID: $name ($hand.length cards)';
}
