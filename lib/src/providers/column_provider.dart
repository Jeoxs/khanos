import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kanboard/src/models/column_model.dart';

class ColumnProvider {
  final String _apiEndPoint = 'https://kanban.gojaponte.com/jsonrpc.php';

  Future<Map<String, ColumnModel>> getColumns(projectId) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getColumns",
      "id": 887036325,
      "params": {"project_id": projectId}
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

    // final List<ColumnModel> columns = [];

    final List<dynamic> results = decodedData['result'];

    if (decodedData == null) return {};

    final Map<String, ColumnModel> columns = {};

    results.forEach((column) {
      final columnTemp = ColumnModel.fromJson(column);
      columns[columnTemp.id] = columnTemp;
    });
    // print(decodedData['result']);
    return columns;
  }
}
