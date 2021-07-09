import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kanboard/src/models/column_model.dart';
import 'package:kanboard/src/preferences/user_preferences.dart';

class ColumnProvider {
  final _prefs = new UserPreferences();

  Future<List<ColumnModel>> getColumns(projectId) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getColumns",
      "id": 887036325,
      "params": {"project_id": projectId}
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
    final List<ColumnModel> columns = [];

    final List<dynamic> results = decodedData['result'];

    if (decodedData == null) return [];

    results.forEach((column) {
      final columnTemp = ColumnModel.fromJson(column);
      columns.add(columnTemp);
    });

    return columns;
  }
}
