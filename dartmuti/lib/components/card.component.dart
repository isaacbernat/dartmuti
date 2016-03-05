library dartmuti.component.card;

import 'package:angular2/angular2.dart';
import 'package:dartmuti/models/card.dart';

@Component(
    selector: 'dartmuti-card',
    templateUrl: 'card.component.html',
    inputs: const ['model'],
    directives: const [NgClass,])
class CardComponent {
  Card model;
  CardComponent() {}
}
