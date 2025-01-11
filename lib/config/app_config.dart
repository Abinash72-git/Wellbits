import 'package:wellbits/flavours.dart';

class AppConfig {
  static const AppConfig instance = AppConfig();
  const AppConfig();
  String get baseUrl {
    switch (F.appFlavor) {
      case null:
        return 'https://tabsquareinfotech.com/App/Abinesh_be_work/tsit_farms/public/api/';
      case Flavor.dev:
        return 'https://tabsquareinfotech.com/App/Abinesh_be_work/tsit_farms/public/api/';
      case Flavor.prod:
        return 'https://tabsquareinfotech.com/App/Abinesh_be_work/tsit_farms/public/api/';
      case Flavor.demo:
        return 'https://tabsquareinfotech.com/App/Abinesh_be_work/tsit_farms/public/api/';
    }
  }
}
