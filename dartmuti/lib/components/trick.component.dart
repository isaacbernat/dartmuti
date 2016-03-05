library dartmuti.component.trick;

import 'package:angular2/angular2.dart';
import 'package:dartmuti/components/card.component.dart';
import 'package:dartmuti/models/trick.dart';

@Component(
    selector: 'dartmuti-trick',
    templateUrl: 'trick.component.html',
    inputs: const ['model'],
    directives: const [CardComponent])
class TrickComponent {
  Trick model;
  TrickComponent() {}
}
