library dartmuti.app;

import 'package:angular2/angular2.dart' show Component, View;
import 'package:angular2/router.dart'
    show ROUTER_DIRECTIVES, Route, RouteConfig, RouteParams;
import 'package:dartmuti/components/tabletop.component.dart'
    show TabletopComponent;
import 'package:dartmuti/components/settings.component.dart'
    show SettingsComponent;

@Component(
    selector: 'app',
    templateUrl: 'app.component.html',
    directives: const [ROUTER_DIRECTIVES,])
@RouteConfig(const [
  const Route(
      path: '/tabletop',
      name: 'Tabletop',
      component: TabletopComponent,
      useAsDefault: true),
  const Route(path: '/settings', name: 'Settings', component: SettingsComponent)
])
class AppComponent {}
