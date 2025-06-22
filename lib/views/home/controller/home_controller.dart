import 'package:area_control/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class HomeController extends GetxController {
  Rx<LatLng> onTapPoint = const LatLng(0, 0).obs;
  Rxn<Offset> curcerPosition = Rxn();
  Rxn<LatLng> houerPosition = Rxn();

  final mapController = MapController();

  DashboardTabs currentTab = DashboardTabs.area;

  initSTad(GoRouterState state) {
    final path = state.matchedLocation;
    if (path == DashboardTabs.area.route.path) {
      currentTab = DashboardTabs.area;
    } else if (path == DashboardTabs.stops.route.path) {
      currentTab = DashboardTabs.stops;
    }
    update();
  }

  changeTab(BuildContext context, DashboardTabs tab) {
    currentTab = tab;
    context.go(tab.route.path);
  }
}
