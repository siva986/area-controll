import 'package:latlong2/latlong.dart';

class AreaModel {
  String id;
  String name;
  String type;
  String parentArea;
  Boundary? boundary;
  DateTime? createdAt;
  DateTime? updatedAt;


  AreaModel({
    this.id = "",
    this.name = "",
    this.type = "",
    this.parentArea = "",
    this.boundary,
    this.createdAt,
    this.updatedAt,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        id: json["_id"] ?? "",
        name: json["name"] ?? "",
        type: json["type"] ?? "",
        parentArea: json["parentArea"] ?? "",
        boundary: Boundary.fromJson(json["boundary"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "type": type,
        "parentArea": parentArea,
        "boundary": boundary!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
  Map<String, dynamic> toParms() => {
        "_id": id,
        "name": name,
        "type": "city",
        "parentArea": parentArea,
        "boundary": boundary!.toJson(),
      };
}

class Boundary {
  String type;
  List<List<LatLng>> coordinates;

  Boundary({
    this.type = "Polygon",
    this.coordinates = const [],
  });

  factory Boundary.fromJson(Map<String, dynamic> json) => Boundary(
      type: json["type"],
      coordinates: (json["coordinates"] as List).map((polygon) {
        return (polygon as List).map((point) {
          return LatLng(point[1].toDouble(), point[0].toDouble());
        }).toList();
      }).toList());

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates.map((polygon) {
          return polygon.map((point) {
            return [point.longitude, point.latitude];
          }).toList();
        }).toList(),
      };
}
