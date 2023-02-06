import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:soori_warehouse/Sales/SalesReturnDrop/model/saleReturnDrop.dart';
import '../../../../consts/string_const.dart';

class SaleReturnDropServices {
  Future fetchSaleReturnDrop(String search ) async {
    // CustomerList? custom erList;
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(StringConst.baseUrl + StringConst.saleReturnDrop +search ),
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

        return <SaleReturnDrop>[];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  // Future fetchChalanReturnDropScan(String id) async {
  //   // CustomerList? custom erList;
  //   final SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //   final response = await http.get(
  //       Uri.parse(StringConst.baseUrl + StringConst.chalanReturnDropScan +id ),
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
  //       });
  //   log(response.body);
  //   try {
  //     if (response.statusCode == 200) {
  //       return response.body;
  //     } else {
  //       return <SaleReturnDrop>[];
  //     }
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }




}
