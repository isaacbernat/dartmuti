import 'card.dart';

class Trick {
    List<Card> cards = [];
    int cardValue;

    Trick(List<Card> trickCards) {
        if (trickCards.length == 0) {
            throw new Exception('tricks must have at least 1 card');
        }
        // cardValue = trickCards[0].value;
        // for (Card c in trickCards) {
        //     if (c.value != cardValue) {
        //         throw new Exception('all cards must have the same value');
        //     }
        // }
        cards = trickCards;
  }

    String toString() => '$cards';

    static bool beats(Trick otherTrick) {
        if (cardValue == 1) { // 1 trumps everything
            return true;
        }
        if (cards.length >= otherTrick.length &&
            cardValue < otherTrick[0].value) {
            return true;
        }
        return false
    }
}
