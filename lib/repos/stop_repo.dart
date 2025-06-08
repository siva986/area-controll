import 'package:area_control/core/services/network/network.dart';
import 'package:area_control/core/utils/apis.dart';
import 'package:area_control/models/stops.model.dart';

class StopRepo {
  Future<Responce> getAllArea({required int pageNo, required int pageSize, String query = ""}) {
    var data = {
      "pageNo": pageNo,
      "pageSize": pageSize,
      "query": query,
    };

    return ApiHelper(NetworkEndPoints.getAllStops.path, parms: data).post.then((res) {
      return res;
    });
  }

  Future<List<StopsModel>> updateNearestStop(StopsModel stop) {
    return ApiHelper(NetworkEndPoints.updateNearestStop.path, parms: stop.toNearBy()).post.then((res) {
      return (res.data as List).map((e) => StopsModel.fromJson(e)).toList();
    });
  }

  Future<StopsModel> saveStop(StopsModel stop) {
    var parms = stop.toParms();

    parms.removeWhere((key, value) => key == '_id' && value == '');
    if (stop.id.isEmpty) {
      return ApiHelper(NetworkEndPoints.createStop.path, parms: parms).post.then((res) {
        return StopsModel.fromJson(res.data);
      });
    }
    return ApiHelper(NetworkEndPoints.createStop.path, parms: parms).put.then((res) {
      return StopsModel.fromJson(res.data);
    });
  }
}
