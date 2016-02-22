import 'package:angular2/angular2.dart';
import 'card.dart';

@Component(
    selector: 'dartmuti-card',
    templateUrl: 'card_component.html',
    inputs: const ['model'],
    directives: const [
      NgClass,
      ]
    )
class CardComponent {
  Card model;
  CardComponent() {}
}
