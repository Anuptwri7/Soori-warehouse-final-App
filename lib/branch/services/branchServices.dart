
import 'dart:convert';
import 'dart:developer';
import 'package:soori_warehouse/branch/model/branchModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../consts/string_const.dart';

Future fetchBranchFromUrl() async {

  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();
  // log(sharedPreferences.getString("access_token"));
  final response = await http.get(
      Uri.parse(
          StringConst.branchUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
      }
  );
  // log("=============="+response.body);
  log(response.body.toString());
  List<Result> respond = [];

  final responseData = json.decode(response.body);
  responseData['results'].forEach(
        (element) {
      respond.add(
        Result.fromJson(element),
      );
    },
  );
  if (response.statusCode == 200) {
    return respond;
  }
}