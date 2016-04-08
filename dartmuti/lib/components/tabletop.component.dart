library dartmuti.component.tabletop;

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
    int seed = routeParams.get('seed');
    Map<String, String> playerConfigs = routeParams.get('player_configs');
    model = new Tabletop(seed, DS, playerConfigs);
    model.startGame();
  }
}
