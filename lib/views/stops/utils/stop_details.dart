import 'package:area_control/core/utils/colors.dart';
import 'package:area_control/core/utils/enums.dart';
import 'package:area_control/models/stops.model.dart';
import 'package:area_control/utils/headline.dart';
import 'package:area_control/views/stops/controller/stop_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class StopDetails extends GetView<StopController> {
  const StopDetails({super.key});

  @override
  Widget build(BuildContext context) {
    StopsModel stop = controller.stop.value!;
    return Stack(
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            controller.tapPosition.value = details.globalPosition;
          },
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: scaffoldBackgroundColor,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Headline(stop.name == "" ? "Add Stop" : "Edit Stop"),
                    GetBuilder<StopController>(
                      id: 'switch',
                      builder: (_) {
                        return Transform.scale(
                          scale: .6,
                          child: Switch(
                            value: stop.live,
                            onChanged: (value) {
                              stop.live = value;
                              controller.update(['switch']);
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
                Row(
                  spacing: 8,
                  children: List.generate(
                    StopAlias.values.length,
                    (index) {
                      return GetBuilder<StopController>(
                          id: 'alias',
                          builder: (context) {
                            bool isSelected = stop.alias == StopAlias.values[index];
                            return InkWell(
                              onTap: () {
                                stop.alias = StopAlias.values[index];
                                controller.update(['alias']);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: isSelected ? Colors.blue : Colors.transparent,
                                  border: Border.all(color: Colors.blue, width: 1),
                                ),
                                child: Headline(
                                  StopAlias.values[index].name.toUpperCase(),
                                  color: appWhite,
                                  size: 10,
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: TextEditingController(text: stop.name),
                  style: const TextStyle(color: appWhite, fontSize: 14),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    hintText: "Stop Name ...",
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blue)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blue)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blue)),
                  ),
                  onSubmitted: (value) {
                    controller.saveStop();
                  },
                  onChanged: (value) {
                    stop.name = value.trim();
                  },
                ),
                TextField(
                  controller: TextEditingController(text: stop.description),
                  style: const TextStyle(color: appWhite, fontSize: 14),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    hintStyle: const TextStyle(fontSize: 12),
                    hintText: "Description",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blue)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blue)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blue)),
                  ),
                  onSubmitted: (value) {
                    controller.saveStop();
                  },
                  onChanged: (value) {
                    stop.description = value.trim();
                  },
                ),
                const Headline("Near By"),
                Row(
                  spacing: 4,
                  children: List.generate(
                    5,
                    (index) {
                      return GetBuilder<StopController>(
                          id: 'level',
                          builder: (_) {
                            bool isSelected = stop.level == index;
                            return InkWell(
                              onTap: () {
                                stop.level = index;
                                controller.update(['level']);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: isSelected ? Colors.blue : Colors.transparent,
                                  border: Border.all(color: Colors.blue, width: 1),
                                ),
                                child: Headline(
                                  index + 1,
                                  color: isSelected ? Colors.white : Colors.blue,
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.saveStop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Headline(stop.name == "" ? "SAVE" : "UPDATE"),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Positioned(
        //   child: GestureDetector(
        //       onDoubleTapDown: (details) {
        //         controller.tapPosition.value = details.globalPosition;
        //       },
        //       child: const InkWell(mouseCursor: SystemMouseCursors.grabbing, child: Icon(Icons.drag_indicator_rounded))),
        // )
      ],
    );
  }
}
