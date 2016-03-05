library dartmuti.component.player;

import 'package:angular2/angular2.dart';
import 'package:dartmuti/components/card.component.dart';

@Component(
    selector: 'dartmuti-player',
    templateUrl: 'player.component.html',
    inputs: const ['model'],
    directives: const [NgClass, CardComponent])
class PlayerComponent {
  Player model;
  PlayerComponent() {}
}
