import 'package:area_control/core/utils/enums.dart';
import 'package:area_control/models/stops.model.dart';
import 'package:flutter/material.dart';

class BusModel {
  String id;
  String name;
  String description;
  List<BusType> tag;
  List<BusVariants> variants;
  bool live;

  BusModel({
    this.id = "",
    this.name = "",
    this.description = "",
    this.tag = const [],
    this.variants = const [],
    this.live = true,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) => BusModel(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        tag: List<BusType>.from(json["tag"].map((x) => BusType.fromName(x))),
        variants: json["variants"] == null
            ? []
            : List<BusVariants>.from(
                json["variants"].map((x) => BusVariants.fromJson(x)),
              ),
        live: json["live"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "tag": List<dynamic>.from(tag.map((x) => x)),
        "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
        "live": live,
      };

  Map<String, dynamic> toParms() => {
        "name": name,
        "description": description,
        "tag": List<dynamic>.from(tag.map((x) => x.name)),
        "live": live,
      };
}

class BusVariants {
  DayType dayType;
  VariantType type;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  int frequency;
  List<StopsModel> route;

  BusVariants({
    this.dayType = DayType.daily,
    this.type = VariantType.normal,
    this.fromTime,
    this.toTime,
    this.frequency = 5,
    this.route = const [],
  });

  factory BusVariants.fromJson(Map<String, dynamic> json) => BusVariants(
        dayType: json["dayType"],
        fromTime: stringToTime(json["from"]),
        toTime: stringToTime(json["to"]),
        frequency: json["frequency"],
        route: [],
      );

  static TimeOfDay stringToTime(int time) {
    try {
      final vv = DateTime.fromMillisecondsSinceEpoch(time);
      return TimeOfDay.fromDateTime(vv);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  Map<String, dynamic> toJson() => {
        "dayType": dayType.name,
        "from": fromTime,
        "to": toTime,
        "frequency": frequency,
        "route": route,
      };
}
