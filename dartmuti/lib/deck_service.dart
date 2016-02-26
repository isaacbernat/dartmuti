import 'package:angular2/angular2.dart';
import 'dart:math';
import 'card.dart';

@Injectable()
class DeckService {
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
  Observable<List<Map>> roles = []; // each element contains name, value, amount

  DeckService() {
    roles = initRoles(roleNames);
  }

  List<Card> getDeck() {
    return buildDeck(roles);
  }

  List<Map> initRoles(List<String> roleNames) {
    Observable<List<Map>> roles = [];
    for (int value = 1; value < roleNames.length + 1; value++) {
      Map role = {
        "name": roleNames[value - 1],
        "value": value,
        "amount": value, // by default there are N cards with value N
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

  String toString() => 'This is the DeckService.';
}
