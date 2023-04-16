import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future fetchBranch() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final response = await http.get(
      Uri.parse(
          "https://api-soori-ims-staging.dipendranath.com.np/api/v1/branches"),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',

      });
  log(response.body);
  try {
    if (response.statusCode == 200) {

      return jsonDecode(response.body);
    }
  } catch (e) {
    throw Exception(e);
  }
}
