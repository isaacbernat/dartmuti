import 'package:angular2/angular2.dart';
import 'card_component.dart';

@Component(
    selector: 'dartmuti-player',
    templateUrl: 'player_component.html',
    inputs: const ['model'],
    directives: const [CardComponent])
class PlayerComponent {
  Player model;
  PlayerComponent() {}
}
