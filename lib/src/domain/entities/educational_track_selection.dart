// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final educationalTrackSelection = educationalTrackSelectionFromJson(jsonString);

import 'dart:convert';

EducationalTrackSelection educationalTrackSelectionFromJson(String str) => EducationalTrackSelection.fromJson(json.decode(str));

String educationalTrackSelectionToJson(EducationalTrackSelection data) => json.encode(data.toJson());

class EducationalTrackSelection {
    final int? id;
    final String? name;
    final int? systemId;
    final int? stageId;
    final int? classroomId;
    final int? termId;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    EducationalTrackSelection({
        this.id,
        this.name,
        this.systemId,
        this.stageId,
        this.classroomId,
        this.termId,
        this.createdAt,
        this.updatedAt,
    });

    factory EducationalTrackSelection.fromJson(Map<String, dynamic> json) => EducationalTrackSelection(
        id: json["id"],
        name: json["name"],
        systemId: json["system_id"],
        stageId: json["stage_id"],
        classroomId: json["classroom_id"],
        termId: json["term_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "system_id": systemId,
        "stage_id": stageId,
        "classroom_id": classroomId,
        "term_id": termId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };

  @override
  bool operator ==(covariant EducationalTrackSelection other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.systemId == systemId &&
      other.stageId == stageId &&
      other.classroomId == classroomId &&
      other.termId == termId &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      systemId.hashCode ^
      stageId.hashCode ^
      classroomId.hashCode ^
      termId.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
