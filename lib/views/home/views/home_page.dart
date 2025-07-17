// ignore_for_file: deprecated_member_use

import 'package:area_control/core/utils/colors.dart';
import 'package:area_control/core/utils/consts.dart';
import 'package:area_control/core/utils/enums.dart';
import 'package:area_control/models/stops.model.dart';
import 'package:area_control/utils/headline.dart';
import 'package:area_control/views/area/provider/area_controller.dart';
import 'package:area_control/views/bus/controller/bus_controller.dart';
import 'package:area_control/views/home/controller/home_controller.dart';
import 'package:area_control/views/stops/controller/stop_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key, required this.child, required this.state});

  final Widget child;
  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    final areaCrtl = Get.find<AreaController>();
    final stopCrtl = Get.find<StopController>();
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                // final boundary = area?.boundary;
                GetBuilder<AreaController>(
                  id: 'polygon',
                  initState: (con) {
                    controller.initSTad(state);
                  },
                  builder: (context) {
                    return FlutterMap(
                      mapController: controller.mapController,
                      options: MapOptions(
                        initialZoom: 10.5,
                        initialCenter: const LatLng(17.417547, 78.475196),
                        onMapReady: () {
                          controller.getintialPosition();
                        },
                        onTap: (tapPosition, point) {
                          controller.onTapPoint.value = point;
                          stopCrtl.onTapMap(tapPosition, point);
                          areaCrtl.addSelectionIntoPolygon(point);
                        },
                        onPointerHover: (event, point) {
                          controller.debounceHover.call(() {
                            controller.curcerPosition.value = event.localPosition;
                            areaCrtl.updatePolyPoint(point);
                            stopCrtl.updateStopLocation(point);
                          });
                        },
                        onPositionChanged: (camera, hasGesture) {
                          controller.saveCurrentPosition(camera);
                          if (hasGesture) {
                            stopCrtl.clearStop();
                          }
                        },
                        initialCameraFit: cameraFit(),
                        interactionOptions: InteractionOptions(
                          rotationThreshold: 0,
                          rotationWinGestures: MultiFingerGesture.none,
                          cursorKeyboardRotationOptions: CursorKeyboardRotationOptions.disabled(),
                        ),
                      ),
                      children: [
                        TileLayer(urlTemplate: maplink),
                        if (controller.currentTab == DashboardTabs.area) ...areaWidgets(),
                        if (controller.currentTab == DashboardTabs.stops) ...stopWidgets(),
                        if (controller.currentTab == DashboardTabs.buses) ...busWidget(),
                      ],
                    );
                  },
                ),
                child,
                _buildTabs(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 10,
        children: List.generate(
          DashboardTabs.values.length,
          (index) {
            final dash = DashboardTabs.values[index];
            bool isSelected = dash.route.path == controller.currentTab.route.path;
            return InkWell(
              onTap: () {
                controller.changeTab(context, dash);
                if (controller.currentTab == DashboardTabs.buses) {
                  final busCrtl = Get.find<BusController>();

                  busCrtl.pageNo = 1;
                  busCrtl.getAllStops();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected ? Colors.blue.withOpacity(.5) : scaffoldBackgroundColor,
                    border: Border.all(
                      color: isSelected ? Colors.blue : scaffoldBackgroundColor,
                    )),
                child: Headline(
                  dash.route.pathName.toUpperCase(),
                  fontWeight: FontWeight.w900,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  CameraFit cameraFit() {
    return CameraFit.bounds(
      bounds: LatLngBounds(
        const LatLng(17.72971773607094, 79.16855897989056),
        const LatLng(17.105605258392135, 77.78092077567123),
      ),
    );
  }

  List<Widget> areaWidgets() {
    final areaCrtl = Get.find<AreaController>();
    final area = areaCrtl.newArea.value;
    return [
      if (area != null) ...[
        PolygonLayer(
          polygons: area.boundary!.coordinates.where((poly) => poly.isNotEmpty).map(
            (poly) {
              return Polygon(
                points: poly,
                color: Colors.green.withOpacity(0.3),
                borderColor: Colors.green,
                borderStrokeWidth: 2,
                label: area.name,
                strokeCap: StrokeCap.round,
                labelPlacement: PolygonLabelPlacement.polylabel,
              );
            },
          ).toList(),
        ),
      ],
      if (area != null && areaCrtl.isEditable.value)
        if (area.boundary != null) ...[
          ...List.generate(
            area.boundary!.coordinates.length,
            (polyindex) {
              final vv = area.boundary!.coordinates[polyindex];
              return MarkerLayer(
                markers: List.generate(
                  vv.length,
                  (latlng) {
                    return Marker(
                      point: vv[latlng],
                      width: 20,
                      height: 20,
                      child: InkWell(
                        onTap: () {
                          if (areaCrtl.selectedPolyIndex.value != null) {
                            areaCrtl.selectedLatlngIndex.value = latlng;
                          } else {
                            areaCrtl.selectedLatlngIndex.value = null;
                          }
                          areaCrtl.update(['polygon']);
                        },
                        onDoubleTap: () {
                          areaCrtl.selectedLatlngIndex.value = null;
                          areaCrtl.update(['polygon']);
                        },
                        child: Obx(
                          () {
                            return Icon(
                              Icons.circle,
                              color: areaCrtl.selectedLatlngIndex.value == latlng ? Colors.deepOrangeAccent : Colors.green,
                              size: 10,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ]
    ];
  }

  List<Widget> stopWidgets() {
    final stopCrtl = Get.find<StopController>();
    return [
      // Obx(() {
      //   final stopMap = {for (var stop in stopCrtl.stopLst) stop.id: stop};
      //   final List<Polyline> polylines = [];
      //   for (var stop in stopCrtl.stopLst) {
      //     final fromCoords = stop.geo!.coordinates;
      //     for (var nearId in stop.nearStops) {
      //       final nearStop = stopMap[nearId];
      //       if (nearStop != null) {
      //         final toCoords = nearStop.geo!.coordinates;
      //         // Optional: avoid duplicate A-B and B-A
      //         if (stop.id.compareTo(nearId) < 0) {
      //           polylines.add(Polyline(
      //             points: [fromCoords, toCoords],
      //             color: stop.id == stopCrtl.stop.value?.id ? Colors.green : Colors.teal,
      //             strokeWidth: 4,
      //           ));
      //         }
      //       }
      //     }
      //   }
      //   return PolylineLayer(
      //     polylines: polylines,
      //   );
      // }),
      Obx(() {
        StopsModel? stop = stopCrtl.stop.value;

        if (stop == null || stop.geo == null) {
          return const SizedBox.shrink();
        }

        final vv = stopCrtl.stopLst.where((element) => stop.nearStops.contains(element.id)).toList();

        return PolylineLayer(
          polylines: [
            ...vv.map((e) => Polyline(
                  points: [e.geo!.coordinates, stop.geo!.coordinates],
                  color: Colors.green,
                  strokeWidth: 4,
                ))
          ],
        );
      }),
      Obx(
        () {
          StopsModel? stop = stopCrtl.stop.value;
          return MarkerLayer(
            markers: [
              if (stop != null && stop.geo != null)
                if (stop.id.isEmpty)
                  Marker(
                    point: stop.geo!.coordinates,
                    child: const Icon(Icons.circle_rounded, color: Colors.blue),
                  ),
              ...List.generate(
                stopCrtl.stopLst.length,
                (index) {
                  StopsModel stop0 = stopCrtl.stopLst[index];
                  return Marker(
                    width: 12,
                    height: 12,
                    point: stop0.geo!.coordinates,
                    child: InkWell(
                      onTap: () {
                        stopCrtl.stop.value = stop0;
                        stopCrtl.tapPosition.value = controller.curcerPosition.value;
                      },
                      onDoubleTap: () {
                        if (stopCrtl.chnageNearStops.value) {
                          stopCrtl.selectNearBy(stop0);
                        } else {
                          if (stopCrtl.updateIndex.value != null) {
                            stopCrtl.clearStop();
                          } else {
                            stopCrtl.updateIndex.value = index;
                          }
                        }
                      },
                      child: Tooltip(
                        triggerMode: TooltipTriggerMode.longPress,
                        message: stop0.name,
                        child: LocationIcon(
                          color: stop0.id == stop?.id
                              ? Colors.redAccent
                              : stop?.nearStops.contains(stop0.id) == true
                                  ? Colors.green
                                  : null,
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    ];
  }

  List<Widget> busWidget() {
    final busCrtl = Get.find<BusController>();
    return [
      GetBuilder<BusController>(
        id: 'busMarker',
        builder: (context) {
          final busVariant = busCrtl.busVariant.value;
          if (busVariant?.stops.isEmpty ?? true) return const SizedBox.shrink();

          // Map for faster lookup
          final stopMap = {for (var stop in busCrtl.stopLst) stop.id: stop};

          final stopPoints = <LatLng>[];
          for (var stopRef in busVariant!.stops) {
            final stop = stopMap[stopRef.id];
            if (stop?.geo?.coordinates != null) {
              stopPoints.add(stop!.geo!.coordinates);
            }
          }

          if (stopPoints.isEmpty) return const SizedBox.shrink();

          return PolylineLayer(
            polylines: [
              Polyline(
                points: stopPoints,
                color: Colors.red,
                strokeWidth: 4,
              ),
            ],
          );
        },
      ),
      Obx(
        () {
          if (busCrtl.busVariant.value != null) {
            return MarkerLayer(
              markers: [
                ...List.generate(
                  busCrtl.stopLst.length,
                  (index) {
                    StopsModel stop0 = busCrtl.stopLst[index];
                    return Marker(
                      width: 10,
                      height: 10,
                      point: stop0.geo!.coordinates,
                      child: GetBuilder<BusController>(
                          id: 'busMarker',
                          builder: (context) {
                            bool isSelected = busCrtl.busVariant.value?.stops.any((e) => e.id == stop0.id) == true;
                            return InkWell(
                              onTap: () {
                                if (busCrtl.busVariant.value != null) {
                                  if (busCrtl.isShiftPressed.value) {
                                    busCrtl.busVariant.value!.stops = busCrtl.busVariant.value!.stops.toList();

                                    if (busCrtl.busVariant.value!.stops.any((e) => e.id != stop0.id)) {
                                      busCrtl.busVariant.value!.stops.add(stop0);
                                    }
                                    if (busCrtl.busVariant.value!.stops.isEmpty) {
                                      busCrtl.busVariant.value!.stops.add(stop0);
                                    }

                                    busCrtl.update(['busMarker']);
                                    print(busCrtl.busVariant.value!.stops);
                                  }
                                }
                              },
                              onDoubleTap: () {
                                busCrtl.busVariant.value!.stops = busCrtl.busVariant.value!.stops.toList();
                                busCrtl.busVariant.value!.stops.removeWhere((e) => e.id == stop0.id);
                                busCrtl.update(['busMarker']);
                              },
                              child: Tooltip(
                                triggerMode: TooltipTriggerMode.longPress,
                                message: stop0.name,
                                child: LocationIcon(
                                  color: isSelected ? Colors.redAccent : null,
                                ),
                              ),
                            );
                          }),
                    );
                  },
                )
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ];
  }
}

class LocationIcon extends StatelessWidget {
  const LocationIcon({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color ?? Colors.green,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.deepOrange, width: 2),
      ),
    );
  }
}
