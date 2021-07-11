import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khanos/src/preferences/user_preferences.dart';

class AuthProvider {
  final _prefs = new UserPreferences();

  Future<bool> login(String endpoint, String username, String password) async {
    bool _validURL = Uri.tryParse(endpoint).isAbsolute;

    if (_validURL != true) return false;

    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getAllProjects",
      "id": 1
    };

    final credentials = "$username:$password";

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(credentials);

    final resp = await http.post(
      Uri.parse(endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
    );

    dynamic decodedData;

    try {
      decodedData =
          json.decode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
    } on FormatException catch (e) {
      return false;
    }

    if (decodedData == null) return false;

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    final List<dynamic> results = decodedData['result'];

    if (results != null) {
      _prefs.endpoint = endpoint;
      _prefs.username = username;
      _prefs.password = password;
      _prefs.authFlag = true;
      return true;
    } else {
      _prefs.authFlag = false;
      return false;
    }

    // print(decodedData['result']);
  }
}
