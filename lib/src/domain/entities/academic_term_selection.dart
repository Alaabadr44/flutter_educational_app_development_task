// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final academicTermSelection = academicTermSelectionFromJson(jsonString);

import 'dart:convert';

AcademicTermSelection academicTermSelectionFromJson(String str) => AcademicTermSelection.fromJson(json.decode(str));

String academicTermSelectionToJson(AcademicTermSelection data) => json.encode(data.toJson());

class AcademicTermSelection {
    final int? id;
    final String? name;
    final int? price;
    final dynamic img;
    final int? termNum;
    final int? systemId;
    final int? stageId;
    final int? classroomId;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? pathsCount;

    AcademicTermSelection({
        this.id,
        this.name,
        this.price,
        this.img,
        this.termNum,
        this.systemId,
        this.stageId,
        this.classroomId,
        this.createdAt,
        this.updatedAt,
        this.pathsCount,
    });

    factory AcademicTermSelection.fromJson(Map<String, dynamic> json) => AcademicTermSelection(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        img: json["img"],
        termNum: json["term_num"],
        systemId: json["system_id"],
        stageId: json["stage_id"],
        classroomId: json["classroom_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        pathsCount: json["paths_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "img": img,
        "term_num": termNum,
        "system_id": systemId,
        "stage_id": stageId,
        "classroom_id": classroomId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "paths_count": pathsCount,
    };

  @override
  bool operator ==(covariant AcademicTermSelection other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.price == price &&
      other.img == img &&
      other.termNum == termNum &&
      other.systemId == systemId &&
      other.stageId == stageId &&
      other.classroomId == classroomId &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.pathsCount == pathsCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      img.hashCode ^
      termNum.hashCode ^
      systemId.hashCode ^
      stageId.hashCode ^
      classroomId.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      pathsCount.hashCode;
  }
}
