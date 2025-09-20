// To parse this JSON data, do
//
//     final quizcData = quizcDataFromJson(jsonString);

import 'dart:convert';

QuizcData quizcDataFromJson(String str) => QuizcData.fromJson(json.decode(str));

String quizcDataToJson(QuizcData data) => json.encode(data.toJson());

class QuizcData {
    final int? id;
    final dynamic updatedBy;
    final dynamic createdBy;
    final String? correctSelect;
    final int? point;
    final dynamic quesFileApi;
    final dynamic descriptionFileApi;
    final dynamic select1FileApi;
    final dynamic select2FileApi;
    final dynamic select3FileApi;
    final dynamic select4FileApi;
    final String? skill;
    final String? quesText;
    final dynamic quesFile;
    final dynamic quesType;
    final int? audioActive;
    final int? isAudio;
    final String? descriptionText;
    final dynamic descriptionFile;
    final dynamic descriptionType;
    final String? select1Text;
    final dynamic select1File;
    final dynamic select1Type;
    final String? select2Text;
    final dynamic select2File;
    final dynamic select2Type;
    final String? select3Text;
    final dynamic select3File;
    final dynamic select3Type;
    final String? select4Text;
    final dynamic select4File;
    final dynamic select4Type;
    final int? systemId;
    final int? stageId;
    final int? classroomId;
    final int? termId;
    final int? subjectId;
    final int? levelId;
    final int? groupId;
    final int? unitId;
    final int? lessonId;
    final int? pathId;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    QuizcData({
        this.id,
        this.updatedBy,
        this.createdBy,
        this.correctSelect,
        this.point,
        this.quesFileApi,
        this.descriptionFileApi,
        this.select1FileApi,
        this.select2FileApi,
        this.select3FileApi,
        this.select4FileApi,
        this.skill,
        this.quesText,
        this.quesFile,
        this.quesType,
        this.audioActive,
        this.isAudio,
        this.descriptionText,
        this.descriptionFile,
        this.descriptionType,
        this.select1Text,
        this.select1File,
        this.select1Type,
        this.select2Text,
        this.select2File,
        this.select2Type,
        this.select3Text,
        this.select3File,
        this.select3Type,
        this.select4Text,
        this.select4File,
        this.select4Type,
        this.systemId,
        this.stageId,
        this.classroomId,
        this.termId,
        this.subjectId,
        this.levelId,
        this.groupId,
        this.unitId,
        this.lessonId,
        this.pathId,
        this.createdAt,
        this.updatedAt,
    });

    factory QuizcData.fromJson(Map<String, dynamic> json) => QuizcData(
        id: json["id"],
        updatedBy: json["updated_by"],
        createdBy: json["created_by"],
        correctSelect: json["correct_select"],
        point: json["point"],
        quesFileApi: json["ques_file_api"],
        descriptionFileApi: json["description_file_api"],
        select1FileApi: json["select_1_file_api"],
        select2FileApi: json["select_2_file_api"],
        select3FileApi: json["select_3_file_api"],
        select4FileApi: json["select_4_file_api"],
        skill: json["skill"],
        quesText: json["ques_text"],
        quesFile: json["ques_file"],
        quesType: json["ques_type"],
        audioActive: json["audio_active"],
        isAudio: json["is_audio"],
        descriptionText: json["description_text"],
        descriptionFile: json["description_file"],
        descriptionType: json["description_type"],
        select1Text: json["select_1_text"],
        select1File: json["select_1_file"],
        select1Type: json["select_1_type"],
        select2Text: json["select_2_text"],
        select2File: json["select_2_file"],
        select2Type: json["select_2_type"],
        select3Text: json["select_3_text"],
        select3File: json["select_3_file"],
        select3Type: json["select_3_type"],
        select4Text: json["select_4_text"],
        select4File: json["select_4_file"],
        select4Type: json["select_4_type"],
        systemId: json["system_id"],
        stageId: json["stage_id"],
        classroomId: json["classroom_id"],
        termId: json["term_id"],
        subjectId: json["subject_id"],
        levelId: json["level_id"],
        groupId: json["group_id"],
        unitId: json["unit_id"],
        lessonId: json["lesson_id"],
        pathId: json["path_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "updated_by": updatedBy,
        "created_by": createdBy,
        "correct_select": correctSelect,
        "point": point,
        "ques_file_api": quesFileApi,
        "description_file_api": descriptionFileApi,
        "select_1_file_api": select1FileApi,
        "select_2_file_api": select2FileApi,
        "select_3_file_api": select3FileApi,
        "select_4_file_api": select4FileApi,
        "skill": skill,
        "ques_text": quesText,
        "ques_file": quesFile,
        "ques_type": quesType,
        "audio_active": audioActive,
        "is_audio": isAudio,
        "description_text": descriptionText,
        "description_file": descriptionFile,
        "description_type": descriptionType,
        "select_1_text": select1Text,
        "select_1_file": select1File,
        "select_1_type": select1Type,
        "select_2_text": select2Text,
        "select_2_file": select2File,
        "select_2_type": select2Type,
        "select_3_text": select3Text,
        "select_3_file": select3File,
        "select_3_type": select3Type,
        "select_4_text": select4Text,
        "select_4_file": select4File,
        "select_4_type": select4Type,
        "system_id": systemId,
        "stage_id": stageId,
        "classroom_id": classroomId,
        "term_id": termId,
        "subject_id": subjectId,
        "level_id": levelId,
        "group_id": groupId,
        "unit_id": unitId,
        "lesson_id": lessonId,
        "path_id": pathId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}