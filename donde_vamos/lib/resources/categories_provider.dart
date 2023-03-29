import 'dart:convert';

import 'package:http/http.dart' as http;

class CategoriesProvider {
  Future<List<String>> getCategories() async {
    List<String> categories = [];
    String url = 'http://10.0.3.2:8000/api/categorias/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));

      for (int i = 0; i <= jsonData.length - 1; i++) {
        categories.add(jsonData[i]["categoria_detalle"]);
      }
    }

    return categories;
  }
}
