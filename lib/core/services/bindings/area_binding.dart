import 'package:area_control/views/area/provider/area_controller.dart';
import 'package:get/get.dart';

class AreaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AreaController>(() => AreaController());
  }
}
