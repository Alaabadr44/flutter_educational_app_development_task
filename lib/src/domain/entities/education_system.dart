// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final educationSystem = educationSystemFromJson(jsonString);

import 'dart:convert';

SelectionData educationSystemFromJson(String str) =>
    SelectionData.fromJson(json.decode(str));

String educationSystemToJson(SelectionData data) => json.encode(data.toJson());

class SelectionData {
  final int? id;
  final String? name;
  final dynamic img;
  final DateTime? endYear;
  final int? systemId;
  final String? createdAt;
  final DateTime? updatedAt;

  SelectionData({
    this.id,
    this.name,
    this.img,
    this.endYear,
    this.systemId,
    this.createdAt,
    this.updatedAt,
  });

  factory SelectionData.fromJson(Map<String, dynamic> json) => SelectionData(
    id: json["id"],
    name: json["name"],
    img: json["img"],
    endYear: json["end_year"] == null ? null : DateTime.parse(json["end_year"]),
    systemId: json["system_id"],
    createdAt: json["created_at"],
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "img": img,
    "end_year":
        "${endYear!.year.toString().padLeft(4, '0')}-${endYear!.month.toString().padLeft(2, '0')}-${endYear!.day.toString().padLeft(2, '0')}",
    "system_id": systemId,
    "created_at": createdAt,
    "updated_at": updatedAt?.toIso8601String(),
  };

  @override
  bool operator ==(covariant SelectionData other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        img.hashCode ^
        endYear.hashCode ^
        systemId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
