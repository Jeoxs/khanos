import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khanos/src/models/user_model.dart';
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
    final List<UserModel> users = [];

    final List<dynamic> results = decodedData['result'];

    if (decodedData == null) return [];

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
    UserModel user;

    user = UserModel.fromJson(decodedData['result']);

    if (decodedData == null) return null;

    return user;
  }
}