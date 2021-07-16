// To parse this JSON data, do
//
//     final subtaskModel = subtaskModelFromJson(jsonString);

import 'dart:convert';

SubtaskModel subtaskModelFromJson(String str) =>
    SubtaskModel.fromJson(json.decode(str));

String subtaskModelToJson(SubtaskModel data) => json.encode(data.toJson());

class SubtaskModel {
  SubtaskModel({
    this.id,
    this.title,
    this.status,
    this.timeEstimated,
    this.timeSpent,
    this.taskId,
    this.userId,
    this.position,
  });

  String id;
  String title;
  String status;
  String timeEstimated;
  String timeSpent;
  String taskId;
  String userId;
  String position;

  factory SubtaskModel.fromJson(Map<String, dynamic> json) => SubtaskModel(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        timeEstimated: json["time_estimated"],
        timeSpent: json["time_spent"],
        taskId: json["task_id"],
        userId: json["user_id"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "time_estimated": timeEstimated,
        "time_spent": timeSpent,
        "task_id": taskId,
        "user_id": userId,
        "position": position,
      };
}
