// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    final String? token;
    final LoginData? loginData;

    UserModel({
        this.token,
        this.loginData,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        token: json["token"],
        loginData: json["login_data"] == null ? null : LoginData.fromJson(json["login_data"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "login_data": loginData?.toJson(),
    };
}

class LoginData {
    final num? id;
    final String? name;
    final dynamic email;
    final bool? isVip;
    final int? references;
    final int? points;
    final int? attendanceWeeks;
    final String? phone;
    final int? phoneVerified;
    final String? countryCode;
    final int? fakeNumber;
    final String? type;
    final String? gendar;
    final String? mobileId;
    final dynamic mobileType;
    final String? img;
    final dynamic socialId;
    final String? username;
    final String? lock;
    final dynamic lockMessage;
    final int? systemId;
    final int? stageId;
    final int? classroomId;
    final int? termId;
    final dynamic pathId;
    final dynamic institutionId;
    final String? createdAt;
    final DateTime? updatedAt;
    final Classroom? system;
    final Classroom? stage;
    final Classroom? classroom;
    final Classroom? term;

    LoginData({
        this.id,
        this.name,
        this.email,
        this.isVip,
        this.references,
        this.points,
        this.attendanceWeeks,
        this.phone,
        this.phoneVerified,
        this.countryCode,
        this.fakeNumber,
        this.type,
        this.gendar,
        this.mobileId,
        this.mobileType,
        this.img,
        this.socialId,
        this.username,
        this.lock,
        this.lockMessage,
        this.systemId,
        this.stageId,
        this.classroomId,
        this.termId,
        this.pathId,
        this.institutionId,
        this.createdAt,
        this.updatedAt,
        this.system,
        this.stage,
        this.classroom,
        this.term,
    });

    factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        id: num.parse(json["id"].toString()),
        name: json["name"],
        email: json["email"],
        isVip: json["is_vip"],
        references: json["references"],
        points: json["points"],
        attendanceWeeks: json["attendance_weeks"],
        phone: json["phone"],
        phoneVerified: json["phone_verified"],
        countryCode: json["country_code"],
        fakeNumber: json["fake_number"],
        type: json["type"],
        gendar: json["gendar"],
        mobileId: json["mobile_id"],
        mobileType: json["mobile_type"],
        img: json["img"],
        socialId: json["social_id"],
        username: json["username"],
        lock: json["lock"],
        lockMessage: json["lock_message"],
        systemId: json["system_id"],
        stageId: json["stage_id"],
        classroomId: json["classroom_id"],
        termId: json["term_id"],
        pathId: json["path_id"],
        institutionId: json["institution_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        system: json["system"] == null ? null : Classroom.fromJson(json["system"]),
        stage: json["stage"] == null ? null : Classroom.fromJson(json["stage"]),
        classroom: json["classroom"] == null ? null : Classroom.fromJson(json["classroom"]),
        term: json["term"] == null ? null : Classroom.fromJson(json["term"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "is_vip": isVip,
        "references": references,
        "points": points,
        "attendance_weeks": attendanceWeeks,
        "phone": phone,
        "phone_verified": phoneVerified,
        "country_code": countryCode,
        "fake_number": fakeNumber,
        "type": type,
        "gendar": gendar,
        "mobile_id": mobileId,
        "mobile_type": mobileType,
        "img": img,
        "social_id": socialId,
        "username": username,
        "lock": lock,
        "lock_message": lockMessage,
        "system_id": systemId,
        "stage_id": stageId,
        "classroom_id": classroomId,
        "term_id": termId,
        "path_id": pathId,
        "institution_id": institutionId,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
        "system": system?.toJson(),
        "stage": stage?.toJson(),
        "classroom": classroom?.toJson(),
        "term": term?.toJson(),
    };
}

class Classroom {
    final int? id;
    final String? name;

    Classroom({
        this.id,
        this.name,
    });

    factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
