class Player {
  String name;
  int position;
  bool currentTurn;
  bool hasPassed;
  List<Card> hand = [];

  Player(this.name, this.hand,
      [this.position, this.currentTurn, this.hasPassed]);

  void sortHand() {
    hand.sort((a, b) => a.value - b.value);
  }

  String toString() => '$ID: $name ($hand.length cards)';
}
