import 'package:area_control/core/utils/colors.dart';
import 'package:area_control/core/utils/images.dart';
import 'package:area_control/models/area.model.dart';
import 'package:area_control/utils/common_image.dart';
import 'package:area_control/utils/headline.dart';
import 'package:area_control/views/area/provider/area_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
// import 'package:latlong2/latlong.dart';

class AreaView extends GetView<AreaController> {
  const AreaView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AreaController>(
      initState: (state) {
        controller.getArea(true);
      },
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [ 
                  _buildPolygons(),
                  _buildListofAreas(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPolygons() {
    return GetBuilder<AreaController>(
        id: 'polygon',
        builder: (__) {
          final area = controller.newArea.value;
          if (!controller.isEditable.value) {
            return const SizedBox.shrink();
          }
          if (area == null) {
            return const SizedBox.shrink();
          }
          if (area.boundary!.coordinates.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            width: 75,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 30),
            decoration: const BoxDecoration(
                color: scaffoldBackgroundColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16))),
            child: Column(
              children: [
                Expanded(
                  child: ReorderableListView.builder(
                    itemCount: area.boundary!.coordinates[controller.selectedPolyIndex.value!].length,
                    onReorder: (oldIndex, newIndex) {
                      // setState(() {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final item = area.boundary!.coordinates[controller.selectedPolyIndex.value!].removeAt(oldIndex);
                      area.boundary!.coordinates[controller.selectedPolyIndex.value!].insert(newIndex, item);
                      controller.update(['polygon']);
                      // });
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        key: ValueKey(index),
                        onTap: () {
                          controller.selectedLatlngIndex.value = index;
                        },
                        child: Obx(() {
                          final isSelected = index == controller.selectedLatlngIndex.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: Colors.white12),
                              color: isSelected ? Colors.blue.withOpacity(.5) : null,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                            child: Headline(index + 1),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildListofAreas() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 350, minWidth: 200),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Headline(
                "Area Control",
                size: 14,
                fontWeight: FontWeight.bold,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    style: const TextStyle(color: appWhite, fontSize: 12),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration.collapsed(hintText: "Search ..."),
                    onChanged: (value) {
                      controller.onSearch(value);
                    },
                  ),
                ),
              ),
              Obx(
                () {
                  if ((controller.newArea.value == null || !controller.isEditable.value) && controller.areaLst.isEmpty) {
                    return InkWell(
                      onTap: () {
                        controller.createArea();
                      },
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              )
            ],
          ),
          Obx(
            () {
              if (controller.newArea.value != null && controller.isEditable.value) {
                return _buildNewAreaTitle();
              } else {
                return const SizedBox();
              }
            },
          ),
          Expanded(
              child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollEndNotification && notification.metrics.atEdge) {
                controller.getArea(false);
                return true;
              }
              return false;
            },
            child: Obx(() {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    ...List.generate(
                      controller.areaLst.length,
                      (index) {
                        AreaModel area = controller.areaLst[index];
                        if (controller.newArea.value != null && area.id == controller.newArea.value!.id && controller.isEditable.value) {
                          return const SizedBox.shrink();
                        }
                        return InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          onTap: () {
                            controller.setPolygones(index);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white24),
                              color: area.id == controller.newArea.value?.id ? Colors.blue.withOpacity(.8) : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Headline(area.name, size: 12)),
                                InkWell(
                                  onTap: () {
                                    controller.setPolygones(index);
                                    controller.isEditable.value = true;
                                  },
                                  child: const Icon(
                                    Icons.edit_rounded,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                                ),
                                const Gap(10),
                                InkWell(
                                  onTap: () {
                                    controller.deleteArea(index);
                                  },
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
          ))
        ],
      ),
    );
  }

  Widget _buildNewAreaTitle() {
    final area = controller.newArea.value;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: EditableText(
                  controller: TextEditingController(text: controller.newArea.value!.name),
                  focusNode: FocusNode(),
                  style: const TextStyle(color: appWhite, fontSize: 14),
                  cursorColor: Colors.white,
                  onChanged: (value) {
                    controller.newArea.value!.name = value;
                  },
                  backgroundCursorColor: Colors.white,
                ),
              ),
              InkWell(
                onTap: () {
                  area!.boundary!.coordinates = area.boundary!.coordinates.toList();
                  area.boundary!.coordinates.add([]);
                  controller.selectedPolyIndex.value = area.boundary!.coordinates.length - 1;
                  controller.update(['coordinates', 'polygon']);
                },
                child: const Icon(Icons.polyline_rounded, color: Colors.white, size: 18),
              ),
              const Gap(10),
              InkWell(
                onTap: () {
                  controller.saveArea();
                },
                child: const Icon(Icons.done_all_rounded, color: Colors.green, size: 18),
              ),
              const Gap(10),
              InkWell(
                onTap: () {
                  controller.newArea.value = null;
                  controller.isEditable.value = !controller.isEditable.value;

                  controller.update(['polygon']);
                },
                child: const Icon(Icons.cancel, color: Colors.red, size: 18),
              ),
            ],
          ),
          const Gap(10),
          GetBuilder<AreaController>(
            id: 'coordinates',
            builder: (_) {
              List<List<LatLng>> boundries = area!.boundary!.coordinates;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8,
                  children: [
                    ...List.generate(
                      boundries.length,
                      (index) {
                        final poly = boundries[index];

                        return Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                controller.selectedPolyIndex.value = index;
                              },
                              child: GetBuilder<AreaController>(
                                id: 'polygon',
                                builder: (context) {
                                  final isSelected = controller.selectedPolyIndex.value == index;
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.white),
                                      color: isSelected ? Colors.white12 : null,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                    margin: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.polyline_rounded, color: Colors.white, size: 12),
                                        const Gap(5),
                                        Headline(poly.length, size: 12, color: Colors.white),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    boundries.removeAt(index);
                                    controller.newArea.refresh();
                                  },
                                  child: const CustomImage(AppIcons.closedFill, width: 12, color: Colors.orange),
                                )),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
