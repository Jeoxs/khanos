import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khanos/src/models/tag_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';

class TagProvider {
  final _prefs = new UserPreferences();

  Future<List<TagModel>> getAllTags() async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getAllTags",
      "id": 45253426
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
    final List<TagModel> tags = [];

    var results = decodedData['result'];

    if (decodedData == null || decodedData.isEmpty) return [];

    results.forEach((element) {
      TagModel tag = TagModel();
      tag.id = element['id'].toString();
      tag.name = element['name'].toString();
      tag.projectId = element['projectId'].toString();
      tag.projectId = element['projectId'].toString();
      tags.add(tag);
    });
    return tags;
  }

  Future<List<TagModel>> getTagsByProject(int projectId) async {
    List arg = [projectId];
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getTagsByProject",
      "id": 1217591720,
      "params": arg
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
    final List<TagModel> tags = [];

    List results = decodedData['result'];

    if (decodedData == null) return [];

    results.forEach((element) {
      TagModel tag = TagModel();
      tag.id = element['id'].toString();
      tag.name = element['name'].toString();
      tag.projectId = element['projectId'].toString();
      tag.projectId = element['projectId'].toString();
      tags.add(tag);
    });

    return tags;
  }

  Future<List<TagModel>> getDefaultTags() async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getAllTags",
      "id": 45253426
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
    final List<TagModel> tags = [];

    var results = decodedData['result'];

    if (decodedData == null || decodedData.isEmpty) return [];

    results.forEach((element) {
      if (element['project_id'] == '0') {
        TagModel tag = TagModel();
        tag.id = element['id'].toString();
        tag.name = element['name'].toString();
        tag.projectId = element['projectId'].toString();
        tag.projectId = element['projectId'].toString();
        tags.add(tag);
      }
    });
    return tags;
  }

  Future<List<TagModel>> getTagsByTask(int taskId) async {
    List arg = [taskId];
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getTaskTags",
      "id": 1667157705,
      "params": arg
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

    final List<TagModel> tags = [];

    var results = decodedData['result'];

    if (decodedData == null) return [];

    results.forEach((id, name) {
      TagModel tag = TagModel();
      tag.id = id.toString();
      tag.name = name.toString();
      tags.add(tag);
    });

    return tags;
  }
}
