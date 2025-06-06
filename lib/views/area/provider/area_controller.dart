import 'package:area_control/core/services/app/debouncer.dart';
import 'package:area_control/models/area.model.dart';
import 'package:area_control/repos/area_repo.dart';
import 'package:area_control/utils/loader.dart';
import 'package:area_control/views/home/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class AreaController extends GetxController {
  final AreaRepo _areaRepo = AreaRepo();

  final homeCrtl = Get.find<HomeController>();

  RxBool isLoading = false.obs;

  Rxn<AreaModel> newArea = Rxn<AreaModel>(null);

  final Debouncer searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));

  

  RxList<AreaModel> areaLst = <AreaModel>[].obs;

  int pageNo = 1;
  int pageSize = 15;
  int totalCount = 0;
  String searchQuery = "";

  onSearch(String searchQuery) {
    this.searchQuery = searchQuery;
    searchDebouncer.call(
      () {
        getArea(true);
      },
    );
  }

  getArea(bool isFirst) {
    if (isFirst) {
      areaLst.clear();
      pageNo = 0;
      isLoading.value = false;
    }
    if (totalCount > 0 && areaLst.length >= totalCount) {
      return;
    }
    isLoading.value = true;
    pageNo++;
    _areaRepo.getAllArea(pageNo: pageNo, pageSize: pageSize, query: searchQuery.trim()).then((res) {
      totalCount = res.paginaton!.totalCount;
      final List<AreaModel> data = List.from((res.data as List).map((ee) => AreaModel.fromJson((ee))));
      if (isFirst) {
        areaLst.value = data;
      } else {
        areaLst.addAll(data);
      }
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  setPolygones(int index) {
    isEditable.value = false;
    if (newArea.value == areaLst[index]) {
      newArea.value = null;
    } else {
      newArea.value = areaLst[index];
    }
    selectedPolyIndex.value = 0;
    update(['polygon']);
  }

  createArea() {
    isEditable.value = !isEditable.value;
    newArea.value = AreaModel(parentArea: "67e42b54b5df103c050cec8e", name: searchQuery.trim(), boundary: Boundary());
  }

  saveArea() {
    if (newArea.value != null) {
      if (newArea.value!.boundary == null) {
        Get.snackbar("Error", "Please select at least 3 points to create a polygon");
        return;
      }
      if (newArea.value!.boundary!.coordinates.isEmpty) {
        Get.snackbar("Error", "Please select at least 3 points to create a polygon");
        return;
      }
      loader(_areaRepo.saveArea(newArea.value!).then((res) {
        areaLst.removeWhere((element) => element.id == res.id);
        areaLst.add(res);
        newArea.value = null;
        isEditable.value = false;
        searchQuery = "";

        homeCrtl.update(['polygon']);
      }));
    }
  }

  deleteArea(int index) {
    loader(_areaRepo.deleteArea(areaLst[index].id).then((res) {
      areaLst.removeAt(index);
      newArea.value = null;
      isEditable.value = false;
      homeCrtl.update(['polygon']);
    }));
  }

  Rxn<int> selectedLatlngIndex = Rxn<int>(null);

  Rxn<int> selectedPolyIndex = Rxn<int>(null);
  RxBool isEditable = false.obs;

  deletePolyLatLng() {
    if (newArea.value != null) {
      if (newArea.value!.boundary!.coordinates.isNotEmpty) {
        List<LatLng> vv = newArea.value!.boundary!.coordinates[selectedPolyIndex.value!];
        if (selectedLatlngIndex.value != null) {
          vv.removeAt(selectedLatlngIndex.value!);
          selectedLatlngIndex.value = null;
          update(['polygon']);
        }
      }
    }
  }

  addSelectionIntoPolygon(LatLng point) {
    if (!isEditable.value) {
      return;
    }
    selectedLatlngIndex.value = null;
    if (selectedPolyIndex.value != null) {
      if (newArea.value != null) {
        if (newArea.value!.boundary!.coordinates.isNotEmpty) {
          List<LatLng> vv = newArea.value!.boundary!.coordinates[selectedPolyIndex.value!];
          if (vv.isEmpty) {
            vv.addAll([point, point, point]);
          } else {
            if (vv.first == vv[1]) {
              vv.removeAt(1);
            }
            vv.insert(vv.length - 1, point);
            // selectedLatlngIndex.value = vv.length - 2;
          }
        }
        update(['polygon']);
      }
    }
  }

  updatePolyPoint(LatLng point) {
    if (!isEditable.value) {
      return;
    }
    if (selectedPolyIndex.value != null) {
      if (newArea.value != null) {
        if (newArea.value!.boundary!.coordinates.isNotEmpty) {
          List<LatLng> vv = newArea.value!.boundary!.coordinates[selectedPolyIndex.value!];
          if (selectedLatlngIndex.value != null) {
            vv[selectedLatlngIndex.value!] = point;
            update(['polygon']);
          }
        }
      }
    }
  }
}
