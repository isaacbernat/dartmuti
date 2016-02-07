import 'package:angular2/angular2.dart';
import 'tabletop.dart';
const List<String> _cards = const [
  '1',
  '2',
  '2',
  '3'
];
@Component(
    selector: 'dartmuti-tabletop',
    templateUrl: 'tabletop_component.html',
    directives: const [NgFor, NgIf])
class TabletopComponent {
  List<String> get cards => _cards;
  Tabletop model = new Tabletop('Test state', [4, 4,], [[4, 4], [3, 3]]);
}
