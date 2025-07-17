import 'package:area_control/utils/headline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/colors.dart';
import '../controller/bus_controller.dart';

class AllRoutesWidget extends GetView<BusController> {
  const AllRoutesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: 0,
      child: Obx(() {
        if (!controller.isLstOpened.value) {
          return InkWell(
            onTap: () {
              controller.isLstOpened.value = !controller.isLstOpened.value;
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: appWhite,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Headline(
                    'All Routes',
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          );
        }
        if (controller.busDetails.value != null || controller.busVariant.value != null) {
          return const SizedBox.shrink();
        }
        return Stack(
          children: [
            Container(
              width: 310,
              margin: const EdgeInsets.only(right: 30, top: 5, left: 5),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: GetBuilder<BusController>(
                id: 'busList',
                initState: (state) {
                  controller.getBuses(true);
                },
                builder: (_) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        style: const TextStyle(
                          color: appWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration.collapsed(hintText: "Search ..."),
                        onChanged: (value) {
                          controller.searchQuery = value.trim().toLowerCase();
                          // controller.onSearch(value);
                        },
                        onSubmitted: (value) {
                          controller.getBuses(true);
                        },
                      ).paddingSymmetric(horizontal: 14, vertical: 8),
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 500),
                          child: Obx(() {
                            if (controller.busesLst.isEmpty) {
                              return const Center(child: Headline("No-Buses Available"));
                            }
                            return Expanded(
                              child: NotificationListener(
                                onNotification: (notification) {
                                  if (notification is ScrollEndNotification && notification.metrics.atEdge) {
                                    controller.getBuses(false);
                                    return true;
                                  }
                                  return false;
                                },
                                child: ListView.builder(
                                  itemCount: controller.busesLst.length,
                                  itemBuilder: (context, index) {
                                    final route = controller.busesLst[index];
                                    return Obx(() {
                                      final isSelected = controller.busDetails.value?.id == route.id;
                                      return ListTile(
                                        shape: isSelected
                                            ? RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                side: const BorderSide(color: Colors.green, width: 1),
                                              )
                                            : null,
                                        title: Headline(route.name),
                                        subtitle: Headline(route.description, size: 10, color: Colors.grey),
                                        onTap: () {
                                          controller.getBus(route.id);
                                          // controller.busDetails.value = route;
                                        },
                                      );
                                    });
                                  },
                                ),
                              ),
                            );
                          })),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: InkWell(
                onTap: () {
                  controller.isLstOpened.value = !controller.isLstOpened.value;
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
      }),
    );
  }
}
