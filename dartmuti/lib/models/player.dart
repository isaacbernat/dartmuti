library dartmuti.model.player;

class Player {
  String name;
  String baseURL;
  int endPosition; // FIXME not used ATM
  int position;
  bool currentTurn;
  bool hasPassed;
  List<Card> hand = [];

  Player(String name, String baseURL) {
    this.name = name;
    this.baseURL = baseURL;
    this.position = -1;
    this.hand = [];
    this.currentTurn = false;
    this.hasPassed = false;
  }

  void sortHand() {
    hand.sort((a, b) => a.value - b.value);
  }

  List<int> getHandValues() {
    List<int> values = [];
    for (Card c in hand) {
      values.add(c.value);
    }
    return values;
  }

  List<Card> getSelectedCards() {
    List<Card> selectedCards = [];
    for (Card c in hand) {
      if (c.selected) {
        selectedCards.add(c);
      }
    }
    return selectedCards;
  }

  void removeCards(List<Card> cards) {
    for (Card c in cards) {
      hand.remove(c);
    }
  }

  String toString() => '$ID: $name ($hand.length cards)';
}
