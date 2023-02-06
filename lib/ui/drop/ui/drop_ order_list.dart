import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/buttons_const.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/in/po_in_list.dart';

import '../../login/login_screen.dart';
import '../model/drop_list.dart';
import 'drop_order_details.dart';

class PODrop extends StatefulWidget {
  const PODrop({Key? key}) : super(key: key);

  @override
  _PODropState createState() => _PODropState();
}

class _PODropState extends State<PODrop> {

  late http.Response response;
  late ProgressDialog pd;
  late Future<List<Result>?> dropOrderReceived;


  @override
  void initState() {
    dropOrderReceived = listDropReceivedOrders();
    pd = initProgressDialog(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.dropOrders),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [

          FutureBuilder<List<Result>?>(
              future: dropOrderReceived,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return _dropOrderCards(snapshot.data);
                    }
                }
              })
        ],
      ),
    );
  }

  _dropOrderCards(List<Result>? data) {
    return data != null
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            margin: kMarginPaddSmall,
            color: Colors.white,
            elevation: kCardElevation,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              padding: kMarginPaddSmall,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text("Received No :",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(width: 30,),
                      Container(
                        height: 30,
                        width: 200,
                        decoration:  BoxDecoration(
                          color: const Color(0xffeff3ff),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xffeff3ff),
                              offset: Offset(-2, -2),
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(child: Text("${data[index].orderNo}",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                    ],
                  ),
                  kHeightSmall,
                  // poInRowDesign('Received No :', data[index].orderNo),
                  Row(
                    children: [
                      Container(
                        child: Text("Date :",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(width: 75,),
                      Container(
                        height: 30,
                        width: 200,
                        decoration:  BoxDecoration(
                          color: const Color(0xffeff3ff),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xffeff3ff),
                              offset: Offset(-2, -2),
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(child: Text("${data[index].createdDateAd.toString().substring(0,10)}",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                    ],
                  ),
                  kHeightSmall,
                  // poInRowDesign(
                  //     'Date :',
                  //     data[index]
                  //         .createdDateAd
                  //         .toLocal()
                  //         .toString()
                  //         .substring(0, 10)),
                  Row(
                    children: [
                      Container(
                        child: Center(child: Text("Supplier Name :",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                      SizedBox(width: 15,),
                      Container(
                        height: 30,
                        width: 200,
                        decoration:  BoxDecoration(
                          color: const Color(0xffeff3ff),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xffeff3ff),
                              offset: Offset(-2, -2),
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(child: Text("${data[index].supplierName}",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                    ],
                  ),
                  kHeightSmall,
                  // poInRowDesign('Supplier Name :',
                  //     data[index].supplierName),
                  // kHeightMedium,
                  taskCheckButtons(data, index),
                ],
              ),
            ),
          );
        })
        : Center(
      child: Text(
        StringConst.noDataAvailable,
        style: kTextStyleBlack,
      ),
    );
  }

  Future<List<Result>?> listDropReceivedOrders() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.urlPurchaseApp}get-orders/received?ordering=-id&limit=0'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // http.Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}get-orders/received?ordering=-id&limit=0')
    //     .getOrdersWithToken();

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return dropOrderReceiveFromJson(response.body.toString()).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }

  taskCheckButtons(List<Result> _data, _index) {

    bool taskCheck = true;
    for(int i = 0; i < _data[_index].purchaseOrderDetails.length; i++){
      for(int j = 0; j < _data[_index].purchaseOrderDetails[i].poPackTypeCodes.length; j++){

        if(_data[_index].purchaseOrderDetails[i].poPackTypeCodes[j].location != null){
          taskCheck = true;
        }
        else{
          taskCheck = false;
          break;
        }

      }
    }

    return taskCheck
        ? RoundedButtons(
      buttonText: 'Task Completed',
      onTap: () => goToPage(context, DropOrderDetails(_data[_index].id)),
      color: Color(0xff6b88e8),
    )
        :  RoundedButtons(
    buttonText: 'View Details',
    onTap: () => goToPage(context, DropOrderDetails(_data[_index].id)),
    color: Color(0xff2c51a4),
    )
    ;
  }

}
