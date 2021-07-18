import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khanos/src/models/user_model.dart';
import 'package:khanos/src/models/activity_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';

class UserProvider {
  final _prefs = new UserPreferences();

  Future<List<UserModel>> getUsers() async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getAllUsers",
      "id": 1438712131
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

    final List<UserModel> users = [];

    final List<dynamic> results = decodedData['result'];

    results.forEach((user) {
      final userTemp = UserModel.fromJson(user);
      users.add(userTemp);
    });
    // print(decodedData['result']);
    return users;
  }

  Future<UserModel> getUser(int userId) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getUser",
      "id": 1769674781,
      "params": {"user_id": userId}
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

    UserModel user;

    user = UserModel.fromJson(decodedData['result']);

    return user;
  }

  Future<List<ActivityModel>> getMyActivityStream() async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getMyActivityStream",
      "id": 1132562181
    };

    final credentials = "${_prefs.username}:${_prefs.password}";

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(credentials);

    print(encoded);

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

    final List<ActivityModel> activities = [];

    final List<dynamic> results = decodedData['result'];

    results.forEach((activity) {
      final activityTemp = ActivityModel.fromJson(activity);

      activities.add(activityTemp);
    });

    // print(decodedData['result']);
    return activities;
  }
}
