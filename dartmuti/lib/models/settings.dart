library dartmuti.model.settings;

import 'dart:math';

class Settings {
  int seed = 1337;
  int turnTime;
  int iterations = 1;
  Map<String, String> playerConfigs = {};
  String auditEndpoint = "";

  Settings() {}

  void addPlayer(nameInput, baseURLInput) {
    String name = nameInput.value;
    if (name?.length > 0) {
      playerConfigs[name] = baseURLInput.value;
      baseURLInput.value = "";
      nameInput.value = "";
    }
  }

  void randomiseSeed() {
    var r = new Random();
    seed = r.nextInt(65535);
  }
}
