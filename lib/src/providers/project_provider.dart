import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kanboard/src/models/project_model.dart';

class ProjectProvider {
  final String _apiEndPoint = 'https://kanban.gojaponte.com/jsonrpc.php';

  Future<List<ProjectModel>> getProjects() async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getAllProjects",
      "id": 1
    };

    final credentials = "jeoxs:J30*54nd*41d1n";

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(credentials);

    final resp = await http.post(
      Uri.parse(_apiEndPoint),
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
