import 'package:area_control/core/utils/colors.dart';
import 'package:area_control/core/utils/consts.dart';
import 'package:area_control/core/utils/enums.dart';
import 'package:area_control/models/stops.model.dart';
import 'package:area_control/utils/headline.dart';
import 'package:area_control/views/area/provider/area_controller.dart';
import 'package:area_control/views/home/controller/home_controller.dart';
import 'package:area_control/views/stops/controller/stop_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../stops/utils/stop_dialog.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key, required this.child});

  final Widget child;

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
                  builder: (context) {
                    return FlutterMap(
                      mapController: controller.mapController,
                      options: MapOptions(
                        initialZoom: 10.5,
                        initialCenter: const LatLng(17.417547, 78.475196),
                        onTap: (tapPosition, point) {
                          controller.onTapPoint.value = point;
                          stopCrtl.onTapMap(tapPosition, point);
                          areaCrtl.addSelectionIntoPolygon(point);
                        },
                        onPointerHover: (event, point) {
                          controller.curcerPosition.value = event.localPosition;
                          areaCrtl.updatePolyPoint(point);
                          stopCrtl.updateStopLocation(point);
                        },
                        onPositionChanged: (camera, hasGesture) {
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
                        if (controller.currentTab == DashboardTabs.stops) ...stopWidgets()
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
                  StopsModel _stop = stopCrtl.stopLst[index];
                  return Marker(
                    point: _stop.geo!.coordinates,
                    child: InkWell(
                        onTap: () {
                          stopCrtl.stop.value = _stop;
                          stopCrtl.tapPosition.value = controller.curcerPosition.value;
                        },
                        onDoubleTap: () {
                          if (stopCrtl.updateIndex.value != null) {
                            stopCrtl.clearStop();
                          } else {
                            stopCrtl.updateIndex.value = index;
                          }
                        },
                        child: Tooltip(
                            message: _stop.name,
                            child: Icon(Icons.location_on_rounded, color: _stop.id == stop?.id ? Colors.redAccent : Colors.blue))),
                  );
                },
              )
            ],
          );
        },
      )
    ];
  }
}

// LatLng(latitude:17.417547, longitude:78.475196)
// LatLngBounds(north: 17.668432034515472, south: 17.16766986786664, east: 78.8333342030127, west: 78.11567658044899)
