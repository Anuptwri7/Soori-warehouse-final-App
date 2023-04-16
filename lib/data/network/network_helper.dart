import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';

class NetworkHelper {
  late http.Response response;
  late final String endPoint;
  String finalUrl = '';

  static dynamic tokenHeader() async {
    var headerWithToken = <String, String>{
      'Content-Type': StringConst.contentType,
      'X-Requested-With': StringConst.xRequestedWith,
      'Authorization': await loadBearerToken(),
    };
    return headerWithToken;
  }

  static var simpleHeader = <String, String>{
    'Content-Type': StringConst.contentType,
    'X-Requested-With': StringConst.xRequestedWith,
  };

  NetworkHelper(this.endPoint) {
    // finalUrl =  getMainUrl();
    finalUrl = endPoint;
    // finalUrl = '${getMainUrl()}${StringConst.urlMidPoint}$endPoint';
    // print('Final Url $finalUrl');
    log(finalUrl);
  }

  Future getData() async {
    response = await http.get(
      Uri.parse(finalUrl),
    );
    return response;
  }

/*
  Future getBranches() async {
    response = await http.get(
      Uri.parse(StringConst.branchUrl),
    );
    return response;
  }
*/

  userLogin(username, userPassword) async {
    print("Username : $username , Password: $userPassword");
    response = await http.post(
      Uri.parse(finalUrl),
      headers: simpleHeader,
      body: jsonEncode(
          <String, String>{'user_name': username, 'password': userPassword}),
    );
    return response;
  }

  getOrdersWithToken() async {
    response =
        await http.get(Uri.parse(finalUrl), headers: await tokenHeader());
    return response;
  }

  userPurchaseOrder(
      {int? refPurchaseOrder, required List purchaseDetails}) async {
    var _body = jsonEncode({
      'ref_purchase_order': refPurchaseOrder,
      'purchase_order_details': purchaseDetails
    });

    response = await http.post(
      Uri.parse(finalUrl),
      headers: await tokenHeader(),
      body: _body,
    );

    print("Response from approve PO: ${response.body.toString()}");
    print("Response  from approve PO: ${response.statusCode.toString()}");

    return response;
  }

  updateLocationDetails({packingItemCode, locationCode}) async {
    var _body = jsonEncode(
        {'packing_type_code': packingItemCode, 'location_code': locationCode});

    response = await http.post(
      Uri.parse(finalUrl),
      headers: await tokenHeader(),
      body: _body,
    );

    return response;
  }

  sendAuditSerialNo({auditDetails, isFinished}) async {
    var _body =
        jsonEncode({'audit_details': auditDetails, 'is_finished': isFinished});
    response = await http.post(
      Uri.parse(finalUrl),
      headers: await tokenHeader(),
      body: _body,
    );
    return response;
  }

  updateAuditSerialNo({auditDetails, isFinished}) async {
    var _body =
        jsonEncode({'audit_details': auditDetails, 'is_finished': isFinished});
    response = await http.patch(
      Uri.parse(finalUrl),
      headers: await tokenHeader(),
      body: _body,
    );
    return response;
  }

  dropReceivedOrders(locationCode, packCode) async {
    var _body = jsonEncode(
        {'location_code': locationCode, 'packing_type_code': packCode});

    response = await http.post(
      Uri.parse(finalUrl),
      headers: await tokenHeader(),
      body: _body,
    );

    return response;
  }

  /*Pickup Orders*/
  pickUpOrders(orderDetailID, packTypeDetailIdList) async {
    var _body = jsonEncode({
      'order_detail': orderDetailID,
      'pack_type_detail_code_ids': packTypeDetailIdList
    });

    response = await http.post(
      Uri.parse(finalUrl),
      headers: await tokenHeader(),
      body: _body,
    );

    return response;
  }
}
