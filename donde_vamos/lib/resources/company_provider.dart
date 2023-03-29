import 'dart:convert';

import 'package:donde_vamos/models/company.dart';
import 'package:http/http.dart' as http;

class CompanyProvider {
  //obtener compañia a la que representa un usuario organizador
  Future<Map<String, dynamic>> getCompanyFromUser(String idUser) async {
    print('compa' + idUser);
    Company company = Company(empresa_cuil: 0, empresa_nombre: '');
    Map<String, dynamic> data = {};
    String url = 'http://10.0.3.2:8000/api/usuarios/$idUser/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      String cuil = jsonData["empresa_cuil"].toString();
      String url = 'http://10.0.3.2:8000/api/empresas/$cuil';
      var resp2 = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      if (resp2.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(resp2.bodyBytes));
        data = jsonData;
        //  company.empresa_cuil = int.parse(cuil);
        //  company.empresa_nombre = jsonData["empresa_nombre"];
      }
      // company.empresa_cuil = jsonData["empresa_cuil"];
      // company.empresa_nombre = jsonData["empresa_nombre"];
    }

    return data;
  }
}
