import 'package:area_control/core/routes/routes.dart';
import 'package:flutter/material.dart';

class NavigatorService {
  static final NavigatorService _instance = NavigatorService._internal();
  factory NavigatorService() {
    return _instance;
  }

  NavigatorService._internal();

  static late BuildContext globalContext;

  static BuildContext? get currentContext {
    return rootNavigatorKey.currentContext;
  }
}
