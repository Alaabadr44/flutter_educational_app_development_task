// To parse this JSON data, do
//
//     final unitData = unitDataFromJson(jsonString);

import 'dart:convert';

UnitData unitDataFromJson(String str) => UnitData.fromJson(json.decode(str));

String unitDataToJson(UnitData data) => json.encode(data.toJson());

class UnitData {
    final int? id;
    final String? name;
    final int? stageId;
    final int? classroomId;
    final int? termId;
    final dynamic pathId;
    final int? subjectId;
    final DateTime? createdAt;
    final int? systemId;
    final List<Lesson>? lessons;

    UnitData({
        this.id,
        this.name,
        this.stageId,
        this.classroomId,
        this.termId,
        this.pathId,
        this.subjectId,
        this.createdAt,
        this.systemId,
        this.lessons,
    });

    factory UnitData.fromJson(Map<String, dynamic> json) => UnitData(
        id: json["id"],
        name: json["name"],
        stageId: json["stage_id"],
        classroomId: json["classroom_id"],
        termId: json["term_id"],
        pathId: json["path_id"],
        subjectId: json["subject_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        systemId: json["system_id"],
        lessons: json["lessons"] == null ? [] : List<Lesson>.from(json["lessons"]!.map((x) => Lesson.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "stage_id": stageId,
        "classroom_id": classroomId,
        "term_id": termId,
        "path_id": pathId,
        "subject_id": subjectId,
        "created_at": createdAt?.toIso8601String(),
        "system_id": systemId,
        "lessons": lessons == null ? [] : List<dynamic>.from(lessons!.map((x) => x.toJson())),
    };
}

class Lesson {
    final int? id;
    final int? sort;
    final String? name;
    final String? videoCode;
    final int? audioActive;
    final int? isAudio;
    final dynamic textDesc;
    final dynamic audioFile;
    final String? pdfFile;
    final dynamic img;
    final int? skipPoint;
    final dynamic description;
    final int? systemId;
    final int? stageId;
    final int? classroomId;
    final int? termId;
    final int? subjectId;
    final int? unitId;
    final dynamic pathId;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic childAnswersPoint;
    final dynamic entry;

    Lesson({
        this.id,
        this.sort,
        this.name,
        this.videoCode,
        this.audioActive,
        this.isAudio,
        this.textDesc,
        this.audioFile,
        this.pdfFile,
        this.img,
        this.skipPoint,
        this.description,
        this.systemId,
        this.stageId,
        this.classroomId,
        this.termId,
        this.subjectId,
        this.unitId,
        this.pathId,
        this.createdAt,
        this.updatedAt,
        this.childAnswersPoint,
        this.entry,
    });

    factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json["id"],
        sort: json["sort"],
        name: json["name"],
        videoCode: json["video_code"],
        audioActive: json["audio_active"],
        isAudio: json["is_audio"],
        textDesc: json["text_desc"],
        audioFile: json["audio_file"],
        pdfFile: json["pdf_file"],
        img: json["img"],
        skipPoint: json["skip_point"],
        description: json["description"],
        systemId: json["system_id"],
        stageId: json["stage_id"],
        classroomId: json["classroom_id"],
        termId: json["term_id"],
        subjectId: json["subject_id"],
        unitId: json["unit_id"],
        pathId: json["path_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        childAnswersPoint: json["child_answers_point"],
        entry: json["entry"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sort": sort,
        "name": name,
        "video_code": videoCode,
        "audio_active": audioActive,
        "is_audio": isAudio,
        "text_desc": textDesc,
        "audio_file": audioFile,
        "pdf_file": pdfFile,
        "img": img,
        "skip_point": skipPoint,
        "description": description,
        "system_id": systemId,
        "stage_id": stageId,
        "classroom_id": classroomId,
        "term_id": termId,
        "subject_id": subjectId,
        "unit_id": unitId,
        "path_id": pathId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "child_answers_point": childAnswersPoint,
        "entry": entry,
    };
}