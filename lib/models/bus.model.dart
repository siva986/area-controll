import 'package:area_control/core/utils/enums.dart';
import 'package:area_control/models/stops.model.dart';

class BusModel {
  String id;
  String name;
  String description;
  List<BusType> tag;
  List<BusVariantModel> variants;
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
            : List<BusVariantModel>.from(
                json["variants"].map((x) => BusVariantModel.fromJson(x)),
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

class BusVariantModel {
  String id;
  String route;
  String name;
  List<StopsModel> stops;
  DayType activeDays;
  String note;

  String displayName;

  BusVariantModel({
    this.id = "",
    this.route = "",
    this.name = "",
    this.stops = const [],
    this.activeDays = DayType.daily,
    this.note = "",
    this.displayName = "",
  });

  factory BusVariantModel.fromJson(Map<String, dynamic> json) => BusVariantModel(
        id: json["_id"],
        route: json["_route"] ?? "",
        name: json["name"] ?? "",
        stops: json["stops"] == null ? [] : List<StopsModel>.from(json["stops"]?.map((x) => StopsModel(id: x))),
        activeDays: DayType.fromName(json['activeDays']),
        note: json["note"] ?? "",
        displayName: "${json['fromStop']} to ${json['toStop']}",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "_route": route,
        "name": name,
        "stops": List<dynamic>.from(stops.map((x) => x)),
        "activeDays": activeDays.name,
        "note": note,
      };

  Map<String, dynamic> toParms() => {
        "_route": route,
        "name": name,
        "stops": List<dynamic>.from(stops.map((x) => x.id)),
        "activeDays": activeDays.name,
        "note": note,
      };
}
// class BusVariants {
//   DayType dayType;
//   VariantType type;
//   TimeOfDay? fromTime;
//   TimeOfDay? toTime;
//   int frequency;
//   List<StopsModel> route;
//   String busId;
//   String id;
//   String note;

//   BusVariants({
//     this.dayType = DayType.daily,
//     this.type = VariantType.normal,
//     this.fromTime,
//     this.busId = "",
//     this.id = "",
//     this.note = "",
//     this.toTime,
//     this.frequency = 5,
//     this.route = const [],
//   });

//   factory BusVariants.fromJson(Map<String, dynamic> json) => BusVariants(
//         dayType: DayType.fromName(json["dayType"]),
//         type: VariantType.fromName(json["variantType"]),
//         fromTime: BusVariants.stringToTime(json["from"]),
//         toTime: BusVariants.stringToTime(json["to"]),
//         frequency: json["frequency"],
//         busId: json["_busId"] ?? "",
//         id: json["_id"] ?? "",
//         note: json["note"] ?? "",
//         route: (json["stopSequence"] as List).map((e) => StopsModel.fromJson(e)).toList(),
//       );

//   static TimeOfDay stringToTime(String time) {
//     try {
//       final format = DateFormat('HH:mm').tryParse(time);
//       return TimeOfDay.fromDateTime(format!);
//     } catch (e) {
//       return TimeOfDay.now();
//     }
//   }

//   Map<String, dynamic> toJson() => {
//         "dayType": dayType.name,
//         "from": fromTime,
//         "to": toTime,
//         "frequency": frequency,
//         "route": route,
//       };

//   Map<String, dynamic> toParms(BuildContext context) => {
//         "variants": [
//           {
//             "_busId": busId,
//             "variantType": type.name,
//             "dayType": dayType.name,
//             "from": fromTime?.toNomalTime,
//             "to": toTime?.toNomalTime,
//             "frequency": frequency,
//           }
//         ],
//         "stopSequence": List<dynamic>.from(route.map((x) => x.id)),
//         "notes": "",
//       };

//   Map<String, dynamic> updateParms(BuildContext context) => {
//         "variants": [
//           {
//             "_busId": busId,
//             "variantType": type.name,
//             "dayType": dayType.name,
//             "from": fromTime?.toString(),
//             "to": toTime?.format(context),
//             "frequency": frequency,
//           }
//         ],
//         "_id": id,
//         "stopSequence": List<dynamic>.from(route.map((x) => x.id)),
//         "notes": "",
//       };
// }

var data = {
  "msg": "Bus saved successfully",
  "data": {
    "_busId": "64ae9d4fa13a8d3b33f24720",
    "dayType": "weekday",
    "variantType": "normal",
    "from": "06:00",
    "to": "10:00",
    "frequency": 30,
    "stopSequence": ["64ae9d4fa13a8d3b33f24700", "64ae9d4fa13a8d3b33f24710", "64ae9d4fa13a8d3b33f24715", "64ae9d4fa13a8d3b33f24705"],
    "notes": "Operates only on working days",
    "_id": "686fcf93b2f339dd2d00cc54",
  }
};
