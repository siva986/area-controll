import 'package:area_control/views/area/provider/area_controller.dart';
import 'package:area_control/views/bus/controller/bus_controller.dart';
import 'package:area_control/views/home/controller/home_controller.dart';
import 'package:area_control/views/stops/controller/stop_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AreaController>(() => AreaController());
    Get.lazyPut<StopController>(() => StopController());
    Get.lazyPut<BusController>(() => BusController());
  }
}
