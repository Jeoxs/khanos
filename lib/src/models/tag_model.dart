// To parse this JSON data, do
//
//     final tagModel = tagModelFromJson(jsonString);

import 'dart:convert';

TagModel tagModelFromJson(String str) => TagModel.fromJson(json.decode(str));

String tagModelToJson(TagModel data) => json.encode(data.toJson());

class TagModel {
  TagModel({
    this.id,
    this.name,
    this.projectId,
  });

  String id;
  String name;
  String projectId;

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
        id: json["id"],
        name: json["name"],
        projectId: json["project_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "project_id": projectId,
      };
}
