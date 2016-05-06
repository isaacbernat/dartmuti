library dartmuti.model.player;

import 'dart:math';

class Player {
  String name;
  String baseURL;
  int endPosition;
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
    this.endPosition = 0;
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

  bool setCardsSelected(List<int> positions, bool selectedFlag) {
    for (int p in positions) {
      if (p < 0 || p >= hand.length) {
        return false;
      }
    }
    for (int p in positions) {
      hand[p].selected = selectedFlag;
    }
    return true;
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

  void removeCards(List<Card> cards, List<Player> players) {
    for (Card c in cards) {
      hand.remove(c);
    }
    if (hand.length == 0) {
      // has just finished. Update endPosition
      int currentEndPosition = 0;
      for (Player p in players) {
        currentEndPosition = max(currentEndPosition, p.endPosition);
      }
      endPosition = currentEndPosition + 1;
    }
  }

  String toString() => '$ID: $name ($hand.length cards)';
}
