import 'package:area_control/core/services/network/network.dart';
import 'package:area_control/core/utils/apis.dart';
import 'package:area_control/models/area.model.dart';

class AreaRepo {
  Future<Responce> getAllArea({int pageNo = 1, int pageSize = 10, String query = ""}) {
    var data = {
      "pageNo": pageNo,
      "pageSize": pageSize,
      "query": query,
    };
    return ApiHelper(NetworkEndPoints.getAllAreas.path, parms: data).post.then((res) {
      return res;
    });
  }

  Future<AreaModel> deleteArea(String id) {
    return ApiHelper(NetworkEndPoints.deleteArea.path + id).delete.then((res) {
      return AreaModel.fromJson(res.data);
    });
  }

  Future<AreaModel> saveArea(AreaModel area) {
    var parms = area.toParms();

    parms.removeWhere((key, value) => key == '_id' && value == '');
    if (area.id.isEmpty) {
      return ApiHelper(NetworkEndPoints.saveArea.path, parms: parms).post.then((res) {
        return AreaModel.fromJson(res.data);
      });
    }
    return ApiHelper(NetworkEndPoints.saveArea.path, parms: parms).put.then((res) {
      return AreaModel.fromJson(res.data);
    });
  }
}
