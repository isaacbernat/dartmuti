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

  String toString() => '$ID: $name ($hand.length cards)';
}
