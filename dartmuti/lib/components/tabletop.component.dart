library dartmuti.component.tabletop;

import 'dart:math';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart' show ROUTER_DIRECTIVES, RouteParams;

import 'package:dartmuti/components/trick.component.dart';
import 'package:dartmuti/components/card.component.dart';
import 'package:dartmuti/components/player.component.dart';
import 'package:dartmuti/models/tabletop.dart';
import 'package:dartmuti/services/deck.service.dart';

@Component(
    selector: 'dartmuti-tabletop',
    templateUrl: 'tabletop.component.html',
    providers: const [DeckService],
    directives: const [
      ROUTER_DIRECTIVES,
      NgFor,
      NgIf,
      NgClass,
      TrickComponent,
      CardComponent,
      PlayerComponent,
    ])
class TabletopComponent {
  Tabletop model;
  TabletopComponent(DeckService DS, RouteParams routeParams) {
    Map<String, String> playerConfigs = routeParams.get('player_configs');
    model = new Tabletop(DS, playerConfigs);
    var seed = routeParams.get('seed');
    seed = seed == null ? 0 : seed.toInt();
    model.startGame(seed);
  }

  void restartGame() {
    var r = new Random();
    int seed = r.nextInt(16777216);
    model.startGame(seed);
  }
}
