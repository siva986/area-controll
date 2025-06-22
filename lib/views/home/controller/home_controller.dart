import 'dart:convert';

import 'package:area_control/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  Rx<LatLng> onTapPoint = const LatLng(0, 0).obs;
  Rxn<Offset> curcerPosition = Rxn();
  Rxn<LatLng> houerPosition = Rxn();

  late MapController mapController;

  DashboardTabs currentTab = DashboardTabs.area;

  @override
  void onInit() {
    mapController = MapController();

    super.onInit();
  }

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

  saveCurrentPosition(MapCamera position) {
    var vv = {
      'center': [position.center.latitude, position.center.longitude],
      'zoom': position.zoom,
    };
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('init', jsonEncode(vv));
    });
  }

  getintialPosition() {
    SharedPreferences.getInstance().then((prefs) {
      String? va = prefs.getString('init');
      if (va == null) {
        return;
      }
      Map vv = jsonDecode(va);

      mapController.move(LatLng(vv['center'][0], vv['center'][1]), vv['zoom']);
    });
  }
}
