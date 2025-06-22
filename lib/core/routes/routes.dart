import 'package:area_control/core/services/bindings/area_binding.dart';
import 'package:area_control/core/services/bindings/home_binding.dart';
import 'package:area_control/core/utils/enums.dart';
import 'package:area_control/views/area/views/area_view.dart';
import 'package:area_control/views/home/views/home_page.dart';
import 'package:area_control/views/stops/views/stops.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoute {
  final BuildContext context;

  AppRoute({required this.context});

  bool isLogged = false;

  GoRouter get routers {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: AppRoutes.home.path,
      debugLogDiagnostics: true,
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            HomeBinding().dependencies();
            return HomePage(state: state, child: child);
          },
          routes: [
            GoRoute(
              path: AppRoutes.home.path,
              builder: (context, state) {
                AreaBinding().dependencies();
                return const Material(
                  type: MaterialType.transparency,
                  child: AreaView(),
                );
              },
            ),
            GoRoute(
              path: AppRoutes.stops.path,
              builder: (context, state) {
                AreaBinding().dependencies();
                return const Material(
                  type: MaterialType.transparency,
                  child: LocalBusStopsPage(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

// ModalBottomSheetRoute
