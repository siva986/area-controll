import 'package:area_control/core/utils/colors.dart';
import 'package:area_control/core/utils/enums.dart';
import 'package:area_control/models/bus.model.dart';
import 'package:area_control/utils/headline.dart';
import 'package:area_control/views/bus/controller/bus_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/state_manager.dart';

import 'existed_buses.dart';

class AddBusWidget extends GetView<BusController> {
  const AddBusWidget({super.key});

  BusModel? get route => controller.busDetails.value;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (route == null) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: 100,
          left: 30,
          child: Stack(
            children: [
              Container(
                width: 300,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Headline(
                        "Bus Route Details",
                        size: 14,
                      ),
                    ),
                    const Gap(20),
                    TextField(
                      controller: TextEditingController(text: route!.name),
                      style: const TextStyle(color: appWhite, fontSize: 18, fontWeight: FontWeight.w900),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '222A',
                        suffix: Obx(() {
                          return InkWell(
                            onTap: () {},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (controller.isChecking.value)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                if (!controller.isChecking.value)
                                  if (controller.existingBuses.isEmpty) const Icon(Icons.check_circle, color: Colors.green, size: 22),
                                if (controller.existingBuses.isNotEmpty)
                                  const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.green, size: 22),
                              ],
                            ),
                          );
                        }),
                        suffixIconConstraints: const BoxConstraints(maxWidth: 20, maxHeight: 20),
                      ),
                      onEditingComplete: () {
                        controller.checkExistance().then((e) {
                          if (controller.existingBuses.isNotEmpty) {
                            showExistedBuses(context).then((value) {
                              if (value != null) {
                                controller.busDetails.value = value;
                              }
                            });
                          }
                        });
                      },
                      onChanged: (value) {
                        route!.name = value;
                      },
                    ),
                    const Gap(12),
                    TextField(
                      controller: TextEditingController(text: route!.description),
                      style: const TextStyle(color: appWhite, fontSize: 13),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration.collapsed(hintText: "Description ..."),
                      onChanged: (value) {
                        route!.description = value;
                      },
                    ),
                    const Gap(20),
                    GetBuilder<BusController>(
                      id: "busType",
                      builder: (context) {
                        return Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: List.generate(
                            BusType.values.length,
                            (index) {
                              final variant = BusType.values[index];
                              bool isSelected = route!.tag.contains(variant); // Example selection logic
                              return InkWell(
                                onTap: () {
                                  route!.tag = route!.tag.toList();

                                  if (isSelected) {
                                    route!.tag.remove(variant);
                                  } else {
                                    route!.tag.add(variant);
                                  }
                                  controller.update(['busType']);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(4.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.green : null,
                                    borderRadius: BorderRadius.circular(4.0),
                                    border: Border.all(color: isSelected ? Colors.transparent : Colors.grey),
                                  ),
                                  child: Headline(
                                    variant.name.toUpperCase(),
                                    size: 10,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Headline('Add Variants'),
                        InkWell(
                          onTap: () {
                            if (route!.id == "") {
                              return;
                            }
                            controller.busVariant.value = BusVariants();

                            controller.update(['variants']);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.green,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.add, size: 10, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const Gap(14),
                    GetBuilder<BusController>(
                      id: 'variants',
                      builder: (context) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 16,
                            children: [
                              ...List.generate(
                                route!.variants.length,
                                (index) {
                                  return InkWell(
                                    onTap: () {
                                      controller.busVariant.value = route!.variants[index];
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue,
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                      child: Headline("Variant ${index + 1}"),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    const Gap(20),
                    InkWell(
                      onTap: () {
                        controller.saveBus();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.green,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Headline(route!.id == "" ? "SAVE" : "UPDATE"),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    controller.busDetails.value = null;
                    controller.busVariant.value = null;
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
          ),
        );
      },
    );
  }
}
