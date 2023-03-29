import 'dart:convert';

import 'package:http/http.dart' as http;

class ProvincesProvider {
  Future<List<String>> getProvinces() async {
    String url = 'http://10.0.3.2:8000/api/provincias';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    List<String> provinces = [];
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        provinces.add(jsonData[i]["provincia_nombre"]);
      }
    }
    return provinces;
  }
}
