// To parse this JSON data, do
//
//     final projectModel = projectModelFromJson(jsonString);

import 'dart:convert';

ProjectModel projectModelFromJson(String str) =>
    ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel {
  ProjectModel({
    this.id,
    this.name,
    this.isActive,
    this.token,
    this.lastModified,
    this.isPublic,
    this.isPrivate,
    this.description,
    this.identifier,
    this.startDate,
    this.endDate,
    this.ownerId,
    this.priorityDefault,
    this.priorityStart,
    this.priorityEnd,
    this.email,
    this.predefinedEmailSubjects,
    this.perSwimlaneTaskLimits,
    this.taskLimit,
    this.enableGlobalTags,
    this.url,
  });

  String id;
  String name;
  String isActive;
  String token;
  String lastModified;
  String isPublic;
  String isPrivate;
  String description;
  String identifier;
  String startDate;
  String endDate;
  String ownerId;
  String priorityDefault;
  String priorityStart;
  String priorityEnd;
  String email;
  String predefinedEmailSubjects;
  String perSwimlaneTaskLimits;
  String taskLimit;
  String enableGlobalTags;
  Url url;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json["id"],
        name: json["name"],
        isActive: json["is_active"],
        token: json["token"],
        lastModified: json["last_modified"],
        isPublic: json["is_public"],
        isPrivate: json["is_private"],
        description: json["description"],
        identifier: json["identifier"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        ownerId: json["owner_id"],
        priorityDefault: json["priority_default"],
        priorityStart: json["priority_start"],
        priorityEnd: json["priority_end"],
        email: json["email"],
        predefinedEmailSubjects: json["predefined_email_subjects"],
        perSwimlaneTaskLimits: json["per_swimlane_task_limits"],
        taskLimit: json["task_limit"],
        enableGlobalTags: json["enable_global_tags"],
        url: Url.fromJson(json["url"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_active": isActive,
        "token": token,
        "last_modified": lastModified,
        "is_public": isPublic,
        "is_private": isPrivate,
        "description": description,
        "identifier": identifier,
        "start_date": startDate,
        "end_date": endDate,
        "owner_id": ownerId,
        "priority_default": priorityDefault,
        "priority_start": priorityStart,
        "priority_end": priorityEnd,
        "email": email,
        "predefined_email_subjects": predefinedEmailSubjects,
        "per_swimlane_task_limits": perSwimlaneTaskLimits,
        "task_limit": taskLimit,
        "enable_global_tags": enableGlobalTags,
        "url": url.toJson(),
      };
}

class Url {
  Url({
    this.board,
    this.list,
    this.calendar,
  });

  String board;
  String list;
  String calendar;

  factory Url.fromJson(Map<String, dynamic> json) => Url(
        board: json["board"],
        list: json["list"],
        calendar: json["calendar"],
      );

  Map<String, dynamic> toJson() => {
        "board": board,
        "list": list,
        "calendar": calendar,
      };
}
