enum Flavor {
  dev,
  prod,
  demo,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Wellbits Dev';
      case Flavor.prod:
        return 'Wellbits';
      case Flavor.demo:
        return 'Wellbits Demo';
      default:
        return 'title';
    }
  }
}
