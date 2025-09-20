// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final subjectsData = subjectsDataFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';

SubjectsData subjectsDataFromJson(String str) => SubjectsData.fromJson(json.decode(str));

String subjectsDataToJson(SubjectsData data) => json.encode(data.toJson());

class SubjectsData {
    final List<Subject>? required;
    final List<Subject>? optional;

    SubjectsData({
        this.required,
        this.optional,
    });

    factory SubjectsData.fromJson(Map<String, dynamic> json) => SubjectsData(
        required: json["required"] == null ? [] : List<Subject>.from(json["required"]!.map((x) => Subject.fromJson(x))),
        optional: json["optional"] == null ? [] : List<Subject>.from(json["optional"]!.map((x) => Subject.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "required": required == null ? [] : List<dynamic>.from(required!.map((x) => x.toJson())),
        "optional": optional == null ? [] : List<dynamic>.from(optional!.map((x) => x.toJson())),
    };
}

class Subject {
    final int? id;
    final String? name;
    final String? img;
    final String? color;
    final bool? isUnit;
    final int? price;
    final int? teacherPrice;
    final int? oldPrice;
    final String? type;
    final int? systemId;
    final int? stageId;
    final int? classroomId;
    final int? termId;
    final int? pathId;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? trueAnswersCount;
    final int? falseAnswersCount;
    final int? lessonsCount;
    final int? finishesLessonsCount;
    final bool? isSubscribe;

    Subject({
        this.id,
        this.name,
        this.img,
        this.color,
        this.isUnit,
        this.price,
        this.teacherPrice,
        this.oldPrice,
        this.type,
        this.systemId,
        this.stageId,
        this.classroomId,
        this.termId,
        this.pathId,
        this.createdAt,
        this.updatedAt,
        this.trueAnswersCount,
        this.falseAnswersCount,
        this.lessonsCount,
        this.finishesLessonsCount,
        this.isSubscribe,
    });

    factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json["id"],
        name: json["name"],
        img: json["img"],
        color: json["color"],
        isUnit: json["is_unit"],
        price: json["price"],
        teacherPrice: json["teacher_price"],
        oldPrice: json["old_price"],
        type: json["type"],
        systemId: json["system_id"],
        stageId: json["stage_id"],
        classroomId: json["classroom_id"],
        termId: json["term_id"],
        pathId: json["path_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        trueAnswersCount: json["true_answers_count"],
        falseAnswersCount: json["false_answers_count"],
        lessonsCount: json["lessons_count"],
        finishesLessonsCount: json["finishesLessons_count"],
        isSubscribe: json["is_subscribe"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "img": img,
        "color": color,
        "is_unit": isUnit,
        "price": price,
        "teacher_price": teacherPrice,
        "old_price": oldPrice,
        "type": type,
        "system_id": systemId,
        "stage_id": stageId,
        "classroom_id": classroomId,
        "term_id": termId,
        "path_id": pathId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "true_answers_count": trueAnswersCount,
        "false_answers_count": falseAnswersCount,
        "lessons_count": lessonsCount,
        "finishesLessons_count": finishesLessonsCount,
        "is_subscribe": isSubscribe,
    };

  @override
  bool operator ==(covariant Subject other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.img == img &&
      other.color == color &&
      other.isUnit == isUnit &&
      other.price == price &&
      other.teacherPrice == teacherPrice &&
      other.oldPrice == oldPrice &&
      other.type == type &&
      other.systemId == systemId &&
      other.stageId == stageId &&
      other.classroomId == classroomId &&
      other.termId == termId &&
      other.pathId == pathId &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.trueAnswersCount == trueAnswersCount &&
      other.falseAnswersCount == falseAnswersCount &&
      other.lessonsCount == lessonsCount &&
      other.finishesLessonsCount == finishesLessonsCount &&
      other.isSubscribe == isSubscribe;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      img.hashCode ^
      color.hashCode ^
      isUnit.hashCode ^
      price.hashCode ^
      teacherPrice.hashCode ^
      oldPrice.hashCode ^
      type.hashCode ^
      systemId.hashCode ^
      stageId.hashCode ^
      classroomId.hashCode ^
      termId.hashCode ^
      pathId.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      trueAnswersCount.hashCode ^
      falseAnswersCount.hashCode ^
      lessonsCount.hashCode ^
      finishesLessonsCount.hashCode ^
      isSubscribe.hashCode;
  }
}
