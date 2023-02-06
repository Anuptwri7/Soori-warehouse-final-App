
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:soori_warehouse/consts/string_const.dart';

Future LocationShiftingGetId( ) async {
  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();

  final response = await http.get(
      Uri.parse(StringConst.branchUrl + StringConst.locationShiftingGetId),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
      },
     );
  if (response.statusCode == 201) {

  log(response.body);
    Fluttertoast.showToast(msg: "Customer created successfully!");
  }

  if (kDebugMode) {
    log('hello${response.statusCode}');
  }
  return response;
}