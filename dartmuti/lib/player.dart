class Player {
  String name;
  int endPosition; // FIXME not used ATM
  bool currentTurn;
  bool hasPassed;
  List<Card> hand = [];

  Player(String name) {
    this.name = name;
    this.hand = [];
    this.currentTurn = false;
    this.hasPassed = false;
  }

  void sortHand() {
    hand.sort((a, b) => a.value - b.value);
  }

  String toString() => '$ID: $name ($hand.length cards)';
}
