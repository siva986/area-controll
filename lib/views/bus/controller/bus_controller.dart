import 'package:area_control/models/bus.model.dart';
import 'package:area_control/models/stops.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repos/bus_repo.dart' show BusRepo;
import '../../../repos/stop_repo.dart';

class BusController extends GetxController {
  final FocusNode focusNode = FocusNode();

  Rxn<BusModel> busDetails = Rxn<BusModel>();

  final BusRepo busRepo = BusRepo();

  Rxn<BusVariants> busVariant = Rxn<BusVariants>();

  Rx<Offset> variantOffset = const Offset(200, 150).obs;

  RxBool isLstOpened = false.obs;

  Future<void> saveBus() {
    if (busDetails.value == null) throw Exception("Bus details are not set");
    return busRepo.saveBus(busDetails.value!).then((res) {
      busDetails.value = null;
      isChecking.value = false;
      existingBuses.clear();
    });
  }

  RxBool isChecking = false.obs;

  RxList<BusModel> existingBuses = <BusModel>[].obs;

  final StopRepo _repo = StopRepo();

  Future<void> checkExistance() {
    isChecking.value = true;
    return busRepo.checkExistance(query: busDetails.value?.name ?? "").then((res) {
      existingBuses.value = res;
    }).catchError((c) {
      existingBuses.clear();
    }).whenComplete(() {
      isChecking.value = false;
    });
  }

  RxBool isLoading = false.obs;

  RxList<BusModel> busesLst = <BusModel>[].obs;
  String searchQuery = "";

  RxBool isShiftPressed = false.obs;

  int pageNo = 1;
  int pageSize = 10;
  int totalCount = 0;

  getBuses(bool isFirst) {
    if (isFirst) {
      busesLst.clear();
      pageNo = 0;
      isLoading.value = false;
    }
    if (totalCount > 0 && busesLst.length >= totalCount) {
      return;
    }
    isLoading.value = true;
    pageNo++;
    var parms = {"query": searchQuery, "pageNo": pageNo, "pageSize": pageSize};
    busRepo.getAllBuses(parms).then((res) {
      totalCount = res.paginaton!.totalCount;
      final List<BusModel> data = List.from((res.data as List).map((ee) => BusModel.fromJson((ee))));
      if (isFirst) {
        busesLst.value = data;
      } else {
        busesLst.addAll(data);
      }
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  RxList<StopsModel> stopLst = <StopsModel>[].obs;

  int _pageNo = 1;
  final int _pageSize = 50;
  int _totalCount = 0;

  getAllStops() {
    return _repo.getAllArea(pageNo: _pageNo, pageSize: _pageSize).then((res) {
      _totalCount = res.paginaton!.totalCount;
      stopLst.addAll((res.data as List).map((e) => StopsModel.fromJson(e)).toList());
      return res.data;
    }).then((v) {
      if ((v as List).isEmpty) {
        pageNo = 1;
        return null;
      }
      if (stopLst.length != _totalCount) {
        _pageNo++;
        return getAllStops();
      } else {
        pageNo = 1;
        return null;
      }
    });
  }
}
