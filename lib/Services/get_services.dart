import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocab/Model/get_model.dart';

class APIservices {
  static String baseUrl = "https://api.dictionaryapi.dev/api/v2/entries/en/";
  static Future<DictionaryModel?> fetchData(String word) async {
    Uri uri = Uri.parse("$baseUrl$word");
    final response = await http.get(uri);
    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DictionaryModel.fromJson(data[0]);
      } else {
        throw Exception("Failure to load meaning");
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
