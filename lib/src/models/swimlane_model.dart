// To parse this JSON data, do
//
//     final swimlaneModel = swimlaneModelFromJson(jsonString);

import 'dart:convert';

SwimlaneModel swimlaneModelFromJson(String str) => SwimlaneModel.fromJson(json.decode(str));

String swimlaneModelToJson(SwimlaneModel data) => json.encode(data.toJson());

class SwimlaneModel {
    SwimlaneModel({
        this.id,
        this.name,
        this.position,
        this.isActive,
        this.projectId,
    });

    String id;
    String name;
    String position;
    String isActive;
    String projectId;

    factory SwimlaneModel.fromJson(Map<String, dynamic> json) => SwimlaneModel(
        id: json["id"],
        name: json["name"],
        position: json["position"],
        isActive: json["is_active"],
        projectId: json["project_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "position": position,
        "is_active": isActive,
        "project_id": projectId,
    };
}
