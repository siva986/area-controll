import 'package:area_control/core/routes/routes.dart';
import 'package:area_control/core/services/navigator/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: MaterialApp.router(
        title: 'Night Mode Controls',
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        builder: (context, child) {
          NavigatorService.globalContext = context;
          return child!;
        },
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.white), scaffoldBackgroundColor: const Color(0XFF111827)),
        routerConfig: AppRoute(context: context).routers,
      ),
    );
  }
}
