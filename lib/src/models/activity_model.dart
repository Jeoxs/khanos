// To parse this JSON data, do
//
//     final activityModel = activityModelFromJson(jsonString);

import 'dart:convert';

ActivityModel activityModelFromJson(String str) =>
    ActivityModel.fromJson(json.decode(str));

String activityModelToJson(ActivityModel data) => json.encode(data.toJson());

class ActivityModel {
  ActivityModel({
    this.id,
    this.dateCreation,
    this.eventName,
    this.creatorId,
    this.projectId,
    this.taskId,
    this.authorUsername,
    this.authorName,
    this.email,
    this.task,
    this.changes,
    this.author,
    this.eventTitle,
    this.eventContent,
  });

  String id;
  String dateCreation;
  String eventName;
  String creatorId;
  String projectId;
  String taskId;
  String authorUsername;
  String authorName;
  String email;
  Map<String, dynamic> task;
  dynamic changes;
  String author;
  String eventTitle;
  String eventContent;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        id: json["id"],
        dateCreation: json["date_creation"],
        eventName: json["event_name"],
        creatorId: json["creator_id"],
        projectId: json["project_id"],
        taskId: json["task_id"],
        authorUsername: json["author_username"],
        authorName: json["author_name"],
        email: json["email"],
        task: json["task"],
        changes: json["changes"],
        // changes: List<dynamic>.from(json["changes"].map((x) => x)),
        author: json["author"],
        eventTitle: json["event_title"],
        eventContent: json["event_content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date_creation": dateCreation,
        "event_name": eventName,
        "creator_id": creatorId,
        "project_id": projectId,
        "task_id": taskId,
        "author_username": authorUsername,
        "author_name": authorName,
        "email": email,
        "task": task,
        "changes": changes,
        // "changes": List<dynamic>.from(changes.map((x) => x)),
        "author": author,
        "event_title": eventTitle,
        "event_content": eventContent,
      };
}
