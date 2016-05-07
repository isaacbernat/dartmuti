library dartmuti.component.settings;

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart' show RouteParams, Router;
import 'package:dartmuti/components/player.component.dart';
import 'package:dartmuti/models/settings.dart';
import 'package:dartmuti/services/deck.service.dart';

@Component(
    selector: 'dartmuti-settings',
    templateUrl: 'settings.component.html',
    directives: const [NgFor, NgIf, NgClass, PlayerComponent,])
class SettingsComponent {
  Settings model;
  Router _router;
  SettingsComponent(RouteParams routeParams, Router router) {
    model = new Settings();
    _router = router;
  }

  void startGame() {
    _router.navigate([
      'Tabletop',
      {
        'seed': model.seed,
        'turn_time': model.turnTime || 0,
        'audit_endpoint': model.auditEndpoint,
        'player_configs': model.playerConfigs,
        'iterations': model.iterations,
      }
    ]);
  }
}
