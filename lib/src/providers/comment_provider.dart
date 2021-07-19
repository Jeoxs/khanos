import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khanos/src/models/comment_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';

class CommentProvider {
  final _prefs = new UserPreferences();

  Future<List<CommentModel>> getAllComments(int taskId) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getAllComments",
      "id": 148484683,
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

    final List<CommentModel> comments = [];

    final List<dynamic> results = decodedData['result'];

    results.forEach((comment) {
      final commentTemp = CommentModel.fromJson(comment);
      comments.add(commentTemp);
    });
    return comments;
  }

  Future<CommentModel> getComment(int commentId) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getComment",
      "id": 867839500,
      "params": {"comment_id": commentId}
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

    if (decodedData == null) return null;

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    final CommentModel comment = CommentModel.fromJson(decodedData['result']);

    return comment;
  }

  Future<int> createComment(Map<String, dynamic> args) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "createComment",
      "id": 1580417921,
      "params": args
    };
    final credentials = "${_prefs.username}:${_prefs.password}";

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(credentials);

    final resp = await http.post(
      Uri.parse(_prefs.endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
      encoding: Encoding.getByName("utf-8"),
    );

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    final result = decodedData['result'];

    if (decodedData == null) return 0;

    return (result != false) ? result : 0;
  }

  Future<bool> updateComment(Map<String, dynamic> args) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "updateComment",
      "id": 496470023,
      "params": args
    };

    final credentials = "${_prefs.username}:${_prefs.password}";

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(credentials);

    final resp = await http.post(
      Uri.parse(_prefs.endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
      encoding: Encoding.getByName("utf-8"),
    );

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));

    if (decodedData == null) return false;

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    final result = decodedData['result'];

    return (result != false && result != null) ? result : 0;
  }

  Future<bool> removeComment(int commentId) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "removeComment",
      "id": 328836871,
      "params": {"comment_id": commentId}
    };

    final credentials = "${_prefs.username}:${_prefs.password}";

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(credentials);

    final resp = await http.post(
      Uri.parse(_prefs.endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
      encoding: Encoding.getByName("utf-8"),
    );

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    final result = decodedData['result'];

    if (decodedData == null) return false;

    return result;
  }
}
