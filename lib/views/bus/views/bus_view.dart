import 'package:area_control/core/utils/colors.dart';
import 'package:area_control/models/bus.model.dart';
import 'package:area_control/utils/headline.dart';
import 'package:area_control/views/bus/controller/bus_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';

import '../utils/add_bus_widget.dart';
import '../utils/add_variant.dart';
import '../utils/all_routes.dart';

class BusesPage extends GetView<BusController> {
  const BusesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: controller.focusNode,
      autofocus: true,
      onKeyEvent: (value) {
        if (value is KeyDownEvent) {
          if (value.logicalKey == LogicalKeyboardKey.shiftLeft) {
            print(value);
            controller.isShiftPressed.value = true;
          }
        }
        if (value is KeyUpEvent) {
          if (value.logicalKey == LogicalKeyboardKey.shiftLeft) {
            controller.isShiftPressed.value = false;
          }
        }
      },
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      controller.busDetails.value = BusModel();
                    },
                    child: const Icon(Icons.add, size: 10, color: scaffoldBackgroundColor),
                  ),
                  const Headline(
                    450,
                    size: 10,
                    color: scaffoldBackgroundColor,
                  ),
                ],
              ),
            ),
          ),
          const AddBusWidget(),
          const BusVariantWidget(),
          const AllRoutesWidget(),
        ],
      ),
    );
  }
}
