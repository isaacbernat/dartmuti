import 'package:angular2/angular2.dart' show provide;
import 'package:angular2/bootstrap.dart' show bootstrap;
import 'package:angular2/router.dart' show APP_BASE_HREF, ROUTER_PROVIDERS;

import 'package:dartmuti/components/app.component.dart' show AppComponent;

main() {
  bootstrap(AppComponent, [
    // routing
    ROUTER_PROVIDERS,
    provide(APP_BASE_HREF, useValue: '/')
  ]);
}
