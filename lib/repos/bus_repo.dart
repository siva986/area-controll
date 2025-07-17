import 'package:area_control/core/routes/routes.dart';
import 'package:area_control/core/services/network/network.dart';
import 'package:area_control/core/utils/apis.dart';
import 'package:flutter/material.dart';

import '../models/bus.model.dart';

class BusRepo {
  final BuildContext? context = rootNavigatorKey.currentContext;
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

  Future<Responce> getAllBuses(Map<String, dynamic> parms) {
    return ApiHelper(NetworkEndPoints.getAllBuses.path, parms: parms).post;
  }

  Future<BusVariantModel> saveRoute(BusVariantModel variant) {
    var parms = variant.toParms();

    return ApiHelper(NetworkEndPoints.saveRoute.path, parms: parms).post.then((res) {
      return BusVariantModel.fromJson(res.data);
    });
  }

  Future<BusVariantModel> getVariant(String id) {
    return ApiHelper("${NetworkEndPoints.saveRoute.path}/$id").get.then((res) {
      return BusVariantModel.fromJson(res.data);
    });
  }

  Future<BusModel> getBus(String id) {
    return ApiHelper("${NetworkEndPoints.saveBus.path}/$id").get.then((res) {
      return BusModel.fromJson(res.data);
    });
  }
}
