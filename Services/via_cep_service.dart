import 'dart:convert';

import 'package:http/http.dart' as http;

class ViaCepService {
  Future buscarEndereco(String cep) async{
    String endpoint = "https://viacep.com.br/ws/$cep/json/";
    Uri uri = Uri.parse(endpoint);

   var response = await http.get(uri);

    if(response.statusCode == 200) {

      Map<String, dynamic> json = jsonDecode(response.body);
      
    }

  }
}
