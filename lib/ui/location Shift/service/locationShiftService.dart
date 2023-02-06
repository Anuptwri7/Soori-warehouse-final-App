
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:soori_warehouse/consts/string_const.dart';

Future LocationShifting12( ) async {
  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();

  final response = await http.post(
      Uri.parse(StringConst.branchUrl + StringConst.locationShifting),
      headers:{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
      },
      body: json.encode({
        {
          "pack_type_code_id": 0,
          "location_code": "string"
        }
      }));
  if (response.statusCode == 201) {


    Fluttertoast.showToast(msg: "Customer created successfully!");
  }else{
    Fluttertoast.showToast(msg: "Error Scan Again!");
  }

  if (kDebugMode) {
    log('hello${response.statusCode}');
  }
  return response;
}