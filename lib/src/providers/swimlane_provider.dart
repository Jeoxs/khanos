import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khanos/src/models/swimlane_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';

class SwimlaneProvider {
  final _prefs = new UserPreferences();
  Future<List<SwimlaneModel>> getActiveSwimlanes(int projectId) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getActiveSwimlanes",
      "id": 934789422,
      "params": [projectId]
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
    
    final List<SwimlaneModel> swimlanes = [];

    final List<dynamic> results = decodedData['result'];

    if (decodedData == null) return [];

    // Check for errors
    if (decodedData['error'] != null) {
      return Future.error(decodedData['error']);
    }

    results.forEach((swimlane) {
      final swimlaneTemp = SwimlaneModel.fromJson(swimlane);
      swimlanes.add(swimlaneTemp);
    });
    return swimlanes;
  }
}