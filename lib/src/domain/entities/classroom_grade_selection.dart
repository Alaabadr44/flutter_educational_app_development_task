// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final classroomGradeSelection = classroomGradeSelectionFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';

ClassroomGradeSelection classroomGradeSelectionFromJson(String str) => ClassroomGradeSelection.fromJson(json.decode(str));

String classroomGradeSelectionToJson(ClassroomGradeSelection data) => json.encode(data.toJson());

class ClassroomGradeSelection {
    final int? id;
    final String? name;
    final dynamic img;
    final dynamic discount;
    final int? systemId;
    final int? stageId;
    final List<dynamic>? paths;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    ClassroomGradeSelection({
        this.id,
        this.name,
        this.img,
        this.discount,
        this.systemId,
        this.stageId,
        this.paths,
        this.createdAt,
        this.updatedAt,
    });

    factory ClassroomGradeSelection.fromJson(Map<String, dynamic> json) => ClassroomGradeSelection(
        id: json["id"],
        name: json["name"],
        img: json["img"],
        discount: json["discount"],
        systemId: json["system_id"],
        stageId: json["stage_id"],
        paths: json["paths"] == null ? [] : List<dynamic>.from(json["paths"]!.map((x) => x)),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "img": img,
        "discount": discount,
        "system_id": systemId,
        "stage_id": stageId,
        "paths": paths == null ? [] : List<dynamic>.from(paths!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };

  @override
  bool operator ==(covariant ClassroomGradeSelection other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.img == img &&
      other.discount == discount &&
      other.systemId == systemId &&
      other.stageId == stageId &&
      listEquals(other.paths, paths) &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      img.hashCode ^
      discount.hashCode ^
      systemId.hashCode ^
      stageId.hashCode ^
      paths.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
