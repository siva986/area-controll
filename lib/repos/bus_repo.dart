import 'package:area_control/core/services/network/network.dart';
import 'package:area_control/core/utils/apis.dart';

import '../models/bus.model.dart';

class BusRepo {
  Future<BusModel> saveBus(BusModel bus) {
    var parms = bus.toParms();

    parms.removeWhere((key, value) => key == '_id' && value == '');
    if (bus.id.isEmpty) {
      return ApiHelper(NetworkEndPoints.saveBus.path, parms: parms).post.then((res) {
        return BusModel.fromJson(res.data);
      });
    }
    return ApiHelper(NetworkEndPoints.saveBus.path, parms: parms).put.then((res) {
      return BusModel.fromJson(res.data);
    });
  }

  Future<List<BusModel>> checkExistance({String query = ""}) {
    return ApiHelper("${NetworkEndPoints.existedBuses.path}/$query").get.then((res) {
      return List.from((res.data as List).map((e) => BusModel.fromJson(e)));
    });
  }
}
