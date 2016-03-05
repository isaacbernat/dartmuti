library dartmuti.app;

import 'package:angular2/angular2.dart' show Component, View;
import 'package:angular2/router.dart'
    show ROUTER_DIRECTIVES, Route, RouteConfig, RouteParams;
import 'package:dartmuti/components/tabletop.component.dart'
    show TabletopComponent;

@Component(
    selector: 'app',
    template: '''
    <section class="dartmuti">
      <router-outlet></router-outlet>
    </section>
    ''',
    directives: const [ROUTER_DIRECTIVES,])
@RouteConfig(
    const [const Route(path: '/:settings', component: TabletopComponent)])
class AppComponent {}
