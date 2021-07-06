import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kanboard/src/models/subtask_model.dart';

class SubtaskProvider {
  final String _apiEndPoint = 'https://kanban.gojaponte.com/jsonrpc.php';
  final credentials = "jeoxs:J30*54nd*41d1n";

  Future<List<SubtaskModel>> getSubtasks(taskId) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getAllSubtasks",
      "id": 133184525,
      "params": {"task_id": taskId}
    };

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(credentials);

    final resp = await http.post(
      Uri.parse(_apiEndPoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
    );

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    final List<SubtaskModel> subtasks = [];

    final List<dynamic> results = decodedData['result'];

    if (decodedData == null) return [];

    results.forEach((subtask) {
      final subtTemp = SubtaskModel.fromJson(subtask);
      subtasks.add(subtTemp);
    });
    return subtasks;
  }

  Future<bool> processSubtask(SubtaskModel subtask) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "updateSubtask",
      "id": 191749979,
      "params": {
        "id": subtask.id,
        "task_id": subtask.taskId,
        "status": subtask.status == "2" ? 0 : 2
      }
    };

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(credentials);

    final resp = await http.post(
      Uri.parse(_apiEndPoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
    );

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));

    final result = decodedData['result'];

    return result;
  }
}
