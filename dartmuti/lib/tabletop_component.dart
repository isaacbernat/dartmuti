import 'package:angular2/angular2.dart';
import 'tabletop.dart';
import 'trick_component.dart';
import 'card_component.dart';
import 'player_component.dart';
import 'deck_service.dart';

@Component(
    selector: 'dartmuti-tabletop',
    templateUrl: 'tabletop_component.html',
    providers: const [DeckService],
    directives: const [
      NgFor,
      NgIf,
      TrickComponent,
      CardComponent,
      PlayerComponent
    ])
class TabletopComponent {
  Tabletop model;
  TabletopComponent(DeckService DS) {
    model = new Tabletop('Test state');
    model.DeckService = DS;
    model.init();
  }
}
