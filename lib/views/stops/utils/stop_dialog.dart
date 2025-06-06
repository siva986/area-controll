import 'package:area_control/core/utils/colors.dart';
import 'package:area_control/utils/headline.dart';
import 'package:area_control/views/stops/controller/stop_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class StopDialogWidget extends GetView<StopController> {
  const StopDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Headline(
              'Mode',
              size: 10,
              color: scaffoldBackgroundColor,
            ),
            Obx(() {
              return Radio(
                value: true,
                toggleable: true,
                groupValue: controller.chnageNearStops.value,
                onChanged: (value) {
                  controller.chnageNearStops.value = !controller.chnageNearStops.value;
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
