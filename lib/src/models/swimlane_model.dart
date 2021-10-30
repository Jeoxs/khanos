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
    });

    String id;
    String name;

    factory SwimlaneModel.fromJson(Map<String, dynamic> json) => SwimlaneModel(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
