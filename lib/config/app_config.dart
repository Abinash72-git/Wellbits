import 'package:wellbits/flavours.dart';

class AppConfig {
  static const AppConfig instance = AppConfig();
  const AppConfig();
  String get baseUrl {
    switch (F.appFlavor) {
      case null:
        return 'https://tsitfilemanager.in/vignesh/wellbits/public/api/';
      case Flavor.dev:
        return 'https://tsitfilemanager.in/vignesh/wellbits/public/api/';
      case Flavor.prod:
        return 'https://tsitfilemanager.in/vignesh/wellbits/public/api/';
      case Flavor.demo:
        return 'https://tsitfilemanager.in/vignesh/wellbits/public/api/';
    }
  }
}
