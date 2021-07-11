import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khanos/src/models/subtask_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';

class SubtaskProvider {
  final _prefs = new UserPreferences();

  Future<List<SubtaskModel>> getSubtasks(taskId) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getAllSubtasks",
      "id": 133184525,
      "params": {"task_id": taskId}
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

    if (decodedData == null) return [];

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    final List<SubtaskModel> subtasks = [];

    final List<dynamic> results = decodedData['result'];

    results.forEach((subtask) {
      final subtTemp = SubtaskModel.fromJson(subtask);
      subtasks.add(subtTemp);
    });
    return subtasks;
  }

  Future<bool> processSubtask(SubtaskModel subtask) async {
    String newSubTaskStatus;
    switch (subtask.status) {
      case "0":
        newSubTaskStatus = "1";
        await setSubtaskStartTime(int.parse(subtask.id));
        break;
      case "1":
        newSubTaskStatus = "2";
        await setSubtaskEndTime(int.parse(subtask.id));
        break;
      case "2":
        newSubTaskStatus = "0";
        break;
      default:
    }
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "updateSubtask",
      "id": 191749979,
      "params": {
        "id": subtask.id,
        "task_id": subtask.taskId,
        "status": newSubTaskStatus
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

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    final result = decodedData['result'];

    return result;
  }

  Future<bool> setSubtaskStartTime(int subtaskId, [int userId]) async {
    List args = [subtaskId];

    if (userId != null) {
      args.add(userId);
    } else {
      args.add(0);
    }

    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "setSubtaskStartTime",
      "id": 1168991769,
      "params": args
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

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    final result = decodedData['result'];

    return result;
  }

  Future<bool> setSubtaskEndTime(int subtaskId, [int userId]) async {
    List args = [subtaskId];

    if (userId != null) {
      args.add(userId);
    } else {
      args.add(0);
    }

    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "setSubtaskEndTime",
      "id": 1026607603,
      "params": args
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

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    final result = decodedData['result'];

    return result;
  }

  Future<double> getSubtaskTimeSpent(int subtaskId, [int userId]) async {
    List args = [subtaskId];

    if (userId != null) {
      args.add(userId);
    } else {
      args.add(0);
    }

    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getSubtaskTimeSpent",
      "id": 738527378,
      "params": args
    };

    print(parameters);

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final credentials = "${_prefs.username}:${_prefs.password}";
    String encoded = stringToBase64.encode(credentials);

    final resp = await http.post(
      Uri.parse(_prefs.endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
    );

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    print(decodedData);

    final result = decodedData['result'];

    return (result > 0) ? result : 0;
  }

  Future<int> createSubtask(
      int taskId, String title, int userId, String timeEstimated) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "createSubtask",
      "id": 2041554661,
      "params": {
        "task_id": taskId,
        "title": title,
        "user_id": userId,
        "timeEstimated": timeEstimated
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

    if (decodedData == null) return 0;

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    final result = decodedData['result'];

    return (result > 0) ? result : 0;
  }

  Future<bool> removeSubtask(int subtaskId) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "removeSubtask",
      "id": 1382487306,
      "params": {"subtask_id": subtaskId}
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
