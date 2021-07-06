import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kanboard/src/models/task_model.dart';

class TaskProvider {
  final String _apiEndPoint = 'https://kanban.gojaponte.com/jsonrpc.php';

  Future<List<TaskModel>> getTasks(int projectId, int statusId) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getAllTasks",
      "id": 1,
      "params": {"project_id": projectId, "status_id": statusId}
    };

    final credentials = "jeoxs:J30*54nd*41d1n";

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(credentials);

    final resp = await http.post(
      Uri.parse(_apiEndPoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
      encoding: Encoding.getByName("utf-8"),
    );

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));

    final List<TaskModel> tasks = [];

    final List<dynamic> results = decodedData['result'];

    if (decodedData == null) return [];

    results.forEach((task) {
      final taskTemp = TaskModel.fromJson(task);
      tasks.add(taskTemp);
    });
    // print(decodedData['result']);
    return tasks;
  }
}
