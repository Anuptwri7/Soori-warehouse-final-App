import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/buttons_const.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/drop/model/drop_list.dart';
import 'package:soori_warehouse/ui/in/po_in_list.dart';
import '../../../login/login_screen.dart';
import '../../ui/drop_order_details.dart';
import 'bulkOrderDetailPage.dart';


class BulkPODrop extends StatefulWidget {
  const BulkPODrop({Key? key}) : super(key: key);

  @override
  _BulkPODropState createState() => _BulkPODropState();
}

class _BulkPODropState extends State<BulkPODrop>with TickerProviderStateMixin {

  late http.Response response;
  late ProgressDialog pd;
  late Future<List<Result>?> dropOrderReceived;
  late TabController? _controller;
  int _selectedIndex = 0;
  @override
  void initState() {
    dropOrderReceived = listDropReceivedOrders();
    pd = initProgressDialog(context);
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller!.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });
      log("Selected Index: " + _controller!.index.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.bulkdropOrders,
            style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),
        ),

        bottom: TabBar(
          controller: _controller,
          indicatorColor:Color(0xffBF1E2E),
          indicatorWeight: 2,
          unselectedLabelColor: Colors.grey,
          labelColor:Color(0xffBF1E2E),
          tabs: [
            Tab(text: "Pending",),
            Tab(text: "Completed",),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          return GestureDetector(
            onTap: (){
              bool taskCheck = true;
              for(int i = 0; i < data[index].purchaseOrderDetails.length; i++){
                for(int j = 0; j < data[index].purchaseOrderDetails[i].poPackTypeCodes.length; j++){

                  if(data[index].purchaseOrderDetails[i].poPackTypeCodes[j].location != null){
                    taskCheck = true;
                  }
                  else{
                    taskCheck = false;
                    break;
                  }

                }
              }
            },
            child: Card(
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
                        Icon(Icons.battery_charging_full_outlined),
                        Text("${data[index].orderNo}"),
                        SizedBox(width: 60,),
                        Text("Rs.${data[index].grandTotal}")
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.brown.shade800,
                          child:  Text('${data[index].supplierName.substring(0,1).toUpperCase() }'),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: 200,
                          child: Text(
                            "${data[index].supplierName}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),

                      ],
                    ),

                    taskCheckButtons(data, index),
                  ],
                ),
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
log(response.body);
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

        ?
    RoundedButtonsCustomized(
      buttonText: 'Task Completed',
      onTap: () => goToPage(context, BulkDropOrderDetails(_data[_index].id,_data[_index].orderNo,_data[_index].supplierName)),
      color: Color(0xff424143),
    )
        :  RoundedButtonsCustomized(
      buttonText: 'View Details',
      onTap: () => goToPage(context, BulkDropOrderDetails(_data[_index].id,_data[_index].orderNo,_data[_index].supplierName)),
      color: Colors.grey,
    )
    ;
  }

}
