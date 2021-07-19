import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khanos/src/models/project_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:khanos/src/utils/utils.dart';

class ProjectProvider {
  final _prefs = new UserPreferences();

  // final String _apiEndPoint = 'https://kanban.gojaponte.com/jsonrpc.php';

  Future<List<ProjectModel>> getProjects() async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getmyProjects",
      "id": 2134420212
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

    // Check for errors
    if (decodedData['error'] != null) {
      var error = processApiError(decodedData['error']);
      return Future.error(error);
    }

    final List<ProjectModel> projects = [];

    final List<dynamic> results = decodedData['result'];

    if (decodedData == null) return [];

    results.forEach((project) {
      final projTemp = ProjectModel.fromJson(project);
      projects.add(projTemp);
    });

    return projects;
  }

  Future<int> createProject(
      String name, String identifier, String description) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "createProject",
      "id": 1797076613,
      "params": {
        "name": name,
        "owner_id": _prefs.userId,
        "description": description
      }
    };

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final credentials = "${_prefs.username}:${_prefs.password}";
    String encoded = stringToBase64.encode(credentials);

    final resp = await http.post(
      Uri.parse(_prefs.endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
    );

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));

    if (decodedData == null || decodedData['result'] == false) return 0;

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    final result = decodedData['result'];

    return (result > 0) ? result : 0;
  }

  Future<bool> removeProject(int projectId) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "removeProject",
      "id": 46285125,
      "params": {"project_id": projectId}
    };

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final credentials = "${_prefs.username}:${_prefs.password}";
    String encoded = stringToBase64.encode(credentials);

    final resp = await http.post(
      Uri.parse(_prefs.endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
    );

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));

    if (decodedData == null) return false;

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    final result = decodedData['result'];

    return result;
  }
}
