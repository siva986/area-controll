import 'package:area_control/core/utils/enums.dart';
import 'package:latlong2/latlong.dart';

class StopsModel {
  String id;
  int level;
  String name;
  String description;
  StopAlias alias;
  List<String> nearStops;
  Geo? geo;
  bool live;

  StopsModel({
    this.id = "",
    this.name = "",
    this.level = 0,
    this.description = "",
    this.alias = StopAlias.middle,
    this.nearStops = const [],
    this.geo,
    this.live = true,
  });

  factory StopsModel.fromJson(Map<String, dynamic> json) => StopsModel(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        level: json["level"] ?? 0,
        description: json["description"] ?? "",
        alias: StopAlias.values.firstWhere((e) => e.name == json["alias"]),
        nearStops: List<String>.from(json["nearStops"].map((x) => x)),
        geo: Geo.fromJson(json["geo"]),
        live: json["live"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "level": level,
        "description": description,
        "alias": alias.name,
        "nearStops": List<dynamic>.from(nearStops.map((x) => x)),
        "geo": geo!.toJson(),
        "live": live,
      };

  Map<String, dynamic> toParms() => {
        "_id": id,
        "name": name,
        "level": level,
        "description": description,
        "alias": alias.name,
        "nearStops": List<dynamic>.from(nearStops.map((x) => x)),
        "geo": geo!.toJson(),
        "live": live,
      };
}

class Geo {
  String type;
  LatLng coordinates;

  Geo({
    this.type = "Point",
    required this.coordinates,
  });

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
        type: json["type"] ?? "Point",
        coordinates: LatLng.fromJson(json),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates.toJson()['coordinates'],
      };
}
