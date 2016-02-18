class Player {
  final int ID;
  String name;
  int position;
  bool currentTurn;
  bool hasPassed;
  List<Card> hand = [];

  Player(this.ID, this.name, this.position, [this.currentTurn, this.hasPassed, this.hand]);

  String toString() => '$ID: $name ($hand.length cards)';
}
