import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:soori_warehouse/Chalan/Chalan%20Return/Model/chalanReturnModel.dart';
import '../../../consts/string_const.dart';
import '../model/saleReturn.dart';

class SaleServices {
  Future fetchSaleReturn(String search ) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(StringConst.baseUrl + StringConst.saleReturn+search ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });
    log(response.body);
    try {
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return <ChalanReturn>[];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  Future fetchSaleReturnView(String id ) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(StringConst.baseUrl + StringConst.saleReturnView+id ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });
    log(response.body);
    try {
      if (response.statusCode == 200) {

        return response.body;
      } else {

        return <SaleReturn>[];
      }
    } catch (e) {
      throw Exception(e);
    }
  }



}
