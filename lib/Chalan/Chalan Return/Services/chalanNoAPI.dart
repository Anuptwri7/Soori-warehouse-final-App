import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../consts/string_const.dart';
import '../Model/chalanNo.dart';
class ChalanNoServices {
  List<ResultsChanal> allChalan = <ResultsChanal>[];
  Future fetchChalanNoFromUrl( String id) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(StringConst.baseUrl + StringConst.chalanReturnAddChalanNo +  "&customer=$id" ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });

    log("chalan"+response.body);

    try {
      if (response.statusCode == 200) {

        int resultLength = json.decode(response.body)['results'].length;
        for (var i = 0; i < resultLength; i++){
          allChalan.add(ResultsChanal(
            id: json.decode(response.body)['results'][i]['id'].toString(),
            chalanNo: json.decode(response.body)['results'][i]['chalan_no'],
          ));
        }
        return allChalan;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}