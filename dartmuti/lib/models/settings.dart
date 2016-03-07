library dartmuti.model.settings;

import 'dart:math';

class Settings {
  int seed = 1337;
  List<String> names = [];

  Settings() {}

  void addPlayer(String name) {
    if (name?.length > 0) {
      names.add(name);
    }
  }

  String toString() =>
      '$name -> trick to beat: $currentTricks.last . $discardPile cards discarded.';

  void randomiseSeed() {
    var r = new Random();
    seed = r.nextInt(65535);
  }
}
