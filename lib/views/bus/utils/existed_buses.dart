import 'package:area_control/core/utils/colors.dart';
import 'package:area_control/utils/headline.dart';
import 'package:area_control/views/bus/controller/bus_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../models/bus.model.dart';

Future<BusModel?> showExistedBuses(BuildContext context) {
  return showMenu<BusModel>(
    position: const RelativeRect.fromLTRB(50, 200, 100, 0),
    context: context,
    color: scaffoldBackgroundColor,
    shadowColor: Colors.white,
    elevation: 2,
    menuPadding: EdgeInsets.zero,
    items: [
      PopupMenuItem(
        enabled: false,
        child: GetBuilder<BusController>(
          builder: (crtl) {
            return Obx(() {
              return Column(spacing: 5, children: [
                InkWell(onTap: () => Navigator.pop(context), child: const Headline("Close")),
                ...List.generate(
                  crtl.existingBuses.length,
                  (index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, crtl.existingBuses[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: const Color.fromARGB(255, 60, 60, 60)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          children: [
                            Headline(crtl.existingBuses[index].name),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const Gap(20),
              ]);
            });
          },
        ),
        onTap: () {},
      ),
    ],
  );
}
