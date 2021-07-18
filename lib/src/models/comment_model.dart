// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  CommentModel({
    this.id,
    this.taskId,
    this.userId,
    this.dateCreation,
    this.comment,
    this.username,
    this.name,
  });

  String id;
  String taskId;
  String userId;
  String dateCreation;
  String comment;
  String username;
  String name;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        taskId: json["task_id"],
        userId: json["user_id"],
        dateCreation: json["date_creation"],
        comment: json["comment"],
        username: json["username"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "user_id": userId,
        "date_creation": dateCreation,
        "comment": comment,
        "username": username,
        "name": name,
      };
}
