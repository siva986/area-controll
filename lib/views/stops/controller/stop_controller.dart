import 'package:area_control/core/services/app/debouncer.dart';
import 'package:area_control/models/stops.model.dart';
import 'package:area_control/repos/stop_repo.dart';
import 'package:area_control/views/area/provider/area_controller.dart';
import 'package:area_control/views/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class StopController extends GetxController {
  Rxn<StopsModel> stop = Rxn();
  Rxn<Offset> tapPosition = Rxn();
  Rxn<int> updateIndex = Rxn();

  final FocusNode focusNode = FocusNode();

  final homeCrtl = Get.find<HomeController>();
  final areaCrtl = Get.find<AreaController>();

  String query = "";
  final searchDebouncer = Debouncer(delay: const Duration(milliseconds: 2000));

  onQuery(String query) {
    if (stop.value == null) {
      this.query = this.query + query.trim().toLowerCase();

      searchDebouncer.call(() {
        stop.value = stopLst.firstWhereOrNull(
          (e) => e.name.toLowerCase().contains(this.query),
        );
        if (stop.value != null) {
          homeCrtl.mapController.move(stop.value!.geo!.coordinates, 16);
        }
        this.query = "";
      });
    }
  }

  void updateStopLocation(LatLng position) {
    if (updateIndex.value == null) return;
    var stop = stopLst[updateIndex.value!];
    stop.geo = Geo(coordinates: position);
    stopLst[updateIndex.value!] = stop;
    areaCrtl.update(['polygon']);
  }

  void onTapMap(TapPosition tapPosition, LatLng latn) {
    if (updateIndex.value != null) return;
    if (stop.value != null) {
      clearStop();
    } else {
      this.tapPosition.value = tapPosition.global;
      stop.value = StopsModel(geo: Geo(coordinates: latn));
    }
  }

  void clearStop() {
    if (!chnageNearStops.value) {
      tapPosition.value = null;
      stop.value = null;
      updateIndex.value = null;
    }
  }

  void getStops() {
    focusNode.requestFocus();
    stopLst.clear();
    _pageNo = 1;
    _pageSize = 50;
    getAllStops();
  }

  final StopRepo _repo = StopRepo();

  RxList<StopsModel> stopLst = <StopsModel>[].obs;

  saveStop() {
    _repo.saveStop(stop.value!).then((stop) {
      stopLst.add(stop);
      clearStop();
    });
  }

  int _pageNo = 1;
  int _pageSize = 50;
  int _totalCount = 0;

  getAllStops() {
    return _repo.getAllArea(pageNo: _pageNo, pageSize: _pageSize).then((res) {
      _totalCount = res.paginaton!.totalCount;
      stopLst.addAll((res.data as List).map((e) => StopsModel.fromJson(e)).toList());
    }).then((v) {
      if (stopLst.length != _totalCount) {
        _pageNo++;
        return getAllStops();
      } else {
        return null;
      }
    });
  }

  List<StopsModel> nearByStops = <StopsModel>[];
  RxBool chnageNearStops = false.obs;

  onselectQuery(StopsModel stop, int index) {
    stopLst[index].nearStops = stopLst[index].nearStops.toList();
    stopLst[index].nearStops.add(stop.id);
    stopLst.refresh();
  }
}
