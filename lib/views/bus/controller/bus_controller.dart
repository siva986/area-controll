import 'package:area_control/models/bus.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repos/bus_repo.dart' show BusRepo;

class BusController extends GetxController {
  final FocusNode focusNode = FocusNode();

  Rxn<BusModel> busDetails = Rxn<BusModel>();

  final BusRepo busRepo = BusRepo();

  Rxn<BusVariants> busVariant = Rxn<BusVariants>();

  Rx<Offset> variantOffset = const Offset(200, 150).obs;

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
}
