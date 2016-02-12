import 'package:angular2/angular2.dart';
import 'tabletop.dart';
import 'trick_component.dart';
import 'card_component.dart';

@Component(
    selector: 'dartmuti-tabletop',
    templateUrl: 'tabletop_component.html',
    directives: const [NgFor, NgIf, TrickComponent, CardComponent])
class TabletopComponent {
  Tabletop model;
  TabletopComponent() {
    model = new Tabletop('Test state');
    model.init();
  }
}
