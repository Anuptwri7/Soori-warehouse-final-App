import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:soori_warehouse/Chalan/Chalan%20Return/Model/chalanReturnModel.dart';
import '../../../../consts/string_const.dart';
import '../Model/chalanReturnDropModel.dart';
import '../Model/chalanReturnDropScan.dart';

List<SalePackingTypeDetailCode> allData = <SalePackingTypeDetailCode>[];
class ChalanReturnDropServices {

  Future fetchChalanReturnDrop(String search ) async {
    // CustomerList? custom erList;
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(StringConst.baseUrl + StringConst.chalanReturnDrop +search ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });
    // log(response.body);
    try {
      if (response.statusCode == 200) {

        return response.body;
      } else {

        return <ChalanReturnDrop>[];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future fetchChalanReturnDropScan(String id) async {

    log(":::::::::::::::::::::::::::::::::::::::::::"+id.toString());
    // CustomerList? custom erList;
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(StringConst.baseUrl + '/api/v1/chalan-app/chalan-return-info?limit=0&chalan_master=$id'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });
    log("--------------------"+response.body);
    try {
      if (response.statusCode == 200) {

        final snapshot = json.decode((response.body));
          ChalanReturnDropScan chalanreturndropscan =
          ChalanReturnDropScan.fromJson(snapshot);
          log(chalanreturndropscan.results!.length.toString());
          for(int i=0;i<chalanreturndropscan.results!.length;i++){
          allData.add(SalePackingTypeDetailCode(
            // id: json.decode(response.body)['results'][0]['chalan_packing_types'][0]['sale_packing_type_detail_code'][0]['id'],
            id: chalanreturndropscan.results![i].chalanPackingTypes![i].salePackingTypeDetailCode![i].id
          ));

          log(allData[i].id.toString());
          }
        return response.body;
      } else {

      }
    } catch (e) {
      throw Exception(e);
    }
  }




}
