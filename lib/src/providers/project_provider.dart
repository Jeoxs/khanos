import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khanos/src/models/project_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';

class ProjectProvider {
  final _prefs = new UserPreferences();

  // final String _apiEndPoint = 'https://kanban.gojaponte.com/jsonrpc.php';

  Future<List<ProjectModel>> getProjects(BuildContext context) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getAllProjects",
      "id": 1
    };

    final credentials = "${_prefs.username}:${_prefs.password}";

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(credentials);

    final resp = await http.post(
      Uri.parse(_prefs.endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
    );

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    final List<ProjectModel> projects = [];

    final List<dynamic> results = decodedData['result'];

    if (decodedData == null) return [];

    results.forEach((project) {
      final projTemp = ProjectModel.fromJson(project);
      projects.add(projTemp);
    });
    // print(decodedData['result']);
    return projects;
  }
}
