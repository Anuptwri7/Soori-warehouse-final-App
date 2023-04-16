import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

import '../../../consts/string_const.dart';
import '../Model/chalanNo.dart';
import '../Model/chalanReturnModel.dart';
import '../Model/chalanReturnView.dart';
import '../Model/customerModel.dart';

class ChalanServices {

  List<CustomerModel> allCustomer = <CustomerModel>[];
  List<ResultsChanal> allChalan = <ResultsChanal>[];
  Future fetchChalanReturn(String search) async {
    // CustomerList? custom erList;
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(StringConst.baseUrl + StringConst.chalanReturn+search ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });

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
  Future fetchChalanReturnView(String id ) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(StringConst.baseUrl + StringConst.chalanReturnView+id ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });

    try {
      if (response.statusCode == 200) {

        return response.body;
      } else {

        return <ChalanReturnView>[];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future fetchCustomerFromUrl() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(StringConst.baseUrl + StringConst.customerList),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });

    // log(response.body);

    try {
      if (response.statusCode == 200) {
        int resultLength = json.decode(response.body)['results'].length;
        for (var i = 0; i < resultLength; i++) {
          allCustomer.add(CustomerModel(
            id: json.decode(response.body)['results'][i]['id'].toString(),
            firstName: json
                .decode(response.body)['results'][i]['first_name']
                .toString(),
            middleName: json
                .decode(response.body)['results'][i]['middle_name']
                .toString(),
            lastName: json
                .decode(response.body)['results'][i]['last_name']
                .toString(),
          ));
        }
        // log(allSupplier.length.toString());
        return allCustomer;
      }
    } catch (e) {
      throw Exception(e);
    }
  }



}
