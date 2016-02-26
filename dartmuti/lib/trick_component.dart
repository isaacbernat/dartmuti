import 'package:angular2/angular2.dart';
import 'trick.dart';
import 'card_component.dart';

@Component(
    selector: 'dartmuti-trick',
    templateUrl: 'trick_component.html',
    inputs: const ['model'],
    directives: const [CardComponent])
class TrickComponent {
  Trick model;
  TrickComponent() {}
}
