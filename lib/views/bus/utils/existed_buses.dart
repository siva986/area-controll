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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    constraints: const BoxConstraints(
      maxHeight: 500,
      minWidth: 300,
      maxWidth: 300,
    ),
    elevation: 2,
    menuPadding: EdgeInsets.zero,
    items: [
      PopupMenuItem(
        enabled: false,
        child: GetBuilder<BusController>(
          builder: (crtl) {
            return Obx(() {
              return Stack(
                children: [
                  SizedBox(
                    width: 300,
                    child: Column(
                      spacing: 5,
                      children: [
                        const Gap(20),
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
                                margin: const EdgeInsets.symmetric(vertical: 5),
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
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        crtl.existingBuses.clear();
                        Navigator.pop(context);
                      },
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.close, size: 14, color: Colors.red)),
                    ),
                  ),
                ],
              );
            });
          },
        ),
        onTap: () {},
      ),
    ],
  );
}
