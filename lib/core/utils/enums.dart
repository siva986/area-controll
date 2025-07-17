enum AppRoutes {
  home(path: '/', pathName: "Area"),
  buses(path: '/buses', pathName: "Bus"),
  stops(path: '/stop', pathName: "stops");

  final String path;
  final String pathName;
  const AppRoutes({required this.path, required this.pathName});
}

enum DashboardTabs {
  area(route: AppRoutes.home),
  stops(route: AppRoutes.stops),
  buses(route: AppRoutes.buses);

  final AppRoutes route;
  const DashboardTabs({required this.route});
}

enum StopAlias { left, right, entrance, middle }

enum DayType {
  weekday,
  saturday,
  sunday,
  holiday,
  daily;

  static DayType fromName(String? name) {
    return DayType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => DayType.daily,
    );
  }
}

enum VariantType {
  normal,
  firstBus,
  lastBus;

  static VariantType fromName(String? name) {
    return VariantType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => VariantType.normal,
    );
  }
}

enum BusType {
  bus,
  metro,
  metroBus,
  airportBus;

  static BusType fromName(String? name) {
    return BusType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => BusType.bus,
    );
  }
}
