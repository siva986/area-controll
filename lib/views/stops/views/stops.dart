import 'package:area_control/core/utils/colors.dart';
import 'package:area_control/utils/headline.dart';
import 'package:area_control/views/stops/controller/stop_controller.dart';
import 'package:area_control/views/stops/utils/stop_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';

import '../utils/stop_dialog.dart';

class LocalBusStopsPage extends GetView<StopController> {
  const LocalBusStopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StopController>(
      initState: (state) {
        controller.getStops();
      },
      builder: (context) {
        return Obx(
          () {
            return KeyboardListener(
              focusNode: controller.focusNode,
              autofocus: true,
              onKeyEvent: (value) {
                if (value is KeyDownEvent && value.character != null) {
                  controller.onQuery(value.character!);
                }
              },
              child: Stack(
                children: [
                  if (controller.stop.value != null && controller.tapPosition.value != null)
                    if (!controller.chnageNearStops.value)
                      Positioned(
                        left: controller.tapPosition.value!.dx,
                        top: controller.tapPosition.value!.dy,
                        child: const StopDetails(),
                      ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      color: appWhite,
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Headline(
                            controller.stopLst.length,
                            size: 10,
                            color: scaffoldBackgroundColor,
                          ),
                          if (controller.stop.value != null)
                            Headline(
                              controller.stop.value?.name,
                              size: 10,
                              color: scaffoldBackgroundColor,
                            )
                        ],
                      ),
                    ),
                  ),
                  const StopDialogWidget(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
