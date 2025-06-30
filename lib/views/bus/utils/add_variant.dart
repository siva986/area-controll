import 'package:area_control/core/utils/colors.dart';
import 'package:area_control/core/utils/enums.dart';
import 'package:area_control/models/bus.model.dart';
import 'package:area_control/utils/headline.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../controller/bus_controller.dart';

class BusVariantWidget extends GetView<BusController> {
  const BusVariantWidget({super.key});

  BusVariants? get busVariant => controller.busVariant.value;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (busVariant == null) {
          return const SizedBox.shrink();
        } else {
          return Positioned(
            top: controller.variantOffset.value.dy,
            left: controller.variantOffset.value.dx,
            child: Stack(
              children: [
                Container(
                  width: 320,
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 14,
                    children: [
                      const Center(child: Headline('Add Bus Variant', size: 14)),
                      GetBuilder<BusController>(
                          id: "time",
                          builder: (_) {
                            return Row(
                              spacing: 10,
                              children: [
                                const Headline('From', size: 14),
                                InkWell(
                                  onTap: () {
                                    selectTime(context, busVariant!.fromTime).then((res) {
                                      busVariant!.fromTime = res;
                                      controller.update(['time']);
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(4.0),
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Headline(busVariant!.fromTime?.format(context) ?? "Start Time"),
                                  ),
                                ),
                                const Headline('To', size: 14),
                                InkWell(
                                  onTap: () {
                                    selectTime(context, busVariant!.toTime).then((res) {
                                      busVariant!.toTime = res;
                                      controller.update(['time']);
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(4.0),
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Headline(busVariant!.toTime?.format(context) ?? "End Time"),
                                  ),
                                ),
                              ],
                            );
                          }),
                      TextField(
                        controller: TextEditingController(text: busVariant!.frequency.toString()),
                        style: const TextStyle(color: appWhite, fontSize: 13),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration.collapsed(hintText: "Frequency ..."),
                        onChanged: (value) {
                          busVariant!.frequency = int.tryParse(value) ?? 5;
                        },
                      ),
                      GetBuilder<BusController>(
                        id: "dayType",
                        builder: (context) {
                          return Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: List.generate(
                              DayType.values.length,
                              (index) {
                                final variant = DayType.values[index];
                                bool isSelected = variant == busVariant!.dayType; // Example selection logic
                                return InkWell(
                                  onTap: () {
                                    controller.busVariant.value!.dayType = variant;
                                    controller.update(['dayType']);
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
                      GetBuilder<BusController>(
                        id: "type",
                        builder: (context) {
                          return Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: List.generate(
                              VariantType.values.length,
                              (index) {
                                final type = VariantType.values[index];
                                bool isSelected = type == busVariant!.type; // Example selection logic
                                return InkWell(
                                  onTap: () {
                                    controller.busVariant.value!.type = type;
                                    controller.update(['type']);
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
                                      type.name.toUpperCase(),
                                      size: 10,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      InkWell(
                        onTap: () {
                          // controller.saveStop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.green,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Headline("UPDATE"),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: InkWell(
                    mouseCursor: SystemMouseCursors.grab,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        controller.variantOffset.value += details.delta;
                      },
                      child: const Icon(
                        Icons.drag_indicator_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<TimeOfDay?> selectTime(BuildContext context, TimeOfDay? initialTime) {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green,
            colorScheme: const ColorScheme.light(primary: Colors.green),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
